namespace Pushkar.Pushkar;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Sales.Receivables;

page 50104 CustomerApplicationPosting
{
    ApplicationArea = All;
    Caption = 'Customer Application Posting';
    PageType = List;
    SourceTable = DtldCustomerLedgerEntry;
    UsageCategory = Tasks;
    Permissions = TableData "Cust. Ledger Entry" = rm;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Cust. Ledger Entry No. field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                }
                field("Customer Ledger Entry No."; Rec."Customer Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Customer Ledger Entry No. field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Dtld. Cust. Ledger Entry No."; Rec."Dtld. Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Dtld. Cust. Ledger Entry No. field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.', Comment = '%';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of the Error Text field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ClearAppliestoID)
            {
                ApplicationArea = All;
                Caption = 'Clear Applies-to ID';
                Image = ClearLog;

                trigger OnAction()
                var
                    CustomerLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustomerLedgerEntry.SetRange("Applies-to ID", UserID());
                    CustomerLedgerEntry.ModifyAll("Applies-to ID", '');
                end;
            }
            action(EnableApplyLedgerEntriesPage)
            {
                ApplicationArea = All;
                Caption = 'Enable Apply Ledger Entries Page';
                Image = EnableAllBreakpoints;

                trigger OnAction()
                var
                    SingleInstanceCU: Codeunit SingleInstanceCU;
                begin
                    SingleInstanceCU.SetIsHandled(false);
                end;
            }
            action(PostApplication)
            {
                ApplicationArea = All;
                Caption = 'Post Application';
                Image = PostApplication;

                trigger OnAction()
                var
                    DtldCustLedENtry2: Record DtldCustomerLedgerEntry;//Application
                    DtldCustLedENtry3: Record DtldCustomerLedgerEntry;//Invoice
                    DtldCustLedENtry: Record DtldCustomerLedgerEntry;
                    ApplicationPostingMgt: Codeunit ApplicationPostingMgt;
                    ApplicationPostingDate: Date;
                    ProgressWindow: Dialog;
                    TotalRecords: Integer;
                    CurrentRecord: Integer;
                    ProgressPercent: Integer;
                    Text0001Tok: Label 'Posting Detailed Application...\\Processing Entry: #1###### of #2###### of #3######)';
                begin


                    DtldCustLedEntry.Reset();
                    DtldCustLedEntry.SetRange(Closed, false);
                    DtldCustLedEntry.SetFilter("Document Type", '%1|%2', DtldCustLedEntry."Document Type"::Payment, DtldCustLedEntry."Document Type"::" ");

                    TotalRecords := DtldCustLedEntry.Count();
                    if TotalRecords = 0 then
                        exit;
                    ProgressWindow.Open(Text0001Tok);
                    if DtldCustLedEntry.FindSet() then
                        repeat
                            DtldCustLedEntry2.Reset();
                            DtldCustLedEntry2.SetRange(Closed, false);
                            DtldCustLedEntry2.SetRange("Customer No.", DtldCustLedEntry."Customer No.");
                            DtldCustLedEntry2.SetRange("Applied Cust. Ledger Entry No.", DtldCustLedEntry."Customer Ledger Entry No.");
                            if DtldCustLedEntry2.FindSet() then
                                repeat
                                    ApplicationPostingDate := DtldCustLedEntry2."Posting Date";
                                    DtldCustLedEntry3.Reset();
                                    DtldCustLedEntry3.SetRange(Closed, false);
                                    DtldCustLedEntry3.SetRange("Customer No.", DtldCustLedENtry2."Customer No.");
                                    DtldCustLedEntry3.SetRange("Customer Ledger Entry No.", DtldCustLedENtry2."Customer Ledger Entry No.");
                                    //DtldCustLedEntry3.SetFilter("Document Type",'%1|%2', DtldCustLedENtry3."Document Type"::Invoice,DtldCustLedENtry3."Document Type"::"Credit Memo");//, );
                                    DtldCustLedEntry3.Setrange("Document Type", DtldCustLedENtry3."Document Type"::Invoice);//, DtldCustLedENtry3."Document Type"::"Credit Memo");
                                    DtldCustLedEntry3.SetRange("Entry Type", 'Initial Entry');
                                    if DtldCustLedEntry3.findfirst() then
                                        if DtldCustLedENtry3."Customer Ledger Entry No." <> DtldCustLedENtry2."Applied Cust. Ledger Entry No." then begin

                                            CurrentRecord += 1;

                                            if CurrentRecord mod 10 = 0 then begin
                                                // 2. Update Window values
                                                // Calculate percentage for progress bar (#3)
                                                ProgressPercent := Round((CurrentRecord / TotalRecords) * 10000, 1, '>');

                                                ProgressWindow.Update(1, CurrentRecord);
                                                ProgressWindow.Update(2, TotalRecords);
                                                ProgressWindow.Update(3, ProgressPercent);
                                            end;
                                            ApplicationPostingMgt.PostApplication(DtldCustLedENtry3,DtldCustLedEntry,ApplicationPostingDate);

                                            ApplicationPostingMgt.Run() // 
                                        end;
                                until DtldCustLedEntry2.Next() = 0;

                        until DtldCustLedENtry.Next() = 0;

                    // 3. Close Progress Window
                    ProgressWindow.Close();

                    Message('Detailed application posting completed successfully.');
                end;
            }
        }
    }
}
