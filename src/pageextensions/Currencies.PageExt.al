namespace Pushkar.Pushkar;

using Microsoft.Finance.Currency;


pageextension 50113 Currencies extends Currencies
{
    layout
    {
        addafter("EMU Currency")
        {
            field("Currency Numeric Description"; Rec."Currency Numeric Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Currency Numeric Description.';
                Editable = true;
                Visible = true;
            }
            field("Currency Decimal Description"; Rec."Currency Decimal Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Currency Decimal Description.';
                Editable = true;
                Visible = true;
            }
        }
    }
}
