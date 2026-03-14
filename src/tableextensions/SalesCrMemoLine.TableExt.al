namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GST.Base;
using Microsoft.Finance.TCS.TCSBase;
using Microsoft.Sales.History;

tableextension 50116 SalesCrMemoLine extends "Sales Cr.Memo Line"
{
    fields
    {

        field(50100; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Credit Memo")));
            ToolTip = 'Specifies the value of the GST Amount field.', Comment = '%';
        }
        field(50101; "TCS Amount"; Decimal)
        {
            Caption = 'TCS Amount';
            FieldClass = FlowField;
            CalcFormula = sum("TCS Entry"."TCS Amount" where("Document No." = field("Document No."), "Document Type" = const("Credit Memo")));
            ToolTip = 'Specifies the value of the TCS Amount field.', Comment = '%';
        }
        field(50102; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Reference Invoice No." where("No." = field("Document No.")));
            ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
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
            ToolTip = 'Specifies the value of the Sales Account field.', Comment = '%';
        }
        field(50105; "Sales Account Name"; Text[100])
        {
            Caption = 'Sales Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Sales Account")));
            ToolTip = 'Specifies the value of the Sales Account Name field.', Comment = '%';
        }
        field(50106; "HSN Code"; Code[10])
        {
            Caption = 'HSN Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Detailed GST Ledger Entry"."HSN/SAC Code" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Credit Memo")));
            ToolTip = 'Specifies the value of the HSN Code field.', Comment = '%';
        }

        field(50107; "CGST Amount"; Decimal)
        {
            Caption = 'CGST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Credit Memo"), "GST Component Code" = filter('CGST')));
            ToolTip = 'Specifies the value of the CGST Amount field.', Comment = '%';
        }
        field(50108; "SGST Amount"; Decimal)
        {
            Caption = 'SGST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Credit Memo"), "GST Component Code" = filter('SGST')));
            ToolTip = 'Specifies the value of the SGST Amount field.', Comment = '%';
        }
        field(50109; "IGST Amount"; Decimal)
        {
            Caption = 'IGST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Credit Memo"), "GST Component Code" = filter('IGST')));
            ToolTip = 'Specifies the value of the IGST Amount field.', Comment = '%';
        }
        field(50110; "IRN Hash"; Text[64])
        {
            Caption = 'IRN';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."IRN Hash" where("No." = field("Document No.")));
        }


    }
}
