namespace Pushkar.Pushkar;

using Microsoft.Warehouse.GateEntry;

pageextension 50124 PostedOutwardGateEntry extends "Posted Outward Gate Entry"
{
    actions
    {
        // Add changes to page actions here
        addfirst("Processing")
        {
            action("Print Gate Entry")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                begin
                    recPostGateEntHead.Reset();
                    recPostGateEntHead.SetRange("No.", rec."No.");
                    if recPostGateEntHead.FindFirst() then
                        Report.Run(50104, true, false, recPostGateEntHead);
                end;
            }
        }
    }
    var
        recPostGateEntHead: Record "Posted Gate Entry Header";
}
