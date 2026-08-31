namespace Planning;

using Microsoft.Inventory.Location;
using Microsoft.Inventory.Item;

table 50103 "Planning Processing Log"
{
    DataClassification = ToBeClassified;
    Caption = 'Planning Processing Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Planning Date"; Date)
        {
            Caption = 'Planning Date';
            DataClassification = CustomerContent;
        }
        field(3; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }

        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }

        field(5; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }

        field(6; "Outstanding SO Qty"; Decimal)
        {
            Caption = 'Outstanding SO Qty';
            DataClassification = CustomerContent;
        }

        field(7; "Outstanding Ass. Cons. Qty"; Decimal)
        {
            Caption = 'Outstanding Assembly Consumption Qty';
            DataClassification = CustomerContent;
        }

        field(8; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }

        field(9; "Consumption Date"; Date)
        {
            Caption = 'Consumption Date';
            DataClassification = CustomerContent;
        }

        field(10; "Inventory Considered"; Decimal)
        {
            Caption = 'Inventory Considered';
            DataClassification = CustomerContent;
        }

        field(11; "Outstanding Assembly Order Qty"; Decimal)
        {
            Caption = 'Outstanding Assembly Order Qty';
            DataClassification = CustomerContent;
        }

        field(12; "Outstanding Purchase Order Qty"; Decimal)
        {
            Caption = 'Outstanding Purchase Order Qty';
            DataClassification = CustomerContent;
        }

        field(13; "Assembly Order No. Considered"; Code[20])
        {
            Caption = 'Assembly Order No. Considered';
            DataClassification = CustomerContent;
        }

        field(14; "Assembly Order Date"; Date)
        {
            Caption = 'Assembly Order Date';
            DataClassification = CustomerContent;
        }

        field(15; "Purchase Order No. Considered"; Code[20])
        {
            Caption = 'Purchase Order No. Considered';
            DataClassification = CustomerContent;
        }

        field(16; "Purchase Order Date"; Date)
        {
            Caption = 'Purchase Order Date';
            DataClassification = CustomerContent;
        }

        field(17; "Qty to Produce"; Decimal)
        {
            Caption = 'Qty to Produce';
            DataClassification = CustomerContent;
        }

        field(18; "New Assembly Order No. Created"; Code[20])
        {
            Caption = 'New Assembly Order No. Created';
            DataClassification = CustomerContent;
        }

        field(19; "Minimum Inventory"; Decimal)
        {
            Caption = 'Minimum Inventory';
            DataClassification = CustomerContent;
        }

        field(20; "Qty to Purchase"; Decimal)
        {
            Caption = 'Qty to Purchase';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure InitializePlanningProcessingLog(LocationCode: Code[20]; ItemDescription: Text[100]; OutstandingSOQty: Decimal; OutstandingAssConsQty: Decimal; ShipmentDate: Date; ConsumptionDate: Date; InventoryConsidered: Decimal; OutstandingAssemblyOrderQty: Decimal; OutstandingPurchaseOrderQty: Decimal; AssemblyOrderNoConsidered: Code[20]; AssemblyOrderDate: Date; PurchaseOrderNoConsidered: Code[20]; PurchaseOrderDate: Date; QtyToProduce: Decimal; NewAssemblyOrderNoCreated: Code[20]; MinimumInventory: Decimal; QtyToPurchase: Decimal)
    begin
        Rec.Init();
        Rec."Planning Date" := WorkDate();
        Rec."Location Code" := LocationCode;
        Rec."Item Description" := ItemDescription;
        Rec."Outstanding SO Qty" := OutstandingSOQty;
        Rec."Outstanding Ass. Cons. Qty" := OutstandingAssConsQty;
        Rec."Shipment Date" := ShipmentDate;
        Rec."Consumption Date" := ConsumptionDate;
        Rec."Inventory Considered" := InventoryConsidered;
        Rec."Outstanding Assembly Order Qty" := OutstandingAssemblyOrderQty;
        Rec."Outstanding Purchase Order Qty" := OutstandingPurchaseOrderQty;
        Rec."Assembly Order No. Considered" := AssemblyOrderNoConsidered;
        Rec."Assembly Order Date" := AssemblyOrderDate;
        Rec."Purchase Order No. Considered" := PurchaseOrderNoConsidered;
        Rec."Purchase Order Date" := PurchaseOrderDate;
        Rec."Qty to Produce" := QtyToProduce;
        Rec."New Assembly Order No. Created" := NewAssemblyOrderNoCreated;
        Rec."Minimum Inventory" := MinimumInventory;
        Rec."Qty to Purchase" := QtyToPurchase;
        Rec.Insert();
    end;


}