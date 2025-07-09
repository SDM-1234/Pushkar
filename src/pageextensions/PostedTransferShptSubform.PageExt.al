namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

pageextension 50119 PostedTransferShptSubform extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Posted Transfer Shipment"; Rec."Posted Transfer Shipment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posted Transfer Shipment No. field.', Comment = '%';
            }
        }
    }
}
