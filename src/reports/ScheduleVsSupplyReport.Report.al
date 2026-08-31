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
            RequestFilterFields = "Shipment Date", "Item Category Code", "Common Item No.";
            column(ItemNo; "Item No.")
            {
            }
            column(CustomerNo; Customer."No.")
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


                if item.Get("Item No.") then;

                SalesHeader.Reset();
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange("No.", "SO No.");
                if SalesHeader.findfirst() then begin


                    Clear(SalesLine_No);
                    Clear(SalesLine_UnitPrice);
                    Clear(SalesLine_ShippedQty);
                    Clear(SalesLine_Quantity);
                    Clear(SalesLine_OutStandingQuantity);
                    Clear(SalesHeaderExtDocNo);
                    Clear(SalesHeaderExtDocDate);
                    Clear(CustomerName);
                    Clear(SalesLineitemDescription);

                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.findfirst() then begin
                        SalesLine_No := SalesLine."No.";
                        SalesLine_UnitPrice := SalesLine."Unit Price";
                        SalesLine_ShippedQty := SalesLine."Quantity Shipped";
                        SalesLine_Quantity := SalesLine.Quantity;
                        SalesLine_OutStandingQuantity := SalesLine."Outstanding Quantity";



                        SalesLineitem.Reset();
                        if SalesLineitem.Get(SalesLine."No.") then
                            SalesLineitemDescription := SalesLineitem.Description;
                    end;
                    if customer.Get(SalesHeader."Sell-to Customer No.") then
                        CustomerName := Customer.Name;

                    SalesHeaderExtDocNo := SalesHeader."External Document No.";
                    SalesHeaderExtDocDate := SalesHeader."Document Date";




                end else begin


                    Clear(SalesLine_No);
                    Clear(SalesLine_UnitPrice);
                    Clear(SalesLine_ShippedQty);
                    Clear(SalesLine_Quantity);
                    Clear(SalesLine_OutStandingQuantity);
                    Clear(SalesHeaderExtDocNo);
                    Clear(SalesHeaderExtDocDate);
                    Clear(CustomerName);
                    Clear(SalesLineitemDescription);

                    SalesHeaderArchive.Reset();
                    SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                    SalesHeaderArchive.SetRange("No.", "SO No.");
                    if SalesHeaderArchive.findlast() then;
                    SalesHeaderExtDocNo := SalesHeaderArchive."External Document No.";
                    SalesHeaderExtDocDate := SalesHeaderArchive."Document Date";

                    SalesLineArchive.Reset();
                    SalesLineArchive.Setrange("Document Type", SalesHeaderArchive."Document Type");
                    SalesLineArchive.Setrange("Document No.", SalesHeaderArchive."No.");
                    SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
                    SalesLineArchive.Setrange("Version No.", SalesHeaderArchive."Version No.");
                    if SalesLineArchive.FindFirst() then begin
                        SalesLine_No := SalesLineArchive."No.";
                        SalesLine_UnitPrice := SalesLineArchive."Unit Price";
                        SalesLine_ShippedQty := SalesLineArchive."Qty. to Ship" + SalesLineArchive."Quantity Shipped";
                        SalesLine_Quantity := SalesLineArchive.Quantity;
                        SalesLine_OutStandingQuantity := SalesLineArchive."Outstanding Quantity";

                        SalesLineitem.Reset();
                    if SalesLineitem.Get(SalesLineArchive."No.") then
                        SalesLineitemDescription := SalesLineitem.Description;
end;
                    if customer.Get(SalesHeaderArchive."Sell-to Customer No.") then
                        CustomerName := Customer.Name;



                end;


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
        CustomerNo: Code[20];


}
