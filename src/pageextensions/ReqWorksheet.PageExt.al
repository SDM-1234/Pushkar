namespace Pushkar.Pushkar;

using Microsoft.Inventory.Requisition;
using System.Automation;

pageextension 50135 ReqWorksheet extends "Req. Worksheet"
{


    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field(ReqLineApprovalStatus; ReqLineApprovalStatus)
            {
                ApplicationArea = All;
                Caption = 'Approval Status';
                Editable = false;
                Visible = true;
                ToolTip = 'Specifies the approval status for Physical Inventory Journal.';
            }
        }
    }


    actions
    {
        // Add changes to page actions here
        addafter(Page)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestRequisitionLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Selected Requisition Lines';
                        Enabled = EnabledReqLineWorkflowsExist;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send selected lines for approval.';

                        trigger OnAction()
                        var
                            [SecurityFiltering(SecurityFilter::Filtered)]
                            ReqLine: Record "Requisition Line";
                            ApprovalsMgmt: Codeunit "Req Line Approval Mgt";
                        begin
                            GetCurrentlySelectedLines(ReqLine);
                            ApprovalsMgmt.OnSendRequestforApproval(ReqLine);
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestRequisitionLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = EnabledReqLineWorkflowsExist;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending selected lines for approval.';

                        trigger OnAction()
                        var
                            [SecurityFiltering(SecurityFilter::Filtered)]
                            ReqLine: Record "Requisition Line";
                            ApprovalsMgmt: Codeunit "Req Line Approval Mgt";
                        begin
                            GetCurrentlySelectedLines(ReqLine);
                            ApprovalsMgmt.OnCancelRequestForApproval(ReqLine);
                        end;
                    }
                }
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
            }

        }

        addafter(Category_Category6)
        {
            group("Category_Request Approval")
            {
                Caption = 'Request Approval';

                group("Category_Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    actionref(SendApprovalRequestJournalLine_Promoted; SendApprovalRequestRequisitionLine)
                    {
                    }
                }
                group("Category_Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    actionref(CancelApprovalRequestJournalLine_Promoted; CancelApprovalRequestRequisitionLine)
                    {
                    }
                }
            }
        }

    }

    local procedure GetCurrentlySelectedLines(var ReqLine: Record "Requisition Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(ReqLine);
        exit(ReqLine.FindSet());
    end;

    trigger OnAfterGetRecord()
    begin
        ApprovalMgmt.GetApprovalStatus(Rec, ReqLineApprovalStatus, EnabledReqLineWorkflowsExist);
    end;

    trigger OnAfterGetCurrRecord()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        ApprovalMgmt.GetApprovalStatus(Rec, ReqLineApprovalStatus, EnabledReqLineWorkflowsExist);
    end;

    trigger OnModifyRecord(): Boolean
    var
        ApprovalStatusName: Text[20];
    begin
        ApprovalMgmt.GetApprovalStatus(Rec, ApprovalStatusName, EnabledReqLineWorkflowsExist);
        if ApprovalStatusName = 'Approved' then
            Error('You cannot modify an approved requisition line.');
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ApprovalStatusName: Text[20];
    begin
        ApprovalMgmt.GetApprovalStatus(Rec, ApprovalStatusName, EnabledReqLineWorkflowsExist);
        if ApprovalStatusName = 'Approved' then
            Error('You cannot delete an approved requisition line.');
    end;

    trigger OnOpenPage()
    begin
        EnabledReqLineWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Requisition Line", WorkflowEventHandling.RunWorkflowOnSendReqLineForApprovalCode());
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "ReqLine Workflow Evt Handling";
        ApprovalMgmt: Codeunit ApprovalMgtPSK;
        ReqLineApprovalStatus: Text[20];
        OpenApprovalEntriesExistForCurrUser, EnabledReqLineWorkflowsExist : Boolean;
}
