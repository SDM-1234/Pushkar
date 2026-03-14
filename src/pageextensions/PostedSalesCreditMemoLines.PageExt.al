namespace Pushkar.Pushkar;

using Microsoft.Sales.Customer;
using Microsoft.Sales.History;

pageextension 50116 PostedSalesCreditMemoLines extends "Posted Sales Credit Memo Lines"
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
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IGST Amount field.', Comment = '%';
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SGST Amount field.', Comment = '%';
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CGST Amount field.', Comment = '%';
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
            field("TCS Amount"; Rec."TCS Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the TCS Amount field.', Comment = '%';
            }
            field("Invoice No."; Rec."Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
            }
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bin where the items are picked or put away.';
            }

        }
        addafter("No.")
        {
            field("HSN Code"; Rec."HSN Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HSN Code field.', Comment = '%';
            }

        }
        addafter("Amount Including VAT")
        {
            field("Total Bill Value"; Rec.Amount + Rec."GST Amount" + Rec."TCS Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Bill Value';
                ToolTip = 'Specifies the value of the Total Bill Value field.';
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
