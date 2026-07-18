namespace Pushkar.Pushkar;

using Microsoft.Inventory.Item;
using System.Automation;

pageextension 50134 ItemCard extends "Item Card"
{
    layout
    {

    }


    trigger OnOpenPage()
    var
        ApprovalEntry: Record "Approval Entry";

    begin
        ApprovalEntry.SetCurrentKey("Table ID");
        ApprovalEntry.SetRange("Table ID", DATABASE::Item);
        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordID);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::"Pending Approval", ApprovalEntry.Status::Approved, ApprovalEntry.Status::Open);
        if Not ApprovalEntry.IsEmpty() then
            CurrPage.Editable := False;
    end;

    trigger OnAfterGetRecord()
    var
        ApprovalEntry: Record "Approval Entry";

    begin
        ApprovalEntry.SetCurrentKey("Table ID");
        ApprovalEntry.SetRange("Table ID", DATABASE::Item);
        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordID);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::"Pending Approval", ApprovalEntry.Status::Approved, ApprovalEntry.Status::Open);
        if Not ApprovalEntry.IsEmpty() then
            CurrPage.Editable := False;
    end;
}
