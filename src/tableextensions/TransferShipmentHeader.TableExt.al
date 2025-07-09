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
        }
        field(50101; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(50102; "Quantity"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(50103; "Applies-to No."; Code[50])
        {
            Caption = 'Applies-to No.';

        }

    }

}
