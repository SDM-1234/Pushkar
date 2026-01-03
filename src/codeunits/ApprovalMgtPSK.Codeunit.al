namespace Pushkar.Pushkar;

using System.Automation;

codeunit 50110 ApprovalMgtPSK
{

    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        PendingApprovalLbl: Label 'Pending Approval';
        ImposedRestrictionLbl: Label 'Imposed restriction';

    local procedure GetApprovalEntryStatusFieldRef(var FieldRef: FieldRef; var ApprovalEntry: Record "Approval Entry")
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(ApprovalEntry);
        FieldRef := RecordRef.Field(ApprovalEntry.FieldNo(Status));
    end;

    local procedure GetApprovalEntryStatusValueName(var FieldRef: FieldRef; ApprovalEntry: Record "Approval Entry"): Text
    begin
        exit(FieldRef.GetEnumValueName(ApprovalEntry.Status.AsInteger() + 1));
    end;

    local procedure GetApprovalEntryStatusValueCaption(var FieldRef: FieldRef; ApprovalEntry: Record "Approval Entry"): Text
    begin
        exit(FieldRef.GetEnumValueCaption(ApprovalEntry.Status.AsInteger() + 1));
    end;

    procedure GetApprovalStatus(RecVariant: Variant; var TransferApprovalStatus: Text[20]; EnabledWorkflowsExist: Boolean)
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        if not RecVariant.IsRecord then
            exit;
        RecRef.GetTable(RecVariant);

        Clear(TransferApprovalStatus);
        if not EnabledWorkflowsExist then
            exit;

        if ApprovalMgt.FindLastApprovalEntryForCurrUser(ApprovalEntry, RecRef.RecordId) then
            TransferApprovalStatus := GetApprovalStatusFromApprovalEntry(ApprovalEntry, RecVariant)
        else
            if ApprovalMgt.FindApprovalEntryByRecordId(ApprovalEntry, RecRef.RecordId) then
                TransferApprovalStatus := GetApprovalStatusFromApprovalEntry(ApprovalEntry, RecVariant);
    end;

    local procedure GetApprovalStatusFromApprovalEntry(var ApprovalEntry: Record "Approval Entry"; RecVariant: Variant): Text[20]
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        ApprovalStatusName: Text;
    begin
        if not RecVariant.IsRecord then
            exit('');
        RecRef.GetTable(RecVariant);
        GetApprovalEntryStatusFieldRef(FieldRef, ApprovalEntry);
        ApprovalStatusName := GetApprovalEntryStatusValueName(FieldRef, ApprovalEntry);
        if ApprovalStatusName = 'Open' then
            exit(CopyStr(PendingApprovalLbl, 1, 20));
        if ApprovalStatusName = 'Approved' then begin
            RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
            if not RestrictedRecord.IsEmpty() then
                exit(CopyStr(ImposedRestrictionLbl, 1, 20));
        end;
        exit(CopyStr(GetApprovalEntryStatusValueCaption(FieldRef, ApprovalEntry), 1, 20));
    end;
}
