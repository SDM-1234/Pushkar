namespace Pushkar.Pushkar;

using Microsoft.Foundation.PaymentTerms;
using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;

codeunit 50106 "Update Posted Invoice Due Date"
{
    Permissions =
        tabledata "Sales Invoice Header" = RM,
        tabledata "Cust. Ledger Entry" = RM,
        tabledata "Detailed Cust. Ledg. Entry" = RM;


    trigger OnRun()
    begin
        ProcessPostedSalesInvoices();
    end;

    procedure UpdateDueDateForPostedSalesInvoice(SalesInvoiceNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if not SalesInvoiceHeader.Get(SalesInvoiceNo) then
            exit;

        if not Codeunit.Run(Codeunit::"Posted Inv. Due Date Wkr", SalesInvoiceHeader) then
            LogInvoiceProcessingError(SalesInvoiceNo, GetLastErrorText());
    end;

    local procedure ProcessPostedSalesInvoices()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.SetLoadFields("No.", "Posting Date", "Payment Terms Code", "Due Date");
        if SalesInvoiceHeader.FindSet(false) then
            repeat
                if not Codeunit.Run(Codeunit::"Posted Inv. Due Date Wkr", SalesInvoiceHeader) then
                    LogInvoiceProcessingError(SalesInvoiceHeader."No.", GetLastErrorText());
            until SalesInvoiceHeader.Next() = 0;
    end;

    local procedure LogInvoiceProcessingError(SalesInvoiceNo: Code[20]; ErrorText: Text)
    var
        CustomDimensions: Dictionary of [Text, Text];
    begin
        CustomDimensions.Add('InvoiceNo', SalesInvoiceNo);
        CustomDimensions.Add('ErrorMessage', CopyStr(ErrorText, 1, 250));
        Session.LogMessage('PSK-INV-DUEDATE-ERROR', 'Failed to update due date for a posted sales invoice.', Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, CustomDimensions);
    end;

}