namespace Pushkar.Pushkar;

using Microsoft.Inventory.Requisition;
using System.Automation;

codeunit 50109 "ReqLine Workflow Response"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(var IsHandled: Boolean; var Variant: Variant; RecRef: RecordRef)
    var
        ReqLine: record "Requisition Line";
    begin
        case
             RecRef.Number of
            DATABASE::"Requisition Line":
                BEGIN
                    RecRef.SetTable(ReqLine);
                    ReqLine.Validate("Approval Status", ReqLine."Approval Status"::"Pending Approval");
                    ReqLine.Modify();
                    IsHandled := true;
                END;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            workflowResponseHandling.SetStatusToPendingApprovalCode():
                workflowResponseHandling.AddResponsePredecessor(workflowResponseHandling.SetStatusToPendingApprovalCode(), workflowHandling.RunWorkflowOnSendReqLineForApprovalCode());
            workflowResponseHandling.CancelAllApprovalRequestsCode():
                workflowResponseHandling.AddResponsePredecessor(workflowResponseHandling.CancelAllApprovalRequestsCode(), workflowHandling.RunWorkflowOnCancelReqLineForApprovalCode());
            workflowResponseHandling.OpenDocumentCode():
                workflowResponseHandling.AddResponsePredecessor(workflowResponseHandling.OpenDocumentCode(), workflowHandling.RunWorkflowOnSendReqLineForApprovalCode());
        end

    end;

    var
        workflowResponseHandling: Codeunit "Workflow Response Handling";
        workflowHandling: Codeunit "ReqLine Workflow Evt Handling";
}
