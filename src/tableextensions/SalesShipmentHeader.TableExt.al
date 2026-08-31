namespace Pushkar.Pushkar;

using Microsoft.Sales.History;

tableextension 50101 SalesShipmentHeader extends "Sales Shipment Header"
{
    fields
    {
        field(50100; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
        }
        field(50101; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Description field.', Comment = '%';
        }
        field(50102; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
        }
        field(50103; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
        }
        field(50104; "Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Posted Sales Invoice No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
        }
        field(50105; "Sales Invoice Posting Date"; date)
        {
            Caption = 'Sales Invoice Posting Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Sales Invoice Posting Date field.', Comment = '%';
        }
        field(50110; "PS Vehicle No."; Code[20])
        {
            Caption = 'Vehicle Num';
            DataClassification = CustomerContent;
        }
        field(50111; "Select for Gate Entry"; Boolean)
        {
            Caption = 'Select for Gate Entry';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Select for Gate Entry field.', Comment = '%';
        }
        field(50112; "Assigned In Gate Entry"; Boolean)
        {
            Caption = 'Assigned In Gate Entry';
            DataClassification = CustomerContent;
        }



    }

}
