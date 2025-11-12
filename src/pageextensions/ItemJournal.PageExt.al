namespace Pushkar.Pushkar;

using Microsoft.Inventory.Journal;

pageextension 50130 ItemJournal extends "Item Journal"
{
    layout
    {
        modify("Unit of Measure Code")
        {
            Editable = true;
        }

        addafter("Unit of Measure Code")
        {
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.', Comment = '%';
            }
        }
    }
}
