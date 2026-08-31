codeunit 50137 ItemApprovalMgt
{


    permissions =
        tabledata "Approval Entry" = RIM;



    [EventSubscriber(ObjectType::Table, Database::"Item", OnBeforeInsertEvent, '', false, false)]
    local procedure Item_OnBeforeInsertEvent(var Rec: Record "Item"; RunTrigger: Boolean)
    var
    begin
        Rec.Blocked := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item", OnBeforeModifyEvent, '', false, false)]
    local procedure Item_OnBeforeModifyEvent(var Rec: Record "Item";
    RunTrigger: Boolean)
    var

        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin

        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item", OnBeforeDeleteEvent, '', false, false)]
    local procedure Item_OnBeforeDeleteEvent(RunTrigger: Boolean; var Rec: Record "Item")
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteApprovalEntriesAfterDeleteItem(RunTrigger: Boolean; var Rec: Record "Item")
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        if not Rec.IsTemporary then
            ApprovalMgt.DeleteApprovalEntries(Rec.RecordId);
    end;





    //>> Workflow Response Handling Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelItemApprovalRequest', '', false, false)]
    local procedure OnCancelItemApprovalRequest(var Item: Record Item)
    var
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        ApprovalEntry: Record "Approval Entry";
    begin



        if Item."Approval Status" <> Item."Approval Status"::Approved then
            exit;


        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Record ID to Approve", Item.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        If APprovalEntry.FindSet() then
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry.Modify();
            until ApprovalEntry.Next() = 0;

        RecordRestrictionMgt.AllowRecordUsage(Item);
        Item.Validate("Approval Status", Item."Approval Status"::Open);
        Item.Validate(Blocked, true);
        Item.Modify(false);
    end;

    //>> Workflow Response Handling Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetItemStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        Item: Record "Item";
    begin
        case RecRef.Number() of
            database::"Item":
                begin
                    if Item."Approval Status" = Item."Approval Status"::"Pending Approval" then
                        exit;
                    RecRef.SetTable(Item);
                    Item.Validate("Approval Status", Item."Approval Status"::"Pending Approval");
                    Item.Validate(Blocked, true);
                    Item.Modify(false);
                    Variant := Item;
                    IsHandled := true;
                end;
        end;
    end;

}
