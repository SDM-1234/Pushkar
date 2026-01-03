namespace Pushkar.Pushkar;

using System.Automation;
using Microsoft.Inventory.Requisition;

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
