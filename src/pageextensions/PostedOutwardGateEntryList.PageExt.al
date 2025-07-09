pageextension 50125 PostedOutwardGateEntryList extends "Posted Outward Gate Entry List"
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
                    if recPostGateEntHead.FindFirst() then Report.Run(50000, true, false, recPostGateEntHead);
                end;
            }
        }
    }
    var
        myInt: Integer;
        recPostGateEntHead: Record "Posted Gate Entry Header";
}
