namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;

pageextension 50138 ChartofAccounts extends "Chart of Accounts"
{
    layout
    {

        addafter("Name")
        {
            field("Modify G/L Entries"; Rec."Modify G/L Entries")
            {
                ApplicationArea = All;
                Caption = 'Modify G/L Entries ';
                ToolTip = 'Specifies whether modification of G/L Entries is allowed for this account.';
            }
        }
    }
}
