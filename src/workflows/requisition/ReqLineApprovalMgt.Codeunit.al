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
        //RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnBeforeDeleteEvent, '', false, false)]
    local procedure RequisitionLine_OnDeleteModifyEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;





}
