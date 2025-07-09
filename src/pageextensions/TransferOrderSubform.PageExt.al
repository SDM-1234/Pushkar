namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

pageextension 50101 TransferOrderSubform extends "Transfer Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Posted Transfer Shipment"; Rec."Posted Transfer Shipment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posted Transfer Shipment field.', Comment = '%';
            }
        }
    }
}
