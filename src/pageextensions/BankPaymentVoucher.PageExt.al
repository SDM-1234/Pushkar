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
}
