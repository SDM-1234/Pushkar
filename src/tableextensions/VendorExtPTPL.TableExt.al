tableextension 50149 VendorExtPTPL extends Vendor
{
    fields
    {
        field(50100; "Approval Status"; Enum ItemApprovalStatus)
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}
