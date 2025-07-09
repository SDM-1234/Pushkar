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
                ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
            }
            field("Unit of Measure"; Rec."Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
            }
        }
    }
}
