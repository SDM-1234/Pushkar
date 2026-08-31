namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50144 PaymentJournal extends "Payment Journal"
{
    Actions
    {
        addafter(PreCheck)
        {
            action("Print Check-PTPL")
            {
                ApplicationArea = All;
                Caption = 'Print Check-PTPL';
                ToolTip = 'Prints a check using the PTPL format.';
                Image = Check;
                //Visible = false;

                trigger OnAction()
                var
                    CheckPrinting: Report "Check Printing";
                begin
                    CheckPrinting.SetChequeParameter(Rec."Document No.", Rec."Journal Template Name", Rec."Journal Batch Name");
                    CheckPrinting.Run();
                end;

            }
        }
    }
}
