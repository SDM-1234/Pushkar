namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

pageextension 50101 TransferOrderSubform extends "Transfer Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Posted Transfer Shipment Nos."; Rec."Posted Transfer Shipment Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action(AssignPostedTransferShipments)
            {
                Caption = 'Assign Posted Transfer Shipments';
                Image = Create;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.AssignPostedTransferShipments();
                    //Message('Posted Transfer Shipments assigned successfully.');
                end;
            }
        }
    }
}
