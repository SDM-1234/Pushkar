namespace Pushkar.Pushkar;

using Microsoft.Purchases.Reports;

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


}
