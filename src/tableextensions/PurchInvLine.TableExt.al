namespace Pushkar.Pushkar;

using Microsoft.Purchases.History;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Finance.TDS.TDSBase;
using Microsoft.Finance.GST.Base;
using Microsoft.Finance.GeneralLedger.Account;

tableextension 50111 PurchInvLine extends "Purch. Inv. Line"
{
    fields
    {
        field(50100; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const(Invoice)));
        }
        field(50101; "TDS Amount"; Decimal)
        {
            Caption = 'TDS Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("TDS Entry"."TDS Amount" where("Document No." = field("Document No."), "Document Type" = const(Invoice)));
        }
        field(50102; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Vendor Invoice No." where("No." = field("Document No.")));
        }

        field(50103; "Document Date"; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Document Date" where("No." = field("Document No.")));
        }
        field(50104; "Purch. Account"; Code[20])
        {
            Caption = 'Purchase Account';
            FieldClass = FlowField;
            CalcFormula = lookup("General Posting Setup"."Purch. Account" where("Gen. Bus. Posting Group" = field("Gen. Bus. Posting Group"), "Gen. Prod. Posting Group" = field("Gen. Prod. Posting Group")));
        }
        field(50105; "Purch. Account Name"; Text[100])
        {
            Caption = 'Purchase Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Purch. Account")));
        }

    }
}
