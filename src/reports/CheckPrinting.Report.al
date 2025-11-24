/// <summary>
/// Report Check Printing (ID 50077).
/// </summary>
report 50106 "Check Printing"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/Cheque.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Check Printing';


    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Document No.");
            RequestFilterFields = "Journal Template Name", "Document No.";
            column(Company_Name; CompanyInformation.Name)
            {
            }
            column(Pay_Name; "Gen. Journal Line".Description)
            {
            }
            column(Posting_Date; FORMAT("Gen. Journal Line"."Posting Date"))
            {
            }
            column(Document_No; "Gen. Journal Line"."Document No.")
            {
            }
            column(Account_No; "Gen. Journal Line"."Account No.")
            {
            }
            column(Description_Val; "Gen. Journal Line".Description)
            {
            }
            column(Debit_Amount; "Gen. Journal Line"."Debit Amount")
            {
            }
            column(Credit_Amount; "Gen. Journal Line"."Credit Amount")
            {
            }
            column(Narrations_Val; VarNarration)
            {
            }
            column(BankAccount_No; BankAccountNo)
            {
            }
            column(BankAccount_Name; BankAccountName)
            {
            }
            column(Check_No; CheckNo)
            {
            }
            column(Check_Date; FORMAT(CheckDate))
            {
            }
            column(Bank_Amount; BankAmount)
            {
            }
            column(TotalAmountInwords_1; TotalAmountInwords[1])
            {
            }
            column(TotalAmountInwords_2; TotalAmountInwords[2])
            {
            }
            column(TotalNet_Amount; TotalNetAmount)
            {
            }
            column(StoreDate_1; StoreDate[1])
            {
            }
            column(StoreDate_2; StoreDate[2])
            {
            }
            column(StoreDate_3; StoreDate[3])
            {
            }
            column(StoreDate_4; StoreDate[4])
            {
            }
            column(StoreDate_5; StoreDate[5])
            {
            }
            column(StoreDate_6; StoreDate[6])
            {
            }
            column(StoreDate_7; StoreDate[7])
            {
            }
            column(StoreDate_8; StoreDate[8])
            {
            }
            column(VendInfo_1; VendInfo[1])
            {
            }
            column(VendInfo_2; VendInfo[2])
            {
            }
            column(VendInfo_4; VendInfo[4])
            {
            }
            column(VendInfo_3; VendInfo[3])
            {
            }
            column(VendInfo_5; VendInfo[5])
            {
            }

            trigger OnPreDataItem()
            begin
                Counter := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                IF TempDocumentNo <> "Document No." THEN BEGIN
                    PayName := '';
                    BankAccountNo := '';
                    BankAccountName := '';
                    CheckNo := '';
                    CheckDate := 0D;
                    BankAmount := 0;
                    TotalNetAmount := 0;
                    CheckDateFormat := '';
                    CLEAR(StoreDate);
                    CLEAR(VendInfo);
                END;
                TempDocumentNo := "Document No.";
                IF PayName = '' THEN BEGIN
                    IF "Account Type" = "Account Type"::Vendor THEN
                        GetVendor.GET("Account No.");
                    //PayName := "Payee Name";
                    VendInfo[1] := GetVendor.Address;
                    VendInfo[2] := GetVendor."Address 2" + ',';
                    VendInfo[3] := GetVendor.City + '-' + GetVendor."Post Code" + ',';
                    IF RecState.GET(GetVendor."State Code") THEN
                        VendInfo[4] := RecState.Description + ',';
                    IF CountryRegion.GET(GetVendor."Country/Region Code") THEN
                        VendInfo[5] := CountryRegion.Name;
                    //IF "Account Type" = "Account Type"::"G/L Account" THEN
                    // PayName := "Payee Name";
                END;


                IF "Cheque No." <> '' THEN BEGIN
                    IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                        BankAccount.GET("Account No.");
                        BankAccountNo := "Account No.";
                    END;
                    IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccount.GET("Bal. Account No.");
                        BankAccountNo := "Bal. Account No.";
                    END;

                    BankAccountName := BankAccount.Name;
                    CheckNo := "Cheque No.";
                    CheckDate := "Cheque Date";
                    BankAmount := ABS(Amount);
                    CheckDateFormat := FORMAT("Posting Date", 0, '<Day,2><Month,2><Year4>');
                    StoreDate[1] := COPYSTR(CheckDateFormat, 1, 1);
                    StoreDate[2] := COPYSTR(CheckDateFormat, 2, 1);
                    StoreDate[3] := COPYSTR(CheckDateFormat, 3, 1);
                    StoreDate[4] := COPYSTR(CheckDateFormat, 4, 1);
                    StoreDate[5] := COPYSTR(CheckDateFormat, 5, 1);
                    StoreDate[6] := COPYSTR(CheckDateFormat, 6, 1);
                    StoreDate[7] := COPYSTR(CheckDateFormat, 7, 1);
                    StoreDate[8] := COPYSTR(CheckDateFormat, 8, 1);
                END;


                If ("Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"Bank Account") and ("Gen. Journal Line"."Bal. Account No." <> '') then
                    TotalNetAmount := "Gen. Journal Line".Amount;


                If ("Gen. Journal Line"."Bal. Account No." = '') and ("Gen. Journal Line"."Account Type" = "Account Type"::"Bank Account") then
                    TotalNetAmount := "Gen. Journal Line".Amount;


                //Counter += 1;
                //IF Counter > 1 THEN
                //  TotalNetAmount := "Credit Amount";

                //IF Counter = 1 THEN
                //  TotalNetAmount := "Debit Amount";




                RecGenJounLine.RESET();
                RecGenJounLine.SETRANGE(RecGenJounLine."Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                RecGenJounLine.SETRANGE(RecGenJounLine."Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                RecGenJounLine.SETRANGE(RecGenJounLine."Document No.", "Gen. Journal Line"."Document No.");
                IF RecGenJounLine.FINDLAST() THEN
                    //VarNarration := RecGenJounLine.Narration;
                ReportCheck.InitTextVariable();

                If TotalNetAmount < 0 then
                    ReportCheck.FormatNoText(TotalAmountInwords, TotalNetAmount * -1, '')
                else
                    ReportCheck.FormatNoText(TotalAmountInwords, TotalNetAmount, '');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET();
    end;

    var
        BankAccount: Record "Bank Account";
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        GetVendor: Record Vendor;
        RecGenJounLine: Record "Gen. Journal Line";
        RecState: Record State;
        ReportCheck: Codeunit AmountToWords;
        BankAccountNo: Code[20];
        CheckNo: Code[10];
        TempDocumentNo: Code[20];
        CheckDate: Date;
        BankAmount: Decimal;
        TotalNetAmount: Decimal;
        Counter: Integer;
        BankAccountName: Text;
        CheckDateFormat: Text;
        PayName: Text;
        StoreDate: array[20] of Text;
        TotalAmountInwords: array[2] of Text[80];
        VarNarration: Text[200];
        VendInfo: array[10] of Text;
}

