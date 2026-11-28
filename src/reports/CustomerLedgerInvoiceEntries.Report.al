namespace Pushkar.Pushkar;

using Microsoft.Sales.Receivables;

report 50117 "Cust. Ledger Invoice Details"
{
    ApplicationArea = All;
    Caption = 'Customer Ledger Invoice Entries';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = RDLC;

    dataset
    {
        dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
        {
            RequestFilterFields = "Customer No.", "Posting Date", "Document No.", "Entry Type";

            column(EntryNo; "Entry No.")
            {
                Caption = 'Detailed Entry No.';
            }

            column(CustomerNo; "Customer No.")
            {
                Caption = 'Customer No.';
            }

            column(PostingDate; "Posting Date")
            {
                Caption = 'Posting Date';
            }

            column(DocumentType; "Document Type")
            {
                Caption = 'Document Type';
            }

            column(DocumentNo; "Document No.")
            {
                Caption = 'Document No.';
            }

            column(EntryType; "Entry Type")
            {
                Caption = 'Entry Type';
            }

            column(CustLedgerEntryNo; "Cust. Ledger Entry No.")
            {
                Caption = 'Customer Ledger Entry No.';
            }

            column(AppliedCustLedgerEntryNo; "Applied Cust. Ledger Entry No.")
            {
                Caption = 'Applied Customer Ledger Entry No.';
            }

            column(Amount; Amount)
            {
                Caption = 'Amount';
            }

            column(AppliedInvoiceNos; AppliedInvoiceNos)
            {
                Caption = 'Applied Invoice No(s).';
            }

            trigger OnAfterGetRecord()
            begin
                FindAppliedInvoiceNos();
            end;
        }
    }

    rendering
    {
        layout(RDLC)
        {
            Type = RDLC;
            LayoutFile = 'src/reportLayouts/CustomerLedgerInvoiceEntries.rdl';
        }
    }

    var
        ApplicationDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        InvoiceInitialDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        AppliedInvoiceNos: Text[2048];

    local procedure FindAppliedInvoiceNos()
    begin
        Clear(AppliedInvoiceNos);

        ApplicationDetailedCustLedgEntry.Reset();
        ApplicationDetailedCustLedgEntry.SetRange(
            "Applied Cust. Ledger Entry No.", DetailedCustLedgEntry."Cust. Ledger Entry No.");
        ApplicationDetailedCustLedgEntry.SetRange(
            "Entry Type", ApplicationDetailedCustLedgEntry."Entry Type"::Application);

        if ApplicationDetailedCustLedgEntry.FindSet() then
            repeat
                if ApplicationDetailedCustLedgEntry."Cust. Ledger Entry No." <>
                   ApplicationDetailedCustLedgEntry."Applied Cust. Ledger Entry No."
                then begin
                    InvoiceInitialDetailedCustLedgEntry.Reset();
                    InvoiceInitialDetailedCustLedgEntry.SetRange(
                        "Cust. Ledger Entry No.", ApplicationDetailedCustLedgEntry."Cust. Ledger Entry No.");
                    InvoiceInitialDetailedCustLedgEntry.SetRange(
                        "Entry Type", InvoiceInitialDetailedCustLedgEntry."Entry Type"::"Initial Entry");
                    InvoiceInitialDetailedCustLedgEntry.SetRange(
                        "Initial Document Type", InvoiceInitialDetailedCustLedgEntry."Initial Document Type"::Invoice);

                    if InvoiceInitialDetailedCustLedgEntry.FindFirst() then
                        AddAppliedInvoiceNo(InvoiceInitialDetailedCustLedgEntry."Document No.");
                end;
            until ApplicationDetailedCustLedgEntry.Next() = 0;
    end;

    local procedure AddAppliedInvoiceNo(InvoiceNo: Code[20])
    begin
        if InvoiceNo = '' then
            exit;

        if StrPos('|' + AppliedInvoiceNos + '|', '|' + InvoiceNo + '|') > 0 then
            exit;

        if AppliedInvoiceNos = '' then
            AppliedInvoiceNos := InvoiceNo
        else
            AppliedInvoiceNos += ', ' + InvoiceNo;
    end;
}
