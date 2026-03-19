namespace Pushkar.Pushkar;

using Microsoft.Sales.Setup;

pageextension 50143 SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group(Pushkar)
            {
                Caption = 'Pushkar';
                field("Posting Date Method"; Rec."Posting Date Method")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
