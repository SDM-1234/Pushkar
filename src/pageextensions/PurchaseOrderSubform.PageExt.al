namespace Pushkar.Pushkar;

using Microsoft.Purchases.Document;

pageextension 50128 PurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {

            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.', Comment = '%';
                Editable = true;
                Visible = true;
            }
        }
    }
}
