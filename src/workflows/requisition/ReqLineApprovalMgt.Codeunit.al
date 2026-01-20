namespace Pushkar.Pushkar;

using Microsoft.Inventory.Requisition;
using System.Automation;

codeunit 50106 "Req Line Approval Mgt"
{



    [IntegrationEvent(false, false)]
    PROCEDURE OnSendRequestforApproval(VAR RequisitionLine: Record "Requisition Line");
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnCancelRequestForApproval(VAR RequisitionLine: Record "Requisition Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnBeforeModifyEvent, '', false, false)]
    local procedure RequisitionLine_OnBeforeModifyEvent(var Rec: Record "Requisition Line"; var xRec: Record "Requisition Line"; RunTrigger: Boolean)
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnBeforeDeleteEvent, '', false, false)]
    local procedure RequisitionLine_OnDeleteModifyEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", OnBeforeCarryOutActionMsg, '', false, false)]
    local procedure "Req. Worksheet_OnBeforeCarryOutActionMsg"(var RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    var
        WorkflowManagement: Codeunit "Workflow Management";
        ApprovalMgmt: Codeunit ApprovalMgtPSK;
        WorkflowEventHandling: Codeunit "ReqLine Workflow Evt Handling";
        ApprovalStatusName: Text[20];
        ApprovalRequired: Boolean;
    begin
        ApprovalRequired := WorkflowManagement.CanExecuteWorkflow(RequisitionLine, WorkflowEventHandling.RunWorkflowOnSendReqLineForApprovalCode());
        if not ApprovalRequired then
            exit;
        ApprovalMgmt.GetApprovalStatus(RequisitionLine, ApprovalStatusName, ApprovalRequired);
        if ApprovalStatusName = '' then
            Error('The journal line must be submitted for approval before it can be posted.');
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterPostItemJnlLine, '', false, false)]
    // local procedure "Item Jnl.-Post Line_OnAfterPostItemJnlLine"(var Sender: Codeunit "Item Jnl.-Post Line"; var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean; var ItemRegister: Record "Item Register"; var ItemLedgEntryNo: Integer; var ItemApplnEntryNo: Integer; var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line")
    // var
    //     ApprovalMgt: Codeunit "Approvals Mgmt.";
    // begin
    //     ApprovalMgt.PostApprovalEntries(ItemJournalLine.RecordId, ItemJournalLine.RecordId, ItemJournalLine."Document No.");
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteApprovalEntriesAfterDeleteItemJournalLine(RunTrigger: Boolean; var Rec: Record "Requisition Line")
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        if not Rec.IsTemporary then
            ApprovalMgt.DeleteApprovalEntries(Rec.RecordId);
    end;



}
