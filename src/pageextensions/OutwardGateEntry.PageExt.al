namespace Pushkar.Pushkar;

using Microsoft.Sales.History;
using Microsoft.Warehouse.GateEntry;
using System.Utilities;

pageextension 50141 OutwardGateEntry extends "Outward Gate Entry"
{


    actions
    {
        addafter("&Gate Entry")
        {

            action(CreateGateEntryLines)
            {
                Image = ShipmentLines;
                ApplicationArea = All;
                Caption = 'Create Gate Entry Lines';
                ToolTip = 'Executes the Create Gate Entry Lines action.';

                trigger OnAction()
                var
                    SalesShipHeader: Record "Sales Shipment Header";
                    GateEntrySubscriber: Codeunit "Gate Entry Subscriber";
                    SingleInstanceCU: Codeunit "SingleInstanceCU";
                    ConfirmMgt: Codeunit "Confirm Management";
                begin

                    SalesShipHeader.Reset();
                    SalesShipHeader.FilterGroup(2);
                    SalesShipHeader.SetRange("Location Code", Rec."Location Code");
                    SalesShipHeader.FilterGroup(0);
                    if Page.RunModal(Page::"Temp Posted Sales Shipments", SalesShipHeader) = Action::LookupOK then begin
                        SalesShipHeader.SetRange("Select for Gate Entry", true);
                        if ConfirmMgt.GetResponseOrDefault('Do you want to create Gate Entry Lines', true) then begin

                            if SalesShipHeader.FindSet() then
                                repeat
                                    GateEntrySubscriber.CreateLines(SalesShipHeader, Rec);
                                until SalesShipHeader.Next() = 0;
                            SingleInstanceCU.SetAllowCreation(false);
                            // Now create Gate Entry Lines for selected Sales Shipments
                        END Else
                            GateEntrySubscriber.ModifyShipmentHeader(SalesShipHeader);
                    end Else begin
                        SalesShipHeader.SetRange("Select for Gate Entry", true);
                        GateEntrySubscriber.ModifyShipmentHeader(SalesShipHeader);
                    end;
                end;
            }
        }
    }
}
