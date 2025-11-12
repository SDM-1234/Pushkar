permissionset 50100 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata WorkOrderRegisterTmp = RIMD,
        table WorkOrderRegisterTmp = X,
        report GatePassOutwardReport = X,
        report InventoryValuationReport = X,
        report "Purchase Order Report" = X,
        report "Tax Invoice Report" = X,
        report "Work Order Report" = X,
        codeunit CommProcess = X,
        codeunit SalesCommonSubscriber = X,
        codeunit TransferOrderMgt = X,
        page "Temp Posted Transfer Shipments" = X;
}