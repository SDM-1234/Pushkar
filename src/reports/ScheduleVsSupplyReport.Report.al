namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

report 50102 ScheduleVsSupplyReport
{
    ApplicationArea = All;
    Caption = 'ScheduleVsSupplyReport';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'src/ReportLayouts/ScheduleVsSupplyReport.rdl';
    dataset
    {
        dataitem(DailyScheduleList; DailyScheduleList)
        {
            column(ItemNo; "Item No.")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(SONo; "SO No.")
            {
            }
            column(ShipmentDate; "Shipment Date")
            {
            }
            column(CustomerName; Customer.Name)
            {
            }




            trigger OnAfterGetRecord()
            var
                SalesHeader: record "Sales Header";
                SalesLine: Record "Sales Line";
            begin

                if SalesHeader.Get('Order', "SO No.") then;

                if Customer.Get(SalesHeader."Sell-to Customer No.") then;



            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        Customer: record Customer;

}
