namespace Planning;

page 50105 "Planning Processing Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Planning Processing Log";
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the entry number.';
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Date';
                    ToolTip = 'Specifies the planning date.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the location code.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the item number.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    ToolTip = 'Specifies the item description.';
                }
                field("Outstanding SO Qty"; Rec."Outstanding SO Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding SO Qty';
                    ToolTip = 'Specifies the outstanding sales order quantity.';
                }
                field("Outstanding Ass. Cons. Qty"; Rec."Outstanding Ass. Cons. Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Assembly Consumption Qty';
                    ToolTip = 'Specifies the outstanding assembly consumption quantity.';
                }

                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Date';
                    ToolTip = 'Specifies the shipment date.';
                }
                field("Consumption Date"; Rec."Consumption Date")
                {
                    ApplicationArea = All;
                    Caption = 'Consumption Date';
                    ToolTip = 'Specifies the consumption date.';
                }
                field("Inventory Considered"; Rec."Inventory Considered")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Considered';
                    ToolTip = 'Specifies the inventory considered.';
                }
                field("Outstanding Assembly Order Qty"; Rec."Outstanding Assembly Order Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Assembly Order Qty';
                    ToolTip = 'Specifies the outstanding assembly order quantity.';
                }
                field("Outstanding Purchase Order Qty"; Rec."Outstanding Purchase Order Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Purchase Order Qty';
                    ToolTip = 'Specifies the outstanding purchase order quantity.';
                }
                field("Assembly Order No. Considered"; Rec."Assembly Order No. Considered")
                {
                    ApplicationArea = All;
                    Caption = 'Assembly Order No. Considered';
                    ToolTip = 'Specifies the assembly order number considered.';
                }
                field("Assembly Order Date"; Rec."Assembly Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'Assembly Order Date';
                    ToolTip = 'Specifies the assembly order date.';
                }
                field("Purchase Order No. Considered"; Rec."Purchase Order No. Considered")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order No. Considered';
                    ToolTip = 'Specifies the purchase order number considered.';
                }
                field("Purchase Order Date"; Rec."Purchase Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order Date';
                    ToolTip = 'Specifies the purchase order date.';
                }
                field("Qty to Produce"; Rec."Qty to Produce")
                {
                    ApplicationArea = All;
                    Caption = 'Qty to Produce';
                    ToolTip = 'Specifies the quantity to produce.';
                }
                field("Qty to Purchase"; Rec."Qty to Purchase")
                {
                    ApplicationArea = All;
                    Caption = 'Qty to Purchase';
                    ToolTip = 'Specifies the quantity to purchase.';
                }
                field("New Assembly Order No. Created"; Rec."New Assembly Order No. Created")
                {
                    ApplicationArea = All;
                    Caption = 'New Assembly Order No. Created';
                    ToolTip = 'Specifies the new assembly order number created.';
                }
                field("Minimum Inventory"; Rec."Minimum Inventory")
                {
                    ApplicationArea = All;
                    Caption = 'Minimum Inventory';
                    ToolTip = 'Specifies the minimum inventory.';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}