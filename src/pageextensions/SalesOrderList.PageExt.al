namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;

pageextension 50112 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Sell-to Customer Name")
        {
            ApplicationArea = All;
            Visible = true;
            ToolTip = 'Specifies the name of the customer that is associated with the sales order.', Comment = '%';
        }

    }

}
