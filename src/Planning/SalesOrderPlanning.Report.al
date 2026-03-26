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
                SetFilter("Requested Delivery Date", '<=%1', AsofDate);
            end;

            trigger OnAfterGetRecord()
            var
                SalesSetup: Record "Sales & Receivables Setup";
                Item: Record Item;
                SalesHeader: Record "Sales Header";
                RequsitionLine, RequsitionLineInsert : Record "Requisition Line";
                GetSalesOrders: Report "Get Sales Orders";
                DemandQty: Decimal;
            begin
                SalesSetup.Get();
                SalesHeader.Get("Document Type", "Document No.");
                // if not (SalesHeader.Status = SalesHeader.Status::Released) then
                //     CurrReport.Skip();
                if "Outstanding Quantity" = "Reserved Quantity" then
                    CurrReport.Skip();

                item.SetAutoCalcFields(Inventory, "Reserved Qty. on Inventory", "Qty. on Assembly Order", "Qty. on Purch. Order");
                Item.SetRange("No.", "No.");
                if "Location Code" <> '' then
                    Item.SetRange("Location Filter", "Location Code");
                Item.FindFirst();
                if item."Assembly BOM" then
                    DemandQty := "Outstanding Quantity" - Item.Inventory + item."Reserved Qty. on Inventory"
                        - item."Qty. on Assembly Order"
                else
                    DemandQty := "Outstanding Quantity" - Item.Inventory + item."Reserved Qty. on Inventory"
                        - item."Qty. on Purch. Order";
                if demandQty <= 0 then
                    CurrReport.Skip();

                case Item."Replenishment System" of
                    Item."Replenishment System"::Purchase:
                        begin
                            SalesLine."Outstanding Quantity" := DemandQty;
                            Clear(RequsitionLine);
                            GetSalesOrders.InsertReqWkshLine(SalesLine, RequsitionLine);
                            if not RequsitionLine.IsEmpty() then begin
                                RequsitionLineInsert := RequsitionLine;
                                RequsitionLineInsert."Worksheet Template Name" := SalesSetup."Req. Worksheet Template Name";
                                RequsitionLineInsert."Journal Batch Name" := SalesSetup."Req. Journal Batch Name";
                                RequsitionLineInsert."Sales Order Planning" := true;
                                RequsitionLine.Delete(true);
                                RequsitionLineInsert.Insert(true);
                            end;
                        end;
                    Item."Replenishment System"::Assembly:
                        begin
                            SalesLine.Validate("Qty. to Assemble to Order", DemandQty);
                            SalesLine.Modify(true);
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
}