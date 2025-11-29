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