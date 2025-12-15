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
            ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
            trigger OnValidate()
            var
                RecItem: Record Item;
            begin
                RecItem.Get("Item No.");
                Description := RecItem.Description;
            end;
        }
        field(50101; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
        }
        field(50102; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            BlankZero = true;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
        }
        field(50103; Description; Text[100])
        {
            OptimizeForTextSearch = true;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Description field.', Comment = '%';
        }


    }
}
