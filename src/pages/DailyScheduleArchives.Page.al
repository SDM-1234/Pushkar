namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;

page 50102 DailyScheduleArchives
{
    ApplicationArea = All;
    Caption = 'Daily Schedule Archives';
    PageType = List;
    SourceTable = DailyScheduleList;
    SourceTableView = where(updated = filter(true));
    UsageCategory = Lists;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Reason Description"; Rec."Reason Description")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("SO No."; Rec."SO No.")
                {
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Sales Line Unit Price"; Rec."Sales Line Unit Price")
                {
                    Editable = false;
                }
                field("Delivered Quantity"; Rec."Delivered Quantity")
                {
                    ToolTip = 'Specifies the value of the Delivered Quantity field.', Comment = '%';
                    Editable = false;

                }
                field("Pending Quantity"; Rec."Pending Quantity")
                {
                    ToolTip = 'Specifies the value of the Pending Quantity field.', Comment = '%';
                    Editable = false;

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(UpdateDeliveryZeroQty)
            {
                ApplicationArea = All;
                Image = UpdateShipment;
                Caption = 'Update Zero Quantity';
                ToolTip = 'Updates the Delivered and Pending Quantity based on Sales Shipment Lines.';

                trigger OnAction()
                begin
                    Rec.ModifyAll("Delivered Quantity", 0);
                    Rec.ModifyAll("Pending Quantity", 0);
                end;
            }

            action(UpdateQuantity)
            {
                ApplicationArea = All;
                Image = UpdateShipment;
                Caption = 'Update Quantity';
                ToolTip = 'Updates the Delivered and Pending Quantity based on Sales Shipment Lines.';

                trigger OnAction()
                var
                    RecDailyScheduleList: Record DailyScheduleList;
                begin
                    RecDailyScheduleList.Reset();
                    CurrPage.SetSelectionFilter(RecDailyScheduleList);
                    RecDailyScheduleList.UpdatePostedShipmentQuantity(RecDailyScheduleList);
                    CurrPage.Update(false);
                    RecDailyScheduleList.Reset();
                end;
            }

        }
        area(Reporting)
        {
            action(ScheduleVsSupplyReport)
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = Report ScheduleVsSupplyReport;
                ToolTip = 'Generates the Schedule Vs Supply Report.';
                Caption = 'Schedule Vs Supply Report';
            }


        }
    }
}
