namespace Pushkar.Pushkar;
using System.Automation;
using Microsoft.Inventory.Requisition;

codeunit 50107 "Req line workflow Setup"
{


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        workflowsetup.InsertWorkflowCategory(workflowCategoryCodeLbl, workflowCategoryDescLbl);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    local procedure OnAfterInsertApprovalsTableRelations()
    begin
        workflowsetup.InsertTableRelation(Database::"Requisition Line", 0, DATABASE::"Approval Entry", approvalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertReqLineTemplate()
    end;

    local procedure InsertReqLineTemplate()
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, WorkflowTemplateCodeLbl, WorkflowTemplateDescLbl, workflowCategoryCodeLbl);
        InsertReqLineApprovalWorkFlowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;


    procedure InsertReqLineApprovalWorkFlowDetails(var workflow: record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        workflowEventHandling: Codeunit "ReqLine Workflow Evt Handling";
        BlankDateFormula: DateFormula;

    begin
        workflowsetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);


        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildReqLineTypeConditions(), workflowEventHandling.RunWorkflowOnSendReqLineForApprovalCode(),
        BuildReqLineTypeConditions(), workflowEventHandling.RunWorkflowOnCancelReqLineForApprovalCode(), WorkflowStepArgument, true);
    end;

    local procedure BuildReqLineTypeConditions(): Text
    var
        ReqLine: record "Requisition Line";
    begin
        ReqLine.SetRange("Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name");
        exit(StrSubstNo(WorkFlowCondLbl, workflowsetup.Encode((ReqLine.GetView(false)))));
    end;



    var
        approvalEntry: Record "Approval Entry";
        workflowsetup: Codeunit "Workflow Setup";
        WorkflowTemplateCodeLbl: TextConst ENU = 'ReqLineWF';
        WorkflowTemplateDescLbl: TextConst ENU = 'Requisition Line Workflow';
        workflowCategoryCodeLbl: TextConst ENU = 'Pushkar';
        workflowCategoryDescLbl: TextConst ENU = 'Pushkar Workflow Category';
        WorkFlowCondLbl: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Requisition Line">%1</DataItem></DataItems></ReportParameters>', Locked = true;

}
