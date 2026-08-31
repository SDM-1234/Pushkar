namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Transfer;
using System.IO;
using System.Utilities;

report 50105 "Work Order Report"
{
    ApplicationArea = All;
    Caption = 'Work Order Register';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    PreviewMode = Normal;

    dataset
    {
        dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
        {
            RequestFilterFields = "No.";

            dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
            {
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                begin
                    SetFilter("Posted Transfer Shipment Nos.", '<>%1', '');
                end;

                trigger OnAfterGetRecord()
                begin
                    TOtQty := 0;

                    // 1. Calculate clean total quantity received specifically for this shipment lineage context
                    TRL.Reset();
                    TRL.SetRange("Posted Transfer Shipment Nos.", "Transfer Receipt Line"."Posted Transfer Shipment Nos.");
                    if TRL.FindSet() then
                        repeat
                            if ParentReceiptHeader.Get(TRL."Document No.") then begin
                                if (ParentReceiptHeader."Posting Date" >= fromDate) and
                                   (ParentReceiptHeader."Posting Date" <= toDate) then
                                    TOtQty += TRL.Quantity;
                            end;
                        until TRL.Next() = 0;

                    // 2. Map and Insert the original Shipment Records
                    if "Transfer Receipt Line"."Posted Transfer Shipment Nos." <> '' then begin
                        ShipmentNoArray := "Transfer Receipt Line"."Posted Transfer Shipment Nos.".Split('|');
                        for i := 1 to ShipmentNoArray.Count do begin
                            ShipmentNo := ShipmentNoArray.Get(i);

                            if TransferShipmentHeader.Get(ShipmentNo) then begin
                                TransferShipmentLine.Reset();
                                TransferShipmentLine.SetRange("Document No.", ShipmentNo);
                                if TransferShipmentLine.FindSet() then
                                    repeat
                                        if CurrentItemNo <> TransferShipmentHeader."Item No." then begin
                                            CurrentItemNo := TransferShipmentHeader."Item No.";
                                            if not ItemRec.Get(CurrentItemNo) then
                                                ItemRec.Init();
                                        end;

                                        ENo += 1;

                                        TempTable.Init();
                                        TempTable.EntryNo := ENo;
                                        TempTable.No := TransferShipmentHeader."No.";
                                        TempTable.DateOfDispatch := TransferShipmentHeader."Posting Date";
                                        TempTable.ItemNo := TransferShipmentHeader."Item No.";
                                        TempTable.ItemDescription := ItemRec.Description;
                                        TempTable.LineNo := TransferShipmentLine."Line No.";
                                        TempTable.Delay := '';
                                        TempTable.DescriptionOfGoodsDispatch := TransferShipmentLine.Description;
                                        TempTable.QtyDispatchedToJobWorker := TransferShipmentLine.Quantity;
                                        TempTable.FinishedGoodQtyProduced := TransferShipmentHeader.Quantity;
                                        TempTable.NameAddJobWorker := TransferShipmentHeader."Transfer-to Name";
                                        TempTable.NatureOfProcessing := TransferShipmentHeader."Transaction Specification"; // Normal specification for shipment row
                                        TempTable.JobWorkerDlvDocDate := '';
                                        TempTable.FGUOM := TransferShipmentHeader."Unit of Measure";
                                        TempTable.FacGoodReciptDocDate := 0D;
                                        TempTable.DateOfClearence := 0D;
                                        TempTable.DescriptionOfGoods := '';
                                        TempTable.QtyProduced := 0;
                                        TempTable.BalanceQty := TransferShipmentHeader.Quantity - TOtQty;
                                        TempTable.Type := TempTable.Type::Shipment;
                                        TempTable.UOM := TransferShipmentLine."Unit of Measure";

                                        TempTableInsert.Reset();
                                        TempTableInsert.SetRange(ItemNo, TransferShipmentHeader."Item No.");
                                        TempTableInsert.SetRange(No, TransferShipmentHeader."No.");
                                        TempTableInsert.SetRange(LineNo, TransferShipmentLine."Line No.");
                                        if not TempTableInsert.FindFirst() then
                                            if not TempTable.Insert() then
                                                TempTable.Modify();

                                    until TransferShipmentLine.Next() = 0;
                            end;
                        end;
                    end;

                    // 3. Insert the true contextual Receipt Entry mapped tightly to its origin shipment
                    ENo += 1;
                    TempTable.Init();
                    TempTable.EntryNo := ENo;
                    TempTable.No := "Transfer Receipt Line"."Document No.";
                    TempTable.DateOfDispatch := "Transfer Receipt Header"."Posting Date";
                    TempTable.ItemNo := "Transfer Receipt Line"."Item No.";
                    TempTable.LineNo := "Transfer Receipt Line"."Line No.";
                    TempTable.Delay := '';
                    TempTable.DescriptionOfGoodsDispatch := "Transfer Receipt Line".Description;
                    TempTable.QtyDispatchedToJobWorker := 0;
                    TempTable.FinishedGoodQtyProduced := 0;
                    TempTable.NameAddJobWorker := "Transfer Receipt Header"."Transfer-to Name";

                    // CRITICAL KEY PAIRING: Store the tracking origin shipment number right here in this field
                    TempTable.NatureOfProcessing := "Transfer Receipt Line"."Posted Transfer Shipment Nos.";

                    TempTable.JobWorkerDlvDocDate := "Transfer Receipt Header"."External Document No.";
                    TempTable.FacGoodReciptDocDate := "Transfer Receipt Header"."Receipt Date";
                    TempTable.DateOfClearence := "Transfer Receipt Header"."Posting Date";
                    TempTable.DescriptionOfGoods := "Transfer Receipt Line".Description;
                    TempTable.QtyProduced := "Transfer Receipt Line".Quantity;
                    TempTable.BalanceQty := 0;
                    TempTable.UOM := "Transfer Receipt Header"."Unit of Measure";
                    TempTable.FGUOM := '';
                    TempTable.Type := TempTable.Type::Receipt;
                    TempTable.Insert(true);
                end;
            }

            trigger OnPreDataItem()
            begin
                TempTable.DeleteAll();
                SetFilter("Posting Date", '%1..%2', fromDate, toDate);
                if (LocationCode <> '') then
                    SetRange("Transfer-to Code", LocationCode);

                Sno := 1;
                ENo := 0;

                excelBuffer.Reset();
                excelBuffer.DeleteAll();
                excelBuffer.NewRow();
                excelBuffer.AddColumn('DOCUMENT NO.', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('DATE OF DISPATCH', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('Delay', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('DESCRIPTION OF GOODS DISPATCHED', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('QUANTITY DISPATCH TO JOB WORKER', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('RM UOM', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('FINISHED QUANTITY PRODUCED', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('FG UOM', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('NAME ADDRESS OF THE JOB WORKER', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('NATURE OF PROCESSING', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('JOB WORKERS DELIVERY DOC.NO.', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('FACTORYS GOODS RECEIPT DOC NO. DATE', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('DATE OF CLEARANCE OF PROCESSED INPUT FROM FACTORY OF JOB WORKER', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('DESCRIPTION OF GOODS', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('QUANTITY PRODUCED', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
                excelBuffer.AddColumn('BALANCE QUANTITY', FALSE, '', TRUE, FALSE, TRUE, '', excelBuffer."Cell Type"::Text);
            end;
        }
    }

    requestpage
    {
        SaveValues = false;
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
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        TableRelation = Location.Code;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        TempTable.Reset();
        TempTable.SetCurrentKey(EntryNo);
        if TempTable.FindSet() then
            repeat
                // Only act when parsing primary base Shipment records to anchor layout outputs
                if (TempTable.Type = TempTable.Type::Shipment) and (TempTable.DescriptionOfGoods = '') then begin
                    QtyDispatch := 0;
                    TempTableBuff.Reset();
                    TempTableBuff.SetRange(No, TempTable.No);
                    TempTableBuff.SetRange(DateOfDispatch, TempTable.DateOfDispatch);
                    TempTableBuff.SetRange(Type, TempTableBuff.type::Shipment);
                    if TempTableBuff.FindSet() then
                        repeat
                            QtyDispatch += TempTableBuff.QtyDispatchedToJobWorker;
                        until TempTableBuff.Next() = 0;

                    TempTableTmp.Init();
                    TempTableTmp."No." := TempTable.No;
                    if not TempTableTmp.Insert() then
                        TempTableTmp.Modify();

                    excelBuffer.NewRow();
                    excelBuffer.AddColumn(TempTable.No, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                    excelBuffer.AddColumn(TempTable.DateOfDispatch, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                    excelBuffer.AddColumn(Today() - TempTable.DateOfDispatch, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                    excelBuffer.AddColumn(TempTable.DescriptionOfGoodsDispatch, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                    excelBuffer.AddColumn(TempTable.QtyDispatchedToJobWorker, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                    excelBuffer.AddColumn(TempTable.UOM, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                    excelBuffer.AddColumn(TempTable.ItemDescription, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.FinishedGoodQtyProduced, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                    excelBuffer.AddColumn(TempTable.FGUOM, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                    excelBuffer.AddColumn(TempTable.NameAddJobWorker, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.NatureOfProcessing, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.JobWorkerDlvDocDate, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.FacGoodReciptDocDate, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.DateOfClearence, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.DescriptionOfGoods, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.QtyProduced, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    excelBuffer.AddColumn(TempTable.BalanceQty, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);

                    // FIXED LOOKUP: Filter matching receipts strictly by the target tracking key mapped to this specific shipment
                    QtyProduced := 0;
                    TempTableBuff.Reset();
                    TempTableBuff.SetRange(NatureOfProcessing, TempTable.No);
                    TempTableBuff.SetRange(ItemNo, TempTable.ItemNo);
                    TempTableBuff.SetRange(type, TempTableBuff.type::Receipt);
                    if TempTableBuff.FindSet() then begin
                        repeat
                            QtyProduced += TempTableBuff.QtyProduced;
                            excelBuffer.NewRow();
                            excelBuffer.AddColumn(TempTableBuff.No, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TempTableBuff.UOM, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TempTableBuff.NameAddJobWorker, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TempTableBuff.JobWorkerDlvDocDate, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TempTableBuff.FacGoodReciptDocDate, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                            excelBuffer.AddColumn(TempTableBuff.DateOfClearence, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                            excelBuffer.AddColumn(TempTableBuff.DescriptionOfGoods, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TempTableBuff.QtyProduced, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            TempTableBuff.Delete(true);
                        until TempTableBuff.Next() = 0;

                        // Clean totals block for this isolated link loop
                        excelBuffer.NewRow();
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                        excelBuffer.AddColumn('Total', FALSE, '', true, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                        excelBuffer.AddColumn(QtyProduced, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                    end;
                end;
            until TempTable.Next() = 0;

        // 4. Output outstanding orphan shipments that haven't received any inputs yet
        TSH.Reset();
        TSH.SetRange("Posting Date", fromDate, toDate);
        TSH.SetRange("Transfer-from Code", LocationCode);
        if TSH.FindSet() then
            repeat
                TempTableTmp.Reset();
                TempTableTmp.SetRange("No.", TSH."No.");
                if TempTableTmp.IsEmpty() then begin
                    TSL.Reset();
                    TSL.SetRange("Document No.", TSH."No.");
                    if TSL.FindSet() then
                        repeat
                            if CurrentItemNo <> TSH."Item No." then begin
                                CurrentItemNo := TSH."Item No.";
                                if not ItemRec.Get(CurrentItemNo) then
                                    ItemRec.Init();
                            end;

                            excelBuffer.NewRow();
                            excelBuffer.AddColumn(TSH."No.", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                            excelBuffer.AddColumn(TSH."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Date);
                            excelBuffer.AddColumn(Today() - TSH."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn(TSL.Description, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn(TSL.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                            excelBuffer.AddColumn(TSL."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn(ItemRec.Description, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn(TSH.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                            excelBuffer.AddColumn(TSH."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Text);
                            excelBuffer.AddColumn(TSH."Transfer-from Name", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TSH."Transaction Specification", FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::text);
                            excelBuffer.AddColumn(TSH.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', excelBuffer."Cell Type"::Number);
                        until TSL.Next() = 0;
                end;
            until TSH.Next() = 0;

        TempTable.DeleteAll();
        excelBuffer.CreateNewBook('Work Order Register');
        excelBuffer.WriteSheet('Work Order Register', CompanyName, UserId);
        excelBuffer.CloseBook();
        excelBuffer.OpenExcel();
    end;

    var
        excelBuffer: Record "Excel Buffer";
        TempTableTmp: Record "Transfer Shipment Header" temporary;
        TSH: Record "Transfer Shipment Header";
        TSL: Record "Transfer Shipment Line";
        TempTable: Record 50120;
        TempTableBuff: Record 50120;
        TempTableInsert: Record 50120;
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        ParentReceiptHeader: Record "Transfer Receipt Header";
        ItemRec: Record Item;
        TRL: Record "Transfer Receipt Line";
        fromDate: Date;
        toDate: Date;
        QtyDispatch: Decimal;
        QtyProduced: Decimal;
        TOtQty: Decimal;
        ENo: Integer;
        i: Integer;
        Sno: Integer;
        LocationCode: Text[20];
        ShipmentNo: Text[20];
        ShipmentNoArray: List of [Text];
        CurrentItemNo: Code[20];
}