page 50110 "Temp Posted Transfer Shipments"
{
    PageType = List;
    SourceTable = "Transfer Shipment Header";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;
    //MultiSelect = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Assign Shipment to FG"; Rec."Assign Shipment to FG")
                {
                    ToolTip = 'Specifies the value of the Applies-to No. field.', Comment = '%';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}