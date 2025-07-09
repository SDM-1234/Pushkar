namespace Pushkar.Pushkar;

using Microsoft.Warehouse.GateEntry;
using Microsoft.Sales.History;

tableextension 50103 GateEntryLine extends "Gate Entry Line"
{
    fields
    {
        modify("Source No.")
        {
            trigger OnAfterValidate()
            var
                SalesShipmentHeader: Record "Sales Shipment Header";
            begin
                If "Source Type" = "Source Type"::"Sales Shipment" then
                    if SalesShipmentHeader.Get("Source No.") then begin
                        Rec.Validate("Challan No.", SalesShipmentHeader."Posted Sales Invoice No.");
                        Rec.Validate("Challan Date", SalesShipmentHeader."Sales Invoice Posting Date");
                        If not Rec.Insert() then
                            Rec.Modify()
                    end;

            end;
        }

    }
}
