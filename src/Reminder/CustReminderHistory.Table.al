namespace Reminder;

using Microsoft.Sales.Customer;

table 50107 "Cust. Reminder History"
{
    Caption = 'Customer Reminder History';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(20; "Reminder Date"; Date)
        {
            Caption = 'Reminder Date';
        }
        field(30; "Outstanding Amount"; Decimal)
        {
            Caption = 'Outstanding Amount';
        }
        field(40; "Invoice Count"; Integer)
        {
            Caption = 'Invoice Count';
        }
        field(50; "Email Address"; Text[250])
        {
            Caption = 'Email Address';
        }
        field(60; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Sent,Skipped,Error;
            OptionCaption = 'Sent,Skipped,Error';
        }
        field(70; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(CustomerDate; "Customer No.", "Reminder Date")
        {
        }
    }
}