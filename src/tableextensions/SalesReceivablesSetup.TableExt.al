namespace Pushkar.Pushkar;

using Microsoft.Sales.Setup;
using Microsoft.Inventory.Requisition;

tableextension 50121 SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Posting Date Method"; Option)
        {
            Caption = 'Posting Date Method';
            OptionMembers = ,Error,Warning;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Posting Date Method field.', Comment = '%';
        }
        field(50101; "Req. Worksheet Template Name"; Code[10])
        {
            Caption = 'Requisition Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(50102; "Req. Journal Batch Name"; Code[10])
        {
            Caption = 'Requisition Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Req. Worksheet Template Name"));
        }

    }
}
