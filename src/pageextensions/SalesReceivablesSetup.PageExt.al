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
                field("Req. Worksheet Template Name"; Rec."Req. Worksheet Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the default requisition worksheet template to be used for generating the purchase requisitions from sales order planning report.';
                }
                field("Req. Journal Batch Name"; Rec."Req. Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the default journal batch to be used for generating the purchase requisitions from sales order planning report.';
                }
            }
        }
    }
}
