namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;

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
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Item"."No.";
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(4; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(5; Updated; Boolean)
        {
            Caption = 'Updated';
        }
        field(6; "SO No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "Sell-to Customer No." = const('1007'));
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
