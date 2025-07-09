namespace Pushkar.Pushkar;

using Microsoft.Sales.History;
using Microsoft.Sales.Customer;

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
