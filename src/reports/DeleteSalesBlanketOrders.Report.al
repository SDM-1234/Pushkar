report 50110 "DeleteSalesBlanketOrders"
{
    ProcessingOnly = true;
    Caption = 'Delete All Sales Blanket Orders';
    Permissions = tabledata "Sales Header" = RD; // R = Read, D = Delete


    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("No.") where("Document Type" = const("Blanket Order"));
            RequestFilterFields = "No.", "Sell-to Customer No.", "Order Date";

            trigger OnAfterGetRecord()
            begin
                // This ensures we only delete Blanket Orders and nothing else
                if "Document Type" = "Document Type"::"Blanket Order" then begin
                    // Delete(true) triggers the OnDelete trigger of the table, 
                    // which cleans up Sales Lines and related comments.
                    Delete(true);
                    Counter += 1;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    label(WarningLabel)
                    {
                        ApplicationArea = All;
                        Caption = 'WARNING: This report will permanently delete filtered Sales Blanket Orders.';
                        Style = Attention;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Message('%1 Sales Blanket Orders have been deleted.', Counter);
    end;

    var
        Counter: Integer;
}