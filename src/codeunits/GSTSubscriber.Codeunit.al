namespace Pushkar.Pushkar;

using Microsoft.Finance.GST.Sales;
using Pushkar.Pushkar;

codeunit 50115 "GST Subscriber"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"e-Invoice Json Handler", OnBeforeExportAsJson, '', false, false)]
    local procedure "e-Invoice Json Handler_OnBeforeExportAsJson"(var JsonArrayData: JsonArray; var JObject: JsonObject; FileName: Text[20]; var IsHandled: Boolean)
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        if SingleInstanceCU.GetBulkEInvoices() then begin
            SingleInstanceCU.AddEinvoiceJsonArray(JObject);
            IsHandled := true;
        end;
    end;
}