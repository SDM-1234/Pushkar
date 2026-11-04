namespace Reminder;

page 50106 "Customer Reminder Setup"
{
    PageType = Card;
    SourceTable = "Cust. Reminder Setup";
    Caption = 'Customer Outstanding Reminder Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Overdue Days"; Rec."Overdue Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Invoices must be overdue by this number of days before a reminder is sent.';
                }
                field("Reminder Frequency Days"; Rec."Reminder Frequency Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Minimum number of days between reminder emails for the same customer.';
                }
                field("Minimum Outstanding Amount"; Rec."Minimum Outstanding Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reminder is not sent when the total overdue amount is below this amount.';
                }
                field("Send Email"; Rec."Send Email")
                {
                    ApplicationArea = All;
                }
                field("Attach PDF"; Rec."Attach PDF")
                {
                    ApplicationArea = All;
                }
                field("PDF Report ID"; Rec."PDF Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Report object ID used to generate the PDF attachment. Use 0 to disable the attachment.';
                }
                field("Email Subject"; Rec."Email Subject")
                {
                    ApplicationArea = All;
                }
                field("Email From Scenario"; Rec."Email From Scenario")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('DEFAULT') then begin
            Rec.Init();
            Rec."Primary Key" := 'DEFAULT';
            Rec."Overdue Days" := 7;
            Rec."Reminder Frequency Days" := 7;
            Rec."Minimum Outstanding Amount" := 0;
            Rec."Send Email" := true;
            Rec."Attach PDF" := false;
            Rec."PDF Report ID" := 0;
            Rec."Email Subject" := 'Payment Reminder - Outstanding Invoices';
            Rec.Insert();
        end;
    end;
}