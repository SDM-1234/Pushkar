namespace Pushkar.Pushkar;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
using Microsoft.Inventory.Transfer;
using Microsoft.Sales.History;
using Microsoft.Inventory.Ledger;

codeunit 50101 TransferOrderMgt
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnBeforeInsertTransShptHeader, '', false, false)]
    local procedure OnBeforeInsertTransShptHeader_PSK(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header")
    begin
        TransShptHeader."Item No." := TransHeader."Item No.";
        TransShptHeader."Unit of Measure" := TransHeader."Unit of Measure";
        TransShptHeader.Quantity := TransHeader.Quantity;
TransShptHeader.Description := TransHeader.Description;
        //OnBeforeInsertTransShptHeader(TransShptHeader, TransHeader, SuppressCommit);
    end;
    //OnBeforeInsertTransShptLine

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnBeforeInsertTransShptLine, '', false, false)]
    local procedure OnBeforeInsertTransShptLine_PSK(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line")
    begin
        TransShptLine."Posted Transfer Shipment Nos." := TransLine."Posted Transfer Shipment Nos.";
        //OnBeforeInsertTransShptHeader(TransShptHeader, TransHeader, SuppressCommit);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforeTransRcptHeaderInsert, '', false, false)]
    local procedure OnBeforeInsertTransRcptHeader_PSK(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Item No." := TransferHeader."Item No.";
        TransferReceiptHeader."Unit of Measure" := TransferHeader."Unit of Measure";
        TransferReceiptHeader.Quantity := TransferHeader.Quantity;
        TransferReceiptHeader.Description := TransferHeader.Description;
        //OnBeforeInsertTransShptHeader(TransShptHeader, TransHeader, SuppressCommit);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforeInsertTransRcptLine, '', false, false)]
    local procedure OnBeforeInsertTransRcptLine_PSK(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line")
    begin
        TransRcptLine."Posted Transfer Shipment Nos." := TransLine."Posted Transfer Shipment Nos.";
        //OnBeforeInsertTransShptHeader(TransShptHeader, TransHeader, SuppressCommit);
    end;

    //OnBeforeInsertTransRcptLine
}
