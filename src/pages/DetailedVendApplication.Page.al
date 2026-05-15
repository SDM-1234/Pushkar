page 50115 DetailedVendApplication
{
    ApplicationArea = All;
    Caption = 'Dtld Vend. Ledger for Application Posting';
    PageType = List;
    SourceTable = DetailedVendorLedgerEntry;
    UsageCategory = Lists;
    Permissions = TableData "Vendor Ledger Entry" = rm;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                }
                field("Vendor Ledger Entry No."; Rec."Vendor Ledger Entry No.")
                {
                }
                field("Dtld. Vendor Ledger Entry No."; Rec."Dtld. Vendor Ledger Entry No.")
                {
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.', Comment = '%';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of the Error Text field.', Comment = '%';
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
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                begin
                    VendorLedgerEntry.SetRange("Applies-to ID", UserID());
                    VendorLedgerEntry.ModifyAll("Applies-to ID", '');
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
                    ApplyingVendLedgerEntry: record "Vendor Ledger Entry";
                    DtldVendLedENtry2: Record DetailedVendorLedgerEntry;//Application
                    DtldVendLedENtry3: Record DetailedVendorLedgerEntry;//Invoice
                    DtldVendLedENtry: Record DetailedVendorLedgerEntry;
                    NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
                    RecVLE: Record "Vendor Ledger Entry" temporary;

                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                    SingleInstanceCU: Codeunit SingleInstanceCU;
                    VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    ApplicationPostingDate: Date;
                    AppliedAmount: Decimal;
                    ErrorText: Text[250];

                begin
                    DtldVendLedEntry.Reset();
                    DtldVendLedEntry.SetRange(Closed, false);
                    DtldVendLedEntry.Setrange("Document Type", DtldVendLedEntry."Document Type"::Payment);
                    if DtldVendLedEntry.FindSet() then
                        repeat

                            DtldVendLedEntry2.Reset();
                            DtldVendLedEntry2.SetRange(Closed, false);
                            DtldVendLedEntry2.SetRange("Applied Vend. Ledger Entry No.", DtldVendLedEntry."Vendor Ledger Entry No.");
                            if DtldVendLedEntry2.FindSet() then
                                repeat

                                    ApplicationPostingDate := DtldVendLedEntry2."Posting Date";

                                    DtldVendLedEntry3.Reset();
                                    DtldVendLedEntry3.SetRange(Closed, false);
                                    DtldVendLedEntry3.SetRange("Vendor Ledger Entry No.", DtldVendLedENtry2."Vendor Ledger Entry No.");
                                    DtldVendLedEntry3.Setrange("Document Type", DtldVendLedENtry3."Document Type"::Invoice);
                                    DtldVendLedEntry3.SetRange("Entry Type", 'Initial Entry');
                                    if DtldVendLedEntry3.findfirst() then
                                        if DtldVendLedENtry3."Vendor Ledger Entry No." <> DtldVendLedENtry2."Applied Vend. Ledger Entry No." then begin

                                            Clear(ErrorText);

                                            VendorLedgerEntry := GetVendorLedgerEntry(DtldVendLedENtry3);
                                            ApplyingVendLedgerEntry := GetApplyingVendorLedgerEntry(DtldVendLedEntry);

                                            //RecVLE.Copy(VendorLedgerEntry);

                                            SetApplyVendorLedgerEntries(VendorLedgerEntry);

                                            SetSingleInstanceValues(ApplyingVendLedgerEntry);

                                            VendEntryApplyPostedEntries.ApplyVendEntryFormEntry(ApplyingVendLedgerEntry);


                                            if not applicationPosting(NewApplyUnapplyParameters, ApplyingVendLedgerEntry, ApplicationPostingDate) then begin

                                                SingleInstanceCU.SetIsHandled(false);

                                                ErrorText := CopyStr(GetLastErrorText(), 1, 250);
                                                UpdateDetailedApplication(DtldVendLedEntry3, true, ErrorText, false);
                                            end else
                                                UpdateDetailedApplication(DtldVendLedEntry3, False, ErrorText, True);
                                        end;
                                until DtldVendLedEntry2.Next() = 0;

                        until DtldVendLedENtry.Next() = 0;

                end;
            }
        }
    }


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

    [TryFunction]
    local procedure ApplicationPosting(var NewApplyUnapplyParameters: Record "Apply Unapply Parameters"; ApplyingVendLedgerEntry: Record "Vendor Ledger Entry"; ApplicationPostingDate: Date)
    var
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        PostApplicationPage: Page "Post Application";
    begin
        ApplyUnapplyParameters.CopyFromVendLedgEntry(ApplyingVendLedgerEntry);
        ApplyUnapplyParameters."Posting Date" := ApplicationPostingDate;
        PostApplicationPage.SetParameters(ApplyUnapplyParameters);
        PostApplicationPage.GetParameters(NewApplyUnapplyParameters);
        VendEntryApplyPostedEntries.Apply(ApplyingVendLedgerEntry, NewApplyUnapplyParameters);
    end;

    local procedure GetApplyingVendorLedgerEntry(DtldVendLedENtry: Record DetailedVendorLedgerEntry): Record "Vendor Ledger Entry"
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


    local procedure GetVendorLedgerEntry(DtldVendLedENtry3: Record DetailedVendorLedgerEntry): Record "Vendor Ledger Entry"
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