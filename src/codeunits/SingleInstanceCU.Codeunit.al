namespace Pushkar.Pushkar;

using Microsoft.Purchases.Payables;

codeunit 50103 SingleInstanceCU
{
    SingleInstance = true;




    procedure SetIsHandled(pIsHandled: Boolean)
    begin
        IsHandled := pIsHandled;
    end;

    procedure GetIsHandled(): Boolean
    begin
        exit(IsHandled);
    end;

    procedure SetVendLedgerEntry(VendLedgerEntryRec: Record "Vendor Ledger Entry");
    begin
        VendLedgerEntry := VendLedgerEntryRec;
    end;


    procedure GetVendLedgerEntry(): Record "Vendor Ledger Entry"
    begin
        exit(VendLedgerEntry);
    end;


    procedure SetApplicationVendLedgerEntryParameters(TempApplyingVendLedgEntry: Record "Vendor Ledger Entry");
    begin
        ApplyVendLedgerEntry := TempApplyingVendLedgEntry;
        if not IsHandled then
            ApplyVendLedgerEntry.Reset();
    end;

    procedure GetApplicationVendLedgerEntryParameters(): Record "Vendor Ledger Entry"
    begin
        exit(ApplyVendLedgerEntry);
    end;


    procedure SetAllowCreation(pAllowCreate: Boolean)
    begin
        AllowCreate := pAllowCreate;
    end;

    procedure GetAllowCreation(): Boolean
    begin
        exit(AllowCreate);
    end;



    procedure SetBulkEInvoices(pBulkEInvoice: Boolean)
    begin
        BulkEInvoice := pBulkEInvoice;
    end;

    procedure GetBulkEInvoices(): Boolean
    begin
        exit(BulkEInvoice);
    end;


    procedure AddEinvoiceJsonArray(JObject: JsonObject)
    begin
        JsonArrayData.Add(JObject);
    end;

    procedure GetEinvoiceJsonArray(): JsonArray
    begin
        exit(JsonArrayData);
    end;

    var
        ApplyVendLedgerEntry: Record "Vendor Ledger Entry" temporary;
        VendLedgerEntry: Record "Vendor Ledger Entry" temporary;
        JsonArrayData: JsonArray;
        AllowCreate: Boolean;
        BulkEInvoice: Boolean;
        IsHandled: Boolean;
}
