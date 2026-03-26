codeunit 50117 "Sales Order Planning Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnBeforeCheckRequsitionLineQuantity, '', false, false)]
    local procedure "Req. Wksh.-Make Order_OnBeforeCheckRequsitionLineQuantity"(var RequisitionLine: Record "Requisition Line"; var PurchOrderLine: Record "Purchase Line"; var SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        if RequisitionLine."Sales Order Planning" then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnBeforePurchOrderLineInsert, '', false, false)]
    local procedure "Req. Wksh.-Make Order_OnBeforePurchOrderLineInsert"(var PurchOrderHeader: Record "Purchase Header"; var PurchOrderLine: Record "Purchase Line"; var ReqLine: Record "Requisition Line"; CommitIsSuppressed: Boolean)
    begin
        if ReqLine."Sales Order Planning" then
            PurchOrderLine."Drop Shipment" := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnAfterInsertPurchOrderLine, '', false, false)]
    local procedure "Req. Wksh.-Make Order_OnAfterInsertPurchOrderLine"(var PurchOrderLine: Record "Purchase Line"; var NextLineNo: Integer; var RequisitionLine: Record "Requisition Line"; var PurchOrderHeader: Record "Purchase Header")
    var
        SalesLine: Record "Sales Line";
        FromReservation, ToReservation : Record "Reservation Entry";
        FromTrackingSpecification: Record "Tracking Specification";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservationStatus: Enum "Reservation Status";
    begin
        if not RequisitionLine."Sales Order Planning" then
            exit;
        if not SalesLine.get(SalesLine."Document Type"::Order,
                        RequisitionLine."Sales Order No.", RequisitionLine."Sales Order Line No.") then
            exit;
        FromReservation.SetSource(Database::"Purchase Line", PurchOrderLine."Document Type".AsInteger()
            , PurchOrderLine."Document No.", PurchOrderLine."Line No.", '', 0);
        ToReservation.SetSource(Database::"Sales Line", SalesLine."Document Type".AsInteger()
            , SalesLine."Document No.", SalesLine."Line No.", '', 0);

        CreateReservEntry.CreateReservEntryFor(
          FromReservation."Source Type", FromReservation."Source Subtype", FromReservation."Source ID",
          FromReservation."Source Batch Name", FromReservation."Source Prod. Order Line", FromReservation."Source Ref. No.",
          FromReservation."Qty. per Unit of Measure", PurchOrderLine.Quantity, PurchOrderLine."Quantity (Base)",
          FromReservation);

        FromTrackingSpecification.SetSourceFromReservEntry(ToReservation);
        FromTrackingSpecification."Qty. per Unit of Measure" := ToReservation."Qty. per Unit of Measure";
        FromTrackingSpecification.CopyTrackingFromReservEntry(ToReservation);
        FromTrackingSpecification."Expiration Date" := ToReservation."Expiration Date";
        CreateReservEntry.CreateReservEntryFrom(FromTrackingSpecification);
        CreateReservEntry.SetApplyFromEntryNo(FromReservation."Appl.-from Item Entry");
        CreateReservEntry.SetApplyToEntryNo(FromReservation."Appl.-to Item Entry");
        CreateReservEntry.SetUntrackedSurplus(ToReservation."Untracked Surplus");


        CreateReservEntry.CreateEntry(
            SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code",
            SalesLine.Description, PurchOrderLine."Expected Receipt Date", SalesLine."Shipment Date",
             0, ReservationStatus::Reservation);
    end;
}