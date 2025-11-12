namespace Pushkar.Pushkar;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;

pageextension 50113 PostedPurchaseInvoiceLines extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Name"; VendorName)
            {
                ApplicationArea = all;
                ToolTip = 'Name of the vendor.';
                Caption = 'Vendor Name';
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if REC."Buy-from Vendor No." <> '' then
            VendorName := GetVendorName(REC."Buy-from Vendor No.");
    end;

    var
        VendorName: Text[100];

    local procedure GetVendorName(VendorNo: Code[20]): Text[100]
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorNo) then
            exit(Vendor.Name)
        else
            exit('');
    end;
}