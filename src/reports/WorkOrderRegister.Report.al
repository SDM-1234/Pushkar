namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;
using System.Utilities;
using Microsoft.Inventory.Item;

report 50107 "Work Order Register1"
{
    ApplicationArea = All;
    Caption = 'Transfer Receipt Shipments Register';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'src/ReportLayouts/WorkOrderRegisterV1.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(TSL_Loop; Integer)
        {



            DataItemTableView = WHERE(Number = CONST(1));


            column(TransferShipmentLine_DocNo; TransferShipmentLine."Document No.") { }
            column(TransferReceiptHeader_ItemNo; TransferReceiptHeader."Item No.") { }
            column(DocNo; TransferShipmentLine."Document No.") { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()

            begin
                TransferReceiptHeader.SetRange("No.");
                TransferReceiptHeader.SetRange("Posting Date", FromDate, ToDate);
                TransferReceiptHeader.SetRange("Transfer-from Code", LocationCode);
                //TransferReceiptHeader.SetRange("Transfer-to Code");
                If TransferReceiptHeader.FindSet() then
                    repeat



                        TransferReceiptLine.Reset();
                        TransferReceiptLine.SetRange("Document No.", TransferReceiptHeader."No.");
                        If TransferReceiptLine.FindFirst() then begin

                            ProducedQty := TransferReceiptLine.Quantity;

                            TransferShipmentLine.Reset();
                            TransferShipmentLine.SetFilter("Document No.", TransferReceiptLine."Posted Transfer Shipment Nos.");
                            If TransferShipmentLine.FindSet() then
                                repeat

                                //TSDocNo.Add(TransferShipmentLine."Document No.");

                                until TransferShipmentLine.Next() = 0;
                        end;
                    until TransferReceiptHeader.Next() = 0;
            end;

        }

    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        ToolTip = 'Specifies the value of the From Date field.';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        ToolTip = 'Specifies the value of the To Date field.';
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        ToolTip = 'Specifies the value of the Location Code field.';
                    }


                }
            }
        }
    }
    var
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptLine: Record "Transfer Receipt Line";
        TransferShipmentLine: Record "Transfer Shipment Line";
        LocationCode: Code[20];
        FromDate: Date;
        ToDate: Date;
        ProducedQty: Decimal;
        TSDocNo: List of [Code[20]];
        i: Integer;

        ShipmentNo: Text[20];
        ShipmentNoArray: List of [Text];
        ShipmentNoSplit: Text;
}
