namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Archive;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;

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
            RequestFilterFields = "Shipment Date";
            column(ItemNo; "Item No.")
            {
            }
            column(CustomerNo; "Customer No.")
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
            column(CustomerName; CustomerName)
            {
            }
            column(ItemDescription; Item.Description)
            {
            }
            column(ItemGroup; Item."Inventory Posting Group")
            {
            }
            column(SalesLine_ShippedQty; SalesLine_ShippedQty)
            {
            }
            column(SalesLine_Quantity; SalesLine_Quantity)
            {
            }
            column(SalesLine_OutStandingQuantity; SalesLine_OutStandingQuantity)
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
            Column(Pending_Quantity; "Pending Quantity") { }
            column(Delivered_Quantity; "Delivered Quantity") { }

            column(Remarks; Remarks)

            {
            }
            column(ShowSummary; ShowSummary)
            { }
            column(SalesLine_No; SalesLine_No)
            { }
            column(SalesLine_UnitPrice; SalesLine_UnitPrice) { }
            column(SalesLineitemDescription; SalesLineitemDescription) { }
            column(SalesHeaderExtDocNo; SalesHeaderExtDocNo) { }
            column(SalesHeaderDocDate; SalesHeaderExtDocDate) { }

            trigger OnPreDataItem()
            begin
                Setrange(Updated, true);
                If (StartDate <> 0D) or (EndDate <> 0D) then
                    SetRange("Shipment Date", StartDate, EndDate);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                SalesLine.Reset();
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange("No.", "SO No.");
                if not SalesHeader.findfirst() then begin
                    SalesHeaderArchive.Reset();
                    SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                    SalesHeaderArchive.SetRange("No.", "SO No.");
                    if SalesHeaderArchive.findlast() then;
                    SalesHeaderExtDocNo := SalesHeaderArchive."External Document No.";
                    SalesHeaderExtDocDate := SalesHeaderArchive."Document Date";
                    if customer.Get(SalesHeaderArchive."Sell-to Customer No.") then
                        CustomerName := Customer.Name;

                    SalesLineArchive.Reset();

                    SalesLineArchive.Setrange("Document Type", SalesHeaderArchive."Document Type");
                    SalesLineArchive.Setrange("Document No.", SalesHeaderArchive."No.");
                    SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
                    SalesLineArchive.Setrange("Version No.", SalesHeaderArchive."Version No.");
                    if SalesLineArchive.FindFirst() then begin
                        //if SalesLineArchive.Get(SalesHeaderArchive."Document Type", SalesHeaderArchive."No.", 10000) then;
                        SalesLine_No := SalesLineArchive."No.";
                        SalesLine_UnitPrice := SalesLineArchive."Unit Price";
                        SalesLine_ShippedQty := SalesLineArchive."Qty. to Ship" + SalesLineArchive."Quantity Shipped";
                        SalesLine_Quantity := SalesLineArchive.Quantity;
                        SalesLine_OutStandingQuantity := SalesLineArchive."Outstanding Quantity";
                    end;
                    SalesLineitem.Reset();
                    if SalesLineitem.Get(SalesLineArchive."No.") then
                        SalesLineitemDescription := SalesLineitem.Description;

                end else begin
                    if customer.Get(SalesHeader."Sell-to Customer No.") then
                        CustomerName := Customer.Name;
                    SalesLine.Reset();
                    if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 10000) then;
                    SalesLine_No := SalesLine."No.";
                    SalesLine_UnitPrice := SalesLine."Unit Price";
                    SalesLine_ShippedQty := SalesLine."Quantity Shipped";
                    SalesLine_Quantity := SalesLine.Quantity;
                    SalesLine_OutStandingQuantity := SalesLine."Outstanding Quantity";

                    SalesLineitem.Reset();
                    if SalesLineitem.Get(SalesLine."No.") then
                        SalesLineitemDescription := SalesLineitem.Description;

                    SalesHeaderExtDocNo := SalesHeader."External Document No.";
                    SalesHeaderExtDocDate := SalesHeader."Document Date";


                end;

                if item.Get("Item No.") then;

            end;

        }




    }

    requestpage
    {
        layout
        {
            area(Content)
            {

                field(StartDate; StartDate)
                {
                    ApplicationArea = all;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the value of the StartDate field.';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = all;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the value of the EndDate field.';
                }
                field(ShowSummary; ShowSummary)
                {
                    ApplicationArea = all;
                    Caption = 'Show Summary';
                    ToolTip = 'Specifies whether to show a summary row.';
                }

            }
        }
    }
    var
        StartDate: Date;
        EndDate: Date;
        ShowSummary: Boolean;
        Customer: record Customer;
        SalesHeaderExtDocNo: Code[35];
        SalesHeaderExtDocDate: Date;
        Item: Record Item;
        SalesLineItem: Record Item;
        SalesLine: Record "Sales Line";
        SalesHeader: record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesLineArchive: Record "Sales Line Archive";
        SalesLine_ShippedQty: Decimal;
        SalesLine_Quantity: Decimal;
        SalesLine_OutStandingQuantity: Decimal;
        Item_UnitPrice: Decimal;
        SalesLine_No: Code[20];
        SalesLine_UnitPrice: Decimal;
        SalesLineitemDescription: Text[100];
        CustomerName: Text[100];


}
