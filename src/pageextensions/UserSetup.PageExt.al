namespace Pushkar.Pushkar;

using System.Security.User;

pageextension 50139 UserSetup extends "User Setup"
{
    layout
    {

        addafter("Allow Posting To")
        {
            field("Modify G/L Entries"; Rec."Modify G/L Entries")
            {
                ApplicationArea = All;
                Caption = 'Modify G/L Entries ';
            }
        }
    }
}
