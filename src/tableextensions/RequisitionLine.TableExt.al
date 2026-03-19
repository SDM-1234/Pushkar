namespace Pushkar.Pushkar;

using Microsoft.Inventory.Requisition;
using System.Automation;

tableextension 50113 RequisitionLine extends "Requisition Line"
{
    fields
    {
        field(50000; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            editable = false;
            ToolTip = 'Specifies the approval status for Transfer Header.';
            Initvalue = Open;
        }

    }
}
