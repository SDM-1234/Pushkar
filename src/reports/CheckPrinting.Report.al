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
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) where(Number = const(1));
            //RequestFilterFields = "Journal Template Name", "Document No.";
            column(Company_Name; CompanyInformation.Name)
            {
            }
            column(Pay_Name; RecGenJounLine.Description)
            {
            }
            column(Posting_Date; FORMAT(RecGenJounLine."Posting Date"))
            {
            }
            column(Document_No; RecGenJounLine."Document No.")
            {
            }
            column(Account_No; RecGenJounLine."Account No.")
            {
            }
            column(Description_Val; RecGenJounLine.Description)
            {
            }
            column(Debit_Amount; RecGenJounLine."Debit Amount")
            {
            }
            column(Credit_Amount; RecGenJounLine."Credit Amount")
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


                RecGenJounLine.RESET();
                RecGenJounLine.SETRANGE(RecGenJounLine."Journal Template Name", JnlTemplateName);
                RecGenJounLine.SETRANGE(RecGenJounLine."Journal Batch Name", JnlBatchName);
                RecGenJounLine.SETRANGE(RecGenJounLine."Document No.", DocumentNo);
                IF RecGenJounLine.FindFirst() THEN
                    repeat

                        IF TempDocumentNo <> RecGenJounLine."Document No." THEN BEGIN
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
                        TempDocumentNo := RecGenJounLine."Document No.";
                        IF PayName = '' THEN BEGIN
                            IF RecGenJounLine."Account Type" = RecGenJounLine."Account Type"::Vendor THEN
                                GetVendor.GET(RecGenJounLine."Account No.");
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


                        IF RecGenJounLine."Cheque No." <> '' THEN BEGIN
                            IF RecGenJounLine."Account Type" = RecGenJounLine."Account Type"::"Bank Account" THEN
                                if BankAccount.GET(RecGenJounLine."Account No.") then
                                    BankAccountNo := RecGenJounLine."Account No.";

                            IF RecGenJounLine."Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN
                                if BankAccount.GET(RecGenJounLine."Bal. Account No.") then
                                    BankAccountNo := RecGenJounLine."Bal. Account No.";


                            BankAccountName := BankAccount.Name;
                            CheckNo := RecGenJounLine."Cheque No.";
                            CheckDate := RecGenJounLine."Cheque Date";
                            BankAmount := ABS(RecGenJounLine.Amount);
                            CheckDateFormat := FORMAT(RecGenJounLine."Posting Date", 0, '<Day,2><Month,2><Year4>');
                            StoreDate[1] := COPYSTR(CheckDateFormat, 1, 1);
                            StoreDate[2] := COPYSTR(CheckDateFormat, 2, 1);
                            StoreDate[3] := COPYSTR(CheckDateFormat, 3, 1);
                            StoreDate[4] := COPYSTR(CheckDateFormat, 4, 1);
                            StoreDate[5] := COPYSTR(CheckDateFormat, 5, 1);
                            StoreDate[6] := COPYSTR(CheckDateFormat, 6, 1);
                            StoreDate[7] := COPYSTR(CheckDateFormat, 7, 1);
                            StoreDate[8] := COPYSTR(CheckDateFormat, 8, 1);
                        END;


                        If (RecGenJounLine."Bal. Account Type" = RecGenJounLine."Bal. Account Type"::"Bank Account") and (RecGenJounLine."Bal. Account No." <> '') then
                            TotalNetAmount := RecGenJounLine.Amount;


                        If (RecGenJounLine."Bal. Account No." = '') and (RecGenJounLine."Account Type" = RecGenJounLine."Account Type"::"Bank Account") then
                            TotalNetAmount := RecGenJounLine.Amount;


                        If RecGenJounLine."Credit Amount" <> 0 then
                            TotalNetAmount := TotalNetAmount * -1;

                        //Counter += 1;
                        //IF Counter > 1 THEN
                        //  TotalNetAmount := "Credit Amount";

                        //IF Counter = 1 THEN
                        //  TotalNetAmount := "Debit Amount";

                        ReportCheck.InitTextVariable();
                        ReportCheck.FormatNoText(TotalAmountInwords, TotalNetAmount, '');


                    until RecGenJounLine.Next() = 0;


            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Group)
                {
                    Caption = 'Filters';
                    field("Journal_Template_Name"; JnlTemplateName)
                    {
                        Caption = 'Journal Template Name';
                        ApplicationArea = All;
                        TableRelation = "Gen. Journal Template".Name;
                    }
                    field("Journal Batch Name"; JnlBatchName)
                    {
                        Caption = 'Journal Batch Name';
                        ApplicationArea = All;
                        TableRelation = "Gen. Journal Batch".Name;
                    }
                    field("Document No."; DocumentNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        //TableRelation = "Gen. Journal Line"."Document No.";
                    }
                }
            }
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
        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
        DocumentNo: Code[20];
        TotalNetAmount: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        Counter: Integer;
        BankAccountName: Text;
        CheckDateFormat: Text;
        PayName: Text;
        StoreDate: array[20] of Text;
        TotalAmountInwords: array[2] of Text[80];
        VarNarration: Text[200];
        VendInfo: array[10] of Text;
}

