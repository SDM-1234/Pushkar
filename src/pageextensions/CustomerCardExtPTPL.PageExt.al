namespace Pushkar.Pushkar;

using Microsoft.Sales.Customer;
using System.Automation;

pageextension 50133 CustomerCardExtPTPL extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Supplier Code"; Rec."Supplier Code")
            {
                ApplicationArea = All;
                Caption = 'Supplier Code';
            }

            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                Caption = 'Approval Status';
            }

        }

    }

    actions
    {
        addafter(SendApprovalRequest)
        {
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                    WorkflowWebhookManagement.FindAndCancel(Rec.RecordId);
                end;
            }
        }

        // Add changes to page actions here
    }
}