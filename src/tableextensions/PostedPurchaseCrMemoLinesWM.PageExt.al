namespace Pushkar.Pushkar;

using Microsoft.Purchases.History;

pageextension 50113 "PostedPurchaseCrMemoLines_WM" extends "Posted Purchase Cr. Memo Lines"
{

    layout
    {
        addafter("Document No.")
        {
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
            }
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
            field("Purch. Account"; Rec."Purch. Account")
            {
                ApplicationArea = All;
            }
        }
    }

}
