namespace Pushkar.Pushkar;
using Microsoft.Sales.Document;
using System.Utilities;


page 50101 DailyScheduleList
{
    ApplicationArea = All;
    Caption = 'Daily Schedule List';
    PageType = List;
    SourceTable = DailyScheduleList;
    SourceTableView = where(updated = filter(false));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the value of the Shipment Date field.';
                }
                field("SO No."; Rec."SO No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field.';
                }
                field(Updated; Rec.Updated)
                {
                    ToolTip = 'Specifies the value of the Updated field.';
                }


        }
    }
    }
    actions
    {

        area(Navigation)
        {
            action(DailyScheduleArchives)

            {
                ApplicationArea = All;
                Image = Archive;
                ToolTip = 'Opens the Daily Schedule Archives page.';
                RunObject = Page DailyScheduleArchives;
            }
        }

        area(processing)
        {


            action(Process)
            {
                Image = Process;
                ApplicationArea = All;
                ToolTip = 'Executes the Process action.';
                trigger OnAction()
                var
                    SelectedRecords: Record DailyScheduleList;
                    ConfirmManagement: Codeunit "Confirm Management";
                    UpdateCount: Integer;

                begin

                    if not ConfirmManagement.GetResponseOrDefault('Do you want to process records?', true) then
                        exit;

                    CurrPage.SetSelectionFilter(SelectedRecords);

                    if SelectedRecords.FindSet() then
                        repeat
                            SelectedRecords.Updated := true;
                            SelectedRecords.Modify();
                            UpdateCount += 1;
                        until SelectedRecords.Next() = 0;
                    Message('%1 Sales Order(s) processed successfully.', UpdateCount);
                end;
            }
            action(UpdateSalesOrder)
            {
                ApplicationArea = All;
                Image = UpdateShipment;
                ToolTip = 'Updates the related sales order.';
                Caption = 'Update Sales Order No.';

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    SelectedRecords: Record DailyScheduleList;
                    EndDateFormula: DateFormula;
                    StartDateFormula: DateFormula;
                    EndDate: Date;
                    StartDate: Date;
                    UpdateCount: Integer;
                    FormulaText: Text;
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
                        //if SelectedRecords.FindSet() then begin
                        StartDate := CalcDate(StartDateFormula, SelectedRecords."Shipment Date");
                        EndDate := CalcDate(EndDateFormula, SelectedRecords."Shipment Date");

                        SalesLine.SetRange("No.", SelectedRecords."Item No.");
                        SalesLine.SetRange("Shipment Date", StartDate, EndDate);

                        if SalesLine.FindFirst() then begin
                            SelectedRecords."SO No." := SalesLine."Document No.";
                            SelectedRecords.Modify();
                            UpdateCount += 1;
                        end;
                    //end;
                    until SelectedRecords.Next() = 0;

                    Message('%1 Sales Order(s) updated successfully.', UpdateCount);
                end;
            }
        }
    }

}
