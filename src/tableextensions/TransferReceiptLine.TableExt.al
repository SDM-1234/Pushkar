namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

tableextension 50106 TransferReceiptLine extends "Transfer Receipt Line"
{
    fields
    {
        field(50105; "Posted Transfer Shipment Nos."; Text[2048])
        {
            Caption = 'Posted Transfer Shipment No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Posted Transfer Shipment No. field.', Comment = '%';
        }
    }

}
