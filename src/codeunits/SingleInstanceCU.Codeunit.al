namespace Pushkar.Pushkar;

codeunit 50103 SingleInstanceCU
{
    SingleInstance = true;



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
        BulkEInvoice: Boolean;
        JsonArrayData: JsonArray;

}
