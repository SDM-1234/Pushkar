
Codeunit 50113 WMWorkflowResponses
{




    procedure FieldMandatory(): code[128]
    begin
        EXIT('CHECKMANDATORYFIELDS');
    end;

    procedure AttachmentMandatory(): code[128]
    begin
        EXIT('CHECKMANDATORYATTACHMENTS');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure AddMyWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin

        WorkflowResponseHandling.AddResponseToLibrary(FieldMandatory(), 0, 'Check Mandatory Fields.', 'GROUP 50000');
        WorkflowResponseHandling.AddResponseToLibrary(AttachmentMandatory(), 0, 'Check Mandatory Attachments.', 'GROUP 50000');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    local procedure ExecuteMyWorkflowResponses(ResponseWorkflowStepInstance: Record "Workflow Step Instance"; var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant)
    var
        WorkflowResponse: record "Workflow Response";
    begin
        if WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                FieldMandatory():
                    BEGIN
                        MandatoryFieldWorkflowResponse(Variant);
                        ResponseExecuted := TRUE;
                    END;
                AttachmentMandatory():
                    BEGIN
                        MandatoryAttachmentWorkflowResponse(Variant);
                        ResponseExecuted := TRUE;
                    END;
            END;
    end;

    local procedure MandatoryFieldWorkflowResponse(Variant: Variant)
    var
        WFMandatoryFields: Record "WF Mandatory Fields";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        recRef.GetTable(Variant);

        WFMandatoryFields.SetRange("Table No.", RecRef.Number);
        if not WFMandatoryFields.FindSet(false) then
            exit;
        repeat
            FieldRef := recRef.Field(WFMandatoryFields."Field No.");
            case WFMandatoryFields."Mandatory Condition" of
                WFMandatoryFields."Mandatory Condition"::"Field Only":
                    FieldRef.TestField();
                WFMandatoryFields."Mandatory Condition"::"Related Table Only":
                    CheckMandatoryForRelationTable(RecRef.Number, FieldRef.Number, RecRef);
                WFMandatoryFields."Mandatory Condition"::Both:
                    begin
                        FieldRef.TestField();
                        CheckMandatoryForRelationTable(RecRef.Number, FieldRef.Number, RecRef);
                    end;
            end;
        until WFMandatoryFields.Next() = 0;
    end;

    local procedure CheckMandatoryForRelationTable(TableNo: Integer; FIeldNo: Integer; ParentRecRef: RecordRef)
    var
        Field: Record Field;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        Keyref: KeyRef;
        i: Integer;
    begin
        Field.Get(TableNo, FIeldNo);
        RecRef.Open(Field.RelationTableNo);
        Keyref := RecRef.KeyIndex(1);
        if Keyref.FieldCount > 1 then
            for i := 1 to Keyref.FieldCount do begin
                FieldRef := Keyref.FieldIndex(i);
                if FieldRef.Relation = ParentRecRef.Number then
                    FieldRef.SetRange(ParentRecRef.field(1).Value);
            end;
        if RecRef.IsEmpty then
            Error('Related table %1 is empty', RecRef.Caption)
        else begin
            RecRef.FindSet();
            repeat
                MandatoryFieldWorkflowResponse(RecRef);
            until RecRef.Next() = 0;
        end;
    end;

    local procedure MandatoryAttachmentWorkflowResponse(Variant: Variant)
    var
        DocAttachment: Record "Document Attachment";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        recRef.GetTable(Variant);
        case recRef.Number of
            DATABASE::"Purchase Header",
            DATABASE::"Sales Header":
                begin
                    FieldRef := recRef.Field(3);
                    DocAttachment.SetRange("Table ID", recRef.Number);
                    DocAttachment.SetRange("No.", FieldRef.Value);
                    if DocAttachment.IsEmpty then
                        Error('No attachment found for %1 %2', recRef.Caption, FieldRef.Value);
                end;
            Database::"Transfer Header",
            Database::"Warehouse Receipt Header":
                Begin
                    FieldRef := recRef.Field(1);
                    DocAttachment.SetRange("Table ID", recRef.Number);
                    DocAttachment.SetRange("No.", FieldRef.Value);
                    if DocAttachment.IsEmpty then
                        Error('No attachment found for %1 %2', recRef.Caption, FieldRef.Value);
                end;
        end;
    end;

}