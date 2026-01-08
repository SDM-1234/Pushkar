namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;

pageextension 50131 SalesOrder extends "Sales Order"
{
    layout
    {
        addafter("Posting Date")
        {
            field("PS Vehicle No."; Rec."PS Vehicle No.")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec."Posting Date" := WorkDate()
    end;
}
