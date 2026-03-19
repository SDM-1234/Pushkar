
namespace Pushkar.Pushkar;

using Microsoft.Inventory.Location;

table 50114 "LUT / ARN Master"
{
    Caption = 'LUT / ARN Master';
    DataClassification = CustomerContent;
    DrillDownPageId = "LUT ARN List";
    LookupPageId = "LUT/ARN Card";

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
            ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
        }
        field(3; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
        }
        field(4; "ARN / LUT No."; Code[50])
        {
            Caption = 'ARN / LUT No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the ARN / LUT No. field.', Comment = '%';
        }
    }
    keys
    {
        key(PK; "Location Code", "Start Date", "End Date", "ARN / LUT No.")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// GetARNNo.
    /// </summary>
    /// <param name="PostingDate">Date.</param>
    /// <param name="LocCode">Code[10].</param>
    /// <returns>Return value of type Code[50].</returns>
    procedure GetARNNo(PostingDate: Date; LocCode: Code[10]): Code[50]
    begin
        Rec.setFilter("Start Date", '<=%1', PostingDate);
        Rec.setFilter("End Date", '>=%1', PostingDate);
        Rec.SetRange("Location Code", LocCode);
        if Rec.FindFirst() then
            exit("ARN / LUT No.")
    end;
}
