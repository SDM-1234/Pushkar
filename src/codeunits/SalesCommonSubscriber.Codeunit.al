namespace Pushkar.Pushkar;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
using Microsoft.Sales.History;
using Microsoft.Inventory.Ledger;

codeunit 50100 SalesCommonSubscriber
{

    Permissions =
        tabledata "Sales Shipment Header" = rm;


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
}
