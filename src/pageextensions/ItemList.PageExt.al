namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;

pageextension 50117 ItemList extends "Item List"
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
                Editable = false;
            }
        }
    }
}
