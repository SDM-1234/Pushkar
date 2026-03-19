namespace Pushkar.Pushkar;

using System.Security.User;

tableextension 50120 UserSetup extends "User Setup"
{
    fields
    {

        field(50100; "Modify G/L Entries"; Boolean)
        {
            Caption = 'G/L Entries Modification';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether modification of G/L Entries is allowed for this user.';
        }

    }
}
