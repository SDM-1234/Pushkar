namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GST.Base;
using Microsoft.Finance.TDS.TDSBase;
using Microsoft.Sales.History;

tableextension 50117 SalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {


        field(50100; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Invoice")));
        }
        field(50101; "TDS Amount"; Decimal)
        {
            Caption = 'TDS Amount';
            FieldClass = FlowField;
            CalcFormula = sum("TDS Entry"."TDS Amount" where("Document No." = field("Document No."), "Document Type" = const("Invoice")));
        }
        field(50102; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Reference Invoice No." where("No." = field("Document No.")));
        }

        field(50103; "Document Date"; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Document Date" where("No." = field("Document No.")));
        }
        field(50104; "Sales Account"; Code[20])
        {
            Caption = 'Sales Account';
            FieldClass = FlowField;
            CalcFormula = lookup("General Posting Setup"."Sales Account" where("Gen. Bus. Posting Group" = field("Gen. Bus. Posting Group"), "Gen. Prod. Posting Group" = field("Gen. Prod. Posting Group")));
        }
        field(50105; "Sales Account Name"; Text[100])
        {
            Caption = 'Sales Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Sales Account")));
        }




    }
}
