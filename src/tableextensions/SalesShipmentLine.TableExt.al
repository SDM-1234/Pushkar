namespace Pushkar.Pushkar;

using Microsoft.Sales.History;

tableextension 50123 SalesShipmentLine extends "Sales Shipment Line"
{
    fields
    {
        field(50104; "Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Posted Sales Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Posted Sales Invoice No." where("No." = field("Document No.")));
            ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
        }
    }
}
