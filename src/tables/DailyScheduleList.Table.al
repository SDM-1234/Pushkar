namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Foundation.AuditCodes;

table 50101 DailyScheduleList
{
    Caption = 'DailyScheduleList';
    DataClassification = CustomerContent;
    DrillDownPageId = DailyScheduleList;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Item"."No.";
            ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
        }
        field(4; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';
        }
        field(5; Updated; Boolean)
        {
            Caption = 'Updated';
            ToolTip = 'Specifies the value of the Updated field.', Comment = '%';
        }
        field(6; "SO No."; Code[20])
        {
            Caption = 'Sales Order No.';
            //TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "Sell-to Customer No." = const('1007'));
            ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
        }
        field(7; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            trigger OnValidate()
            var
                ReasonCode: Record "Reason Code";
            begin
                if "Reason Code" <> '' then begin
                    ReasonCode.SetRange("Code", "Reason Code");
                    if ReasonCode.FindFirst() then
                        "Reason Description" := ReasonCode.Description;
                end;
            end;

        }

        field(8; "Reason Description"; Text[100])
        {
            Caption = 'Reason Description';
            //TableRelation = "Reason Code".Description where("Code" = field("Reason Code"));
            Editable = false;
        }

        field(9; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
        }


    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Item No.", Quantity, "Shipment Date", Updated)
        { }
    }
}
