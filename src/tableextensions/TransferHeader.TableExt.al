namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;

tableextension 50107 TransferHeader extends "Transfer Header"
{
    fields
    {
        field(50100; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
        }
        field(50101; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
        }
        field(50102; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            BlankZero = true;
            DataClassification = CustomerContent;
        }
    }
}
