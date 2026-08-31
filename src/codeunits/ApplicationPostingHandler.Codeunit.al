

namespace Pushkar.Pushkar;

using Microsoft.Purchases.Payables;
using Microsoft.Sales.Receivables;

codeunit 50109 ApplicationPostingHandler
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters, '', false, false)]
    local procedure OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters(var IsHandled: Boolean);
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        IsHandled := SingleInstanceCU.GetIsHandled();
    end;


    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", OnBeforeSetApplyingCustLedgerEntry, '', false, false)]
    local procedure OnBeforeSetApplyingCustLedgEntry(var ApplyingCustLedgEntry: Record "Cust. Ledger Entry");
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        ApplyingCustLedgEntry := SingleInstanceCU.GetApplicationCustLedgerEntryParameters();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnApplyVendEntryFormEntryOnAfterVendLedgEntrySetFilters, '', false, false)]
    local procedure OnApplyVendEntryFormEntryOnAfterVendLedgEntrySetFilters(var IsHandled: Boolean);
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        IsHandled := SingleInstanceCU.GetIsHandled();
    end;


    [EventSubscriber(ObjectType::Page, Page::"Apply Vendor Entries", OnBeforeSetApplyingVendLedgEntry, '', false, false)]
    local procedure OnBeforeSetApplyingVendLedgEntry(var ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; var CalcType: Enum "Vendor Apply Calculation Type");
    var
        SingleInstanceCU: Codeunit SingleInstanceCU;
    begin
        ApplyingVendLedgEntry := SingleInstanceCU.GetApplicationVendLedgerEntryParameters();
    end;

}