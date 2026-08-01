namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;

tableextension 50122 ItemExt extends Item
{
    fields
    {
        field(50100; "Approval Status"; Enum ItemApprovalStatus)
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }



}
