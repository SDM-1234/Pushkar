namespace Pushkar.Pushkar;

using Microsoft.Sales.History;
using Microsoft.Warehouse.GateEntry;

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
