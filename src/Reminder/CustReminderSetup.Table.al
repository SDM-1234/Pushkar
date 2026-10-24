namespace Reminder;

using System.Email;

table 50104 "Cust. Reminder Setup"
{
    Caption = 'Customer Reminder Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Overdue Days"; Integer)
        {
            Caption = 'Overdue Days';
            MinValue = 0;
        }
        field(20; "Reminder Frequency Days"; Integer)
        {
            Caption = 'Reminder Frequency Days';
            MinValue = 1;
        }
        field(30; "Minimum Outstanding Amount"; Decimal)
        {
            Caption = 'Minimum Outstanding Amount';
            MinValue = 0;
        }
        field(40; "Send Email"; Boolean)
        {
            Caption = 'Send Email';
        }
        field(50; "Attach PDF"; Boolean)
        {
            Caption = 'Attach PDF';
        }
        field(60; "PDF Report ID"; Integer)
        {
            Caption = 'PDF Report ID';
        }
        field(70; "Email Subject"; Text[250])
        {
            Caption = 'Email Subject';
        }
        field(80; "Email From Scenario"; Enum "Email Scenario")
        {
            Caption = 'Email Scenario';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}