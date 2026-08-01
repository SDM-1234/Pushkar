pageextension 50148 VendorCard extends "Vendor Card"
{
    layout
    {
        addlast(General)
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
                    ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);
                    WorkflowWebhookManagement.FindAndCancel(Rec.RecordId);
                end;
            }
        }
    }

}
