namespace Pushkar.Pushkar;

using Microsoft.Sales.Document;
using Microsoft.Finance.TaxEngine.TaxTypeHandler;

pageextension 50112 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Sell-to Customer Name")
        {
            ApplicationArea = All;
            Visible = true;
            ToolTip = 'Specifies the name of the customer that is associated with the sales order.', Comment = '%';
        }

    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                PrePostValidations();
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                PrePostValidations();
            end;
        }

        modify("Preview Posting")
        {
            trigger OnBeforeAction()
            begin
                PrePostValidations();
            end;
        }

    }


    local procedure PrePostValidations()
    BEGIN

        if Rec."GST Customer Type" IN [Rec."GST Customer Type"::Registered, Rec."GST Customer Type"::Unregistered, Rec."GST Customer Type"::" "] then
            CalculateGSTAmount();
    End;

    local procedure CalculateGSTAmount()
    var
        SalesLine1: Record "Sales Line";
        TaxTrnasactionValue1: Record "Tax Transaction Value";
        TaxTrnasactionValue: Record "Tax Transaction Value";
        GSTCompAmount: array[10] of Decimal;
        GSTCompNo: Integer;
        GSTComponentCode: array[10] of Integer;
        GSTAmountByLineNo: Decimal;
    begin
        SalesLine1.SetCurrentKey("Document No.", "Document Type", "Line No.");
        SalesLine1.SetRange("Document No.", Rec."No.");
        SalesLine1.SetRange("Document Type", Rec."Document Type");
        SalesLine1.SetRange(Type, SalesLine1.Type::"G/L Account");
        if SalesLine1.FindSet() then
            repeat
                GSTAmountByLineNo := 0;
                GSTCompNo := 1;
                TaxTrnasactionValue.Reset();
                TaxTrnasactionValue.SetRange("Tax Record ID", SalesLine1.RecordId);
                TaxTrnasactionValue.SetRange("Tax Type", 'GST');
                TaxTrnasactionValue.SetRange("Value Type", TaxTrnasactionValue."Value Type"::COMPONENT);
                TaxTrnasactionValue.SetFilter(Percent, '<>%1', 0);
                if TaxTrnasactionValue.FindSet() then
                    repeat
                        GSTCompNo := TaxTrnasactionValue."Value ID";
                        GSTComponentCode[GSTCompNo] := TaxTrnasactionValue."Value ID";
                        TaxTrnasactionValue1.Reset();
                        TaxTrnasactionValue1.SetRange("Tax Record ID", SalesLine1.RecordId);
                        TaxTrnasactionValue1.SetRange("Tax Type", 'GST');
                        TaxTrnasactionValue1.SetRange("Value Type", TaxTrnasactionValue1."Value Type"::COMPONENT);
                        TaxTrnasactionValue1.SetRange("Value ID", GSTComponentCode[GSTCompNo]);
                        if TaxTrnasactionValue1.FindSet() then begin
                            repeat
                                GSTCompAmount[GSTCompNo] += TaxTrnasactionValue1."Amount";
                                GSTAmountByLineNo += TaxTrnasactionValue1.Amount;
                            until TaxTrnasactionValue1.Next() = 0;
                            GSTCompNo += 1;
                        end;
                    until TaxTrnasactionValue.Next() = 0;
                if GSTAmountByLineNo = 0 then
                    Error('GST Amount is missing for Document No. %1, Line No. %2. Please verify the GST calculation.', SalesLine1."Document No.", SalesLine1."Line No.");
            until SalesLine1.Next() = 0;
    end;


}
