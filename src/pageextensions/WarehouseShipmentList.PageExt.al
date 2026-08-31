namespace Pushkar.Pushkar;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Document;

pageextension 50118 WarehouseShipmentList extends "Warehouse Shipment List"
{
    Layout
    {
        addafter("Shipment Date")
        {
            field(DestinationName; DestinationName)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Destination Name field.', Comment = '%';
                Caption = 'DestinationName';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        WarehouseShipmentLine: record "Warehouse Shipment Line";
        SalesOrder: Record "Sales Header";
        PurchaseOrder: Record "Purchase Header";
        Vendor: Record Vendor;
        Customer: record Customer;
    begin
        WarehouseShipmentLine.SetRange("No.", Rec."No.");
        if WarehouseShipmentLine.FindFirst() then;
        case WarehouseShipmentLine."Source Document" of
            WarehouseShipmentLine."Source Document"::"Purchase Order":
                if PurchaseOrder.Get(PurchaseOrder."Document Type"::Order, WarehouseShipmentLine."Source No.") then
                    if Vendor.Get(PurchaseOrder."Buy-from Vendor No.") then
                        DestinationName := Vendor.Name
                    else
                        DestinationName := '';
            WarehouseShipmentLine."Source Document"::"Sales Order":
                if SalesOrder.Get(SalesOrder."Document Type"::Order, WarehouseShipmentLine."Source No.") then
                    if Customer.Get(SalesOrder."Sell-to Customer No.") then
                        DestinationName := Customer.Name
                    else
                        DestinationName := '';
            else
                DestinationName := '';
        end;
    end;

    var
        DestinationName: Text[100]; // Define the DestinationName variable
}
