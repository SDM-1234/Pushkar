namespace Reminder;

using Microsoft.Sales.Receivables;

report 50130 "Outstanding Invoice Reminder"
{
    Caption = 'Outstanding Invoice Reminder';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/OutstandingInvoiceReminder.rdl';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Customer No.";

            DataItemTableView = sorting("Customer No.", "Due Date", "Document No.")
                                where("Document Type" = const(Invoice),
                                      Open = const(true));

            column(Customer_No; "Customer No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Document_No; "Document No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Due_Date; "Due Date") { }
            column(Remaining_Amount; "Remaining Amount") { }
            column(Currency_Code; "Currency Code") { }
        }
    }
}