namespace Pushkar.Pushkar;

using Microsoft.Purchases.Reports;
using Microsoft.Finance.TDS.TDSBase;

reportextension 50101 VendorPaymentReceipt extends "Vendor - Payment Receipt"
{
    dataset
    {
        add(VendLedgEntry1)
        {
            column(ExternalDocumentNo_VLE1; "External Document No.")
            {
                IncludeCaption = true;
            }
            column(DocumentDate_VLE1; "Document Date")
            {
                IncludeCaption = true;
            }
            column(TDSAmount_VLE1; TDSAmount)
            {
            }
            column(TDSSection_VLE1; TDSSection)
            {
            }

        }
        modify(VendLedgEntry1)
        {
            trigger OnAfterAfterGetRecord()
            var
                TDSEntry: Record "TDS Entry";
            begin
                TDSEntry.SetRange("Document No.", VendLedgEntry1."Document No.");
                If TDSEntry.findfirst() then begin
                    TDSAmount := TDSEntry."TDS Amount";
                    TDSSection := TDSEntry.Section;
                end;
            end;
        }


    }




    rendering
    {
        layout(VendorPaymentRcpt)
        {
            Type = RDLC;
            LayoutFile = 'src/reportlayouts/VendorPaymentReceipt.rdl';
        }
    }


    var
        TDSAmount: Decimal;
        TDSSection: Code[20];

}
