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
        }
        field(50101; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50102; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(50103; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(50104; "Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Posted Sales Invoice No.';
            DataClassification = CustomerContent;
        }
        field(50105; "Sales Invoice Posting Date"; date)
        {
            Caption = 'Sales Invoice Posting Date';
            DataClassification = CustomerContent;
        }
        field(50110; "PS Vehicle No."; Code[20])
        {
            Caption = 'Vehicle Num';
            DataClassification = CustomerContent;
        }

    }

}
