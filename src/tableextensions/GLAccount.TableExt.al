namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;

tableextension 50119 GLAccount extends "G/L Account"
{
    fields
    {
        field(50100; "Modify G/L Entries"; Boolean)
        {
            Caption = 'G/L Entries Modification';
            DataClassification = CustomerContent;
        }
    }
}
