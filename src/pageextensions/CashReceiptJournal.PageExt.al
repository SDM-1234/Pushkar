namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.TaxBase;

pageextension 50135 CashReceiptJournal extends "Cash Receipt Journal"
{
    actions
    {
        addlast("&Line")
        {
            action("Line Narration")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Line Narration';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select this option to enter narration for a particular line.';

                trigger OnAction()
                var
                    GenNarration: Record "Gen. Journal Narration";
                    LineNarrationPage: Page "Line Narration";
                begin
                    GenNarration.Reset();
                    GenNarration.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenNarration.SetRange("Document No.", Rec."Document No.");
                    GenNarration.SetRange("Gen. Journal Line No.", Rec."Line No.");
                    LineNarrationPage.SetTableView(GenNarration);
                    LineNarrationPage.RunModal();

                    //  ShowOldNarration();
                    VoucherFunctions.ShowOldNarration(Rec);
                    CurrPage.Update(true);
                end;
            }
            action("Voucher Narration")
            {
                PromotedOnly = true;
                ApplicationArea = Basic, Suite;
                Caption = 'Journal Narration';
                Image = LineDescription;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select this option to enter narration for the voucher.';

                trigger OnAction()
                var
                    GenNarration: Record "Gen. Journal Narration";
                    VoucherNarration: Page "Voucher Narration";
                begin
                    GenNarration.Reset();
                    GenNarration.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenNarration.SetRange("Document No.", Rec."Document No.");
                    GenNarration.SetFilter("Gen. Journal Line No.", '%1', 0);
                    VoucherNarration.SetTableView(GenNarration);
                    VoucherNarration.RunModal();

                    // ShowOldNarration();
                    VoucherFunctions.ShowOldNarration(Rec);
                    CurrPage.Update(true);
                end;
            }
        }

    }
    var
        VoucherFunctions: Codeunit "Voucher Functions";
}