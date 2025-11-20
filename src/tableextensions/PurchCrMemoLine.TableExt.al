namespace Pushkar.Pushkar;

using Microsoft.Purchases.History;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Finance.TDS.TDSBase;
using Microsoft.Finance.GST.Base;

tableextension 50112 PurchCrMemoLine extends "Purch. Cr. Memo Line"
{


    fields
    {
        field(50100; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            FieldClass = FlowField;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST Amount" where("Document Line No." = field("Line No."), "Document No." = field("Document No."), "Document Type" = const("Credit Memo")));
        }
        field(50101; "TDS Amount"; Decimal)
        {
            Caption = 'TDS Amount';
            FieldClass = FlowField;
            CalcFormula = lookup("TDS Entry"."TDS Amount" where("Document No." = field("Document No."), "Document Type" = const("Credit Memo")));
        }
        field(50102; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Cr Memo No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No." where("No." = field("Document No.")));
        }

        field(50103; "Document Date"; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."Document Date" where("No." = field("Document No.")));
        }
        field(50104; "Purch. Account"; Code[20])
        {
            Caption = 'Purchase Account';
            FieldClass = FlowField;
            CalcFormula = lookup("General Posting Setup"."Purch. Account" where("Gen. Bus. Posting Group" = field("Gen. Bus. Posting Group"), "Gen. Prod. Posting Group" = field("Gen. Prod. Posting Group")));
        }
    }

}
