namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;

tableextension 50118 Item extends Item
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
