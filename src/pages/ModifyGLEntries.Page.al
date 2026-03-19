namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Ledger;

page 50141 "Modify GL Entries"
{
    Caption = 'Modify G/L Entries';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Modify Values';

                field(NewGLAccountNo; NewGLAccountNo)
                {
                    Caption = 'New G/L Account No.';
                    ApplicationArea = All;
                    ToolTip = 'Specify the new G/L account code for selected entries.';
                    TableRelation = "G/L Account"."No.";

                    trigger OnValidate()
                    var
                        GLAccount: Record "G/L Account";
                    begin
                        if NewGLAccountNo <> '' then
                            GLAccount.Get(NewGLAccountNo);

                    end;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OK)
            {
                Caption = 'OK';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // Validation can be added here if needed
                    CurrPage.Close();
                end;
            }

            action(Cancel)
            {
                Caption = 'Cancel';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        SelectedGLEntries: Record "G/L Entry";
        NewGLAccountNo: Code[20];

    procedure SetSelectedEntries(var GLEntries: Record "G/L Entry")
    begin
        SelectedGLEntries.Copy(GLEntries);
    end;

    procedure GetModifiedValues(): Code[20]
    begin
        exit(NewGLAccountNo);
    end;
}