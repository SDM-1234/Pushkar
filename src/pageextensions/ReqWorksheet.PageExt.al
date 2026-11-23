namespace Pushkar.Pushkar;

using Microsoft.Assembly.Document;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Requisition;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

pageextension 50100 "ReqWorksheet" extends "Req. Worksheet"
{
    actions
    {
        addlast(Processing)
        {
            action(CalculateSalesOrderPlanning)
            {
                ApplicationArea = All;
                Caption = 'Calculate Sales Order Planning';
                Image = CalculatePlan;
                ToolTip = 'Delete and recreate requisition lines in this batch from outstanding sales and assembly demand.';

                trigger OnAction()
                begin
                    RecreateSalesOrderPlanningLines();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure RecreateSalesOrderPlanningLines()
    var
        RequisitionLine: Record "Requisition Line";
        TempRequisitionLine: Record "Requisition Line" temporary;
        SalesLine: Record "Sales Line";
        AssemblyLine: Record "Assembly Line";
        RemainingSupply: Dictionary of [Text, Decimal];
        WorksheetTemplateName: Code[10];
        JournalBatchName: Code[10];
        WorksheetTemplateFilter: Text;
        JournalBatchFilter: Text;
        AvailableQty: Decimal;
        QtyToPurchase: Decimal;
        SupplyKey: Text;
        LineNo: Integer;
        DemandLineNo: Integer;
    begin
        WorksheetTemplateName := Rec."Worksheet Template Name";
        if WorksheetTemplateName = '' then begin
            WorksheetTemplateFilter := Rec.GetFilter("Worksheet Template Name");
            if StrLen(WorksheetTemplateFilter) > MaxStrLen(WorksheetTemplateName) then
                Error('The requisition worksheet template filter must identify one template.');
            WorksheetTemplateName := CopyStr(WorksheetTemplateFilter, 1, MaxStrLen(WorksheetTemplateName));
        end;
        JournalBatchName := Rec."Journal Batch Name";
        if JournalBatchName = '' then begin
            JournalBatchFilter := Rec.GetFilter("Journal Batch Name");
            if StrLen(JournalBatchFilter) > MaxStrLen(JournalBatchName) then
                Error('The requisition worksheet batch filter must identify one batch.');
            JournalBatchName := CopyStr(JournalBatchFilter, 1, MaxStrLen(JournalBatchName));
        end;

        if (WorksheetTemplateName = '') or (JournalBatchName = '') then
            Error('Select a requisition worksheet batch before calculating sales order planning.');

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Outstanding Qty. (Base)", '>0');
        SalesLine.SetFilter("Shipment Date", '<=%1', WorkDate());
        if SalesLine.FindSet() then
            repeat
                AllocateDemand(
                    SalesLine."No.", SalesLine."Location Code", SalesLine."Variant Code",
                    SalesLine."Unit of Measure Code", SalesLine."Outstanding Qty. (Base)",
                    SalesLine."Shipment Date", SalesLine."Dimension Set ID",
                    SalesLine."Document No.", SalesLine."Line No.", '', 0,
                    TempRequisitionLine, DemandLineNo);
            until SalesLine.Next() = 0;

        AssemblyLine.SetRange("Document Type", AssemblyLine."Document Type"::Order);
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        AssemblyLine.SetFilter("Remaining Quantity (Base)", '>0');
        if AssemblyLine.FindSet() then
            repeat
                AllocateDemand(
                    AssemblyLine."No.", AssemblyLine."Location Code", AssemblyLine."Variant Code",
                    AssemblyLine."Unit of Measure Code", AssemblyLine."Remaining Quantity (Base)",
                    AssemblyLine."Due Date", AssemblyLine."Dimension Set ID",
                    '', 0, AssemblyLine."Document No.", AssemblyLine."Line No.",
                    TempRequisitionLine, DemandLineNo);
            until AssemblyLine.Next() = 0;

        RequisitionLine.SetRange("Sales Order Planning", true);
        RequisitionLine.SetRange("Worksheet Template Name", WorksheetTemplateName);
        RequisitionLine.SetRange("Journal Batch Name", JournalBatchName);
        RequisitionLine.DeleteAll(true);

        TempRequisitionLine.Reset();
        if TempRequisitionLine.FindSet() then
            repeat
                SupplyKey := StrSubstNo(
                    '%1|%2|%3', TempRequisitionLine."No.",
                    TempRequisitionLine."Location Code", TempRequisitionLine."Variant Code");
                if not RemainingSupply.Get(SupplyKey, AvailableQty) then begin
                    AvailableQty := GetAvailableSupply(
                        TempRequisitionLine."No.", TempRequisitionLine."Location Code",
                        TempRequisitionLine."Variant Code");
                    RemainingSupply.Add(SupplyKey, AvailableQty);
                end;

                QtyToPurchase := TempRequisitionLine."Quantity (Base)" - AvailableQty;
                if QtyToPurchase > 0 then begin
                    CreatePlanningRequisitionLine(
                        WorksheetTemplateName, JournalBatchName,
                        TempRequisitionLine."No.", TempRequisitionLine."Location Code",
                        TempRequisitionLine."Variant Code", TempRequisitionLine."Unit of Measure Code",
                        QtyToPurchase, TempRequisitionLine."Due Date", TempRequisitionLine."Dimension Set ID",
                        TempRequisitionLine."Sales Order No.", TempRequisitionLine."Sales Order Line No.",
                        TempRequisitionLine."Ref. Order No.", TempRequisitionLine."Ref. Line No.", LineNo);
                    AvailableQty := 0;
                end else
                    AvailableQty -= TempRequisitionLine."Quantity (Base)";

                RemainingSupply.Set(SupplyKey, AvailableQty);
            until TempRequisitionLine.Next() = 0;
    end;

    local procedure AllocateDemand(
        ItemNo: Code[20];
        LocationCode: Code[10];
        VariantCode: Code[10];
        UnitOfMeasureCode: Code[10];
        DemandQty: Decimal;
        DueDate: Date;
        DimensionSetID: Integer;
        SalesOrderNo: Code[20];
        SalesOrderLineNo: Integer;
        AssemblyOrderNo: Code[20];
        AssemblyLineNo: Integer;
        var TempRequisitionLine: Record "Requisition Line" temporary;
        var DemandLineNo: Integer)
    var
        Item: Record Item;
    begin
        if (ItemNo = '') or (DemandQty <= 0) then
            exit;

        if not Item.Get(ItemNo) then
            Error('Item %1 referenced by demand was not found.', ItemNo);
        if Item."Replenishment System" <> Item."Replenishment System"::Purchase then
            exit;

        TempRequisitionLine.Reset();
        TempRequisitionLine.SetRange(Type, TempRequisitionLine.Type::Item);
        TempRequisitionLine.SetRange("No.", ItemNo);
        TempRequisitionLine.SetRange("Location Code", LocationCode);
        TempRequisitionLine.SetRange("Variant Code", VariantCode);
        TempRequisitionLine.SetRange("Unit of Measure Code", UnitOfMeasureCode);
        if TempRequisitionLine.FindFirst() then begin
            TempRequisitionLine."Quantity (Base)" += DemandQty;
            TempRequisitionLine.Modify();
            exit;
        end;

        DemandLineNo += 10000;
        TempRequisitionLine.Init();
        TempRequisitionLine."Line No." := DemandLineNo;
        TempRequisitionLine.Validate(Type, TempRequisitionLine.Type::Item);
        TempRequisitionLine.Validate("No.", ItemNo);
        TempRequisitionLine.Validate("Location Code", LocationCode);
        TempRequisitionLine.Validate("Variant Code", VariantCode);
        TempRequisitionLine.Validate("Unit of Measure Code", UnitOfMeasureCode);
        TempRequisitionLine."Quantity (Base)" := DemandQty;
        TempRequisitionLine."Due Date" := DueDate;
        TempRequisitionLine."Dimension Set ID" := DimensionSetID;
        if AssemblyOrderNo <> '' then begin
            TempRequisitionLine."Ref. Order Type" := TempRequisitionLine."Ref. Order Type"::Assembly;
            TempRequisitionLine."Ref. Order No." := AssemblyOrderNo;
            TempRequisitionLine."Ref. Line No." := AssemblyLineNo;
        end else begin
            TempRequisitionLine."Sales Order No." := SalesOrderNo;
            TempRequisitionLine."Sales Order Line No." := SalesOrderLineNo;
        end;
        TempRequisitionLine.Insert();
    end;

    local procedure GetAvailableSupply(ItemNo: Code[20]; LocationCode: Code[10]; VariantCode: Code[10]): Decimal
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            Error('Item %1 referenced by demand was not found.', ItemNo);

        Item.SetRange("No.", ItemNo);
        Item.SetRange("Location Filter", LocationCode);
        Item.SetRange("Variant Filter", VariantCode);
        Item.CalcFields(Inventory, "Qty. on Purch. Order");

        exit(Item.Inventory + Item."Qty. on Purch. Order");
    end;

    local procedure CreatePlanningRequisitionLine(
        WorksheetTemplateName: Code[10];
        JournalBatchName: Code[10];
        ItemNo: Code[20];
        LocationCode: Code[10];
        VariantCode: Code[10];
        UnitOfMeasureCode: Code[10];
        QuantityBase: Decimal;
        DueDate: Date;
        DimensionSetID: Integer;
        SalesOrderNo: Code[20];
        SalesOrderLineNo: Integer;
        RefOrderNo: Code[20];
        RefLineNo: Integer;
        var LineNo: Integer)
    var
        RequisitionLine: Record "Requisition Line";
    begin
        LineNo += 10000;
        RequisitionLine.Init();
        RequisitionLine."Worksheet Template Name" := WorksheetTemplateName;
        RequisitionLine."Journal Batch Name" := JournalBatchName;
        RequisitionLine."Line No." := LineNo;
        RequisitionLine.Validate(Type, RequisitionLine.Type::Item);
        RequisitionLine.Validate("No.", ItemNo);
        RequisitionLine.Validate("Location Code", LocationCode);
        RequisitionLine.Validate("Variant Code", VariantCode);
        RequisitionLine.Validate("Unit of Measure Code", UnitOfMeasureCode);
        RequisitionLine.Validate("Quantity (Base)", QuantityBase);
        if DueDate <> 0D then
            RequisitionLine.Validate("Due Date", DueDate);
        RequisitionLine.Validate("Dimension Set ID", DimensionSetID);

        if RefOrderNo <> '' then begin
            RequisitionLine.Validate("Ref. Order Type", RequisitionLine."Ref. Order Type"::Assembly);
            RequisitionLine.Validate("Ref. Order No.", RefOrderNo);
            RequisitionLine.Validate("Ref. Line No.", RefLineNo);
        end else begin
            RequisitionLine.Validate("Sales Order No.", SalesOrderNo);
            RequisitionLine.Validate("Sales Order Line No.", SalesOrderLineNo);
        end;

        RequisitionLine."Sales Order Planning" := true;
        RequisitionLine.Insert(true);
    end;
}
