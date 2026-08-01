

codeunit 50138 CustomerWFResponseHandling
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnCustomerOpenDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        Customer: Record "Customer";
    begin
        case RecRef.Number() of
            DATABASE::"Customer":
                begin
                    RecRef.SetTable(Customer);
                    Customer.validate("Approval Status", Customer."Approval Status"::Open);
                    Customer.Validate(Blocked, Customer.Blocked::All);

                    Customer.Modify(true);
                    Handled := true;
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseCustomerDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        Customer: Record "Customer";

    begin
        case RecRef.Number() of
            DATABASE::"Customer":
                begin
                    RecRef.SetTable(Customer);
                    Customer.validate("Approval Status", Customer."Approval Status"::Approved);
                    Customer.Validate(Blocked, Customer.Blocked::" ");
                    Customer.Modify(true);
                    Handled := true;
                END;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddCustomerWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode());
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode());
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode());
            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode());
            WorkflowResponseHandling.ReleaseDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode());
            WorkflowResponseHandling.RejectAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RejectAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode());

        end;
    end;

    //<< Workflow Response Handling End 
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

}

