namespace Reminder;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using System.Email;
using System.Utilities;

codeunit 50120 "Auto Customer Reminder"
{
    trigger OnRun()
    begin
        SendOutstandingReminders();
    end;

    procedure SendOutstandingReminders()
    var
        Setup: Record "Cust. Reminder Setup";
        Customer: Record Customer;
    begin
        if not Setup.Get('DEFAULT') then
            exit;

        if not Setup."Send Email" then
            exit;

        Customer.SetRange(Blocked, Customer.Blocked::" ");
        if Customer.FindSet() then
            repeat
                ProcessCustomer(Customer, Setup);
            until Customer.Next() = 0;
    end;

    local procedure ProcessCustomer(Customer: Record Customer; Setup: Record "Cust. Reminder Setup")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        History: Record "Cust. Reminder History";
        TotalOutstanding: Decimal;
        InvoiceCount: Integer;
        LastReminderDate: Date;
    begin
        if Customer."E-Mail" = '' then
            exit;

        CustLedgEntry.SetRange("Customer No.", Customer."No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Due Date", '<%1', CalcDate('<-' + Format(Setup."Overdue Days") + 'D>', Today));

        if CustLedgEntry.FindSet() then
            repeat
                if CustLedgEntry."Remaining Amount" > 0 then begin
                    TotalOutstanding += CustLedgEntry."Remaining Amount";
                    InvoiceCount += 1;
                end;
            until CustLedgEntry.Next() = 0;

        if InvoiceCount = 0 then
            exit;

        if TotalOutstanding < Setup."Minimum Outstanding Amount" then
            exit;

        LastReminderDate := GetLastReminderDate(Customer."No.");
        if (LastReminderDate <> 0D) and
           (LastReminderDate > CalcDate('<-' + Format(Setup."Reminder Frequency Days") + 'D>', Today)) then
            exit;

        History.Init();
        History."Customer No." := Customer."No.";
        History."Reminder Date" := Today;
        History."Outstanding Amount" := TotalOutstanding;
        History."Invoice Count" := InvoiceCount;
        History."Email Address" := Customer."E-Mail";

        if TrySendReminder(Customer, Setup) then begin
            History.Status := History.Status::Sent;
            History.Insert();
        end else begin
            History.Status := History.Status::Error;
            History."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(History."Error Message"));
            History.Insert();
        end;
    end;

    local procedure TrySendReminder(Customer: Record Customer; Setup: Record "Cust. Reminder Setup"): Boolean
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        RecRef: RecordRef;
        Body: Text;
        Subject: Text;
        AttachmentName: Text;
        ReportID: Integer;
        ToRecipients: List of [Text];
    begin
        Body := BuildEmailBody(Customer, CustLedgEntry, Setup);
        Subject := StrSubstNo(Setup."Email Subject", Customer.Name);

        ToRecipients.Add(Customer."E-Mail");
        EmailMessage.Create(ToRecipients, Subject, Body, true);

        if Setup."Attach PDF" and (Setup."PDF Report ID" > 0) then begin
            CustLedgEntry.Reset();
            CustLedgEntry.SetRange("Customer No.", Customer."No.");
            CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
            CustLedgEntry.SetRange(Open, true);
            CustLedgEntry.SetFilter("Due Date", '<%1', CalcDate('<-' + Format(Setup."Overdue Days") + 'D>', Today));

            RecRef.GetTable(CustLedgEntry);
            TempBlob.CreateOutStream(OutStream);

            ReportID := Setup."PDF Report ID";
            if not Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef) then
                Error('Unable to generate the outstanding invoice PDF.');

            TempBlob.CreateInStream(InStream);
            AttachmentName := 'Outstanding_Invoices_' + Customer."No." + '.pdf';
            EmailMessage.AddAttachment(AttachmentName, 'application/pdf', InStream);
        end;

        exit(Email.Send(EmailMessage, Setup."Email From Scenario"));
    end;

    local procedure BuildEmailBody(Customer: Record Customer; var CustLedgEntry: Record "Cust. Ledger Entry"; Setup: Record "Cust. Reminder Setup"): Text
    var
        Body: Text;
        LineCount: Integer;
        TotalOutstanding: Decimal;
        DueText: Text;
    begin
        Body :=
            '<html><body>' +
            '<p>Dear ' + Customer.Name + ',</p>' +
            '<p>This is a reminder that the following invoice(s) are outstanding and overdue.</p>' +
            '<table border="1" cellpadding="5" cellspacing="0">' +
            '<tr><th>Invoice No.</th><th>Posting Date</th><th>Due Date</th><th>Outstanding Amount</th></tr>';

        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Customer No.", Customer."No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Due Date", '<%1', CalcDate('<-' + Format(Setup."Overdue Days") + 'D>', Today));

        if CustLedgEntry.FindSet() then
            repeat
                if CustLedgEntry."Remaining Amount" > 0 then begin
                    DueText := Format(CustLedgEntry."Due Date");
                    Body +=
                        '<tr><td>' + CustLedgEntry."Document No." + '</td>' +
                        '<td>' + Format(CustLedgEntry."Posting Date") + '</td>' +
                        '<td>' + DueText + '</td>' +
                        '<td align="right">' + Format(CustLedgEntry."Remaining Amount") + ' ' + CustLedgEntry."Currency Code" + '</td></tr>';

                    TotalOutstanding += CustLedgEntry."Remaining Amount";
                    LineCount += 1;
                end;
            until CustLedgEntry.Next() = 0;

        Body +=
            '<tr><td colspan="3"><b>Total Outstanding</b></td>' +
            '<td align="right"><b>' + Format(TotalOutstanding) + '</b></td></tr>' +
            '</table>' +
            '<p>Please arrange payment at your earliest convenience. If payment has already been made, please disregard this reminder.</p>' +
            '<p>Regards,<br/>Accounts Receivable</p>' +
            '</body></html>';

        exit(Body);
    end;

    local procedure GetLastReminderDate(CustomerNo: Code[20]): Date
    var
        History: Record "Cust. Reminder History";
    begin
        History.SetRange("Customer No.", CustomerNo);
        History.SetRange(Status, History.Status::Sent);
        if History.FindLast() then
            exit(History."Reminder Date");

        exit(0D);
    end;
}