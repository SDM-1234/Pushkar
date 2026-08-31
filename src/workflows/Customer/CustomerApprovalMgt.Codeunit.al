codeunit 50139 CustomerApprovalMgt
{

    permissions =
        tabledata "Approval Entry" = RIM;


    [EventSubscriber(ObjectType::Table, Database::"Customer", OnBeforeInsertEvent, '', false, false)]
    local procedure Customer_OnBeforeInsertEvent(var Rec: Record "Customer"; RunTrigger: Boolean)
    var
    begin
        Rec.Blocked := Rec.Blocked::All;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Customer", OnBeforeModifyEvent, '', false, false)]
    local procedure Customer_OnBeforeModifyEvent(var Rec: Record "Customer"; RunTrigger: Boolean)
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", OnBeforeDeleteEvent, '', false, false)]
    local procedure Customer_OnBeforeDeleteEvent(RunTrigger: Boolean; var Rec: Record "Customer")
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteApprovalEntriesAfterDeleteCustomer(RunTrigger: Boolean; var Rec: Record "Customer")
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        if not Rec.IsTemporary then
            ApprovalMgt.DeleteApprovalEntries(Rec.RecordId);
    end;



    //>> Workflow Response Handling Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetCustomerStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        Customer: Record "Customer";
    begin
        case RecRef.Number() of
            database::"Customer":
                begin
                    if Customer."Approval Status" = Customer."Approval Status"::"Pending Approval" then
                        exit;
                    RecRef.SetTable(Customer);
                    Customer.Validate("Approval Status", Customer."Approval Status"::"Pending Approval");
                    Customer.Validate(Blocked, Customer.Blocked::All);
                    Customer.Modify(false);
                    Variant := Customer;
                    IsHandled := true;
                end;
        end;
    end;

    //>> Workflow Response Handling Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelCustomerApprovalRequest', '', false, false)]
    local procedure OnCancelCustomerApprovalRequest(var Customer: Record "Customer")
    var
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        ApprovalEntry: Record "Approval Entry";
    begin



        if Customer."Approval Status" <> Customer."Approval Status"::Approved then
            exit;


        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Record ID to Approve", Customer.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        If APprovalEntry.FindSet() then
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry.Modify();
            until ApprovalEntry.Next() = 0;

        RecordRestrictionMgt.AllowRecordUsage(Customer);
        Customer.Validate("Approval Status", Customer."Approval Status"::Open);
        Customer.Validate(Blocked, Customer.Blocked::All);
        Customer.Modify(false);
    end;


}
