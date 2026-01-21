namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;

tableextension 50118 InventoryPostingGroup extends "Inventory Posting Group"
{
    fields
    {
        field(50100; "Block Positive Adjustment"; Boolean)
        {
            Caption = 'Block Positive Adjustment';
            DataClassification = CustomerContent;
        }
    }
}
