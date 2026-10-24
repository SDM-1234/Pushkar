namespace Pushkar.Pushkar;

using Microsoft.Foundation.PaymentTerms;
using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;

codeunit 50114 "Posted Inv. Due Date Wkr"
{
    TableNo = "Sales Invoice Header";

    Permissions =
        tabledata "Sales Invoice Header" = RM,
        tabledata "Cust. Ledger Entry" = RM,
        tabledata "Detailed Cust. Ledg. Entry" = RM;

    trigger OnRun()
    var
        PaymentTerms: Record "Payment Terms";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        CalculatedDueDate: Date;
    begin
        CalculatedDueDate := Rec."Posting Date";
        if Rec."Payment Terms Code" <> '' then begin
            PaymentTerms.Get(Rec."Payment Terms Code");
            CalculatedDueDate := CalcDate(PaymentTerms."Due Date Calculation", Rec."Posting Date");
        end;

        if Rec."Due Date" <> CalculatedDueDate then begin
            Rec.Validate("Due Date", CalculatedDueDate);
            Rec.Modify();
        end;

        CustomerLedgerEntry.SetRange("Document Type", CustomerLedgerEntry."Document Type"::Invoice);
        CustomerLedgerEntry.SetRange("Document No.", Rec."No.");
        CustomerLedgerEntry.SetFilter("Due Date", '<>%1', CalculatedDueDate);
        if CustomerLedgerEntry.FindSet(false) then
            repeat
                CustomerLedgerEntry.Validate("Due Date", CalculatedDueDate);
                CustomerLedgerEntry.Modify();

                DetailedCustLedgerEntry.SetRange("Cust. Ledger Entry No.", CustomerLedgerEntry."Entry No.");
                DetailedCustLedgerEntry.SetFilter("Initial Entry Due Date", '<>%1', CalculatedDueDate);
                if DetailedCustLedgerEntry.FindSet(false) then
                    repeat
                        DetailedCustLedgerEntry.Validate("Initial Entry Due Date", CalculatedDueDate);
                        DetailedCustLedgerEntry.Modify();
                    until DetailedCustLedgerEntry.Next() = 0;
            until CustomerLedgerEntry.Next() = 0;
    end;
}
