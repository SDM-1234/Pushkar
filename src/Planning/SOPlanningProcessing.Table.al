table 50105 "SO Planning Processing"
{
    DataClassification = ToBeClassified;
    Caption = 'SO Planning Processing';
    TableType = Temporary;

    fields
    {
        field(1; "Item No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(2; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(3; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit of Measure Code';
        }
        field(4; "Demand Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Demand Quantity';
        }
        field(5; "Replenishment System"; Enum "Replenishment System")
        {
            DataClassification = ToBeClassified;
            Caption = 'Replenishment System';
        }
        field(6; "Assembly Order Level"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembly Order Level';
        }

    }

    keys
    {
        key(Key1; "Item No", "Location Code", "Unit of Measure Code")
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