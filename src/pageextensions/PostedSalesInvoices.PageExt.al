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
                ToolTip = 'Executes the TATA JSON action.';
                //PromotedCategory = Process;
                //Promoted = true;

                trigger OnAction()
                begin
                    objcucomprocess.CreatePostSaleJson(Rec);
                end;
            }

            action(UpdatePostingDate)
            {
                ApplicationArea = All;
                Caption = 'Update Posting Date';
                ToolTip = 'Update Posting Date';
                RunObject = Report "Update Posting Date";
                Gesture = LeftSwipe;
                Ellipsis = true;
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
