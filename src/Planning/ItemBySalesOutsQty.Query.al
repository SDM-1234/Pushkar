query 50100 "Item By Sales Outs Qty"
{
    QueryType = Normal;
    Caption = 'Item By Sales Outstanding Quantity';

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = filter(Order), "Outstanding Quantity" = filter('>0'), "Type" = filter(Item);
            column(Outstanding_Quantity; "Outstanding Qty. (Base)")
            {
                Method = Sum;

            }
            filter(Shipment_Date; "Shipment Date")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(Item_No; "No.")
            {

            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}