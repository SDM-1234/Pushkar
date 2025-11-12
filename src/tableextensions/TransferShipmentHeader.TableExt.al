namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

tableextension 50108 TransferShipmentHeader extends "Transfer Shipment Header"
{
    fields
    {
        field(50100; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50103; Description; Text[100])
        {
            OptimizeForTextSearch = true;
        }
        field(50104; "Assign Shipment to FG"; Boolean)
        {
            Caption = 'Assign Shipment to FG';
        }


    }
}