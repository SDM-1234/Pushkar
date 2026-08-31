namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using System.Automation;

pageextension 50134 ItemCard extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
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
                    ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);
                    WorkflowWebhookManagement.FindAndCancel(Rec.RecordId);
                end;

            }
        }
    }

}

