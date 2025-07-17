namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

tableextension 50105 TransferShipmentLine extends "Transfer Shipment Line"
{
    fields
    {
        field(50105; "Posted Transfer Shipment Nos."; Text[2048])
        {
            Caption = 'Posted Transfer Shipment No.';
            DataClassification = CustomerContent;
        }
    }
}
