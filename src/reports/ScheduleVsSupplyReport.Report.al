namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;

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
            column(ScheduleQuantity; Quantity)
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
            column(ItemDescription; Item.Description)
            {
            }
            column(ItemGroup; Item."Inventory Posting Group")
            {
            }

            trigger OnAfterGetRecord()
            var
                SalesHeader: record "Sales Header";
            begin

                if SalesHeader.Get('Order', "SO No.") then;
                if customer.Get(SalesHeader."Sell-to Customer No.") then;
                if item.Get("Item No.") then;

            end;

        }

    }


    var
        Customer: record Customer;
        Item: Record Item;


}
