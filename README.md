# Pushkar

## Bank receipt payment-advice import

Assign the **Receipt Advice** permission set to users who will use the import. No OCR service or credentials are required. The Bank Receipt Voucher import accepts an Excel workbook (`.xlsx`) or a comma-separated CSV. It searches the selected workbook sheet or CSV for the invoice table header. The table must include `Invoice Number` and `Invoice Amount` (for example, `Invoice Amount (Rs.)`); other columns such as `Sr No.`, `Invoice Date`, and `FI Document No.` may also be present.

On a Bank Receipt Voucher customer line, choose **Import Payment Advice** and select the Excel or CSV file. For workbooks with multiple sheets, select the sheet containing the invoice table. The importer reads invoice numbers and amounts, combines repeated rows for the same document, and skips blank rows. Negative amounts (including trailing-minus formats such as `6,612.53-`) are applied to open credit memos; positive amounts are applied to open invoices. It sets **Amount to Apply**, attaches the original file to the journal line, and updates the receipt amount to the net sum. Review the applications and amount before posting. The import stops with an error if it cannot identify the required columns, if an invoice/credit memo is missing or ambiguous, or if amounts/currencies do not match.
