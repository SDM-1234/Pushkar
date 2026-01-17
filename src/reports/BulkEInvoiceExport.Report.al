namespace Pushkar.Pushkar;

using Microsoft.Finance.GST.Sales;
using Microsoft.Sales.History;
using System.Utilities;

report 50107 "Bulk E-Invoice Export"
{
    ApplicationArea = All;
    Caption = 'Bulk E-Invoice Export';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Posting Date", "Bill-to Customer No.";

            trigger OnPreDataItem()
            begin
                if Count > 50 then
                    Error('The number of records to be processed exceeds the maximum limit of 50. Please refine your selection criteria and try again.');
                SingleInstanceCU.SetBulkEInvoices(true);
            end;

            trigger OnAfterGetRecord()
            var
                SalesInvHeader: Record "Sales Invoice Header";
                eInvoiceJsonHandler: Codeunit "e-Invoice Json Handler";
                eInvoiceManagement: Codeunit "e-Invoice Management";
            begin
                if eInvoiceManagement.IsGSTApplicable("No.", Database::"Sales Invoice Header") then begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", "No.");
                    if SalesInvHeader.FindFirst() then begin
                        Clear(eInvoiceJsonHandler);
                        SalesInvHeader.Mark(true);
                        eInvoiceJsonHandler.SetSalesInvHeader(SalesInvHeader);
                        eInvoiceJsonHandler.Run();
                    end;
                End;
            end;

            trigger OnPostDataItem()
            var
                TempBlob: Codeunit "Temp Blob";
                JsonArrayData: JsonArray;
                OutStream: OutStream;
                InStream: InStream;
                JsonText: Text;
                ToFile: Text[250];
            begin
                JsonArrayData := SingleInstanceCU.GetEinvoiceJsonArray();
                JsonArrayData.WriteTo(JsonText);
                TempBlob.CreateOutStream(OutStream);
                OutStream.WriteText(JsonText);
                ToFile := 'EInvoice' + '.json';
                TempBlob.CreateInStream(InStream);
                DownloadFromStream(InStream, 'e-Invoice', '', '', ToFile);
                SingleInstanceCU.SetBulkEInvoices(false);
            end;
        }
    }
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
}
