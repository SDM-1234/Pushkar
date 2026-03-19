namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GST.Base;
using Microsoft.Finance.TDS.TDSBase;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;

tableextension 50111 PurchInvLine extends "Purch. Inv. Line"
{
    fields
    {
        field(50100; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const(Invoice)));
            ToolTip = 'Specifies the value of the GST Amount field.';
        }
        field(50101; "TDS Amount"; Decimal)
        {
            Caption = 'TDS Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("TDS Entry"."TDS Amount" where("Document No." = field("Document No."), "Document Type" = const(Invoice)));
            ToolTip = 'Specifies the value of the TDS Amount field.';
        }
        field(50102; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Vendor Invoice No." where("No." = field("Document No.")));
            ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
        }

        field(50103; "Document Date"; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Document Date" where("No." = field("Document No.")));
            ToolTip = 'Specifies the value of the Document Date field.';
        }
        field(50104; "Purch. Account"; Code[20])
        {
            Caption = 'Purchase Account';
            FieldClass = FlowField;
            CalcFormula = lookup("General Posting Setup"."Purch. Account" where("Gen. Bus. Posting Group" = field("Gen. Bus. Posting Group"), "Gen. Prod. Posting Group" = field("Gen. Prod. Posting Group")));
            ToolTip = 'Specifies the value of the Purchase Account field.';
        }
        field(50105; "Purch. Account Name"; Text[100])
        {
            Caption = 'Purchase Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Purch. Account")));
            ToolTip = 'Specifies the value of the Purchase Account Name field.';
        }
        field(50106; "HSN Code"; Code[10])
        {
            Caption = 'HSN Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Detailed GST Ledger Entry"."HSN/SAC Code" where("No." = field("No."), "Document No." = field("Document No."), "Document Type" = const("Invoice")));
            ToolTip = 'Specifies the value of the HSN Code field.', Comment = '%';
        }

        field(50107; "CGST Amount"; Decimal)
        {
            Caption = 'CGST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "HSN/SAC Code" = field("HSN/SAC Code"), "Document No." = field("Document No."), "Document Type" = const("Invoice"), "GST Component Code" = filter('CGST')));
            ToolTip = 'Specifies the value of the CGST Amount field.', Comment = '%';
        }
        field(50108; "SGST Amount"; Decimal)
        {
            Caption = 'SGST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "HSN/SAC Code" = field("HSN/SAC Code"), "Document No." = field("Document No."), "Document Type" = const("Invoice"), "GST Component Code" = filter('SGST')));
            ToolTip = 'Specifies the value of the SGST Amount field.', Comment = '%';
        }
        field(50109; "IGST Amount"; Decimal)
        {
            Caption = 'IGST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "HSN/SAC Code" = field("HSN/SAC Code"), "Document No." = field("Document No."), "Document Type" = const("Invoice"), "GST Component Code" = filter('IGST')));
            ToolTip = 'Specifies the value of the IGST Amount field.', Comment = '%';
        }
        field(50111; "TDS Section"; Code[20])
        {
            Caption = 'TDS Section GL No.';
            FieldClass = FlowField;
            CalcFormula = lookup("TDS Entry"."Account No." where("Document No." = field("Document No."), "Document Type" = const("Invoice")));
            ToolTip = 'Specifies the value of the TDS Section GL No. field.', Comment = '%';
        }
        field(50112; "TDS Section Name"; Text[100])
        {
            Caption = 'TDS Section GL Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."Name" where("No." = field("TDS Section")));
            ToolTip = 'Specifies the value of the TDS Section GL Name field.', Comment = '%';
        }
    }
}
