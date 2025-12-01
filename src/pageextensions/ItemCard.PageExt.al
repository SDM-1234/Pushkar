namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;

pageextension 50134 ItemCard extends "Item Card"
{
    layout
    {

        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'The item number of the item.';
                Caption = 'Item No. 2';
                Editable = true;
            }
        }
    }
}
