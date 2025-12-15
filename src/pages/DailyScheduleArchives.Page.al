namespace Pushkar.Pushkar;

page 50102 DailyScheduleArchives
{
    ApplicationArea = All;
    Caption = 'Daily Schedule Archives';
    PageType = List;
    SourceTable = DailyScheduleList;
    SourceTableView = where(updated = filter(true));
    UsageCategory = Lists;

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
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
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
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                }
                field(Updated; Rec.Updated)
                {
                    Editable = false;
                }
            }
        }
    }
    actions
    {
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
