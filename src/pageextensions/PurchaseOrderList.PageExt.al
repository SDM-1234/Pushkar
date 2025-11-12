namespace Pushkar.Pushkar;

using Microsoft.Purchases.Document;

pageextension 50108 PurchaseOrderList extends "Purchase Order List"
{
    layout
    {
        modify("Buy-from Vendor Name")
        {
            ApplicationArea = All;
            Visible = true;
            ToolTip = 'Specifies the name of the vendor that is associated with the purchase order.', Comment = '%';
        }
    }
}
