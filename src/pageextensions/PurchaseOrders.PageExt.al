namespace Pushkar.Pushkar;

using Microsoft.Purchases.Document;

pageextension 50137 PurchaseOrders extends "Purchase Orders"
{
    layout
    {
        Addafter("Buy-from Vendor No.")
        {
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Transaction Type';
            }
        }
    }
}
