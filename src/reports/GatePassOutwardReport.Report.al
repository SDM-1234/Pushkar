namespace Pushkar.Pushkar;

using Microsoft.Finance.TaxBase;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Sales.History;
using Microsoft.Warehouse.GateEntry;

report 50104 GatePassOutwardReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/GatePassoutward.rdl';

    dataset
    {
        dataitem(PostedGateEntryHeader; "Posted Gate Entry Header")
        {
            DataItemTableView = where("Entry Type" = filter("Entry Type"::OutWard));
            RequestFilterFields = "No.";

            column(CompinfoName; recCompinfo.Name)
            {
            }
            column(CompinfoAddress; recCompinfo.Address)
            {
            }
            column(CompinfoAddress2; recCompinfo."Address 2")
            {
            }
            column(CompinfoCity; recCompinfo.City)
            {
            }
            column(CompinfoCountry; recCompinfo."Country/Region Code")
            {
            }
            column(CompinfoPostcode; recCompinfo."Post Code")
            {
            }
            column(txtStatecoun; txtStatecoun)
            {
            }
            column(No_; "No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Description; Description)
            {
            }
            column(Vehicle_No_; "Vehicle No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Document_Time; "Document Time")
            {
            }
            column(recSaleShpHeadCustNo; recSaleShpHead."Sell-to Customer No.")
            {
            }
            column(recSaleShpHeadCustName; recSaleShpHead."Sell-to Customer Name")
            {
            }
            dataitem(PostedGateEntryLine; "Posted Gate Entry Line")
            {
                DataItemLink = "Gate Entry No." = field("No.");

                column(Challan_No_; "Challan No.")
                {
                }
                column(recSalesShpLineNo; recSalesShpLine."No.")
                {
                }
                column(recSalesShpLineDesc; recSalesShpLine.Description)
                {
                }
                column(recSalesShpLineQty; recSalesShpLine.Quantity)
                {
                }
                column(recSalesShpLineUOM; recSalesShpLine."Unit of Measure")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    recSalesShpLine.Reset();
                    recSalesShpLine.SetRange("Document No.", "Source No.");
                    if recSalesShpLine.FindFirst() then;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                recPostGateEntLine.Reset();
                recPostGateEntLine.SetRange("Gate Entry No.", PostedGateEntryHeader."No.");
                if recPostGateEntLine.FindFirst() then
                    if recSaleShpHead.Get(recPostGateEntLine."Source No.") then;
            end;
        }
    }
    trigger OnPreReport()
    begin
        recCompinfo.FindFirst();
        if recState.Get(recCompinfo."State Code") then txtStatecoun := recState.Description;
        if recCoun.get(recCompinfo."Country/Region Code") then txtStatecoun += ' ' + reccoun.Name;
    end;

    var
        recCompinfo: Record "Company Information";
        recPostGateEntLine: Record "Posted Gate Entry Line";
        recSaleShpHead: Record "Sales Shipment Header";
        recSalesShpLine: Record "Sales Shipment Line";
        recState: Record State;
        recCoun: Record "Country/Region";
        txtStatecoun: Text;
}
