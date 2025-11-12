pageextension 50126 PostedSalesInvoice extends "Posted Sales Invoice"
{
    actions
    {
        // Add changes to page actions here
        addfirst(processing)
        {
            action("TATA JSON")
            {
                ApplicationArea = all;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                begin
                    objcucomprocess.CreatePostSaleJson(Rec);
                end;
            }
        }
    }
    var
        objcucomprocess: Codeunit CommProcess;
}
