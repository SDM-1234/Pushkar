
table 50115 "WF Mandatory Fields"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = Const(1));
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(3; "Field Caption"; Text[100])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Field No.")));
            Caption = 'Field Caption';
            FieldClass = FlowField;
            editable = false;
        }
        field(4; "Parent Table No."; Integer)
        {
            Caption = 'Parent Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = Const(1));
        }
        field(5; "Mandatory Condition"; Option)
        {
            Caption = 'Mandatory Condition';
            OptionCaption = 'Field Only,Related Table Only,Both';
            OptionMembers = "Field Only","Related Table Only",Both;
            ToolTip = 'Specifies whether the field is mandatory or if related table fields are also mandatory.';
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

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