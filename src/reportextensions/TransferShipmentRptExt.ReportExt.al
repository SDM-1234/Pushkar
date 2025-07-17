reportextension 50101 TransferShipmentRptExt extends "Transfer Shipment"
{
    dataset
    {
        add("Transfer Shipment Line")
        {
            column(CovertQty; CovertQty)
            { }
            column(PurchUOM; PurchUOM)
            { }
        }
        // Add changes to dataitems and columns here
        modify("Transfer Shipment Line")
        {

            // {}
            trigger OnBeforeAfterGetRecord()
            begin
                _qty := 0;
                _AvgQty := 0;
                CovertQty := 0;
                ItemLedgerEntry.reset;
                item.SetRange("No.", "Transfer Shipment Line"."Item No.");
                Item.SetRange("Gen. Prod. Posting Group", 'RAW MATERIAL');
                if Item.Find('-') then begin
                    ItemLedgerEntry.SetFilter("Location Code", "Transfer Shipment Line"."Transfer-from Code");
                    ItemLedgerEntry.SetRange("Posting Date", "Transfer Shipment Header"."Posting Date");
                    ItemLedgerEntry.SetRange("Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                    ItemLedgerEntry.SetRange("Global Dimension 2 Code", "Shortcut Dimension 2 Code");
                    ItemLedgerEntry.SetRange("Entry Type", "ItemLedgerEntry"."Entry Type"::Purchase);
                    if ItemLedgerEntry.FindSet() then
                        repeat
                            _qty := _qty + ItemLedgerEntry.Quantity;
                            _AvgQty := _avgQty + ItemLedgerEntry.Quantity / ItemLedgerEntry."Qty. per Unit of Measure";
                        until ItemLedgerEntry.Next() = 0;
                    PurchUOM := item."Purch. Unit of Measure";
                end;
                if (_AvgQty <> 0) then begin
                    CovertQty := _qty / _AvgQty;

                end;

            end;
        }

    }
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        CovertQty: Decimal;
        PurchUOM: Text[20];
        _qty: Decimal;
        _AvgQty: Decimal;



}