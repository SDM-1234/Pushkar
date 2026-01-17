namespace Pushkar.Pushkar;

using Microsoft.Sales.History;
    
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

                trigger OnAction()
                begin
                    objcucomprocess.CreatePostSaleJson(Rec);
                end;
            }
        }

        addafter(Statistics)
        {
            Action(BulkEInvoiceResponse)
            {
                ApplicationArea = All;
                Caption = 'Upload Bulk Import E-Invoice Response';
                ToolTip = 'Upload Bulk Import E-Invoice Response';
                Image = Import;
                trigger OnAction()
                var
                    EInvoiceExcelImport: Codeunit "E-Invoice Import Excel";
                begin
                    EInvoiceExcelImport.ImportExcel();
                    CurrPage.Update();
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(BulkAttachment_Promoted; BulkEInvoiceResponse)
            {
            }
            actionref(TATAJSON_Promoted; "TATA JSON")
            {
            }

        }

    }
    var
        objcucomprocess: Codeunit CommProcess;
}
