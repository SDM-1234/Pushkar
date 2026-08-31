codeunit 50135 "ItemWorkflow Response Handling"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnItemOpenDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        Item: Record "Item";
    begin
        case RecRef.Number() of
            DATABASE::"Item":
                begin
                    RecRef.SetTable(Item);
                    Item.validate("Approval Status", Item."Approval Status"::Open);
                    Item.Validate(Blocked, true);

                    Item.Modify(true);
                    Handled := true;
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseItemDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        Item: Record "Item";

    begin
        case RecRef.Number() of
            DATABASE::"Item":
                begin
                    RecRef.SetTable(Item);
                    Item.validate("Approval Status", Item."Approval Status"::Approved);
                    Item.Validate(Blocked, false);
                    Item.Modify(true);
                    Handled := true;
                END;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddItemWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode());
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode());
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode());
            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode());
            WorkflowResponseHandling.ReleaseDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode());
            WorkflowResponseHandling.RejectAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RejectAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode());

        end;
    end;

    //<< Workflow Response Handling End 
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

}