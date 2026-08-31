report 50112 "Sales Order Planning"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            trigger OnPreDataItem()
            begin
                ItemBySalesOutsQty.SetFilter(Shipment_Date, '<=%1', AsofDate);
                if this.ItemNoFilter <> '' then
                    ItemBySalesOutsQty.SetFilter(Item_No, '%1', ItemNoFilter);
                if this.LocationFilter <> '' then
                    ItemBySalesOutsQty.SetFilter(Location_Code, '%1', LocationFilter);
                ItemBySalesOutsQty.Open();
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                DemandQty: Decimal;
            begin
                if not ItemBySalesOutsQty.Read() then
                    CurrReport.Break();
                item.get(ItemBySalesOutsQty.Item_No);

                case Item."Replenishment System" of
                    Item."Replenishment System"::Purchase:
                        FillProcessingTable(ItemBySalesOutsQty.Item_No, ItemBySalesOutsQty.Location_Code, ItemBySalesOutsQty.Unit_of_Measure_Code, ItemBySalesOutsQty.Outstanding_Quantity, 0, DemandQty);
                    Item."Replenishment System"::Assembly:
                        begin
                            FillProcessingTable(ItemBySalesOutsQty.Item_No, ItemBySalesOutsQty.Location_Code, ItemBySalesOutsQty.Unit_of_Measure_Code, ItemBySalesOutsQty.Outstanding_Quantity, 0, DemandQty);
                            ExplodeAssBom(ItemBySalesOutsQty.Item_No, ItemBySalesOutsQty.Location_Code, DemandQty, 1);
                        end;
                end;
            end;

            trigger OnPostDataItem()
            var
                AsmLine: Record "Assembly Line";
            begin
                // Process the temporary table to create planned orders
                SOPlanningProcessing.SetCurrentKey("Assembly Order Level");
                SOPlanningProcessing.SetFilter("Demand Quantity", '>0');
                if SOPlanningProcessing.FindSet() then
                    repeat
                        case SOPlanningProcessing."Replenishment System" of
                            SOPlanningProcessing."Replenishment System"::Purchase:
                                CreateReqLine(0, SOPlanningProcessing."Item No", SOPlanningProcessing."Location Code", SOPlanningProcessing."Unit of Measure Code", SOPlanningProcessing."Demand Quantity", AsmLine);
                            SOPlanningProcessing."Replenishment System"::Assembly:
                                CreateAssOrder(SOPlanningProcessing."Item No", SOPlanningProcessing."Location Code", SOPlanningProcessing."Unit of Measure Code", SOPlanningProcessing."Demand Quantity", SOPlanningProcessing."Process Log Entry No");
                        end;
                    until SOPlanningProcessing.Next() = 0;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(AsofDate_; AsofDate)
                    {
                        Caption = 'As of Date';
                        ToolTip = 'Select the date for which you want to view the sales order planning.';
                        ApplicationArea = All;
                    }
                    // field(ItemNoFilter_; ItemNoFilter)
                    // {
                    //     Caption = 'Item No. Filter';
                    //     ToolTip = 'Select the item for which you want to view the sales order planning.';
                    //     ApplicationArea = All;
                    //     TableRelation = Item;
                    // }
                    field(LocationFilter_; LocationFilter)
                    {
                        Caption = 'Location Filter';
                        ToolTip = 'Select the location for which you want to view the sales order planning.';
                        ApplicationArea = All;
                        TableRelation = Location;
                    }
                }
            }
        }
    }

    var
        SOPlanningProcessing: Record "SO Planning Processing";
        ItemBySalesOutsQty: Query "Item By Sales Outs Qty";
        AsofDate: Date;
        ItemNoFilter, LocationFilter : Code[20];

    local procedure ExplodeAssBom(ItemNo: Code[20]; locationCode: Code[10]; Qty: Decimal; Level: Integer)
    var
        BomComponent: Record "BOM Component";
        DemandQty: Decimal;
    begin
        if Qty <= 0 then
            exit;
        BomComponent.SetAutoCalcFields("Assembly BOM");
        BomComponent.SetRange("Parent Item No.", ItemNo);
        BomComponent.SetRange(Type, BomComponent.Type::Item);
        if BomComponent.FindSet(false) then
            repeat
                DemandQty := 0;
                FillProcessingTable(BomComponent."No.", locationCode, BomComponent."Unit of Measure Code", Qty * BomComponent."Quantity per", Level, DemandQty);
                if BomComponent."Assembly BOM" then
                    ExplodeAssBom(BomComponent."No.", locationCode, DemandQty, Level + 1);
            until BomComponent.Next() = 0;
    end;

    local procedure FillProcessingTable(ItemNo: Code[20]; locationCode: Code[10]; uom: Code[10]; Qty: Decimal; Level: Integer; var ActualQty: Decimal)
    var
        item: Record Item;
        PlanningProcessingLog: Record "Planning Processing Log";
        DemandQty: Decimal;
    begin
        if SOPlanningProcessing.Get(ItemNo, locationCode, uom) then begin
            SOPlanningProcessing."Demand Quantity" := SOPlanningProcessing."Demand Quantity" + Qty;
            SOPlanningProcessing.modify();
        end else begin
            item.SetAutoCalcFields("Assembly BOM", Inventory, "Reserved Qty. on Inventory", "Qty. on Assembly Order", "Qty. on Purch. Order"
                    , "Res. Qty. on Assembly Order", "Reserved Qty. on Purch. Orders");
            Item.SetRange("No.", ItemNo);
            if locationCode <> '' then
                Item.SetRange("Location Filter", locationCode);
            Item.FindFirst();

            if item."Assembly BOM" then
                DemandQty := Qty - Item.Inventory + item."Reserved Qty. on Inventory" + item."Minimum Order Quantity"
                    - (item."Qty. on Assembly Order" - item."Res. Qty. on Assembly Order")
            else
                DemandQty := Qty - Item.Inventory + item."Reserved Qty. on Inventory" + item."Minimum Order Quantity"
                    - (item."Qty. on Purch. Order" - item."Reserved Qty. on Purch. Orders");

            PlanningProcessingLog.InitializePlanningProcessingLog(locationCode, item.Description, Qty, Qty, 0D, WorkDate(), Item.Inventory, item."Qty. on Assembly Order", item."Qty. on Purch. Order", '', WorkDate(), '', WorkDate(), DemandQty, '', Item.Inventory, 0);
            SOPlanningProcessing.Init();
            SOPlanningProcessing."Item No" := ItemNo;
            SOPlanningProcessing."Location Code" := locationCode;
            SOPlanningProcessing."Unit of Measure Code" := uom;
            SOPlanningProcessing."Demand Quantity" := DemandQty;
            SOPlanningProcessing."Replenishment System" := item."Replenishment System";
            SOPlanningProcessing."Assembly Order Level" := Level;
            SOPlanningProcessing."Process Log Entry No" := PlanningProcessingLog."Entry No.";
            SOPlanningProcessing.Insert();
        end;
        ActualQty := SOPlanningProcessing."Demand Quantity";

    end;

    local procedure CreateAssOrder(ItemNo: Code[20]; locationCode: Code[10]; uom: Code[10]; Qty: Decimal; LogEntryNo: Integer)
    var
        AssHeader: Record "Assembly Header";
        PlanningProcessingLog: Record "Planning Processing Log";
        AssemblyLineMgt: Codeunit "Assembly Line Management";
    begin
        AssHeader.Init();
        AssHeader.Validate("Document Type", AssHeader."Document Type"::Order);
        AssHeader.Insert(true);
        AssHeader.Validate("Item No.", ItemNo);
        AssHeader.Validate("Location Code", locationCode);
        AssHeader.Validate("Unit of Measure Code", uom);
        AssHeader.Validate("Quantity (Base)", Qty);
        AssHeader."Sales Order Planning" := true;
        AssHeader.Modify(true);
        AssemblyLineMgt.UpdateAssemblyLines(AssHeader, AssHeader, 0, true, 0, 0);
        PlanningProcessingLog.Get(LogEntryNo);
        PlanningProcessingLog."New Assembly Order No. Created" := AssHeader."No.";
        PlanningProcessingLog.Modify();
    end;

    local procedure CreateReqLine(CreateFrom: Option Sales,Assembly; ItemNo: Code[20]; locationCode: Code[10]; uom: Code[10]
        ; Qty: Decimal; AsmLine: Record "Assembly Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ReqLine: Record "Requisition Line";
        LineNo: Integer;
    begin
        SalesSetup.Get();
        ReqLine.SetRange("Worksheet Template Name", SalesSetup."Req. Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", SalesSetup."Req. Journal Batch Name");
        if ReqLine.FindLast() then
            LineNo := ReqLine."Line No.";
        Clear(ReqLine);
        ReqLine.Reset();
        ReqLine.SetCurrentKey(Type, "No.");
        ReqLine.SetRange(Type, ReqLine.Type::Item);
        ReqLine.SetRange("No.", ItemNo);
        if CreateFrom = CreateFrom::Assembly then begin
            ReqLine.SetRange("Ref. Order Type", ReqLine."Ref. Order Type"::Assembly);
            ReqLine.SetRange("Ref. Order No.", AsmLine."Document No.");
            ReqLine.SetRange("Ref. Line No.", AsmLine."Line No.");
        end else begin
            ReqLine.SetRange("Location Code", locationCode);
            ReqLine.SetRange("Unit of Measure Code", uom);
            ReqLine.SetRange("Quantity (Base)", Qty);
        end;
        if ReqLine.FindFirst() then
            exit;

        LineNo := LineNo + 10000;
        Clear(ReqLine);
        ReqLine.Init();
        ReqLine."Worksheet Template Name" := SalesSetup."Req. Worksheet Template Name";
        ReqLine."Journal Batch Name" := SalesSetup."Req. Journal Batch Name";
        ReqLine."Line No." := LineNo;
        ReqLine.Validate(Type, ReqLine.Type::Item);
        ReqLine.Validate("No.", ItemNo);
        ReqLine.Validate("Location Code", locationCode);
        ReqLine.Validate("Unit of Measure Code", uom);
        ReqLine.Validate("Quantity (Base)", Round(Qty, 1, '>'));
        if CreateFrom = CreateFrom::Assembly then begin
            ReqLine.Validate("Variant Code", AsmLine."Variant Code");
            ReqLine.Validate("Dimension Set ID", AsmLine."Dimension Set ID");
            ReqLine.Validate("Ref. Order Type", ReqLine."Ref. Order Type"::Assembly);
            ReqLine.Validate("Ref. Order No.", AsmLine."Document No.");
            ReqLine.Validate("Ref. Line No.", AsmLine."Line No.");
        end;
        ReqLine."Sales Order Planning" := true;
        ReqLine.Insert(true);
    end;
}