namespace Pushkar.Pushkar;

using Microsoft.Sales.Setup;

tableextension 50121 SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Posting Date Method"; Option)
        {
            Caption = 'Posting Date Method';
            OptionMembers = ,Error,Warning;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Posting Date Method field.', Comment = '%';
        }

    }
}
