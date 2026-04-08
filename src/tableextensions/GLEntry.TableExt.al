namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Purchases.Payables;

tableextension 50122 GLEntry extends "G/L Entry"
{
    fields
    {
        field(50100; "Application Document No."; Code[20])
        {
            Caption = 'Application Document No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Ledger Entry"."Document No." where("Closed By Entry No." = field("Entry No."), "Document Type" = filter(Invoice)));
        }
    }
}
