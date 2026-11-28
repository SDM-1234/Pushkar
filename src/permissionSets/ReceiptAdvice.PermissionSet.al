namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.Attachment;
using Microsoft.Sales.Receivables;

permissionset 50148 "Receipt Advice"
{
    Assignable = true;
    Permissions =
        tabledata "Cust. Ledger Entry" = RM,
        tabledata "Gen. Journal Line" = RM,
        tabledata "Document Attachment" = RIMD,
        codeunit "Bank Receipt Advice Import" = X;
}
