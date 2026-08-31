codeunit 50149 VendorApprovalMgt
{

    permissions =
        tabledata "Approval Entry" = RIM;




    [EventSubscriber(ObjectType::Table, Database::"Vendor", OnBeforeInsertEvent, '', false, false)]
    local procedure Vendor_OnBeforeInsertEvent(var Rec: Record "Vendor"; RunTrigger: Boolean)
    var
    begin
        Rec.Blocked := Rec.Blocked::All;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", OnBeforeModifyEvent, '', false, false)]
    local procedure Vendor_OnBeforeModifyEvent(var Rec: Record "Vendor"; RunTrigger: Boolean)
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", OnBeforeDeleteEvent, '', false, false)]
    local procedure Vendor_OnBeforeDeleteEvent(RunTrigger: Boolean; var Rec: Record "Vendor")
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteApprovalEntriesAfterDeleteVendor(RunTrigger: Boolean; var Rec: Record "Vendor")
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        if not Rec.IsTemporary then
            ApprovalMgt.DeleteApprovalEntries(Rec.RecordId);
    end;


    //>> Workflow Response Handling Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelVendorApprovalRequest', '', false, false)]
    local procedure OnCancelVendorApprovalRequest(var Vendor: Record "Vendor")
    var
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        ApprovalEntry: Record "Approval Entry";
    begin



        if Vendor."Approval Status" <> Vendor."Approval Status"::Approved then
            exit;


        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Record ID to Approve", Vendor.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        If APprovalEntry.FindSet() then
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry.Modify();
            until ApprovalEntry.Next() = 0;

        RecordRestrictionMgt.AllowRecordUsage(Vendor);
        Vendor.Validate("Approval Status", Vendor."Approval Status"::Open);
        Vendor.Validate(Blocked, Vendor.Blocked::All);
        Vendor.Modify(false);
    end;




    //>> Workflow Response Handling Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetVendorStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        Vendor: Record "Vendor";
    begin
        case RecRef.Number() of
            database::"Vendor":
                begin
                    if Vendor."Approval Status" = Vendor."Approval Status"::"Pending Approval" then
                        exit;
                    RecRef.SetTable(Vendor);
                    Vendor.Validate("Approval Status", Vendor."Approval Status"::"Pending Approval");
                    Vendor.Validate(Blocked, Vendor.Blocked::All);
                    Vendor.Modify(false);
                    Variant := Vendor;
                    IsHandled := true;
                end;
        end;
    end;

}
