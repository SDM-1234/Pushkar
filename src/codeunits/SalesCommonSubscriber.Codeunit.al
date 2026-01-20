namespace Pushkar.Pushkar;

using Microsoft.Bank.BankAccount;
using Microsoft.Bank.Ledger;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Transfer;
using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Posting;
using Microsoft.Sales.Receivables;
using Microsoft.Warehouse.GateEntry;
using Microsoft.Inventory.Posting;
using Microsoft.Inventory.Journal;

codeunit 50100 SalesCommonSubscriber
{

    Permissions =
        tabledata "Sales Shipment Header" = rm;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode_ItemJnl(var ItemJournalLine: Record "Item Journal Line")
    var
        item: Record Item;
    begin

        if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::"Positive Adjmt.") and (ItemJournalLine.Quantity > 0) then
            if item.Get(ItemJournalLine."Item No.") then
                if item."Block Positive Adjustment" then
                    error('Positive adjustment is blocked for this item.');

    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', "No.", false, false)]
    local procedure OnAfterValidateEventNo_PSK(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if (Rec."No." <> '') and (Rec."Type" = Rec.Type::Item) then begin
            SalesHeader.Validate("Item No.", Rec."No.");
            SalesHeader.Validate(Description, Rec.Description);
            SalesHeader.Validate(Quantity, Rec.Quantity);
            SalesHeader.Validate("Unit of Measure", Rec."Unit of Measure");
            SalesHeader.Modify();
        end;
    end;



    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageEvent_SO(var Rec: Record "Sales Header")
    begin
        Rec."Posting Date" := WorkDate();
        //Rec.Modify();
    end;


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterOnAfterGetRecord', '', false, false)]
    local procedure OnAfterOnAfterGetRecord_SO(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."Posting Date" := WorkDate();
        //SalesHeader.Modify();
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', Quantity, false, false)]
    local procedure OnAfterValidateEventQty_PSK(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if (Rec."No." <> '') and (Rec."Type" = Rec.Type::Item) then begin
            SalesHeader.Validate("Item No.", Rec."No.");
            SalesHeader.Validate(Description, Rec.Description);
            SalesHeader.Validate(Quantity, Rec.Quantity);
            SalesHeader.Validate("Unit of Measure", Rec."Unit of Measure");
            SalesHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, COdeunit::"Sales-Post", OnAfterFinalizePosting, '', false, false)]
    local procedure OnAfterInsertEvent(var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetRange("Document No.", SalesShipmentHeader."No.");
        if ItemLedgerEntry.FindFirst() then begin
            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
            if ValueEntry.FindFirst() then begin
                SalesShipmentHeader.Validate("Posted Sales Invoice No.", ValueEntry."Document No.");
                SalesShipmentHeader.Validate("Sales Invoice Posting Date", ValueEntry."Posting Date");
                SalesShipmentHeader.Modify();
            end;
        end;
    end;


    #region Gate Entry Subscribers

    [EventSubscriber(ObjectType::Table, Database::"Gate Entry Line", OnAfterValidateEvent, "Source No.", false, false)]
    local procedure OnAfterValidateSourceNo(var Rec: Record "Gate Entry Line"; var xRec: Record "Gate Entry Line")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        If Rec."Source Type" = Rec."Source Type"::"Sales Shipment" then
            if SalesShipmentHeader.Get(Rec."Source No.") then begin
                Rec.Validate("Challan No.", SalesShipmentHeader."Posted Sales Invoice No.");
                Rec.Validate("Challan Date", SalesShipmentHeader."Sales Invoice Posting Date");
            end;
    end;

    #endregion

    local Procedure CreateDefaultDimensionForMaster(TableID: Integer; No: Code[20]; DimCode1: Code[20]; DimCode2: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin

        If DimCode1 <> '' then begin
            DefaultDimension.Init();
            DefaultDimension.Validate("Table ID", TableID);
            DefaultDimension.Validate("No.", No);
            DefaultDimension.Validate("Dimension Code", DimCode1);
            DefaultDimension.Validate("Value Posting", DefaultDimension."Value Posting"::"Code Mandatory");
            case TableID of
                Database::Vendor:
                    DefaultDimension.Validate("Parent Type", DefaultDimension."Parent Type"::Vendor);
                Database::"G/L account":
                    DefaultDimension.Validate("Parent Type", DefaultDimension."Parent Type"::" ");
                database::Customer:
                    DefaultDimension.Validate("Parent Type", DefaultDimension."Parent Type"::Customer);
            end;
            DefaultDimension.Insert();
        end;
        If DimCode2 <> '' then begin
            DefaultDimension.Init();
            DefaultDimension.Validate("Table ID", TableID);
            DefaultDimension."No." := No;
            DefaultDimension.Validate("Dimension Code", DimCode2);
            DefaultDimension.Validate("Value Posting", DefaultDimension."Value Posting"::"Code Mandatory");
            case TableID of
                23:
                    DefaultDimension.Validate("Parent Type", DefaultDimension."Parent Type"::Vendor);
                15:
                    DefaultDimension.Validate("Parent Type", DefaultDimension."Parent Type"::" ");
                18:
                    DefaultDimension.Validate("Parent Type", DefaultDimension."Parent Type"::Customer);
            end;
            DefaultDimension.Insert();
        end;
    end;

    local procedure GetGenLedgerSetup(): Boolean
    begin
        GenLedgSetup.Get();
        if (GenLedgSetup."Global Dimension 1 Code" <> '') OR (GenLedgSetup."Global Dimension 2 Code" <> '') then
            exit(true);
    end;

    var
        GenLedgSetup: Record "General Ledger Setup";
    #region GL and Customer/Vendor Creation Mandatory Condition
    [EventSubscriber(ObjectType::TABLE, Database::"G/L Account", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEventGL(var Rec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        if RunTrigger then
            if GetGenLedgerSetup() then
                CreateDefaultDimensionForMaster(Database::"G/L Account", Rec."No.", GenLedgSetup."Global Dimension 1 Code", GenLedgSetup."Global Dimension 2 Code");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Customer", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEventCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        if RunTrigger then
            if GetGenLedgerSetup() then
                CreateDefaultDimensionForMaster(Database::Customer, Rec."No.", GenLedgSetup."Global Dimension 1 Code", GenLedgSetup."Global Dimension 2 Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEventVendor(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;
        if RunTrigger then
            if GetGenLedgerSetup() then
                CreateDefaultDimensionForMaster(Database::Vendor, Rec."No.", GenLedgSetup."Global Dimension 1 Code", GenLedgSetup."Global Dimension 2 Code");
    end;
    #endregion

    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterValidateEvent, "Customer Posting Group", false, false)]
    local procedure OnAfterValidateEventCPG(var Rec: Record Customer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgExistErr: Label 'The Customer Posting Group cannot be changed because related Customer Ledger Entries already exist.',
        Comment = 'Displayed when user attempts to change posting group with existing ledger entries',
        Locked = true;
    begin
        CustLedgEntry.SetRange("Customer No.", Rec."No.");
        If not CustLedgEntry.IsEmpty() then
            error(CustLedgExistErr)
    end;


    [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterValidateEvent, "Vendor Posting Group", false, false)]
    local procedure OnAfterValidateEventVPG(var Rec: Record Vendor)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgExistErr: Label 'The Vendor Posting Group cannot be changed because related Vendor Ledger Entries already exist.',
        Comment = 'Displayed when user attempts to change posting group with existing ledger entries',
        Locked = true;
    begin
        VendLedgEntry.SetRange("Vendor No.", Rec."No.");
        If not VendLedgEntry.IsEmpty() then
            error(VendLedgExistErr)
    end;


    [EventSubscriber(ObjectType::Table, Database::Item, OnAfterValidateEvent, "Inventory Posting Group", false, false)]
    local procedure OnAfterValidateEventIPG(var Rec: Record Item)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgExistErr: Label 'The Inventory Posting Group cannot be changed because related Item Ledger Entries already exist.',
        Comment = 'Displayed when user attempts to change posting group with existing ledger entries',
        Locked = true;
    begin
        ItemLedgEntry.SetRange("Item No.", Rec."No.");
        If not ItemLedgEntry.IsEmpty() then
            error(ItemLedgExistErr)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account", OnAfterValidateEvent, "Bank Acc. Posting Group", false, false)]
    local procedure OnAfterValidateEventBAPG(var Rec: Record "Bank Account")
    var
        BankLedgEntry: Record "Bank Account Ledger Entry";
        BankLedgEntryExistErr: Label 'The Bank Account Posting Group cannot be changed because related Item Ledger Entries already exist.',
        Comment = 'Displayed when user attempts to change posting group with existing ledger entries',
        Locked = true;
    begin
        BankLedgEntry.SetRange("Bank Account No.", Rec."No.");
        If not BankLedgEntry.IsEmpty() then
            error(BankLedgEntryExistErr)
    end;
}
