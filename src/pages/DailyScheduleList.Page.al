namespace Pushkar.Pushkar;
using Microsoft.Sales.Document;
using System.Utilities;
using Microsoft.Sales.History;


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
                    if Rec.Updated then
                        Rec.ArchiveRecords(Rec);
                    //CurrPage.Update();
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
