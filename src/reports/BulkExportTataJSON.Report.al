namespace Pushkar.Pushkar;

using Microsoft.Finance.GST.Base;
using Microsoft.Finance.GST.Sales;
using Microsoft.Foundation.Company;
using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using System.Utilities;

report 50109 "BulkExportTataJSON"
{
    ApplicationArea = All;
    Caption = 'Bulk Export Tata JSON';
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
            end;

            trigger OnAfterGetRecord()
            begin
                CreatePostSaleJson(SalesInvoiceHeader);
            end;

            trigger OnPostDataItem()
            var
                TempBlob: Codeunit "Temp Blob";
                OutStream: OutStream;
                InStream: InStream;
                JsonText: Text;
                ToFile: Text[250];
            begin
                JsonArrayData.WriteTo(JsonText);
                TempBlob.CreateOutStream(OutStream);
                OutStream.WriteText(JsonText);
                ToFile := 'TataJson' + '.json';
                TempBlob.CreateInStream(InStream);
                DownloadFromStream(InStream, 'e-Invoice', '', '', ToFile);
            end;
        }
    }
    var
        JsonArrayData: JsonArray;


    procedure CreatePostSaleJson(SalesInvHdr: Record "Sales Invoice Header")
    var
        recCompinfo: Record "Company Information";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldGSTLedgEntry: Record "Detailed GST Ledger Entry";
        SalesInvLine: Record "Sales Invoice Line";
        JsonObjSalesInv: JsonObject;
        decCGSTAmt: Decimal;
        decCGSTPer: Decimal;
        decIGSTAmt: Decimal;
        decIGSTPer: Decimal;
        decInvoiceAmt: Decimal;
        decSGSTAmt: Decimal;
        decSGSTPer: Decimal;
        txtdate: Text;

    begin
        Clear(decCGSTAmt);
        Clear(decSGSTAmt);
        Clear(decIGSTAmt);
        Clear(decCGSTPer);
        Clear(decIGSTPer);
        Clear(decSGSTPer);
        recCompinfo.FindFirst();
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        if SalesInvLine.FindFirst() then;
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange("Document No.", SalesInvHdr."No.");
        if CustLedgEntry.FindFirst() then begin
            CustLedgEntry.CalcFields(CustLedgEntry."Amount (LCY)");
            decInvoiceAmt := CustLedgEntry."Amount (LCY)";
        end;
        DtldGSTLedgEntry.Reset();
        DtldGSTLedgEntry.SetRange("Document Type", DtldGSTLedgEntry."Document Type"::Invoice);
        DtldGSTLedgEntry.SetRange("Document No.", SalesInvHdr."No.");
        DtldGSTLedgEntry.SetRange("GST Component Code", 'CGST');
        if DtldGSTLedgEntry.FindFirst() then begin
            decCGSTAmt := DtldGSTLedgEntry."GST Amount";
            decCGSTPer := DtldGSTLedgEntry."GST %";
        end;
        DtldGSTLedgEntry.Reset();
        DtldGSTLedgEntry.SetRange("Document Type", DtldGSTLedgEntry."Document Type"::Invoice);
        DtldGSTLedgEntry.SetRange("Document No.", SalesInvHdr."No.");
        DtldGSTLedgEntry.SetRange("GST Component Code", 'SGST');
        if DtldGSTLedgEntry.FindFirst() then begin
            decSGSTAmt := DtldGSTLedgEntry."GST Amount";
            decSGSTPer := DtldGSTLedgEntry."GST %";
        end;
        DtldGSTLedgEntry.Reset();
        DtldGSTLedgEntry.SetRange("Document Type", DtldGSTLedgEntry."Document Type"::Invoice);
        DtldGSTLedgEntry.SetRange("Document No.", SalesInvHdr."No.");
        DtldGSTLedgEntry.SetRange("GST Component Code", 'IGST');
        if DtldGSTLedgEntry.FindFirst() then begin
            decIGSTAmt := DtldGSTLedgEntry."GST Amount";
            decIGSTPer := DtldGSTLedgEntry."GST %";
        end;
        txtdate := Format(SalesInvHdr."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
        JsonObjSalesInv.Add('PORefr', SalesInvHdr."External Document No.");
        JsonObjSalesInv.Add('SlNo', '10');
        JsonObjSalesInv.Add('Qty', fnRemovedecimals(Format(SalesInvLine.Quantity)));
        JsonObjSalesInv.Add('Inv_No', SalesInvHdr."No.");
        JsonObjSalesInv.Add('Inv_Dt', txtdate);
        JsonObjSalesInv.Add('UnitPrice', fnRemovedecimals(Format(SalesInvLine."Unit Price")));
        JsonObjSalesInv.Add('NetUnitPrice', fnRemovedecimals(Format(SalesInvLine."Unit Price")));
        JsonObjSalesInv.Add('TotAmt', fnRemovedecimals(Format(SalesInvLine."Line Amount")));
        JsonObjSalesInv.Add('AssAmt', fnRemovedecimals(Format(SalesInvLine."Line Amount")));
        JsonObjSalesInv.Add('SgstVal', fnRemovedecimals(Format(Abs(decSGSTAmt))));
        JsonObjSalesInv.Add('CgstVal', fnRemovedecimals(Format(Abs(decCGSTAmt))));
        JsonObjSalesInv.Add('IgstVal', fnRemovedecimals(Format(Abs(decIGSTAmt))));
        JsonObjSalesInv.Add('SGstRt', fnRemovedecimals(Format(decSGSTPer)));
        JsonObjSalesInv.Add('CGstRt', fnRemovedecimals(Format(decCGSTPer)));
        JsonObjSalesInv.Add('IGstRt', fnRemovedecimals(Format(decIGSTPer)));
        JsonObjSalesInv.Add('TotItemVal', fnRemovedecimals(Format(decInvoiceAmt)));
        if SalesInvHdr."Currency Code" = '' then
            JsonObjSalesInv.Add('ForCur', 'INR')
        else
            JsonObjSalesInv.Add('ForCur', SalesInvHdr."Currency Code");
        JsonObjSalesInv.Add('Sup_Gstin', recCompinfo."GST Registration No.");
        JsonObjSalesInv.Add('VehNo', SalesInvHdr."PS Vehicle No.");
        JsonObjSalesInv.Add('Part_Rev', 'A');
        JsonObjSalesInv.Add('Buy_Gstin', SalesInvHdr."Customer GST Reg. No.");
        JsonObjSalesInv.Add('Irn', SalesInvHdr."IRN Hash");
        JsonObjSalesInv.Add('file', '');

        JsonArrayData.Add(JsonObjSalesInv);
    end;

    procedure fnRemovedecimals(txtVal: Text) txtResult: Text
    var
        intCheck1: Integer;
        intCheck: Integer;
        intVal1: Integer;
        txtVal1: Text;
    begin
        Clear(intCheck);
        Clear(intCheck1);
        Clear(intVal1);
        Clear(txtVal1);
        intCheck := StrPos(txtVal, '.');
        if (intCheck = 0) then
            txtResult := txtVal
        else begin
            txtVal1 := CopyStr(txtVal, intCheck + 1, (StrLen(txtVal) - intCheck));
            Evaluate(intVal1, txtVal1);
            if (intVal1 = 0) then
                txtResult := CopyStr(txtVal, 1, intCheck - 1)
            else
                txtResult := txtVal;
        end;
        intCheck1 := StrPos(txtResult, ',');
        if (intCheck1 > 0) then txtResult := DelStr(txtResult, StrPos(txtResult, ','), 1);


        if txtVal in ['0', '0.00', '0.000', '0.0000'] then
            txtResult := '';
        exit(txtResult);
    end;

}
