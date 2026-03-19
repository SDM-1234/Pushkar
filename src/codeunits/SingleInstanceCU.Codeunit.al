namespace Pushkar.Pushkar;

codeunit 50103 SingleInstanceCU
{
    SingleInstance = true;



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
        BulkEInvoice: Boolean;
        AllowCreate: Boolean;
        JsonArrayData: JsonArray;

}
