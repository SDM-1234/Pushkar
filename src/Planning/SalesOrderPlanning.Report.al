report 50111 "Sales Order Planning"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableView = where("Document Type" = filter(Order), "Outstanding Quantity" = filter(> 0),
                Type = filter(Item));
            RequestFilterFields = "Document No.", Type, "No.";
            CalcFields = "Reserved Quantity";
            trigger OnPreDataItem()
            begin
                SetFilter("Shipment Date", '<=%1', AsofDate);
            end;

            trigger OnAfterGetRecord()
            var
                SalesSetup: Record "Sales & Receivables Setup";
                Item: Record Item;
                SalesHeader: Record "Sales Header";
                AsmLine: Record "Assembly Line";
                UnitOfMeasureMgt: Codeunit "Unit of Measure Management";
                DemandQty: Decimal;
            begin
                SalesSetup.Get();
                SalesHeader.Get("Document Type", "Document No.");
                // if not (SalesHeader.Status = SalesHeader.Status::Released) then
                //     CurrReport.Skip();

                if "Outstanding Quantity" = "Reserved Quantity" then
                    CurrReport.Skip();

                item.SetAutoCalcFields("Assembly BOM", Inventory, "Reserved Qty. on Inventory", "Qty. on Assembly Order", "Qty. on Purch. Order");
                Item.SetRange("No.", "No.");
                if "Location Code" <> '' then
                    Item.SetRange("Location Filter", "Location Code");
                Item.FindFirst();
                if item."Assembly BOM" then
                    DemandQty := "Outstanding Qty. (Base)" - Item.Inventory + item."Reserved Qty. on Inventory"
                        - item."Qty. on Assembly Order"
                else
                    DemandQty := "Outstanding Qty. (Base)" - Item.Inventory + item."Reserved Qty. on Inventory"
                        - item."Qty. on Purch. Order";

                if demandQty <= 0 then
                    CurrReport.Skip();
                SalesLine.AutoReserve();

                case Item."Replenishment System" of
                    Item."Replenishment System"::Purchase:
                        CreateReqLine(0, SalesLine."No.", SalesLine."Location Code", SalesLine."Unit of Measure Code", DemandQty, AsmLine);
                    Item."Replenishment System"::Assembly:
                        begin
                            SalesLine.Validate("Qty. to Assemble to Order", UnitOfMeasureMgt.CalcQtyFromBase(DemandQty, SalesLine."Qty. per Unit of Measure"));
                            SalesLine.Modify(true);
                            ExplodeAssOrder();
                            CreateReqFromAssemblyOrders();
                        end;
                end;

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
                }
            }
        }
    }

    var
        AsofDate: Date;

    local procedure ExplodeAssOrder()
    var
        Item: Record Item;
        ATOLink: Record "Assemble-to-Order Link";
        AsmLine: Record "Assembly Line";
    begin
        SalesLine.TestField("Qty. to Asm. to Order (Base)");
        if ATOLink.AsmExistsForSalesLine(SalesLine) then begin
            AsmLine.SetRange("Document Type", ATOLink."Assembly Document Type");
            AsmLine.SetRange("Document No.", ATOLink."Assembly Document No.");
            AsmLine.SetRange(Type, AsmLine.Type::Item);
            if AsmLine.FindSet(false) then
                repeat
                    Item.Get(AsmLine."No.");
                    item.CalcFields("Assembly BOM");
                    if Item."Assembly BOM" and (item."Replenishment System" = Item."Replenishment System"::Assembly) then begin
                        AsmLine.ExplodeAssemblyList();
                        ExplodeAssOrder();
                    end;
                until AsmLine.Next() = 0;
        end;
    end;

    local procedure CreateReqFromAssemblyOrders()
    var
        Item: Record Item;
        ATOLink: Record "Assemble-to-Order Link";
        AsmLine: Record "Assembly Line";
        DemandQty: Decimal;
    begin
        SalesLine.TestField("Qty. to Asm. to Order (Base)");
        if ATOLink.AsmExistsForSalesLine(SalesLine) then begin
            AsmLine.SetRange("Document Type", ATOLink."Assembly Document Type");
            AsmLine.SetRange("Document No.", ATOLink."Assembly Document No.");
            AsmLine.SetRange(Type, AsmLine.Type::Item);
            if AsmLine.FindSet(false) then
                repeat
                    item.SetAutoCalcFields("Assembly BOM", Inventory, "Reserved Qty. on Inventory", "Qty. on Assembly Order", "Qty. on Purch. Order");
                    Item.SetRange("No.", AsmLine."No.");
                    if AsmLine."Location Code" <> '' then
                        Item.SetRange("Location Filter", AsmLine."Location Code");
                    Item.FindFirst();
                    DemandQty := AsmLine."Remaining Quantity (Base)" - Item.Inventory + item."Reserved Qty. on Inventory"
                        - item."Qty. on Purch. Order";
                    if DemandQty <= 0 then
                        continue;
                    CreateReqLine(1, AsmLine."No.", AsmLine."Location Code", AsmLine."Unit of Measure Code", DemandQty, AsmLine);

                until AsmLine.Next() = 0;
        end;
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
        ReqLine.SetRange(Type, SalesLine.Type);
        ReqLine.SetRange("No.", ItemNo);
        if CreateFrom = CreateFrom::Assembly then begin
            ReqLine.validate("Variant Code", AsmLine."Variant Code");
            ReqLine.SetRange("Ref. Order Type", ReqLine."Ref. Order Type"::Assembly);
            ReqLine.SetRange("Ref. Order No.", AsmLine."Document No.");
            ReqLine.SetRange("Ref. Line No.", AsmLine."Line No.");
        end else begin
            ReqLine.SetRange("Sales Order No.", SalesLine."Document No.");
            ReqLine.SetRange("Sales Order Line No.", SalesLine."Line No.");
        end;
        if ReqLine.FindFirst() then
            exit;

        LineNo := LineNo + 10000;
        Clear(ReqLine);
        ReqLine.Init();
        ReqLine."Worksheet Template Name" := SalesSetup."Req. Worksheet Template Name";
        ReqLine."Journal Batch Name" := SalesSetup."Req. Journal Batch Name";
        ReqLine."Line No." := LineNo;
        ReqLine.Validate(Type, SalesLine.Type);
        ReqLine.Validate("No.", ItemNo);
        ReqLine.Validate("Location Code", locationCode);
        ReqLine.Validate("Unit of Measure Code", uom);
        ReqLine.Validate("Quantity (Base)", Qty);
        if CreateFrom = CreateFrom::Assembly then begin
            ReqLine.Validate("Variant Code", AsmLine."Variant Code");
            ReqLine.Validate("Dimension Set ID", AsmLine."Dimension Set ID");
            ReqLine.Validate("Ref. Order Type", ReqLine."Ref. Order Type"::Assembly);
            ReqLine.Validate("Ref. Order No.", AsmLine."Document No.");
            ReqLine.Validate("Ref. Line No.", AsmLine."Line No.");
        end else begin
            ReqLine.Validate("Variant Code", SalesLine."Variant Code");
            ReqLine.Validate("Dimension Set ID", SalesLine."Dimension Set ID");
            ReqLine.Validate("Sales Order No.", SalesLine."Document No.");
            ReqLine.Validate("Sales Order Line No.", SalesLine."Line No.");
        end;
        ReqLine."Sales Order Planning" := true;
        ReqLine.Insert(true);
    end;
}