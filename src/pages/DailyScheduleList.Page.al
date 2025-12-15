namespace Pushkar.Pushkar;
using Microsoft.Sales.Document;


page 50101 DailyScheduleList
{
    ApplicationArea = All;
    Caption = 'Daily Schedule List';
    PageType = List;
    SourceTable = DailyScheduleList;
    SourceTableView = where(Updated = filter(false));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("SO No."; Rec."SO No.")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                { }

                field("Reason Description"; Rec."Reason Description")
                { }
                field(Remarks; Rec.Remarks) { }
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
        area(processing)
        {

            action(ProcessedRecords)
            {

                ApplicationArea = All;
                Image = Archive;
                RunObject = Page ProcessedDailySchedule;
                ToolTip = 'View processed records.';
                Caption = 'Processed Records';
            }
            action(UpdateSalesOrder)
            {
                ApplicationArea = All;
                Image = UpdateShipment;
                ToolTip = 'Updates the related sales order.';
                Caption = 'Update Sales Order';

                trigger OnAction()
                var
                    SelectedRecords: Record DailyScheduleList;
                    SalesLine: Record "Sales Line";
                    EndDateFormula: DateFormula;
                    StartDateFormula: DateFormula;
                    EndDate: Date;
                    StartDate: Date;
                    FormulaText: Text;
                    UpdateCount: Integer;
                begin
                    // Get all selected records from the current page
                    CurrPage.SetSelectionFilter(SelectedRecords);

                    if not SelectedRecords.FindSet() then begin
                        Message('No records selected.');
                        exit;
                    end;

                    FormulaText := 'CM-1M+1D';
                    Evaluate(StartDateFormula, FormulaText);
                    FormulaText := 'CM';
                    Evaluate(EndDateFormula, FormulaText);

                    UpdateCount := 0;

                    // Loop through each selected record and update
                    repeat
                        if not SelectedRecords.Updated then begin
                            StartDate := CalcDate(StartDateFormula, SelectedRecords."Shipment Date");
                            EndDate := CalcDate(EndDateFormula, SelectedRecords."Shipment Date");

                            SalesLine.SetRange("No.", SelectedRecords."Item No.");
                            SalesLine.SetRange("Shipment Date", StartDate, EndDate);

                            if SalesLine.FindFirst() then begin
                                SelectedRecords."SO No." := SalesLine."Document No.";
                                SelectedRecords.Updated := true;
                                SelectedRecords.Modify();
                                UpdateCount += 1;
                            end;
                        end;
                    until SelectedRecords.Next() = 0;

                    Message('%1 Sales Order(s) updated successfully.', UpdateCount);
                end;
            }
        }
    }

}
