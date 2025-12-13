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
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';
                }
                field("SO No."; Rec."SO No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
                }


            }
        }


    }

    actions
    {
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
                    SalesLine: Record "Sales Line";
                    StartDate: Date;
                    EndDate: Date;
                begin

                    StartDate := CalcDate('CM-M+1D', Rec."Shipment Date");
                    EndDate := CalcDate('CM', Rec."Shipment Date");

                    If not Rec.Updated then begin
                        //SalesLine.SetRange("Document No.", Rec."SO No.");
                        SalesLine.SetRange("No.", Rec."Item No.");
                        SalesLine.SetRange("Shipment Date", StartDate, EndDate);
                        //SalesLine.SetRange("Sell-to Customer No.", '1007');
                        If SalesLine.FindFirst() then begin
                            Rec."SO No." := SalesLine."Document No.";
                            Rec.Modify();
                            Message('Sales Order %1 updated successfully.', Rec."SO No.");
                        end;
                    end;


                    // SalesLine2 := SalesLine;
                    // SalesLine2.Validate(Quantity, SalesLine.Quantity - Rec.Quantity);
                    // SalesLine2.Validate("Line No.", SalesLine."Line No." + 10000);
                    // SalesLine2.Insert();

                    // SalesLine.Validate(Quantity, Rec.Quantity);
                    // SalesLine.Validate("Shipment Date", Rec."Shipment Date");
                    // SalesLine.Modify();

                    // Rec.Updated := true;
                    // Rec.Modify();
                    // Implement the action logic here
                end;
            }
        }
    }

}
