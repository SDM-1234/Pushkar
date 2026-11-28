namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.Attachment;
using Microsoft.Sales.Receivables;
using System.IO;
using System.Utilities;

codeunit 50146 "Bank Receipt Advice Import"
{
    Permissions =
        tabledata "Cust. Ledger Entry" = RM,
        tabledata "Gen. Journal Line" = RM,
        tabledata "Document Attachment" = RIMD,
        tabledata "CSV Buffer" = RIMD;

    procedure ImportAndApply(var GenJournalLine: Record "Gen. Journal Line")
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        DocumentAttachment: Record "Document Attachment";
        TempCSVBuffer: Record "CSV Buffer" temporary;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        NormalizedCsvBlob: Codeunit "Temp Blob";
        InvoiceAmounts: Dictionary of [Text, Decimal];
        InvoiceNumbers: List of [Text];
        UploadedInStream: InStream;
        CsvInStream: InStream;
        CsvOutStream: OutStream;
        InvoiceNo: Text;
        FileName: Text;
        CustomerNo: Code[20];
        AppliesToID: Code[50];
        InvoiceAmount: Decimal;
        TotalPaymentAmount: Decimal;
    begin
        CheckJournalLine(GenJournalLine, CustomerNo);
        UploadPaymentAdvice(FileName, UploadedInStream);
        TempBlob.CreateOutStream(CsvOutStream);
        CopyStream(CsvOutStream, UploadedInStream);

        if IsExcelPaymentAdvice(FileName) then
            ReadExcelInvoiceAmounts(TempBlob, TempExcelBuffer, InvoiceAmounts)
        else begin
            NormalizeCsvLineBreaks(TempBlob, NormalizedCsvBlob);
            NormalizedCsvBlob.CreateInStream(CsvInStream);
            ReadInvoiceAmounts(CsvInStream, TempCSVBuffer, InvoiceAmounts);
        end;

        InvoiceNumbers := InvoiceAmounts.Keys();
        if InvoiceNumbers.Count() = 0 then
            Error(NoInvoicesFoundErr);

        foreach InvoiceNo in InvoiceNumbers do begin
            InvoiceAmounts.Get(InvoiceNo, InvoiceAmount);
            ValidateInvoice(CustomerLedgerEntry, CustomerNo, GenJournalLine, InvoiceNo, InvoiceAmount);
            TotalPaymentAmount := TotalPaymentAmount + InvoiceAmount;
        end;

        if TotalPaymentAmount <= 0 then
            Error(InvalidTotalAmountErr);

        AppliesToID := CopyStr(Format(CreateGuid()), 1, MaxStrLen(AppliesToID));
        SaveAttachment(DocumentAttachment, TempBlob, FileName, GenJournalLine);
        ApplyInvoices(CustomerLedgerEntry, GenJournalLine, InvoiceAmounts, InvoiceNumbers, CustomerNo, AppliesToID, TotalPaymentAmount);

        Message(ImportCompletedMsg, InvoiceNumbers.Count(), TotalPaymentAmount);
    end;

    local procedure CheckJournalLine(GenJournalLine: Record "Gen. Journal Line"; var CustomerNo: Code[20])
    begin
        if GenJournalLine."Account Type" <> GenJournalLine."Account Type"::Customer then
            Error(CustomerAccountRequiredErr);
        if GenJournalLine."Account No." = '' then
            Error(CustomerAccountRequiredErr);
        if GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Payment then
            Error(PaymentDocumentTypeRequiredErr);
        if GenJournalLine."Document No." = '' then
            Error(DocumentNoRequiredErr);
        if GenJournalLine."Applies-to ID" <> '' then
            Error(ExistingApplicationErr);
        if GenJournalLine."Applies-to Doc. No." <> '' then
            Error(ExistingApplicationErr);

        CustomerNo := GenJournalLine."Account No.";
    end;

    local procedure UploadPaymentAdvice(var FileName: Text; var UploadedInStream: InStream)
    var
        UploadPromptLbl: Label 'Select the payment-advice CSV file.';
        FileFilterLbl: Label 'Excel or CSV files (*.xlsx;*.csv)|*.xlsx;*.csv';
    begin
        UploadIntoStream(UploadPromptLbl, '', FileFilterLbl, FileName, UploadedInStream);
        if FileName = '' then
            Error(UploadCancelledErr);
        if not IsExcelPaymentAdvice(FileName) and not IsCsvPaymentAdvice(FileName) then
            Error(SupportedFileRequiredErr);
    end;

    local procedure IsExcelPaymentAdvice(FileName: Text): Boolean
    begin
        exit((StrLen(FileName) >= 5) and (CopyStr(LowerCase(FileName), StrLen(FileName) - 4, 5) = '.xlsx'));
    end;

    local procedure IsCsvPaymentAdvice(FileName: Text): Boolean
    begin
        exit((StrLen(FileName) >= 4) and (CopyStr(LowerCase(FileName), StrLen(FileName) - 3, 4) = '.csv'));
    end;

    local procedure ReadExcelInvoiceAmounts(var SourceBlob: Codeunit "Temp Blob"; var TempExcelBuffer: Record "Excel Buffer" temporary; var InvoiceAmounts: Dictionary of [Text, Decimal])
    var
        ExcelInStream: InStream;
        SheetName: Text;
        MaxRowNo: Integer;
        MaxColumnNo: Integer;
        HeaderRowNo: Integer;
        InvoiceColumnNo: Integer;
        AmountColumnNo: Integer;
        RowNo: Integer;
        ColumnNo: Integer;
        InvoiceNo: Text;
        AmountText: Text;
        InvoiceAmount: Decimal;
        TotalAmountForInvoice: Decimal;
    begin
        SourceBlob.CreateInStream(ExcelInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);
        if SheetName = '' then
            Error(UploadCancelledErr);

        SourceBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindSet() then
            repeat
                if TempExcelBuffer."Row No." > MaxRowNo then
                    MaxRowNo := TempExcelBuffer."Row No.";
                if TempExcelBuffer."Column No." > MaxColumnNo then
                    MaxColumnNo := TempExcelBuffer."Column No.";
            until TempExcelBuffer.Next() = 0;

        for RowNo := 1 to MaxRowNo do begin
            InvoiceColumnNo := 0;
            AmountColumnNo := 0;
            for ColumnNo := 1 to MaxColumnNo do begin
                AmountText := NormalizeHeader(GetExcelCellValue(TempExcelBuffer, RowNo, ColumnNo));
                if IsInvoiceNumberHeader(AmountText) then
                    InvoiceColumnNo := ColumnNo
                else
                    if IsInvoiceAmountHeader(AmountText) then
                        AmountColumnNo := ColumnNo;
            end;

            if (InvoiceColumnNo > 0) and (AmountColumnNo > 0) then begin
                HeaderRowNo := RowNo;
                break;
            end;
        end;

        if HeaderRowNo = 0 then
            Error(CsvHeadersRequiredErr);

        for RowNo := HeaderRowNo + 1 to MaxRowNo do begin
            InvoiceNo := NormalizeInvoiceNo(GetExcelCellValue(TempExcelBuffer, RowNo, InvoiceColumnNo));
            if InvoiceNo = '' then
                continue;
            if StrLen(InvoiceNo) > 20 then
                Error(InvoiceNoTooLongErr, InvoiceNo);

            AmountText := GetExcelCellValue(TempExcelBuffer, RowNo, AmountColumnNo);
            if AmountText = '' then
                Error(InvoiceAmountMissingErr, InvoiceNo);
            InvoiceAmount := ParseInvoiceAmount(AmountText);
            if InvoiceAmounts.ContainsKey(InvoiceNo) then begin
                InvoiceAmounts.Get(InvoiceNo, TotalAmountForInvoice);
                InvoiceAmounts.Remove(InvoiceNo);
                InvoiceAmount += TotalAmountForInvoice;
            end;
            if InvoiceAmount <> 0 then
                InvoiceAmounts.Add(InvoiceNo, InvoiceAmount);
        end;

        TempExcelBuffer.DeleteAll();
        if InvoiceAmounts.Count() = 0 then
            Error(NoInvoiceRowsErr);
    end;

    local procedure GetExcelCellValue(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColumnNo: Integer): Text
    begin
        if TempExcelBuffer.Get(RowNo, ColumnNo) then
            exit(TempExcelBuffer."Cell Value as Text");
        exit('');
    end;

    local procedure ReadInvoiceAmounts(CsvInStream: InStream; var TempCSVBuffer: Record "CSV Buffer" temporary; var InvoiceAmounts: Dictionary of [Text, Decimal])
    var
        InvoiceColumn: Integer;
        AmountColumn: Integer;
        HeaderLine: Integer;
        LineNo: Integer;
        InvoiceNo: Text;
        AmountText: Text;
        InvoiceAmount: Decimal;
        TotalAmountForInvoice: Decimal;
    begin
        TempCSVBuffer.LoadDataFromStream(CsvInStream, ',');
        if TempCSVBuffer.GetNumberOfLines() < 2 then
            Error(CsvNoDataErr);

        FindInvoiceColumns(TempCSVBuffer, InvoiceColumn, AmountColumn, HeaderLine);
        if (HeaderLine = 0) then
            Error(CsvHeadersRequiredErr);

        for LineNo := HeaderLine + 1 to TempCSVBuffer.GetNumberOfLines() do begin
            InvoiceNo := NormalizeInvoiceNo(TempCSVBuffer.GetValue(LineNo, InvoiceColumn));
            if InvoiceNo = '' then
                continue;
            if IsInvoiceNumberHeader(NormalizeHeader(InvoiceNo)) then
                continue;
            if StrLen(InvoiceNo) > 20 then
                Error(InvoiceNoTooLongErr, InvoiceNo);

            AmountText := TempCSVBuffer.GetValue(LineNo, AmountColumn);
            if AmountText = '' then
                Error(InvoiceAmountMissingErr, InvoiceNo);
            InvoiceAmount := ParseInvoiceAmount(AmountText);
            if InvoiceAmounts.ContainsKey(InvoiceNo) then begin
                InvoiceAmounts.Get(InvoiceNo, TotalAmountForInvoice);
                InvoiceAmounts.Remove(InvoiceNo);
                InvoiceAmount += TotalAmountForInvoice;
            end;
            if InvoiceAmount <> 0 then
                InvoiceAmounts.Add(InvoiceNo, InvoiceAmount);
        end;

        if InvoiceAmounts.Count() = 0 then
            Error(NoInvoiceRowsErr);
    end;

    local procedure FindInvoiceColumns(var TempCSVBuffer: Record "CSV Buffer" temporary; var InvoiceColumn: Integer; var AmountColumn: Integer; var HeaderLine: Integer)
    var
        HeaderText: Text;
        LineNo: Integer;
    begin
        for LineNo := 1 to TempCSVBuffer.GetNumberOfLines() do begin
            InvoiceColumn := 0;
            AmountColumn := 0;
            TempCSVBuffer.Reset();
            TempCSVBuffer.SetRange("Line No.", LineNo);
            if TempCSVBuffer.FindSet() then
                repeat
                    HeaderText := NormalizeHeader(TempCSVBuffer.Value);
                    if IsInvoiceNumberHeader(HeaderText) then
                        InvoiceColumn := TempCSVBuffer."Field No."
                    else
                        if IsInvoiceAmountHeader(HeaderText) then
                            AmountColumn := TempCSVBuffer."Field No.";
                until TempCSVBuffer.Next() = 0;

            if (InvoiceColumn > 0) and (AmountColumn > 0) then begin
                HeaderLine := LineNo;
                exit;
            end;
        end;
    end;

    local procedure IsInvoiceNumberHeader(NormalizedHeader: Text): Boolean
    begin
        exit((NormalizedHeader = 'invoiceno') or
             (NormalizedHeader = 'invoicenumber') or
             (NormalizedHeader = 'invoiceref') or
             (NormalizedHeader = 'invno') or
             (NormalizedHeader = 'invnumber') or
             (NormalizedHeader = 'invref'));
    end;

    local procedure IsInvoiceAmountHeader(NormalizedHeader: Text): Boolean
    begin
        exit((NormalizedHeader = 'invoiceamount') or
             (NormalizedHeader = 'invoiceamountrs') or
             (NormalizedHeader = 'invoiceamountinr') or
             (NormalizedHeader = 'invamount') or
             (NormalizedHeader = 'invamtrs') or
             (NormalizedHeader = 'invamountinr') or
             (NormalizedHeader = 'invamt') or
             (NormalizedHeader = 'invoicevalue'));
    end;

    local procedure NormalizeHeader(HeaderText: Text): Text
    var
        NormalizedHeader: Text;
        Character: Text;
        Index: Integer;
    begin
        for Index := 1 to StrLen(HeaderText) do begin
            Character := LowerCase(CopyStr(HeaderText, Index, 1));
            if ((Character >= 'a') and (Character <= 'z')) or
               ((Character >= '0') and (Character <= '9'))
            then
                NormalizedHeader := NormalizedHeader + Character;
        end;

        exit(NormalizedHeader);
    end;

    local procedure NormalizeInvoiceNo(InvoiceText: Text): Text
    begin
        exit(UpperCase(DelChr(InvoiceText, '<>', ' ')));
    end;

    local procedure ParseInvoiceAmount(AmountText: Text): Decimal
    var
        NormalizedAmount: Text;
        Character: Text;
        Amount: Decimal;
        IsNegative: Boolean;
        DecimalSeparatorPosition: Integer;
        Index: Integer;
        DigitsAfterSeparator: Integer;
    begin
        IsNegative := StrPos(AmountText, '-') > 0;
        for Index := 1 to StrLen(AmountText) do begin
            Character := CopyStr(AmountText, Index, 1);
            if (Character >= '0') and (Character <= '9') then
                NormalizedAmount := NormalizedAmount + Character
            else
                if (Character = '.') or (Character = ',') then
                    DecimalSeparatorPosition := Index;
        end;

        if DecimalSeparatorPosition > 0 then begin
            DigitsAfterSeparator := 0;
            for Index := DecimalSeparatorPosition + 1 to StrLen(AmountText) do begin
                Character := CopyStr(AmountText, Index, 1);
                if (Character >= '0') and (Character <= '9') then
                    DigitsAfterSeparator := DigitsAfterSeparator + 1
                else
                    if (Character = '.') or (Character = ',') then
                        DigitsAfterSeparator := 0;
            end;
            if DigitsAfterSeparator in [1, 2] then
                NormalizedAmount := NormalizeDecimalSeparators(AmountText, DecimalSeparatorPosition)
            else
                NormalizedAmount := KeepAmountDigits(AmountText);
        end else
            NormalizedAmount := KeepAmountDigits(AmountText);

        if (NormalizedAmount = '') or not Evaluate(Amount, NormalizedAmount, 9) then
            Error(InvalidInvoiceAmountErr, AmountText);
        if IsNegative then
            Amount := -Amount;
        if Amount = 0 then
            Error(InvalidInvoiceAmountErr, AmountText);
        exit(Amount);
    end;

    local procedure NormalizeDecimalSeparators(AmountText: Text; DecimalSeparatorPosition: Integer): Text
    var
        NormalizedAmount: Text;
        Character: Text;
        Index: Integer;
    begin
        for Index := 1 to StrLen(AmountText) do begin
            Character := CopyStr(AmountText, Index, 1);
            if (Character >= '0') and (Character <= '9') then
                NormalizedAmount := NormalizedAmount + Character
            else
                if Index = DecimalSeparatorPosition then
                    NormalizedAmount := NormalizedAmount + '.';
        end;
        exit(NormalizedAmount);
    end;

    local procedure KeepAmountDigits(AmountText: Text): Text
    var
        NormalizedAmount: Text;
        Character: Text;
        Index: Integer;
    begin
        for Index := 1 to StrLen(AmountText) do begin
            Character := CopyStr(AmountText, Index, 1);
            if (Character >= '0') and (Character <= '9') then
                NormalizedAmount := NormalizedAmount + Character;
        end;
        exit(NormalizedAmount);
    end;

    local procedure ValidateInvoice(var CustomerLedgerEntry: Record "Cust. Ledger Entry"; CustomerNo: Code[20]; GenJournalLine: Record "Gen. Journal Line"; InvoiceNo: Text; InvoiceAmount: Decimal)
    begin
        CustomerLedgerEntry.Reset();
        CustomerLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustomerLedgerEntry.SetRange("Document No.", CopyStr(InvoiceNo, 1, MaxStrLen(CustomerLedgerEntry."Document No.")));
        if InvoiceAmount < 0 then
            CustomerLedgerEntry.SetRange("Document Type", CustomerLedgerEntry."Document Type"::"Credit Memo")
        else
            CustomerLedgerEntry.SetRange("Document Type", CustomerLedgerEntry."Document Type"::Invoice);
        CustomerLedgerEntry.SetRange(Open, true);
        if CustomerLedgerEntry.Count() = 0 then
            Error(InvoiceNotFoundErr, InvoiceNo, CustomerNo);
        if CustomerLedgerEntry.Count() > 1 then
            Error(InvoiceAmbiguousErr, InvoiceNo, CustomerNo);
        CustomerLedgerEntry.FindFirst();

        CustomerLedgerEntry.CalcFields("Remaining Amount");
        if CustomerLedgerEntry."Applies-to ID" <> '' then
            Error(InvoiceAlreadyAppliedErr, InvoiceNo);
        if CustomerLedgerEntry."Amount to Apply" <> 0 then
            Error(InvoiceAlreadyAppliedErr, InvoiceNo);
        if CustomerLedgerEntry."Currency Code" <> GenJournalLine."Currency Code" then
            Error(InvoiceCurrencyMismatchErr, InvoiceNo);
        if (InvoiceAmount * CustomerLedgerEntry."Remaining Amount" <= 0) or
           (Abs(InvoiceAmount) > Abs(CustomerLedgerEntry."Remaining Amount"))
        then
            Error(InvoiceAmountExceedsBalanceErr, InvoiceNo, InvoiceAmount, CustomerLedgerEntry."Remaining Amount");
    end;

    local procedure SaveAttachment(var DocumentAttachment: Record "Document Attachment"; var TempBlob: Codeunit "Temp Blob"; FileName: Text; GenJournalLine: Record "Gen. Journal Line")
    var
        FileManagement: Codeunit "File Management";
        AttachmentInStream: InStream;
    begin
        TempBlob.CreateInStream(AttachmentInStream);
        DocumentAttachment.Init();
        DocumentAttachment."Table ID" := Database::"Gen. Journal Line";
        DocumentAttachment."No." := GenJournalLine."Document No.";
        DocumentAttachment."Line No." := GenJournalLine."Line No.";
        DocumentAttachment."File Name" := CopyStr(FileManagement.GetFileName(FileName), 1, MaxStrLen(DocumentAttachment."File Name"));
        if IsExcelPaymentAdvice(FileName) then
            DocumentAttachment."File Extension" := 'xlsx'
        else
            DocumentAttachment."File Extension" := 'csv';
        DocumentAttachment."Document Reference ID".ImportStream(AttachmentInStream, FileName);
        DocumentAttachment.Insert(true);
    end;

    local procedure NormalizeCsvLineBreaks(var SourceBlob: Codeunit "Temp Blob"; var NormalizedCsvBlob: Codeunit "Temp Blob")
    var
        SourceInStream: InStream;
        NormalizedOutStream: OutStream;
        LineText: Text;
        CurrentRecord: Text;
        InQuotes: Boolean;
        Index: Integer;
    begin
        SourceBlob.CreateInStream(SourceInStream);
        NormalizedCsvBlob.CreateOutStream(NormalizedOutStream);
        while not SourceInStream.EOS do begin
            SourceInStream.ReadText(LineText);
            if CurrentRecord <> '' then
                CurrentRecord += ' ';
            CurrentRecord += LineText;

            Index := 1;
            while Index <= StrLen(LineText) do begin
                if CopyStr(LineText, Index, 1) = '"' then
                    if InQuotes and (Index < StrLen(LineText)) and (CopyStr(LineText, Index + 1, 1) = '"') then
                        Index += 1
                    else
                        InQuotes := not InQuotes;
                Index += 1;
            end;

            if not InQuotes then begin
                NormalizedOutStream.WriteText(CurrentRecord);
                NormalizedOutStream.WriteText();
                CurrentRecord := '';
            end;
        end;

        if CurrentRecord <> '' then begin
            if InQuotes then
                Error(MalformedCsvErr);
            NormalizedOutStream.WriteText(CurrentRecord);
        end;
    end;

    local procedure ApplyInvoices(var CustomerLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; InvoiceAmounts: Dictionary of [Text, Decimal]; InvoiceNumbers: List of [Text]; CustomerNo: Code[20]; AppliesToID: Code[50]; TotalPaymentAmount: Decimal)
    var
        InvoiceNo: Text;
        InvoiceAmount: Decimal;
    begin
        foreach InvoiceNo in InvoiceNumbers do begin
            InvoiceAmounts.Get(InvoiceNo, InvoiceAmount);
            CustomerLedgerEntry.Reset();
            CustomerLedgerEntry.SetRange("Customer No.", CustomerNo);
            CustomerLedgerEntry.SetRange("Document No.", CopyStr(InvoiceNo, 1, MaxStrLen(CustomerLedgerEntry."Document No.")));
            if InvoiceAmount < 0 then
                CustomerLedgerEntry.SetRange("Document Type", CustomerLedgerEntry."Document Type"::"Credit Memo")
            else
                CustomerLedgerEntry.SetRange("Document Type", CustomerLedgerEntry."Document Type"::Invoice);
            CustomerLedgerEntry.SetRange(Open, true);
            CustomerLedgerEntry.FindFirst();
            CustomerLedgerEntry.Validate("Applies-to ID", AppliesToID);
            CustomerLedgerEntry.Validate("Amount to Apply", InvoiceAmount);
            CustomerLedgerEntry.Modify(true);
        end;

        GenJournalLine.Validate("Applies-to ID", AppliesToID);
        GenJournalLine.Validate(Amount, -TotalPaymentAmount);
        GenJournalLine.Modify(true);
    end;

    var
        UploadCancelledErr: Label 'No payment-advice file was selected.';
        SupportedFileRequiredErr: Label 'Select an Excel workbook (.xlsx) or CSV file.';
        CsvNoDataErr: Label 'The file must contain an invoice table header and at least one invoice row.';
        CsvHeadersRequiredErr: Label 'The selected sheet or CSV file must contain an invoice table with an Invoice Number and an Invoice Amount column, such as Invoice Amount (Rs.).';
        CustomerAccountRequiredErr: Label 'Select a customer in Account Type and Account No. before importing a payment advice.';
        PaymentDocumentTypeRequiredErr: Label 'The Bank Receipt Voucher line must have Document Type Payment.';
        DocumentNoRequiredErr: Label 'Enter the receipt Document No. before importing a payment advice.';
        ExistingApplicationErr: Label 'Clear the existing application on this journal line before importing a payment advice.';
        MalformedCsvErr: Label 'The CSV file contains an unterminated quoted field.';
        InvoiceNoTooLongErr: Label 'Invoice number %1 is longer than the Business Central document number field.', Comment = '%1 = invoice number';
        InvoiceAmountMissingErr: Label 'No invoice amount was found for invoice %1.', Comment = '%1 = invoice number';
        InvalidInvoiceAmountErr: Label 'The invoice amount "%1" could not be read as a valid non-zero amount.', Comment = '%1 = amount text from the CSV table';
        NoInvoiceRowsErr: Label 'The CSV file contains no invoice rows with invoice numbers and amounts.';
        NoInvoicesFoundErr: Label 'No invoice amounts were read from the CSV file.';
        InvoiceNotFoundErr: Label 'Payment-advice document %1 is not an open invoice or credit memo for customer %2.', Comment = '%1 = document number, %2 = customer number';
        InvoiceAmbiguousErr: Label 'More than one open matching entry for document %1 was found for customer %2.', Comment = '%1 = document number, %2 = customer number';
        InvoiceAlreadyAppliedErr: Label 'Invoice %1 already has an application ID. Clear it before importing the advice.', Comment = '%1 = invoice number';
        InvoiceCurrencyMismatchErr: Label 'Invoice %1 has a different currency from the receipt line.', Comment = '%1 = invoice number';
        InvoiceAmountExceedsBalanceErr: Label 'The amount %2 for invoice %1 exceeds its remaining amount %3.', Comment = '%1 = invoice number, %2 = requested amount, %3 = remaining invoice amount';
        InvalidTotalAmountErr: Label 'The total payment amount from the CSV file must be greater than zero.';
        ImportCompletedMsg: Label 'Applied %1 invoice/credit memo entry(s) and updated the receipt amount to %2. Review the journal line before posting.', Comment = '%1 = number of entries applied, %2 = total receipt amount';
}
