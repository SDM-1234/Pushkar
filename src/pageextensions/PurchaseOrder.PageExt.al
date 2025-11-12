namespace Pushkar.Pushkar;

using Microsoft.Purchases.Document;

pageextension 50103 PurchaseOrder extends "Purchase Order"
{
    layout
    {

        modify("Location Code")
        {
            Visible = true;
        }
    }
}
