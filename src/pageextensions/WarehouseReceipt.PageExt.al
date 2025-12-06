namespace Pushkar.Pushkar;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Document;
    
pageextension 50110 WarehouseReceipt extends "Warehouse Receipt"
{
    layout
    {
        addafter("Vendor Shipment No.")
        {
            field("Destination Name"; DestinationName)
            {
                ApplicationArea = All;
                ToolTip = 'Name of the destination. The name is assigned to the destination in the "Destination" field on the "Source Document" page.';
                Editable = false;
                ShowCaption = true;
                Caption = 'DestinationName';
            }

        }

    }
    trigger OnAfterGetRecord()
    var
        WarehouseRcptLine: Record "Warehouse Receipt Line";
        PurchaseOrder: Record "Purchase Header";
        SalesOrder: Record "Sales Header";
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        // Filter Warehouse Receipt Line by the current Warehouse Receipt No.
        WarehouseRcptLine.SetRange("No.", Rec."No.");
        if WarehouseRcptLine.FindFirst() then;
        case WarehouseRcptLine."Source Document" of
            WarehouseRcptLine."Source Document"::"Purchase Order":
                if PurchaseOrder.Get(PurchaseOrder."Document Type"::Order, WarehouseRcptLine."Source No.") then
                    if Vendor.Get(PurchaseOrder."Buy-from Vendor No.") then
                        DestinationName := Vendor.Name
                    else
                        DestinationName := '';
            WarehouseRcptLine."Source Document"::"Sales Order":
                if SalesOrder.Get(SalesOrder."Document Type"::Order, WarehouseRcptLine."Source No.") then
                    if Customer.Get(SalesOrder."Sell-to Customer No.") then
                        DestinationName := Customer.Name
                    else
                        DestinationName := '';
            else
                DestinationName := '';
        end;
    end;

    var
        DestinationName: Text[100];
}