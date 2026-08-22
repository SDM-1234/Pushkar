namespace Pushkar.Pushkar;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Purchases.Payables;

page 50113 VendorAplicationPosting
{
    ApplicationArea = All;
    Caption = 'Vendor Application Posting';
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
                    DtldVendLedENtry2: Record DetailedVendorLedgerEntry;//Application
                    DtldVendLedENtry3: Record DetailedVendorLedgerEntry;//Invoice
                    DtldVendLedENtry: Record DetailedVendorLedgerEntry;
                    ApplicationPostingMgt: Codeunit VendorApplicationPostingMgt;
                    ProgressWindow: Dialog;
                    ApplicationPostingDate: Date;
                    CurrentRecord: Integer;
                    ProgressPercent: Integer;
                    TotalRecords: Integer;
                    Text0001Tok: Label 'Posting Detailed Application...\\Processing Entry: #1###### of #2######)';

                begin


                    DtldVendLedEntry.Reset();
                    DtldVendLedEntry.SetRange(Closed, false);
                    DtldVendLedEntry.SetFilter("Document Type", '%1|%2', DtldVendLedEntry."Document Type"::Payment, DtldVendLedEntry."Document Type"::" ");

                    TotalRecords := DtldVendLedEntry.Count();
                    if TotalRecords = 0 then
                        exit;
                    ProgressWindow.Open(Text0001Tok);
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
                                    DtldVendLedEntry3.SetRange("Vendor Ledger Entry No.", DtldVendLedEntry2."Vendor Ledger Entry No.");
                                    DtldVendLedEntry3.Setrange("Document Type", DtldVendLedEntry3."Document Type"::Invoice);//, DtldVendLedEntry3."Document Type"::"Credit Memo");
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