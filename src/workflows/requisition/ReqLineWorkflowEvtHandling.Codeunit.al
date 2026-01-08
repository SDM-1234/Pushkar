namespace Pushkar.Pushkar;

using Microsoft.Inventory.Requisition;
using System.Automation;

codeunit 50108 "ReqLine Workflow Evt Handling"
{


    procedure RunWorkflowOnSendReqLineForApprovalCode(): code[128]
    begin
        exit('RUNWORKFLOWONSENDREQLINEFORAPPROVAL')
    end;

    procedure RunWorkflowOnCancelReqLineForApprovalCode(): code[128]
    begin
        exit('RUNWORKFLOWONCANCELREQLINEFORAPPROVAL')
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        workflowEventHandling.AddEventToLibrary(RunWorkflowOnSendReqLineForApprovalCode(), DATABASE::"Requisition Line", ReqLineSendApprovalLbl, 0, false);
        workflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelReqLineForApprovalCode(), DATABASE::"Requisition Line", ReqLineCancelApprovalLbl, 0, false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req Line Approval Mgt", 'OnSendRequestForApproval', '', false, false)]
    local procedure OnSendRequestForApproval(var RequisitionLine: Record "Requisition Line")
    begin
        if RequisitionLine.FindSet() then
            repeat
                workflowMgt.HandleEvent(RunWorkflowOnSendReqLineForApprovalCode(), RequisitionLine);
            until RequisitionLine.Next() = 0;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req Line Approval Mgt", 'OnCancelRequestForApproval', '', false, false)]
    local procedure OnCancelRequestForApproval(var RequisitionLine: Record "Requisition Line")
    begin
        if RequisitionLine.FindSet() then
            repeat
                workflowMgt.HandleEvent(RunWorkflowOnCancelReqLineForApprovalCode(), RequisitionLine);
            until RequisitionLine.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelReqLineForApprovalCode():
                workflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelReqLineForApprovalCode(), RunWorkflowOnSendReqLineForApprovalCode());
            workflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                workflowEventHandling.AddEventPredecessor(workflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnSendReqLineForApprovalCode())
        end;
    end;


    procedure isReqLinepprovalWorkflowEnabled(Var ReqLine: Record "Requisition Line"): Boolean
    begin
        exit(workflowMgt.CanExecuteWorkflow(ReqLine, RunWorkflowOnSendReqLineForApprovalCode()))
    end;

    procedure IsReqLinePendingApproval(Var ReqLine: Record "Requisition Line"): Boolean
    begin
        exit(isReqLinepprovalWorkflowEnabled(ReqLine));
    end;


    procedure CheckInvcomingApprovalWorkFlowEnabled(Var ReqLine: Record "Requisition Line"): Boolean
    begin
        if not IsReqLinePendingApproval(ReqLine) then
            error(ReqLineApprovalExistErr);
        exit(true);
    end;



    var
        workflowMgt: Codeunit "Workflow Management";
        workflowEventHandling: Codeunit "Workflow Event Handling";
        ReqLineSendApprovalLbl: Label 'Requisition Line Approval Requested';
        ReqLineCancelApprovalLbl: Label 'Requisition Line Approval Cancelled';
        ReqLineApprovalExistErr: Label 'No Approval Workflow For This Line';

}
