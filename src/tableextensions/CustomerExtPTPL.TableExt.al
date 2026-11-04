namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Sales.Customer;

tableextension 50115 CustomerExtPTPL extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Supplier Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            ToolTip = 'Specifies the supplier code associated with the customer.';
            Caption = 'Supplier Code';
        }
        field(50100; "Approval Status"; Enum ItemApprovalStatus)
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "TDS G/L Account"; Code[20])
        {
            Caption = 'TDS G/L Account';
            TableRelation = "G/L Account"."No.";
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}