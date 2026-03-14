
page 50111 "LUT ARN List"
{
    ApplicationArea = All;
    Caption = 'LUT ARN List';
    PageType = List;
    SourceTable = "LUT / ARN Master";
    UsageCategory = Lists;
    CardPageId = "LUT/ARN Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                }
                field("ARN / LUT No."; Rec."ARN / LUT No.")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
            }
        }
    }
}
