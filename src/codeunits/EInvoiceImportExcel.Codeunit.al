namespace Pushkar.Pushkar;

using Microsoft.QRGeneration;
using Microsoft.Sales.History;
using System.IO;
using System.Utilities;

codeunit 50105 "E-Invoice Import Excel"
{

    Permissions =
        tabledata "Sales Invoice Header" = RM;
    trigger OnRun()
    begin

    end;

    procedure ImportExcel()
    var
        SalesInv: Record "Sales Invoice Header";
        FileMgt: Codeunit "File Management";
        QRGenerator: Codeunit "QR Generator";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        IStream: InStream;
        FileName, SheetName, FromFile : Text;
        RowNo, ColNo, LineNo, MaxRowNo : Integer;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess_Msg: Label 'E-Invoice Response Imported Successfully.';
    begin
        UploadIntoStream(UploadExcelMsg, '', 'Excel Files|*.xlsx', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();

        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;

        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            if SalesInv.get(GetValueAtCell(RowNo, 5)) then begin
                SalesInv.Validate("IRN Hash", GetValueAtCell(RowNo, 2));
                SalesInv.Validate("Acknowledgement No.", GetValueAtCell(RowNo, 3));
                Evaluate(SalesInv."Acknowledgement Date", GetValueAtCell(RowNo, 4));
                SalesInv.IsJSONImported := true;
                SalesInv.Modify();
                //Generate QR Code and update in Sales Invoice Header
                QRGenerator.GenerateQRCodeImage(GetValueAtCell(RowNo, 11), TempBlob);
                RecRef.Open(Database::"Sales Invoice Header");
                RecRef.GetBySystemId(SalesInv.SystemId);
                TempBlob.ToRecordRef(RecRef, SalesInv.FieldNo("QR Code"));
                RecRef.SetTable(SalesInv);
                RecRef.Close();
                SalesInv.Modify();
            End;
        end;
        TempExcelBuffer.DeleteAll();
        Message(ExcelImportSucess_Msg);
    End;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}

