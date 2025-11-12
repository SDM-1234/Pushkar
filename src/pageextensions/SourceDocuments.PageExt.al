namespace Pushkar.Pushkar;

using Microsoft.Warehouse.Request;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Document;
using Microsoft.Manufacturing.Family;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;

pageextension 50109 SourceDocuments extends "Source Documents"
{

    Layout
    {
        addafter("Destination No.")
        {
            field("Destination Name"; DestinationName)
            {
                ApplicationArea = All;
                ToolTip = 'Name of the destination. The name is assigned to the destination in the "Destination" field on the "Source Document" page.';
                Editable = false;
                Caption = 'Destination Name';
                ShowCaption = true;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Item: Record Item;
        Location: Record Location;
        Family: Record Family;
        SalesOrder: Record "Sales Header";
    begin
        case Rec."Destination Type" of
            Rec."Destination Type"::Customer:
                if Customer.Get(Rec."Destination No.") then
                    DestinationName := Customer.Name
                else
                    DestinationName := '';
            Rec."Destination Type"::Vendor:
                if Vendor.Get(Rec."Destination No.") then
                    DestinationName := Vendor.Name
                else
                    DestinationName := '';
            Rec."Destination Type"::Location:
                if Location.Get(Rec."Destination No.") then
                    DestinationName := Location.Name
                else
                    "DestinationName" := '';
            Rec."Destination Type"::Item:
                if Item.Get(Rec."Destination No.") then
                    "DestinationName" := Item.Description
                else
                    DestinationName := '';
            Rec."Destination Type"::Family:
                if Family.Get(Rec."Destination No.") then
                    DestinationName := Family.Description
                else
                    DestinationName := '';
            Rec."Destination Type"::"Sales Order":
                if SalesOrder.Get(SalesOrder."Document Type"::Order, Rec."Destination No.") then
                    DestinationName := SalesOrder."Sell-to Customer Name"
                else
                    DestinationName := '';
            else
                DestinationName := '';
        end;
    end;


    var
        DestinationName: Text[100];
}
