namespace Pushkar.Pushkar;

using Microsoft.Sales.History;
using Microsoft.Warehouse.GateEntry;
using System.Utilities;

codeunit 50111 "Gate Entry Subscriber"
{

    Permissions = TableData "Sales Shipment Header" = rmid,
                  TableData "Gate Entry Line" = ri;


    trigger OnRun()
    begin
    end;



    [EventSubscriber(ObjectType::Table, Database::"Gate Entry Line", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteEvent(var Rec: Record "Gate Entry Line")
    var
        SalesShipHeader: Record "Sales Shipment Header";
    begin
        SalesShipHeader.Get(Rec."Source No.");
        SalesShipHeader."Assigned In Gate Entry" := false;
        SalesShipHeader.Modify();
    end;


    procedure CreateLines(SSH: Record "Sales Shipment Header"; GateEntryHeader: Record "Gate Entry Header")
    var
        GateEntryLine: Record "Gate Entry Line";

    begin
        GateEntryLine.Init();
        GateEntryLine.Validate("Entry Type", GateEntryLine."Entry Type"::Outward);
        GateEntryLine.Validate("Gate Entry No.", GateEntryHeader."No.");

        GateEntryLine.SetRange("Gate Entry No.", GateEntryHeader."No.");
        if GateEntryLine.FindLast() then
            GateEntryLine."Line No." := GateEntryLine."Line No." + 10000
        else
            GateEntryLine."Line No." := 10000;

        GateEntryLine.Validate("Source Type", GateEntryLine."Source Type"::"Sales Shipment");
        GateEntryLine.Validate("Source No.", SSH."No.");
        GateEntryLine.Insert();

        SSH."Assigned In Gate Entry" := true;
        SSH."Select for Gate Entry" := false;
        SSH.Modify();
    end;

    procedure ModifyShipmentHeader(var SSH: Record "Sales Shipment Header")
    begin
        SSH.modifyall("Select for Gate Entry", false);
    end;
}