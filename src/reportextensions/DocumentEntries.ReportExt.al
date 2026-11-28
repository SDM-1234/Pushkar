namespace Pushkar.Pushkar;

using Microsoft.Foundation.Navigate;
using Microsoft.Sales.Receivables;

reportextension 50107 DocumentEntries extends "Document Entries"
{
    dataset
    {
        add("Detailed Cust. Ledg. Entry")
        {
            column(AppliedInvoiceNo_DtldCustLedgEntry; AppliedInvoiceNo)
            {
                Caption = 'Invoice No.';
            }
        }

        modify("Detailed Cust. Ledg. Entry")
        {
            trigger OnAfterAfterGetRecord()
            begin
                AppliedInvoiceNo := '';
                //if "Detailed Cust. Ledg. Entry"."Entry Type" <>
                // "Detailed Cust. Ledg. Entry"."Entry Type"::"Initial Entry"
                //then
                //  exit;

                ApplicationDetailedCustLedgEntry.Reset();
                ApplicationDetailedCustLedgEntry.SetRange(
                    "Applied Cust. Ledger Entry No.", "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                ApplicationDetailedCustLedgEntry.SetRange(
                    "Entry Type", ApplicationDetailedCustLedgEntry."Entry Type"::Application);
                if ApplicationDetailedCustLedgEntry.FindFirst() then
                    if ApplicationDetailedCustLedgEntry."Cust. Ledger Entry No." <>
                       ApplicationDetailedCustLedgEntry."Applied Cust. Ledger Entry No."
                    then begin
                        InvoiceInitialDetailedCustLedgEntry.Reset();
                        InvoiceInitialDetailedCustLedgEntry.SetRange(
                            "Cust. Ledger Entry No.", ApplicationDetailedCustLedgEntry."Cust. Ledger Entry No.");
                        InvoiceInitialDetailedCustLedgEntry.SetRange(
                            "Entry Type", InvoiceInitialDetailedCustLedgEntry."Entry Type"::"Initial Entry");
                        if InvoiceInitialDetailedCustLedgEntry.FindFirst() then
                            if StrPos(
                                '|' + AppliedInvoiceNo + '|',
                                '|' + InvoiceInitialDetailedCustLedgEntry."Document No." + '|') = 0
                            then
                                if AppliedInvoiceNo = '' then
                                    AppliedInvoiceNo := InvoiceInitialDetailedCustLedgEntry."Document No."
                                else
                                    AppliedInvoiceNo += ', ' + InvoiceInitialDetailedCustLedgEntry."Document No.";
                    end;
                //until ApplicationDetailedCustLedgEntry.Next() = 0;
            end;
        }
    }


    rendering
    {
        layout(DocumentEntriesPTPL)
        {
            Type = RDLC;
            LayoutFile = 'src/reportlayouts/DocumentEntries.rdl';
        }
    }
    var
        ApplicationDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        InvoiceInitialDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        AppliedInvoiceNo: Text[2048];



}
