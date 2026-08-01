
namespace Pushkar.Pushkar;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Payables;
using Microsoft.Sales.Receivables;

codeunit 50116 VendorApplicationPostingMgt
{

    trigger OnRun()
    var


    begin

    end;

    local procedure SetSingleInstanceValues(ApplyingVendLedgerEntry: Record "Vendor Ledger Entry")
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        SingleInstanceCU.SetApplicationVendLedgerEntryParameters(ApplyingVendLedgerEntry);
        SingleInstanceCU.SetIsHandled(true);
    end;

    local procedure SetApplyVendorLedgerEntries(VendLedgEntry: Record "Vendor Ledger Entry")
    var
        ApplyVendEntries: Page "Apply Vendor Entries";
    begin

        ApplyVendEntries.SetSelectionFilter(VendLedgEntry);
        ApplyVendEntries.SetRecord(VendLedgEntry);

        ApplyVendEntries.SetVendLedgEntry(VendLedgEntry);
        ApplyVendEntries.SetApplyingVendLedgEntry();


        ApplyVendEntries.SetAppliesToID(UserID());
        ApplyVendEntries.SetVendApplId(false);

    end;



    local procedure UpdateDetailedApplication(DtldVendLedEntry: Record DetailedVendorLedgerEntry; Error: Boolean; ErrorText: Text[250]; Closed: Boolean)
    begin
        DtldVendLedEntry.Error := Error;
        DtldVendLedEntry."Error Text" := ErrorText;
        DtldVendLedEntry.Closed := Closed;
        DtldVendLedEntry.Modify();
    end;


    procedure PostApplication(DtldVendLedEntry3: Record DetailedVendorLedgerEntry; DtldVendLedEntry: Record DetailedVendorLedgerEntry; ApplicationPostingDate: Date)
    var
        ApplyingVendLedgerEntry: Record "Vendor Ledger Entry";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        SingleInstanceCU: Codeunit SingleInstanceCU;
        ErrorText: Text[250];
    begin

        Clear(ErrorText);

        if not applicationPosting(NewApplyUnapplyParameters, ApplyingVendLedgerEntry, ApplicationPostingDate, DtldVendLedEntry3, DtldVendLedEntry) then begin
            SingleInstanceCU.SetIsHandled(false);
            ErrorText := CopyStr(GetLastErrorText(), 1, 250);
            UpdateDetailedApplication(DtldVendLedEntry3, true, ErrorText, false);
        end else
            UpdateDetailedApplication(DtldVendLedEntry3, False, ErrorText, True);

    end;

    [TryFunction]
    procedure ApplicationPosting(var NewApplyUnapplyParameters: Record "Apply Unapply Parameters"; ApplyingVendLedgerEntry: Record "Vendor Ledger Entry"; ApplicationPostingDate: Date; DtldVendLedEntry3: Record DetailedVendorLedgerEntry; DtldVendLedEntry: Record DetailedVendorLedgerEntry)
    var
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        PostApplicationPage: Page "Post Application";

    begin

        VendorLedgerEntry := GetVendorLedgerEntry(DtldVendLedENtry3);
        ApplyingVendLedgerEntry := GetApplyingVendorLedgerEntry(DtldVendLedEntry);
        SetApplyVendorLedgerEntries(VendorLedgerEntry);

        SetSingleInstanceValues(ApplyingVendLedgerEntry);


        VendEntryApplyPostedEntries.ApplyVendEntryFormEntry(ApplyingVendLedgerEntry);

        ApplyUnapplyParameters.CopyFromVendLedgEntry(ApplyingVendLedgerEntry);
        ApplyUnapplyParameters."Posting Date" := ApplicationPostingDate;
        PostApplicationPage.SetParameters(ApplyUnapplyParameters);
        PostApplicationPage.GetParameters(NewApplyUnapplyParameters);
        VendEntryApplyPostedEntries.Apply(ApplyingVendLedgerEntry, NewApplyUnapplyParameters);
    end;

    procedure GetApplyingVendorLedgerEntry(DtldVendLedENtry: Record DetailedVendorLedgerEntry): Record "Vendor Ledger Entry"
    var
        ApplyingVendLedgerEntry: Record "Vendor Ledger Entry";
    begin

        ApplyingVendLedgerEntry.Reset();
        ApplyingVendLedgerEntry.SetRange("Document No.", DtldVendLedEntry."Document No.");
        ApplyingVendLedgerEntry.SetRange("Document Type", DtldVendLedEntry."Document Type");
        ApplyingVendLedgerEntry.CalcFields("Remaining Amount", Amount);
        if ApplyingVendLedgerEntry.findfirst() then
            exit(ApplyingVendLedgerEntry);

    end;


    procedure GetVendorLedgerEntry(DtldVendLedENtry3: Record DetailedVendorLedgerEntry): Record "Vendor Ledger Entry"
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document No.", DtldVendLedENtry3."Document No.");
        VendorLedgerEntry.SetRange("Document Type", DtldVendLedENtry3."Document Type");
        VendorLedgerEntry.CalcFields("Remaining Amount", Amount);
        if VendorLedgerEntry.findfirst() then
            exit(VendorLedgerEntry);
    end;

}