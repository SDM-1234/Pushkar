namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

pageextension 50120 "PostedTransferRcptSubform" extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Posted Transfer Shipment"; Rec."Posted Transfer Shipment Nos.")
            {
                ApplicationArea = All;
            }
        }
    }

}
