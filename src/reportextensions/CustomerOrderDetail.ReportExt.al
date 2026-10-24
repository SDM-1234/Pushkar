namespace Pushkar.Pushkar;

using Microsoft.Sales.Reports;

reportextension 50106 CustomerOrderDetail extends "Customer - Order Detail"
{
    dataset
    {
        add("Sales Header")
        {
            column(ExternalDocumentNo; "External Document No.")
            {
            }
        }
        add("Sales Line")
        {
            column(PlannedDeliveryDate; "Planned Delivery Date")
            {
            }
        }
    }



    rendering
    {
        layout(CustomerOrderDetail)
        {
            Type = RDLC;
            LayoutFile = 'src/reportlayouts/CustomerOrderDetail.rdl';
        }
    }

}
