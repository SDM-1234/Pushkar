namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Reports;
using System.Environment;


report 50101 InventoryValuationReport
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/InventoryValuationReport.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory Valuation Report with Unit Conversion';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("Inventory Posting Group") where(Type = const(Inventory));
            RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group";
            column(BoM_Text; BoM_TextLbl)
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_; StrSubstNo('%1: %2', TableCaption(), ItemFilter))
            {
            }
            column(STRSUBSTNO_Text005_StartDateText_; StrSubstNo(Text005, StartDateText))
            {
            }
            column(STRSUBSTNO_Text005_FORMAT_EndDate__; StrSubstNo(Text005, Format(EndDate)))
            {
            }
            column(ShowExpected; ShowExpected)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(Inventory_ValuationCaption; Inventory_ValuationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_report_includes_entries_that_have_been_posted_with_expected_costs_Caption; This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl)
            {
            }
            column(ItemNoCaption; ValueEntry.FieldCaption("Item No."))
            {
            }
            column(ItemDescriptionCaption; FieldCaption(Description))
            {
            }
            column(IncreaseInvoicedQtyCaption; IncreaseInvoicedQtyCaptionLbl)
            {
            }
            column(DecreaseInvoicedQtyCaption; DecreaseInvoicedQtyCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(ValueCaption; ValueCaptionLbl)
            {
            }
            column(QuantityCaption_Control31; QuantityCaption_Control31Lbl)
            {
            }
            column(QuantityCaption_Control40; QuantityCaption_Control40Lbl)
            {
            }
            column(InvCostPostedToGL_Control53Caption; InvCostPostedToGL_Control53CaptionLbl)
            {
            }
            column(QuantityCaption_Control58; QuantityCaption_Control58Lbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Expected_Cost_IncludedCaption; Expected_Cost_IncludedCaptionLbl)
            {
            }
            column(Expected_Cost_Included_TotalCaption; Expected_Cost_Included_TotalCaptionLbl)
            {
            }
            column(Expected_Cost_TotalCaption; Expected_Cost_TotalCaptionLbl)
            {
            }
            column(GetUrlForReportDrilldown; GetUrlForReportDrilldown("No."))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(ItemDescription; Description)
            {
            }
            column(ItemBaseUnitofMeasure; "Base Unit of Measure")
            {
            }
            column(Item_Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            column(StartingInvoicedValue; StartingInvoicedValue)
            {
                AutoFormatType = 1;
            }

            column(CovertQty; CovertQty)
            {

            }
            column(ConvertStartingInvoicedQty; ConvertStartingInvoicedQty)
            { }
            column(ConvertIncreaseInvoicedQty; ConvertIncreaseInvoicedQty)
            { }
            column(ConvertEndingInvoicedQty; ConvertEndingInvoicedQty)
            { }
            column(CovertQtyClosing; CovertQtyClosing)
            { }
            column(ConvertDecreaseInvoicedQty; ConvertDecreaseInvoicedQty)
            { }
            column(PurchUOM; PurchUOM)
            { }
            column(StartingInvoicedQty; StartingInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(StartingExpectedValue; StartingExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingExpectedQty; StartingExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseInvoicedValue; IncreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseInvoicedQty; IncreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseExpectedValue; IncreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseExpectedQty; IncreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseInvoicedValue; DecreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseInvoicedQty; DecreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseExpectedValue; DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseExpectedQty; DecreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(EndingInvoicedValue; StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(EndingInvoicedQty; StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(ConvertEndingQty; ConvertEndingQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(EndingExpectedValue; StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(EndingExpectedQty; StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(CostPostedToGL; CostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(InvCostPostedToGL; InvCostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(ExpCostPostedToGL; ExpCostPostedToGL)
            {
                AutoFormatType = 1;
            }

            trigger OnAfterGetRecord()
            var
                SkipItem: Boolean;
                VarItem: Record Item;
            begin
                CalculateItem(Item);

                If Item."Gen. Prod. Posting Group" = 'RAW MATERIAL' then begin

                    // Opening
                    _qtyOpening := 0;
                    _AvgQtyOpening := 0;
                    CovertQtyOpening := 0;
                    ConvertStartingInvoicedQty := 0;
                    ItemLedgerEntryOpening.reset();
                    //Item.SetRange("Gen. Prod. Posting Group", 'RAW MATERIAL');
                    if Item."Location Filter" <> '' then
                        ItemLedgerEntryOpening.SetFilter("Location Code", Item."Location Filter");
                    if Item."Global Dimension 1 Filter" <> '' then
                        ItemLedgerEntryOpening.SetFilter("Global Dimension 1 Code", Item."Global Dimension 1 Filter");
                    if Item."Global Dimension 2 Filter" <> '' then
                        ItemLedgerEntryOpening.SetFilter("Global Dimension 2 Code", Item."Global Dimension 2 Filter");
                    ItemLedgerEntryOpening.SetRange("Item No.", Item."No.");
                    ItemLedgerEntryOpening.SetFilter("Posting Date", '<%1', StartDate);
                    ItemLedgerEntryOpening.SetRange("Entry Type", "ItemLedgerEntryOpening"."Entry Type"::Purchase);


                    if ItemLedgerEntryOpening.FindSet() then
                        repeat
                            _qtyOpening := _qtyOpening + ItemLedgerEntryOpening.Quantity;
                            _AvgQtyOpening := _AvgQtyOpening + ItemLedgerEntryOpening.Quantity / ItemLedgerEntryOpening."Qty. per Unit of Measure";
                        until ItemLedgerEntryOpening.Next() = 0;

                    if (_AvgQtyOpening <> 0) then begin
                        CovertQtyOpening := _qtyOpening / _AvgQtyOpening;
                        ConvertStartingInvoicedQty := StartingInvoicedQty / CovertQtyOpening;
                    end;
                    //Opening

                    _qty := 0;
                    _AvgQty := 0;
                    CovertQty := 0;
                    ConvertEndingInvoicedQty := 0;
                    ConvertIncreaseInvoicedQty := 0;
                    PurchUOM := '';
                    ItemLedgerEntry.reset();
                    //Item.SetRange("Gen. Prod. Posting Group", 'RAW MATERIAL');
                    if Item."Location Filter" <> '' then
                        ItemLedgerEntry.SetFilter("Location Code", Item."Location Filter");
                    if Item."Global Dimension 1 Filter" <> '' then
                        ItemLedgerEntry.SetFilter("Global Dimension 1 Code", Item."Global Dimension 1 Filter");
                    if Item."Global Dimension 2 Filter" <> '' then
                        ItemLedgerEntry.SetFilter("Global Dimension 2 Code", Item."Global Dimension 2 Filter");
                    ItemLedgerEntry.SetRange("Item No.", Item."No.");
                    ItemLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
                    ItemLedgerEntry.SetRange("Entry Type", "ItemLedgerEntry"."Entry Type"::Purchase);
                    if ItemLedgerEntry.FindSet() then
                        repeat
                            _qty := _qty + ItemLedgerEntry.Quantity;
                            _AvgQty := _avgQty + ItemLedgerEntry.Quantity / ItemLedgerEntry."Qty. per Unit of Measure";
                        until ItemLedgerEntry.Next() = 0;

                    if (_AvgQty <> 0) then begin
                        CovertQty := _qty / _AvgQty;
                        ConvertIncreaseInvoicedQty := IncreaseInvoicedQty / CovertQty;
                        //    ConvertDecreaseInvoicedQty := DecreaseInvoicedQty / CovertQty;
                        ConvertEndingInvoicedQty := ConvertStartingInvoicedQty + ConvertIncreaseInvoicedQty - ConvertDecreaseInvoicedQty;
                        PurchUOM := item."Purch. Unit of Measure";
                    end;

                    // closing
                    _qtyClosing := 0;
                    _AvgQtyClosing := 0;
                    CovertQtyClosing := 0;
                    ConvertDecreaseInvoicedQty := 0;
                    ConvertEndingQty := 0;
                    ItemLedgerEntryClosing.reset();
                    //Item.SetRange("Gen. Prod. Posting Group", 'RAW MATERIAL');
                    if Item."Location Filter" <> '' then
                        ItemLedgerEntryClosing.SetFilter("Location Code", Item."Location Filter");
                    if Item."Global Dimension 1 Filter" <> '' then
                        ItemLedgerEntryClosing.SetFilter("Global Dimension 1 Code", Item."Global Dimension 1 Filter");
                    if Item."Global Dimension 2 Filter" <> '' then
                        ItemLedgerEntryClosing.SetFilter("Global Dimension 2 Code", Item."Global Dimension 2 Filter");
                    ItemLedgerEntryClosing.SetRange("Item No.", Item."No.");
                    ItemLedgerEntryClosing.SetRange("Posting Date", 0D, EndDate);
                    ItemLedgerEntryClosing.SetRange("Entry Type", "ItemLedgerEntryClosing"."Entry Type"::Purchase);
                    if ItemLedgerEntryClosing.FindSet() then
                        repeat

                            _qtyClosing := _qtyClosing + ItemLedgerEntryClosing.Quantity;
                            _AvgQtyClosing := _AvgQtyClosing + ItemLedgerEntryClosing.Quantity / ItemLedgerEntryClosing."Qty. per Unit of Measure";
                        until ItemLedgerEntryClosing.Next() = 0;

                    if (_AvgQtyClosing <> 0) then begin
                        CovertQtyClosing := _qtyClosing / _AvgQtyClosing;

                        ConvertEndingQty := (StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty) / CovertQtyClosing;

                        ConvertDecreaseInvoicedQty := ConvertStartingInvoicedQty - ConvertEndingQty + ConvertIncreaseInvoicedQty;
                    end

                    //ConvertStartingInvoicedQty := StartingInvoicedQty / CovertQtyOpening;
                    ;
                    // closing



                end;

                SkipItem := false;
                OnBeforeOnAfterItemGetRecord(Item, SkipItem);
                if SkipItem then
                    CurrReport.Skip();



            end;
        }
    }

    requestpage
    {
        AboutTitle = 'About Inventory Valuation';
        AboutText = 'Reconcile your inventory subledger to the inventory account(s) in the general ledger at the end of each period. Include Expected Costs and Apply Location Filters to ensure that the Ending Date Value, Cost Posted to G/L and the Balance in the related Inventory or Inventory (Interim) Account are all in balance.';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(IncludeExpectedCost; ShowExpected)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Expected Cost';
                        ToolTip = 'Specifies if you want the report to also show entries that only have expected costs.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if (StartDate = 0D) and (EndDate = 0D) then
                EndDate := WorkDate();
        end;
    }

    labels
    {
        Inventory_Posting_Group_NameCaption = 'Inventory Posting Group Name';
        Expected_CostCaption = 'Expected Cost';
    }

    trigger OnPreReport()
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            EndDate := WorkDate();

        if StartDate in [0D, 00000101D] then
            StartDateText := ''
        else
            StartDateText := Format(StartDate - 1);

        ItemFilter := Item.GetFilters();
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntryOpening: Record "Item Ledger Entry";
        ItemLedgerEntryClosing: Record "Item Ledger Entry";

    protected var
        ValueEntry: Record "Value Entry";
        IsEmptyLine: Boolean;
        ShowExpected: Boolean;
        EndDate: Date;
        StartDate: Date;
        ConvertDecreaseInvoicedQty: Decimal;
        ConvertEndingInvoicedQty: Decimal;
        ConvertIncreaseInvoicedQty: Decimal;
        ConvertStartingInvoicedQty: Decimal;
        CostPostedToGL: Decimal;
        CovertQty: Decimal;
        CovertQtyOpening: Decimal;
        CovertQtyClosing: Decimal;
        ConvertEndingQty: Decimal;
        DecreaseExpectedQty: Decimal;
        DecreaseExpectedValue: Decimal;
        DecreaseInvoicedQty: Decimal;
        DecreaseInvoicedValue: Decimal;
        ExpCostPostedToGL: Decimal;
        IncreaseExpectedQty: Decimal;
        IncreaseExpectedValue: Decimal;
        IncreaseInvoicedQty: Decimal;
        IncreaseInvoicedValue: Decimal;
        InvCostPostedToGL: Decimal;
        StartingExpectedQty: Decimal;
        StartingExpectedValue: Decimal;
        StartingInvoicedQty: Decimal;
        StartingInvoicedValue: Decimal;
        _AvgQty: Decimal;
        _AvgQtyOpening: Decimal;
        _AvgQtyClosing: Decimal;
        _qty: Decimal;
        _qtyOpening: Decimal;
        _qtyClosing: Decimal;
        ItemFilter: Text;
        PurchUOM: Text[20];
        StartDateText: Text[10];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        DecreaseInvoicedQtyCaptionLbl: Label 'Decreases (LCY)';
        Expected_Cost_IncludedCaptionLbl: Label 'Expected Cost Included';
        Expected_Cost_Included_TotalCaptionLbl: Label 'Expected Cost Included Total';
        Expected_Cost_TotalCaptionLbl: Label 'Expected Cost Total';
        IncreaseInvoicedQtyCaptionLbl: Label 'Increases (LCY)';
        InvCostPostedToGL_Control53CaptionLbl: Label 'Cost Posted to G/L';
        Inventory_ValuationCaptionLbl: Label 'Inventory Valuation';
        QuantityCaptionLbl: Label 'Quantity';
        QuantityCaption_Control31Lbl: Label 'Quantity';
        QuantityCaption_Control40Lbl: Label 'Quantity';
        QuantityCaption_Control58Lbl: Label 'Quantity';
        This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl: Label 'This report includes entries that have been posted with expected costs.';
        TotalCaptionLbl: Label 'Total';
        ValueCaptionLbl: Label 'Value';
#pragma warning disable AA0074
#pragma warning disable AA0470
        Text005: Label 'As of %1';
#pragma warning restore AA0470
#pragma warning restore AA0074
        BoM_TextLbl: Label 'Base UoM';


    procedure AssignAmounts(ValueEntry: Record "Value Entry"; var InvoicedValue: Decimal; var InvoicedQty: Decimal; var ExpectedValue: Decimal; var ExpectedQty: Decimal; Sign: Decimal)
    begin
        InvoicedValue += ValueEntry."Cost Amount (Actual)" * Sign;
        InvoicedQty += ValueEntry."Invoiced Quantity" * Sign;
        ExpectedValue += ValueEntry."Cost Amount (Expected)" * Sign;
        ExpectedQty += ValueEntry."Item Ledger Entry Quantity" * Sign;
    end;

    procedure CalculateItem(var Item: Record Item)
    var
        HasEntriesWithinDateRange: Boolean;
        IsHandled: Boolean;
    begin
        Item.CalcFields("Assembly BOM");

        if EndDate = 0D then
            EndDate := DMY2Date(31, 12, 9999);

        StartingInvoicedValue := 0;
        StartingExpectedValue := 0;
        StartingInvoicedQty := 0;
        StartingExpectedQty := 0;
        IncreaseInvoicedValue := 0;
        IncreaseExpectedValue := 0;
        IncreaseInvoicedQty := 0;
        IncreaseExpectedQty := 0;
        DecreaseInvoicedValue := 0;
        DecreaseExpectedValue := 0;
        DecreaseInvoicedQty := 0;
        DecreaseExpectedQty := 0;
        InvCostPostedToGL := 0;
        CostPostedToGL := 0;
        ExpCostPostedToGL := 0;

        ValueEntry.Reset();
        ValueEntry.SetRange("Item No.", Item."No.");
        ValueEntry.SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        ValueEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        ValueEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        ValueEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        OnItemOnAfterGetRecordOnAfterValueEntrySetInitialFilters(ValueEntry, Item);

        ValueEntry.SetRange("Posting Date", 0D, EndDate);
        IsEmptyLine := ValueEntry.IsEmpty();
        if not IsEmptyLine then begin
            ValueEntry.SetRange("Posting Date", StartDate, EndDate);
            HasEntriesWithinDateRange := not ValueEntry.IsEmpty();
        end;
        ValueEntry.SetRange("Posting Date");

        if not IsEmptyLine then begin
            IsEmptyLine := true;
            if StartDate > 0D then begin
                ValueEntry.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartDate));
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, StartingInvoicedValue, StartingInvoicedQty, StartingExpectedValue, StartingExpectedQty, 1);
                IsEmptyLine := IsEmptyLine and ((StartingInvoicedValue = 0) and (StartingInvoicedQty = 0));
                if ShowExpected then
                    IsEmptyLine := IsEmptyLine and ((StartingExpectedValue = 0) and (StartingExpectedQty = 0));
            end;

            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetFilter(
                    "Item Ledger Entry Type", '%1|%2|%3|%4',
                    ValueEntry."Item Ledger Entry Type"::Purchase,
                    ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                    ValueEntry."Item Ledger Entry Type"::Output,
                    ValueEntry."Item Ledger Entry Type"::"Assembly Output");
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);
            end;

            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetFilter(
                    "Item Ledger Entry Type", '%1|%2|%3|%4',
                    ValueEntry."Item Ledger Entry Type"::Sale,
                    ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                    ValueEntry."Item Ledger Entry Type"::Consumption,
                    ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");

                OnCalculateItemOnBeforeAssignDecreaseAmounts(ValueEntry, Item);
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1);
                OnCalculateItemOnAfterAssignDecreaseAmounts(ValueEntry, Item, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty);
            end;

            if HasEntriesWithinDateRange then begin
                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Transfer);
                if ValueEntry.FindSet() then
                    repeat
                        if true in [ValueEntry."Valued Quantity" < 0, not GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.")] then
                            AssignAmounts(ValueEntry, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1)
                        else
                            AssignAmounts(ValueEntry, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);
                    until ValueEntry.Next() = 0;

                IsEmptyLine := IsEmptyLine and ((IncreaseInvoicedValue = 0) and (IncreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((DecreaseInvoicedValue = 0) and (DecreaseInvoicedQty = 0));
                if ShowExpected then begin
                    IsEmptyLine := IsEmptyLine and ((IncreaseExpectedValue = 0) and (IncreaseExpectedQty = 0));
                    IsEmptyLine := IsEmptyLine and ((DecreaseExpectedValue = 0) and (DecreaseExpectedQty = 0));
                end;
            end;
            ValueEntry.SetRange("Posting Date", 0D, EndDate);
            ValueEntry.SetRange("Item Ledger Entry Type");
            ValueEntry.CalcSums("Cost Posted to G/L", "Expected Cost Posted to G/L");
            ExpCostPostedToGL += ValueEntry."Expected Cost Posted to G/L";
            InvCostPostedToGL += ValueEntry."Cost Posted to G/L";

            StartingExpectedValue += StartingInvoicedValue;
            IncreaseExpectedValue += IncreaseInvoicedValue;
            DecreaseExpectedValue += DecreaseInvoicedValue;
            CostPostedToGL := ExpCostPostedToGL + InvCostPostedToGL;
        end; // if not IsEmptyLine

        IsHandled := false;
        OnAfterGetRecordItemOnBeforeSkipEmptyLine(Item, StartingInvoicedQty, IncreaseInvoicedQty, DecreaseInvoicedQty, IsHandled, IsEmptyLine, StartingExpectedQty, IncreaseExpectedQty, DecreaseExpectedQty);
        if not IsHandled then
            if IsEmptyLine then
                CurrReport.Skip();
    end;

    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SetCurrentKey("Item Ledger Entry No.");
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
        if not ItemApplnEntry.FindFirst() then
            exit(true);

        ItemLedgEntry.SetRange("Item No.", Item."No.");
        ItemLedgEntry.SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        ItemLedgEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        ItemLedgEntry.SetRange("Entry No.", ItemApplnEntry."Outbound Item Entry No.");
        OnGetOutboundItemEntryOnAfterSetItemLedgEntryFilters(ItemLedgEntry, Item);
        exit(ItemLedgEntry.IsEmpty());
    end;

    procedure SetStartDate(DateValue: Date)
    begin
        StartDate := DateValue;
    end;

    procedure SetEndDate(DateValue: Date)
    begin
        EndDate := DateValue;
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewShowExpected: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        ShowExpected := NewShowExpected;
    end;

    local procedure GetUrlForReportDrilldown(ItemNumber: Code[20]): Text
    var
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        // Generates a URL to the report which sets tab "Item" and field "Field1" on the request page, such as
        // dynamicsnav://hostname:port/instance/company/runreport?report=5801<&Tenant=tenantId>&filter=Item.Field1:1100.
        // TODO
        // Eventually leverage parameters 5 and 6 of GETURL by adding ",Item,TRUE)" and
        // use filter Item.SETFILTER("No.",'=%1',ItemNumber);.
        exit(GetUrl(ClientTypeManagement.GetCurrentClientType(), CompanyName, OBJECTTYPE::Report, REPORT::"Invt. Valuation - Cost Spec.") +
          StrSubstNo('&filter=Item.Field1:%1', ItemNumber));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnAfterItemGetRecord(var Item: Record Item; var SkipItem: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecordItemOnBeforeSkipEmptyLine(var Item: Record Item; var StartingInvoicedQty: Decimal; var IncreaseInvoicedQty: Decimal; var DecreaseInvoicedQty: Decimal; var IsHandled: Boolean; var IsEmptyLine: Boolean; var StartingExpectedQty: Decimal; var IncreaseExpectedQty: Decimal; var DecreaseExpectedQty: Decimal)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnItemOnAfterGetRecordOnAfterValueEntrySetInitialFilters(var ValueEntry: Record "Value Entry"; Item: Record Item)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnCalculateItemOnBeforeAssignDecreaseAmounts(var ValueEntry: Record "Value Entry"; Item: Record Item)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnCalculateItemOnAfterAssignDecreaseAmounts(var ValueEntry: Record "Value Entry"; Item: Record Item; var DecreaseInvoicedValue: Decimal; var DecreaseInvoicedQty: Decimal; var DecreaseExpectedValue: Decimal; var DecreaseExpectedQty: Decimal; var IncreaseInvoicedValue: Decimal; var IncreaseInvoicedQty: Decimal; var IncreaseExpectedValue: Decimal; var IncreaseExpectedQty: Decimal)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnGetOutboundItemEntryOnAfterSetItemLedgEntryFilters(var ItemLedgerEntry: Record "Item Ledger Entry"; Item: Record Item)
    begin
    end;
}
