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
            }
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = All;
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = All;
            }
            field("Sales Account"; Rec."Sales Account")
            {
                ApplicationArea = All;
            }
            field("Sales Account Name"; Rec."Sales Account Name")
            {
                ApplicationArea = All;
            }
            field("TCS Amount"; Rec."TCS Amount")
            {
                ApplicationArea = All;
            }
            field("Invoice No."; Rec."Invoice No.")
            {
                ApplicationArea = All;
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
