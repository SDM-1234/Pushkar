namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;

pageextension 50105 SalesCreditMemo extends "Sales Credit Memo"
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
        modify("Location Code")
        {
            Visible = true;
        }
    }
}
