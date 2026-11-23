namespace Pushkar.Pushkar;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Payables;

page 50113 VendorAplicationPosting
{
    ApplicationArea = All;
    Caption = 'Vendor Application Posting';
    PageType = List;
    SourceTable = DetailedVendorLedgerEntry;
    UsageCategory = Tasks;
    Permissions = TableData "Vendor Ledger Entry" = rm;

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
                field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Vend. Ledger Entry No. field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                }
                field("Vendor Ledger Entry No."; Rec."Vendor Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Ledger Entry No. field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
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
                field("Dtld. Vendor Ledger Entry No."; Rec."Dtld. Vendor Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Dtld. Vendor Ledger Entry No. field.', Comment = '%';
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
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                begin
                    VendorLedgerEntry.SetRange("Applies-to ID", UserID());
                    VendorLedgerEntry.ModifyAll("Applies-to ID", '');
                end;
            }
            action(ClearErrors)
            {
                ApplicationArea = All;
                Caption = 'Clear Errors';
                Image = ClearLog;

                trigger OnAction()
                var
                    DtldVendLedEntry: Record DetailedVendorLedgerEntry;
                begin
                    DtldVendLedEntry.Reset();
                    DtldVendLedEntry.SetFilter("Error Text", '<>%1', '');

                    if DtldVendLedEntry.FindSet() then
                        repeat
                            DtldVendLedEntry.Error := false;
                            DtldVendLedEntry."Error Text" := '';
                            DtldVendLedEntry.Modify();
                        until DtldVendLedEntry.Next() = 0;

                    CurrPage.Update(false);
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
                    DtldVendLedENtry2: Record DetailedVendorLedgerEntry;//Application
                    DtldVendLedENtry3: Record DetailedVendorLedgerEntry;//Invoice
                    DtldVendLedENtry: Record DetailedVendorLedgerEntry;
                    ApplicationPostingMgt: Codeunit VendorApplicationPostingMgt;
                    ProgressWindow: Dialog;
                    ApplicationPostingDate: Date;
                    CurrentRecord: Integer;
                    ProgressPercent: Integer;
                    TotalRecords: Integer;
                    Text0001Tok: Label 'Posting Detailed Application...\\Processing Entry: #1###### of #2###### of #3######)';

                begin

                    DtldVendLedEntry.Reset();
                    DtldVendLedEntry.SetRange(Closed, false);
                    DtldVendLedEntry.SetRange(Error, false);
                    DtldVendLedEntry.SetFilter("Document Type", '%1|%2', DtldVendLedEntry."Document Type"::Payment, DtldVendLedEntry."Document Type"::" ");

                    TotalRecords := DtldVendLedEntry.Count();
                    if TotalRecords = 0 then
                        exit;
                    ProgressWindow.Open(Text0001Tok);
                    if DtldVendLedEntry.FindSet() then
                        repeat
                            DtldVendLedEntry2.Reset();
                            DtldVendLedEntry2.SetRange(Closed, false);
                            DtldVendLedEntry2.SetRange(Error, false);
                            DtldVendLedEntry2.SetRange("Applied Vend. Ledger Entry No.", DtldVendLedEntry."Vendor Ledger Entry No.");
                            DtldVendLedEntry2.SetRange("Vendor No.", DtldVendLedEntry."Vendor No.");

                            if DtldVendLedEntry2.FindSet() then
                                repeat
                                    ApplicationPostingDate := DtldVendLedEntry2."Posting Date";
                                    DtldVendLedEntry3.Reset();
                                    DtldVendLedEntry3.SetRange(Error, false);
                                    DtldVendLedEntry3.SetRange(Closed, false);
                                    DtldVendLedEntry3.SetRange("Vendor No.", DtldVendLedEntry2."Vendor No.");
                                    DtldVendLedEntry3.SetRange("Vendor Ledger Entry No.", DtldVendLedEntry2."Vendor Ledger Entry No.");
                                    DtldVendLedEntry3.SetFilter(
                                        "Document Type", '%1|%2', DtldVendLedEntry3."Document Type"::Invoice,
                                        DtldVendLedEntry3."Document Type"::"Credit Memo"
                                    );
                                    DtldVendLedEntry3.SetRange("Entry Type", 'Initial Entry');
                                    if DtldVendLedEntry3.findfirst() then
                                        if DtldVendLedEntry3."Vendor Ledger Entry No." <> DtldVendLedEntry2."Applied Vend. Ledger Entry No." then begin

                                            CurrentRecord += 1;

                                            if CurrentRecord mod 10 = 0 then begin
                                                // 2. Update Window values
                                                // Calculate percentage for progress bar (#3)
                                                ProgressPercent := Round((CurrentRecord / TotalRecords) * 10000, 1, '>');

                                                ProgressWindow.Update(1, CurrentRecord);
                                                ProgressWindow.Update(2, TotalRecords);
                                                ProgressWindow.Update(3, ProgressPercent);
                                            end;
                                            ApplicationPostingMgt.PostApplication(DtldVendLedEntry3, DtldVendLedEntry, ApplicationPostingDate);

                                            ApplicationPostingMgt.Run() // 
                                        end;
                                until DtldVendLedEntry2.Next() = 0;

                        until DtldVendLedEntry.Next() = 0;

                    // 3. Close Progress Window
                    ProgressWindow.Close();

                    Message('Detailed application posting completed successfully.');
                end;

            }
        }
    }
}