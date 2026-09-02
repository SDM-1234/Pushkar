namespace Pushkar.Pushkar;

using Microsoft.Sales.History;

pageextension 50145 GetShipmentLines extends "Get Shipment Lines"
{

    layout
    {
        addafter("No.")
        {
            field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
            }
        }
    }
}
