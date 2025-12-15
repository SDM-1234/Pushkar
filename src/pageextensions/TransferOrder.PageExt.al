namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

pageextension 50123 TransferOrder extends "Transfer Order"
{
    layout
    {
        addafter(Status)
        {

            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
            field("Unit of Measure"; Rec."Unit of Measure")
            {
                ApplicationArea = All;
            }

            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                Editable = true;
            }

        }

    }
}
