namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;

pageextension 50107 SalesInvoice extends "Sales Invoice"
{
    layout
    {
        addafter("Posting Date")
        {

            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
                Caption = 'Posting No. Series';
            }
        }
    }
}
