namespace Pushkar.Pushkar;

using Microsoft.Finance.TaxBase;

pageextension 50129 BankPaymentVoucher extends "Bank Payment Voucher"
{
    layout
    {
        addafter("Document No.")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
            }
        }
    }
    Actions
    {
        addafter("Print Check")
        {
            action("Print Check-PTPL")
            {
                RunObject = report "Check Printing";
                ApplicationArea = All;
                Caption = 'Print Check-PTPL';
                ToolTip = 'Prints a check using the PTPL format.';
                Image = Check;
                //Visible = false;

            }
        }
    }
}
