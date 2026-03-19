namespace Pushkar.Pushkar;

using Microsoft.Finance.Reports;
using Microsoft.Inventory.Comment;
using Microsoft.Inventory.Intrastat;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

reportextension 50102 TransferShipmentGST extends "Transfer Shipment GST"
{
    dataset
    {
        add("Transfer Shipment Line")
        {
            column(CovertQty; CovertQty)
            { }
            column(PurchUOM; PurchUOM)
            { }
            column(Unit_Price; "Unit Price")
            { }
            column(Remarks; remarks) { }
        }
        add("Transfer Shipment Header")
        {
            column(Vehicle_No_; "Vehicle No.")
            { }
            column(Time_of_Removal; "Time of Removal")
            { }
            column(FGItem_No_; "Item No.") { }
            column(FGQuantity; Quantity) { }
            column(FGUnit_of_Measure; "Unit of Measure") { }
            column(FGDescription; Description) { }
            column(Transaction_Specification; TransactionSpecifcation.Text) { }
            column(TransferOrderNo; "Transfer Shipment Header"."Transfer Order No.") { }
            column(Transaction_NatureDesc; TransactionType.Description) { }
        }


        modify("Transfer Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                if TransactionSpecifcation.Get("Transfer Shipment Header"."Transaction Specification") then;
                if TransactionType.Get("Transfer Shipment Header"."Transaction Type") then;
            end;
        }

        modify("Transfer Shipment Line")
        {
            trigger OnBeforeAfterGetRecord()
            begin
                InvetoryCommentLine.Reset();
                InvetoryCommentLine.SetRange("Document Type", InvetoryCommentLine."Document Type"::"Posted Transfer Shipment");
                InvetoryCommentLine.SetRange("No.", "Transfer Shipment Line"."Document No.");
                if InvetoryCommentLine.FindSet() then
                    repeat
                        if Remarks <> '' then
                            Remarks += ' | '; // Separator between comments
                        Remarks += InvetoryCommentLine.Comment;
                    until InvetoryCommentLine.Next() = 0;
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

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'src/ReportLayouts/TransferShipmentGSTWithUOMCon.rdl';
        }
    }



    var
        InvetoryCommentLine: Record "Inventory Comment Line";
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntryLot: Record "Item Ledger Entry";
        TransactionSpecifcation: Record "Transaction Specification";
        TransactionType: Record "Transaction Type";
        CovertQty: Decimal;
        Remarks: Text[250];
        _AvgQty: Decimal;
        _qty: Decimal;
        PurchUOM: Text[20];
}