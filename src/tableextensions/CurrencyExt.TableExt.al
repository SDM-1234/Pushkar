namespace Pushkar.Pushkar;

using Microsoft.Finance.Currency;

tableextension 50114 CurrencyExt extends Currency
{
    fields
    {
        field(50000; "Currency Numeric Description"; Code[10])
        {
            DataClassification = ToBeClassified;
            caption = 'Currency Numeric Description';
            tooltip = 'Currency Numeric Description';
        }
        field(50001; "Currency Decimal Description"; Code[10])
        {
            DataClassification = ToBeClassified;
            caption = 'Currency Decimal Description';
            tooltip = 'Currency Decimal Description';
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

    var
        myInt: Integer;
}