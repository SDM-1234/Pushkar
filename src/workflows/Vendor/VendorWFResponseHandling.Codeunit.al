

codeunit 50148 VendorWFResponseHandling
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnVendorOpenDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        Vendor: Record "Vendor";
    begin
        case RecRef.Number() of
            DATABASE::"Vendor":
                begin
                    RecRef.SetTable(Vendor);
                    Vendor.validate("Approval Status", Vendor."Approval Status"::Open);
                    Vendor.Validate(Blocked, Vendor.Blocked::All);

                    Vendor.Modify(true);
                    Handled := true;
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseVendorDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        Vendor: Record "Vendor";

    begin
        case RecRef.Number() of
            DATABASE::"Vendor":
                begin
                    RecRef.SetTable(Vendor);
                    Vendor.validate("Approval Status", Vendor."Approval Status"::Approved);
                    Vendor.Validate(Blocked, Vendor.Blocked::" ");
                    Vendor.Modify(true);
                    Handled := true;
                END;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddVendorWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode());
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode());
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode());
            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode());
            WorkflowResponseHandling.ReleaseDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode());
            WorkflowResponseHandling.RejectAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RejectAllApprovalRequestsCode(), WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode());

        end;
    end;

    //<< Workflow Response Handling End 
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

}

