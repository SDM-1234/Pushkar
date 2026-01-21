namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;

pageextension 50142 InventoryPostingGroups extends "Inventory Posting Groups"
{
    layout
    {

        addafter("Description")
        {
            field("Block Positive Adjustment"; Rec."Block Positive Adjustment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether positive adjustments are blocked for this inventory posting group.';
                Caption = 'Block Positive Adjustment';
            }
        }
    }
}
