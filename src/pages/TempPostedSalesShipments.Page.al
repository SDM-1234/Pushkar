namespace Pushkar.Pushkar;

using Microsoft.Sales.History;

page 50103 "Temp Posted Sales Shipments"
{
    ApplicationArea = All;
    Caption = 'Posted Sales Shipments';
    PageType = List;
    SourceTable = "Sales Shipment Header";
    SourceTableView = where("Assigned In Gate Entry" = const(false));
    SourceTableTemporary = true;
    UsageCategory = Tasks;
    Permissions = TableData "Sales Shipment Header" = rimd;

    layout
    {
        area(Content)

        {
            repeater(General)
            {
                field("Select for Gate Entry"; Rec."Select for Gate Entry")
                {
                }

                field("No."; Rec."No.")
                {
                    Editable = false;

                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;

                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.', Comment = '%';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = false;

                    ToolTip = 'Specifies the name of customer at the sell-to address.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;

                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;

                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
                field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
                {
                    Editable = false;
                }
                field("Sales Invoice Posting Date"; Rec."Sales Invoice Posting Date")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;

                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;

                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
            }


        }


    }
}

