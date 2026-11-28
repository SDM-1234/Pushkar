namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.TaxBase;

pageextension 50147 "Bank Receipt Voucher Advice" extends "Bank Receipt Voucher"
{
    actions
    {
        addlast(Processing)
        {
            action(ImportPaymentAdvice)
            {
                ApplicationArea = All;
                Caption = 'Import Payment Advice';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Upload an Excel workbook or CSV payment advice. The import reads the Invoice Number and Invoice Amount columns and applies them to this customer receipt.';

                trigger OnAction()
                var
                    AdviceImport: Codeunit "Bank Receipt Advice Import";
                begin
                    AdviceImport.ImportAndApply(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
