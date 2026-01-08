namespace Pushkar.Pushkar;

using Microsoft.Sales.Customer;

pageextension 50133 CustomerCardExtPTPL extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Supplier Code"; Rec."Supplier Code")
            {
                ApplicationArea = All;
                Caption = 'Supplier Code';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }
}