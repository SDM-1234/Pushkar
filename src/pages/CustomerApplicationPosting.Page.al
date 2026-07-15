namespace Pushkar.Pushkar;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Sales.Receivables;

page 50104 CustomerApplicationPosting
{
    ApplicationArea = All;
    Caption = 'Customer Application Posting';
    PageType = List;
    SourceTable = DtldCustomerLedgerEntry;
    UsageCategory = Tasks;
    Permissions = TableData "Cust. Ledger Entry" = rm;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Cust. Ledger Entry No. field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                }
                field("Customer Ledger Entry No."; Rec."Customer Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Customer Ledger Entry No. field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Dtld. Cust. Ledger Entry No."; Rec."Dtld. Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Dtld. Cust. Ledger Entry No. field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.', Comment = '%';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of the Error Text field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ClearAppliestoID)
            {
                ApplicationArea = All;
                Caption = 'Clear Applies-to ID';
                Image = ClearLog;

                trigger OnAction()
                var
                    CustomerLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustomerLedgerEntry.SetRange("Applies-to ID", UserID());
                    CustomerLedgerEntry.ModifyAll("Applies-to ID", '');
                end;
            }
            action(EnableApplyLedgerEntriesPage)
            {
                ApplicationArea = All;
                Caption = 'Enable Apply Ledger Entries Page';
                Image = EnableAllBreakpoints;

                trigger OnAction()
                var
                    SingleInstanceCU: Codeunit SingleInstanceCU;
                begin
                    SingleInstanceCU.SetIsHandled(false);
                end;
            }
            action(PostApplication)
            {
                ApplicationArea = All;
                Caption = 'Post Application';
                Image = PostApplication;

                trigger OnAction()
                var
                    ApplyingCustLedgerEntry: Record "Cust. Ledger Entry";
                    DtldCustLedENtry2: Record DtldCustomerLedgerEntry;//Application
                    DtldCustLedENtry3: Record DtldCustomerLedgerEntry;//Invoice
                    DtldCustLedENtry: Record DtldCustomerLedgerEntry;
                    NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
                    RecVLE: Record "Cust. Ledger Entry" temporary;

                    CustomerLedgerEntry: Record "Cust. Ledger Entry";
                    SingleInstanceCU: Codeunit SingleInstanceCU;
                    CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
                    ApplicationPostingDate: Date;
                    ErrorText: Text[250];

                begin
                    DtldCustLedEntry.Reset();
                    DtldCustLedEntry.SetRange(Closed, false);
                    DtldCustLedEntry.Setrange("Document Type", DtldCustLedEntry."Document Type"::Payment);
                    if DtldCustLedEntry.FindSet() then
                        repeat

                            DtldCustLedEntry2.Reset();
                            DtldCustLedEntry2.SetRange(Closed, false);
                            DtldCustLedEntry2.SetRange("Applied Cust. Ledger Entry No.", DtldCustLedEntry."Customer Ledger Entry No.");
                            if DtldCustLedEntry2.FindSet() then
                                repeat

                                    ApplicationPostingDate := DtldCustLedEntry2."Posting Date";
                                    DtldCustLedEntry3.Reset();
                                    DtldCustLedEntry3.SetRange(Closed, false);
                                    DtldCustLedEntry3.SetRange("Customer Ledger Entry No.", DtldCustLedENtry2."Customer Ledger Entry No.");
                                    DtldCustLedEntry3.Setrange("Document Type", DtldCustLedENtry3."Document Type"::Invoice);//, DtldCustLedENtry3."Document Type"::"Credit Memo");
                                    DtldCustLedEntry3.SetRange("Entry Type", 'Initial Entry');
                                    if DtldCustLedEntry3.findfirst() then
                                        if DtldCustLedENtry3."Customer Ledger Entry No." <> DtldCustLedENtry2."Applied Cust. Ledger Entry No." then begin

                                            Clear(ErrorText);

                                            CustomerLedgerEntry := GetCustomerLedgerEntry(DtldCustLedENtry3);
                                            ApplyingCustLedgerEntry := GetApplyingCustomerLedgerEntry(DtldCustLedEntry);

                                            //RecVLE.Copy(CustomerLedgerEntry);

                                            SetApplyCustomerLedgerEntries(CustomerLedgerEntry);

                                            SetSingleInstanceValues(ApplyingCustLedgerEntry);

                                            CustEntryApplyPostedEntries.ApplyCustEntryFormEntry(ApplyingCustLedgerEntry);


                                            if not applicationPosting(NewApplyUnapplyParameters, ApplyingCustLedgerEntry, ApplicationPostingDate) then begin

                                                SingleInstanceCU.SetIsHandled(false);

                                                ErrorText := CopyStr(GetLastErrorText(), 1, 250);
                                                UpdateDetailedApplication(DtldCustLedEntry3, true, ErrorText, false);
                                            end else
                                                UpdateDetailedApplication(DtldCustLedEntry3, False, ErrorText, True);
                                        end;
                                until DtldCustLedEntry2.Next() = 0;

                        until DtldCustLedENtry.Next() = 0;

                end;
            }
        }
    }


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

    [TryFunction]
    local procedure ApplicationPosting(var NewApplyUnapplyParameters: Record "Apply Unapply Parameters"; ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; ApplicationPostingDate: Date)
    var
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplicationPage: Page "Post Application";
    begin
        ApplyUnapplyParameters.CopyFromCustLedgEntry(ApplyingCustLedgerEntry);
        ApplyUnapplyParameters."Posting Date" := ApplicationPostingDate;
        PostApplicationPage.SetParameters(ApplyUnapplyParameters);
        PostApplicationPage.GetParameters(NewApplyUnapplyParameters);
        CustEntryApplyPostedEntries.Apply(ApplyingCustLedgerEntry, NewApplyUnapplyParameters);
    end;

    local procedure GetApplyingCustomerLedgerEntry(DtldCustLedENtry: Record DtldCustomerLedgerEntry): Record "Cust. Ledger Entry"
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


    local procedure GetCustomerLedgerEntry(DtldCustLedENtry3: Record DtldCustomerLedgerEntry): Record "Cust. Ledger Entry"
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
