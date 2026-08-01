namespace Pushkar.Pushkar;

using Microsoft.Purchases.Payables;
using Microsoft.Sales.Receivables;

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


    procedure SetCustLedgerEntry(CustLedgerEntryRec: Record "Cust. Ledger Entry");
    begin
        CustLedgerEntry := CustLedgerEntryRec;
    end;


    procedure GetCustLedgerEntry(): Record "Cust. Ledger Entry"
    begin
        exit(CustLedgerEntry);
    end;


    procedure SetApplicationVendLedgerEntryParameters(TempApplyingVendLedgEntry: Record "Vendor Ledger Entry");
    begin
        ApplyVendLedgerEntry := TempApplyingVendLedgEntry;
        if not IsHandled then
            ApplyVendLedgerEntry.Reset();
    end;

    procedure SetApplicationCustLedgerEntryParameters(TempApplyingCustLedgEntry: Record "Cust. Ledger Entry");
    begin
        ApplyCustLedgerEntry := TempApplyingCustLedgEntry;
        if not IsHandled then
            ApplyCustLedgerEntry.Reset();
    end;


    procedure GetApplicationVendLedgerEntryParameters(): Record "Vendor Ledger Entry"
    begin
        exit(ApplyVendLedgerEntry);
    end;

    procedure GetApplicationCustLedgerEntryParameters(): Record "Cust. Ledger Entry"
    begin
        exit(ApplyCustLedgerEntry);
    end;


procedure SetSkipModifyEvent(pSkipModify: Boolean)
    begin
        SkipModify := pSkipModify;
    end;


    procedure GetSkipModifyEvent(): Boolean
    begin
        exit(SkipModify);
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
        //Clear(JsonArrayData);
        JsonArrayData.Add(JObject);
    end;

    procedure GetEinvoiceJsonArray(): JsonArray
    begin
        exit(JsonArrayData);
    end;

    var
        ApplyVendLedgerEntry: Record "Vendor Ledger Entry" temporary;
        VendLedgerEntry: Record "Vendor Ledger Entry" temporary;
        ApplyCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
        CustLedgerEntry: Record "Cust. Ledger Entry" temporary;

        JsonArrayData: JsonArray;
        AllowCreate: Boolean;
        BulkEInvoice: Boolean;
        IsHandled: Boolean;
        SkipModify: Boolean;
}
