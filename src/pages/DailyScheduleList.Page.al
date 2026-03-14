namespace Pushkar.Pushkar;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
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
                caption = 'Daily Schedule Archives';
                ToolTip = 'Opens the Daily Schedule Archives page.';
                RunObject = Page DailyScheduleArchives;
            }
        }

        area(processing)
        {
            action(ArchiveRecords)
            {
                Image = Process;
                ApplicationArea = All;
                Caption = 'Archive Records';
                ToolTip = 'Executes the Process action.';
                trigger OnAction()
                var
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if not Rec.Updated then
                        Rec.ArchiveRecords(Rec);
                    CurrPage.Update(false);
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
                begin
                    // Get all selected records from the current page
                    CurrPage.SetSelectionFilter(Rec);
                    if not Rec.Updated then
                        Rec.UpdateSalesOrderNo(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

}
