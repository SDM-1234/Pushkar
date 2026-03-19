namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Transfer;

reportextension 50105 TransferShipmentRptExt extends "Transfer Shipment"
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
                ItemLedgerEntry.reset();
                item.SetRange("No.", "Transfer Shipment Line"."Item No.");
                Item.SetRange("Gen. Prod. Posting Group", 'RAW MATERIAL');
                if Item.Find('-') then begin
                    ItemLedgerEntry.SetFilter("Location Code", "Transfer Shipment Line"."Transfer-from Code");
                    ItemLedgerEntry.SetRange("Document No.", "Transfer Shipment Header"."No.");
                    // ItemLedgerEntry.SetRange("Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                    // ItemLedgerEntry.SetRange("Global Dimension 2 Code", "Shortcut Dimension 2 Code");
                    ItemLedgerEntry.SetRange("Entry Type", "ItemLedgerEntry"."Entry Type"::Transfer);
                    ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Transfer Shipment");
                    if ItemLedgerEntry.FindFirst() then begin
                        ItemLedgerEntryLot.Reset();
                        ItemLedgerEntryLot.SetRange("Item No.", ItemLedgerEntry."Item No.");
                        ItemLedgerEntryLot.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                        ItemLedgerEntryLot.SetRange("Entry Type", ItemLedgerEntryLot."Entry Type"::Purchase);
                        if ItemLedgerEntryLot.FindSet() then
                            repeat
                                _qty := _qty + ItemLedgerEntryLot.Quantity;
                                _AvgQty := _avgQty + ItemLedgerEntryLot.Quantity / ItemLedgerEntryLot."Qty. per Unit of Measure";
                            until ItemLedgerEntryLot.Next() = 0;
                        PurchUOM := item."Purch. Unit of Measure";
                    end;
                    if (_AvgQty <> 0) then
                        CovertQty := (Quantity) / (Abs(_qty / _AvgQty));
                end;
            end;
        }

    }
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntryLot: Record "Item Ledger Entry";
        Item: Record Item;
        CovertQty: Decimal;
        PurchUOM: Text[20];
        _qty: Decimal;
        _AvgQty: Decimal;
}