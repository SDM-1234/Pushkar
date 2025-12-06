namespace Pushkar.Pushkar;

using Microsoft.Sales.History;
    
pageextension 50127 PostedSalesInvoices extends "Posted Sales Invoices"
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
