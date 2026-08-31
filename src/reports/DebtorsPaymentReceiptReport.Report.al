report 50112 "Debtors Payment Receipt Report"
{
    Caption = 'Debtors Received Payment Details';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    DefaultRenderingLayout = RDLC;

    //RDLCLayout = 'src/ReportLayouts/DebtorsPaymentReceiptReport.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.")
                where(Blocked = filter(" "));

            RequestFilterFields = "No.", "Date Filter";

            column(CustomerNo; "No.")
            {
            }

            column(CustomerName; Name)
            {
            }

            column(DateFilter; DateFilterText)
            {
            }

            column(StartDate; StartDate)
            {
            }

            column(EndDate; EndDate)
            {
            }

            column(CustomerBillTotal; CustomerBillTotal)
            {
            }

            column(CustomerReceiptTotal; CustomerReceiptTotal)
            {
            }

            dataitem(CustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink =
                    "Customer No." = field("No."),
                    "Posting Date" = field("Date Filter");

                DataItemTableView = sorting(
                        "Customer No.",
                        "Posting Date",
                        "Currency Code")
                    where(
                        "Source Code" = filter('BANKRCPTV|GENJNL|SALES'),
                        Reversed = const(false));

                column(CLEEntryNo; "Entry No.")
                {
                }

                column(ReceiptDocumentNo; "Document No.")
                {
                }

                column(BankAccountNo; BankAccountNo)
                {
                }

                column(BankName; BankName)
                {
                }

                column(BankAccountDisplay; BankAccountDisplay)
                {
                }

                column(ChequeNo; ChequeNo)
                {
                }

                column(BankAmount; BankAmount)
                {
                }

                dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink =
                        "Applied Cust. Ledger Entry No." =
                        field("Entry No.");

                    DataItemTableView = sorting(
                            "Applied Cust. Ledger Entry No.",
                            "Entry Type")
                        where(
                            "Entry Type" = filter(<> "Initial Entry"),
                            "Source Code" = filter(
                                'BANKRCPTV|SALESAPPL|GENJNL'),
                            Unapplied = const(false),
                            "Applied Cust. Ledger Entry No." = filter(> 0),
                            "Initial Document Type" =
                                filter(Invoice | "Credit Memo"));

                    column(DetailedEntryNo; "Entry No.")
                    {
                    }

                    column(ReceiptPostingDate; "Posting Date")
                    {
                    }

                    column(BillDocumentNo; BillDocumentNo)
                    {
                    }

                    column(BillPostingDate; BillPostingDate)
                    {
                    }

                    column(BillAmount; BillAmount)
                    {
                    }

                    column(ReceiptAmount; ReceiptAmount)
                    {
                    }

                    column(RemainingAmount; BillAmount - ReceiptAmount)
                    {
                    }

                    column(InitialDocumentType; "Initial Document Type")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GetBillInformation();
                        CalculateReceiptAmount();

                        CustomerBillTotal += BillAmount;
                        CustomerReceiptTotal += ReceiptAmount;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GetBankInformation();

                    CalcFields(Amount);
                    BankAmount := Amount;
                end;
            }

            trigger OnPreDataItem()
            begin
                DateFilterText := GetFilter("Date Filter");

                if DateFilterText = '' then
                    Error(DateFilterRequiredErr);

                StartDate := GetRangeMin("Date Filter");
                EndDate := GetRangeMax("Date Filter");
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CustomerBillTotal);
                Clear(CustomerReceiptTotal);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = All;
                        Caption = 'Print To Excel';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(RDLC)
        {
            Type = RDLC;
            LayoutFile = 'src/ReportLayouts/DebtorsPaymentReceiptReport.rdl';
            Caption = 'Debtors Payment Receipt - RDLC';
            Summary = 'Debtors payment receipt report';
        }

        layout(Excel)
        {
            Type = Excel;
            LayoutFile = 'src/ReportLayouts/DebtorsPaymentReceiptReport.xlsx';
            Caption = 'Debtors Payment Receipt - Excel';
            Summary = 'Debtors payment receipt Excel report';
        }
    }

    labels
    {
        ReportTitleLbl =
            'Debtors Received Payment Details';

        ReportPeriodLbl =
            'Report Between :-';

        PartyNoLbl =
            'Party No. :-';

        PartyNameLbl =
            'Party Name :-';

        ReceiptVoucherLbl =
            'Receipt Voucher No./Sale Inv No.';

        BankAccountBillDateLbl =
            'Bank Account No./Bill Date';

        BillAmountLbl =
            'Bill Amount';

        BankAmountLbl =
            'Bank Amount';

        ReceiptDateHundiLbl =
            'Receipt Date/Hundi No.';

        ReceiptAmountLbl =
            'Receipt Amount';

        RemainingAmountLbl =
            'Remaining Amount';

        SubtotalLbl =
            'Subtotal :-';
    }

    var
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccount: Record "Bank Account";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";

        DateFilterText: Text;
        StartDate: Date;
        EndDate: Date;

        BankAccountNo: Code[20];
        BankName: Text[100];
        BankAccountDisplay: Text[150];
        ChequeNo: Code[100];

        BankAmount: Decimal;

        BillDocumentNo: Code[20];
        BillPostingDate: Date;
        BillAmount: Decimal;
        ReceiptAmount: Decimal;

        CustomerBillTotal: Decimal;
        CustomerReceiptTotal: Decimal;

        PrintToExcel: Boolean;

        DateFilterRequiredErr: Label
            'Please enter the Date. It cannot be empty.';

    local procedure GetBankInformation()
    begin
        Clear(BankAccountNo);
        Clear(BankName);
        Clear(BankAccountDisplay);
        Clear(ChequeNo);

        BankLedgerEntry.Reset();
        BankLedgerEntry.SetRange(
            "Document No.",
            CustLedgerEntry."Document No.");

        if BankLedgerEntry.FindSet() then
            repeat
                BankAccountNo :=
                    BankLedgerEntry."Bank Account No.";

                ChequeNo :=
                    BankLedgerEntry."Cheque No.";

                BankAccount.Reset();
                BankAccount.SetRange(
                    "No.",
                    BankLedgerEntry."Bank Account No.");

                if BankAccount.FindFirst() then
                    BankName := BankAccount.Name;

            until BankLedgerEntry.Next() = 0;

        if BankAccountNo <> '' then
            BankAccountDisplay :=
                BankAccountNo + ' - ' + BankName;
    end;

    local procedure GetBillInformation()
    begin
        Clear(BillDocumentNo);
        Clear(BillPostingDate);
        Clear(BillAmount);

        CustLedgerEntry2.Reset();
        CustLedgerEntry2.SetRange(
            "Entry No.",
            DetailedCustLedgEntry."Cust. Ledger Entry No.");

        CustLedgerEntry2.SetFilter(
            "Document Type",
            '%1|%2',
            CustLedgerEntry2."Document Type"::Invoice,
            CustLedgerEntry2."Document Type"::"Credit Memo");

        if CustLedgerEntry2.FindSet() then
            repeat
                CustLedgerEntry2.CalcFields(Amount);

                BillAmount := CustLedgerEntry2.Amount;
                BillDocumentNo := CustLedgerEntry2."Document No.";
                BillPostingDate := CustLedgerEntry2."Posting Date";

                SalesInvoiceHeader.Reset();
                SalesInvoiceHeader.SetRange(
                    "No.",
                    CustLedgerEntry2."Document No.");

                if SalesInvoiceHeader.FindFirst() then begin
                    BillDocumentNo := SalesInvoiceHeader."No.";
                    BillPostingDate :=
                        SalesInvoiceHeader."Posting Date";
                end;

                SalesCrMemoHeader.Reset();
                SalesCrMemoHeader.SetRange(
                    "No.",
                    CustLedgerEntry2."Document No.");

                if SalesCrMemoHeader.FindFirst() then begin
                    BillDocumentNo := SalesCrMemoHeader."No.";
                    BillPostingDate :=
                        SalesCrMemoHeader."Posting Date";
                end;

            until CustLedgerEntry2.Next() = 0;
    end;

    local procedure CalculateReceiptAmount()
    begin
        Clear(ReceiptAmount);

        if DetailedCustLedgEntry."Initial Document Type" =
            DetailedCustLedgEntry."Initial Document Type"::"Credit Memo"
        then
            ReceiptAmount := -DetailedCustLedgEntry.Amount
        else
            ReceiptAmount := Abs(DetailedCustLedgEntry.Amount);
    end;
}