namespace Pushkar.Pushkar;

using Microsoft.Warehouse.GateEntry;
using Microsoft.Sales.History;

tableextension 50103 GateEntryLine extends "Gate Entry Line"
{
    fields
    {
        modify("Source No.")
        {
            trigger OnAfterValidate()
            begin
            end;
        }



    }
}
