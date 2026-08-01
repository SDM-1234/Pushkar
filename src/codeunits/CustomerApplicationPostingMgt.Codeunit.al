
namespace Pushkar.Pushkar;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Payables;
using Microsoft.Sales.Receivables;

codeunit 50108 ApplicationPostingMgt
{

    trigger OnRun()
    var


    begin

    end;

    local procedure SetSingleInstanceValues(ApplyingCustLedgerEntry: Record "Cust. Ledger Entry")
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        SingleInstanceCU.SetApplicationCustLedgerEntryParameters(ApplyingCustLedgerEntry);
        SingleInstanceCU.SetIsHandled(true);
    end;

    local procedure SetApplyCustomerLedgerEntries(CustLedgEntry: Record "Cust. Ledger Entry")
    var
        ApplyCustEntries: Page "Apply Customer Entries";
    begin

        ApplyCustEntries.SetSelectionFilter(CustLedgEntry);
        ApplyCustEntries.SetRecord(CustLedgEntry);

        ApplyCustEntries.SetCustLedgEntry(CustLedgEntry);
        ApplyCustEntries.SetApplyingCustLedgEntry();


        ApplyCustEntries.SetAppliesToID(UserID());
        ApplyCustEntries.SetCustApplId(false);

    end;



    local procedure UpdateDetailedApplication(DtldCustLedEntry: Record DtldCustomerLedgerEntry; Error: Boolean; ErrorText: Text[250]; Closed: Boolean)
    begin
        DtldCustLedEntry.Error := Error;
        DtldCustLedEntry."Error Text" := ErrorText;
        DtldCustLedEntry.Closed := Closed;
        DtldCustLedEntry.Modify();
    end;


    procedure PostApplication(DtldCustLedEntry3: Record DtldCustomerLedgerEntry; DtldCustLedEntry: Record DtldCustomerLedgerEntry; ApplicationPostingDate: Date)
    var
        ApplyingCustLedgerEntry: Record "Cust. Ledger Entry";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        SingleInstanceCU: Codeunit SingleInstanceCU;
        ErrorText: Text[250];
    begin

        Clear(ErrorText);

        if not applicationPosting(NewApplyUnapplyParameters, ApplyingCustLedgerEntry, ApplicationPostingDate, DtldCustLedEntry3, DtldCustLedEntry) then begin
            SingleInstanceCU.SetIsHandled(false);
            ErrorText := CopyStr(GetLastErrorText(), 1, 250);
            UpdateDetailedApplication(DtldCustLedEntry3, true, ErrorText, false);
        end else
            UpdateDetailedApplication(DtldCustLedEntry3, False, ErrorText, True);

    end;

    [TryFunction]
    procedure ApplicationPosting(var NewApplyUnapplyParameters: Record "Apply Unapply Parameters"; ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; ApplicationPostingDate: Date; DtldCustLedEntry3: Record DtldCustomerLedgerEntry; DtldCustLedEntry: Record DtldCustomerLedgerEntry)
    var
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplicationPage: Page "Post Application";

    begin

        CustomerLedgerEntry := GetCustomerLedgerEntry(DtldCustLedENtry3);
        ApplyingCustLedgerEntry := GetApplyingCustomerLedgerEntry(DtldCustLedEntry);
        SetApplyCustomerLedgerEntries(CustomerLedgerEntry);

        SetSingleInstanceValues(ApplyingCustLedgerEntry);


        CustEntryApplyPostedEntries.ApplyCustEntryFormEntry(ApplyingCustLedgerEntry);

        ApplyUnapplyParameters.CopyFromCustLedgEntry(ApplyingCustLedgerEntry);
        ApplyUnapplyParameters."Posting Date" := ApplicationPostingDate;
        PostApplicationPage.SetParameters(ApplyUnapplyParameters);
        PostApplicationPage.GetParameters(NewApplyUnapplyParameters);
        CustEntryApplyPostedEntries.Apply(ApplyingCustLedgerEntry, NewApplyUnapplyParameters);
    end;

    procedure GetApplyingCustomerLedgerEntry(DtldCustLedENtry: Record DtldCustomerLedgerEntry): Record "Cust. Ledger Entry"
    var
        ApplyingCustLedgerEntry: Record "Cust. Ledger Entry";
    begin

        ApplyingCustLedgerEntry.Reset();
        ApplyingCustLedgerEntry.SetRange("Document No.", DtldCustLedEntry."Document No.");
        ApplyingCustLedgerEntry.SetRange("Document Type", DtldCustLedEntry."Document Type");
        ApplyingCustLedgerEntry.CalcFields("Remaining Amount", Amount);
        if ApplyingCustLedgerEntry.findfirst() then
            exit(ApplyingCustLedgerEntry);

    end;


    procedure GetCustomerLedgerEntry(DtldCustLedENtry3: Record DtldCustomerLedgerEntry): Record "Cust. Ledger Entry"
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustomerLedgerEntry.Reset();
        CustomerLedgerEntry.SetRange("Document No.", DtldCustLedENtry3."Document No.");
        CustomerLedgerEntry.SetRange("Document Type", DtldCustLedENtry3."Document Type");
        CustomerLedgerEntry.CalcFields("Remaining Amount", Amount);
        if CustomerLedgerEntry.findfirst() then
            exit(CustomerLedgerEntry);
    end;

}