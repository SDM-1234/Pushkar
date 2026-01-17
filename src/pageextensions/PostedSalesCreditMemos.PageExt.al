namespace Pushkar.Pushkar;

using Microsoft.Finance.GST.Sales;
using Microsoft.QRGeneration;
using Microsoft.Sales.History;
using System.Text;
using System.Utilities;

pageextension 50136 PostedSalesCreditMemos extends "Posted Sales Credit Memos"
{

    actions
    {

        addafter(Statistics)
        {

            fileuploadaction(BulkEInvoiceResponse)
            {
                ApplicationArea = All;
                Caption = 'Upload Bulk Import E-Invoice Response';
                ToolTip = 'Upload Bulk Import E-Invoice Response';
                AllowMultipleFiles = true;
                AllowedFileExtensions = '.json';
                Image = Import;
                trigger OnAction(Files: List of [FileUpload])
                var
                    SalesCrMemo: Record "Sales Cr.Memo Header";
                    eInvoiceJsonHandler: Codeunit "e-Invoice Json Handler";
                    JSONManagement: Codeunit "JSON Management";
                    TempBlob: Codeunit "Temp Blob";
                    QRGenerator: Codeunit "QR Generator";
                    RecRef: RecordRef;
                    FieldRef: FieldRef;
                    JsonString: Text;
                    TempIRNTxt: Text;
                    TempDateTime: DateTime;
                    AcknowledgementDateTimeText: Text;
                    AcknowledgementDate: Date;
                    AcknowledgementTime: Time;
                    CurrentFile: FileUpload;
                    TempInStream: InStream;
                    FileName: Text;
                    IRNTxt: Label 'Irn', Locked = true;
                    AcknowledgementNoTxt: Label 'AckNo', Locked = true;
                    AcknowledgementDateTxt: Label 'AckDt', Locked = true;
                    IRNHashErr: Label 'No matched IRN Hash %1 found to update.', Comment = '%1 = IRN Hash';
                    SignedQRCodeTxt: Label 'SignedQRCode', Locked = true;
                begin
                    foreach CurrentFile in Files do begin
                        FileName := CopyStr(ConvertStr(CurrentFile.FileName, '_', '/'), 1, StrLen(CurrentFile.FileName) - 4);
                        if SalesCrMemo.Get(FileName) then begin
                            CurrentFile.CreateInStream(TempInStream, TEXTENCODING::UTF8);
                            Clear(eInvoiceJsonHandler);
                            Clear(RecRef);
                            RecRef.GetTable(SalesCrMemo);
                            TempInStream.ReadText(JsonString);
                            if (JsonString = '') or (JsonString = '[]') then
                                exit;

                            JSONManagement.InitializeObject(JsonString);
                            if JSONManagement.GetValue(IRNTxt) <> '' then begin
                                FieldRef := RecRef.Field(SalesCrMemo.FieldNo("IRN Hash"));
                                FieldRef.Value := JSONManagement.GetValue(IRNTxt);
                                FieldRef := RecRef.Field(SalesCrMemo.FieldNo("Acknowledgement No."));
                                FieldRef.Value := JSONManagement.GetValue(AcknowledgementNoTxt);

                                AcknowledgementDateTimeText := JSONManagement.GetValue(AcknowledgementDateTxt);
                                Evaluate(AcknowledgementDate, CopyStr(AcknowledgementDateTimeText, 1, 10));
                                Evaluate(AcknowledgementTime, CopyStr(AcknowledgementDateTimeText, 11, 8));
                                TempDateTime := CreateDateTime(AcknowledgementDate, AcknowledgementTime);
                                FieldRef := RecRef.Field(SalesCrMemo.FieldNo("Acknowledgement Date"));

                                FieldRef.Value := TempDateTime;
                                FieldRef := RecRef.Field(SalesCrMemo.FieldNo(IsJSONImported));
                                FieldRef.Value := true;
                                QRGenerator.GenerateQRCodeImage(JSONManagement.GetValue(SignedQRCodeTxt), TempBlob);
                                FieldRef := RecRef.Field(SalesCrMemo.FieldNo("QR Code"));
                                TempBlob.ToRecordRef(RecRef, SalesCrMemo.FieldNo("QR Code"));
                                RecRef.Modify();
                            end else
                                Error(IRNHashErr, TempIRNTxt);
                            RecRef.Close();
                        end;
                    end;
                    CurrPage.Update();
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(BulkAttachment_Promoted; BulkEInvoiceResponse)
            {
            }
        }
    }
}
