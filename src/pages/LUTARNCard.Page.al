page 50112 "LUT/ARN Card"
{
    ApplicationArea = All;
    Caption = 'LUT/ARN Card';
    PageType = Card;
    SourceTable = "LUT / ARN Master";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
