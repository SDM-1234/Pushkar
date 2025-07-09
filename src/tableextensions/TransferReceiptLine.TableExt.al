namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

tableextension 50106 TransferReceiptLine extends "Transfer Receipt Line"
{
    fields
    {
        field(50100; "Posted Transfer Shipment"; Code[20])
        {
            Caption = 'Posted Transfer Shipment No.';
            TableRelation = "Transfer Shipment Header"."No.";
            DataClassification = CustomerContent;
        }
    }

}
