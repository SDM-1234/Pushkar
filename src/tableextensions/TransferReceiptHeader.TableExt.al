namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

tableextension 50109 TransferReceiptHeader extends "Transfer Receipt Header"
{
    fields
    {
        field(50100; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
        }
        field(50101; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
        }
        field(50102; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
        }
        field(50103; Description; Text[100])
        {
            OptimizeForTextSearch = true;
            ToolTip = 'Specifies the value of the Description field.', Comment = '%';
        }

    }

}
