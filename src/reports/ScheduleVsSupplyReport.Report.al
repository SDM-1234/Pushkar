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
            column(DailyScheduleQuantity; Quantity)
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
            column(SalesLine_ShippedQty; SalesLine."Quantity Shipped")
            {
            }
            column(SalesLine_Quantity; SalesLine.Quantity)
            {
            }
            column(SalesLine_OutStandingQuantity; SalesLine."Outstanding Quantity")
            {
            }
            column(Item_UnitPrice; Item."Unit Price")
            {
            }
            column(Reason_Code; "Reason Code")
            {
            }

            column(Reason_Description; "Reason Description")
            {
            }

            column(Remarks; Remarks)
            {
            }
            column(SalesLine_No; SalesLine."No.")
            {
            }
            column(SalesLineitemDescription; SalesLineitem.Description)
            { }
            column(SalesHeaderExtDocNo; SalesHeader."External Document No.") { }
            column(SalesHeaderDocDate; SalesHeader."Document Date") { }
            trigger OnAfterGetRecord()
            var
            begin

                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange("No.", "SO No.");
                if SalesHeader.findfirst() then;
                if customer.Get(SalesHeader."Sell-to Customer No.") then;
                if item.Get("Item No.") then;

                if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 10000) then;
                if SalesLineitem.Get(SalesLine."No.") then;


            end;

        }

    }


    var
        Customer: record Customer;
        Item: Record Item;
        SalesLineItem: Record Item;
        SalesLine: Record "Sales Line";
        SalesHeader: record "Sales Header";
}
