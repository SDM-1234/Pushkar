namespace Pushkar.Pushkar;

using Microsoft.Sales.Customer;
using Microsoft.Sales.History;

pageextension 50115 PostedSalesInvoiceLines extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Customer Name"; CustomerName)
            {
                ApplicationArea = all;
                ToolTip = 'Name of the customer.';
                Caption = 'Customer Name';
                Editable = false;
            }

            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GST Amount field.', Comment = '%';
            }
            field("Sales Account"; Rec."Sales Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Account field.', Comment = '%';
            }
            field("Sales Account Name"; Rec."Sales Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Account Name field.', Comment = '%';
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the TDS Amount field.', Comment = '%';
            }
            field("Invoice No."; Rec."Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if REC."Sell-to Customer No." <> '' then
            CustomerName := GetCustomerName(REC."Sell-to Customer No.");
    end;

    var
        CustomerName: Text[100];

    local procedure GetCustomerName(CustomerNo: Code[20]): Text[100]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit(Customer.Name)
        else
            exit('');
    end;
}
