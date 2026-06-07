/// <summary>
/// Codeunit PurchaseHandler (ID 50118).
/// </summary>
namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GST.Base;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Posting;


codeunit 50112 PurchaseHandler
{

    Permissions = tabledata "Purch. Inv. Line" = RM;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePurchInvLineInsert, '', false, false)]

    local procedure OnBeforePurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line")
    var
        Item: record Item;
        GLAcc: Record "G/L Account";
        FA: Record "Fixed Asset";
        Resource: Record Resource;
        ChargeItem: Record "Item Charge";
    begin
        case PurchInvLine.Type of
            Type::Item:
                if Item.Get(PurchInvLine."No.") then
                    PurchInvLine.Name := Item.Description;
            Type::"G/L Account":
                if GLAcc.Get(PurchInvLine."No.") then
                    PurchInvLine.Name := GLAcc.Name;
            Type::"Fixed Asset":
                if FA.Get(PurchInvLine."No.") then
                    PurchInvLine.Name := FA.Description;
            Type::Resource:
                if Resource.Get(PurchInvLine."No.") then
                    PurchInvLine.Name := Resource.Name;
            Type::"Charge (Item)":
                if ChargeItem.Get(PurchInvLine."No.") then
                    PurchInvLine.Name := ChargeItem.Description;
        end;
    end;



    /// <summary>
    /// UpdateName.
    /// Updating Name on Posted Purchase Inv Lines
    /// <param name="Rec">VAR Record "Purch. Inv. Line".</param>
    procedure UpdateName(var Rec: Record "Purch. Inv. Line")
    var
        Item: record Item;
        GLAcc: Record "G/L Account";
        FA: Record "Fixed Asset";
        Resource: Record Resource;
        ChargeItem: Record "Item Charge";

    begin
        case Rec.Type of
            Type::Item:
                if Item.Get(Rec."No.") then
                    Rec.Name := Item.Description;
            Type::"G/L Account":
                if GLAcc.Get(Rec."No.") then
                    Rec.Name := GLAcc.Name;
            Type::"Fixed Asset":
                if FA.Get(Rec."No.") then
                    Rec.Name := FA.Description;
            Type::Resource:
                if Resource.Get(Rec."No.") then
                    Rec.Name := Resource.Name;
            Type::"Charge (Item)":
                if ChargeItem.Get(Rec."No.") then
                    Rec.Name := ChargeItem.Description;


        end;
        Rec.Modify();
    end;

}