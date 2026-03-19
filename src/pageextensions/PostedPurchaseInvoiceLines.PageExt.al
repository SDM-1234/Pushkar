namespace Pushkar.Pushkar;

using Microsoft.Purchases.History;

pageextension 50132 PostedPurchaseInvoiceLines extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
            }
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = All;
            }
            field("CGST Amount"; Rec."CGST Amount")
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
            field("Purch. Account Name"; Rec."Purch. Account Name")
            {
                ApplicationArea = All;
            }
            field("TDS Section"; Rec."TDS Section")
            {
                ApplicationArea = All;
                Caption = 'TDS Account No.';
            }
            field("TDS Section Name"; Rec."TDS Section Name")
            {
                ApplicationArea = All;
                Caption = 'TDS Account Name';
            }

        }
        modify("Order No.")
        {
            Visible = true;
        }

        addafter("No.")
        {
            field("HSN Code"; Rec."HSN Code")
            {
                ApplicationArea = All;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
            }



        }
        addafter("Amount Including VAT")
        {
            field("Total Bill Value"; Rec.Amount + Rec."GST Amount" + Rec."TDS Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Bill Value';
                ToolTip = 'Specifies the value of the Total Bill Value field.';
            }

        }

    }

}