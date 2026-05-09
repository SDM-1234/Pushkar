namespace Pushkar.Pushkar;

table 50105 DetailedVendorLedgerEntry
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;

        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;

        }
        field(3; "Applied Vend. Ledger Entry No."; Integer)
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
        field(7; "Vendor No."; Code[20])
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
        field(11; "Vendor Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Dtld. Vendor Ledger Entry No."; Integer)
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

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}