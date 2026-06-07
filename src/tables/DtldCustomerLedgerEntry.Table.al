namespace Pushkar.Pushkar;

table 50106 DtldCustomerLedgerEntry
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;

        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;

        }
        field(3; "Applied Cust. Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;

        }
        field(4; "Entry Type"; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(5; "Document Type"; Enum Microsoft.Finance.GeneralLedger.Journal."Gen. Journal Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(6; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Credit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Debit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Customer Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Dtld. Cust. Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; Closed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14; Error; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Error Text"; Text[250])
        {
            DataClassification = CustomerContent;
        }




    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }



}