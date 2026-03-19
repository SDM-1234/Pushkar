namespace Pushkar.Pushkar;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Account;
using System.Security.User;

pageextension 50140 GeneralLedgerEntries extends "General Ledger Entries"
{
    actions
    {

        addafter("F&unctions")
        {

            action(ModifyGLEntries)
            {
                Caption = 'Modify G/L Entries';
                Image = Edit;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GLAccount: Record "G/L Account";
                    SelectedGLEntries: Record "G/L Entry";
                    UserSetup: Record "User Setup";
                    ModifyGLEntriesPage: Page "Modify GL Entries";
                    ModifiedCount: Integer;
                begin
                    // Check user permission
                    UserSetup.Get(UserId());
                    if not UserSetup."Modify G/L Entries" then
                        Error('You do not have permission to modify G/L entries.');

                    // Get selected entries
                    CurrPage.SetSelectionFilter(SelectedGLEntries);
                    if not SelectedGLEntries.FindSet() then
                        Error('No G/L entries selected.');

                    // Validate that all selected entries have GL accounts that allow modification
                    repeat
                        GLAccount.Get(SelectedGLEntries."G/L Account No.");
                        if not GLAccount."Modify G/L Entries" then
                            Error('G/L Account %1 does not allow modification of entries.', SelectedGLEntries."G/L Account No.");
                    until SelectedGLEntries.Next() = 0;

                    // Open modification page
                    ModifyGLEntriesPage.SetSelectedEntries(SelectedGLEntries);
                    if ModifyGLEntriesPage.RunModal() = Action::OK then begin
                        //ModifyGLEntriesPage.GetModifiedValues(GLAccNo);
                        // Apply modifications to selected entries
                        SelectedGLEntries.FindSet();
                        ModifiedCount := 0;
                        repeat
                            SelectedGLEntries.Validate("G/L Account No.", ModifyGLEntriesPage.GetModifiedValues());
                            SelectedGLEntries.Modify(false);
                            ModifiedCount += 1;
                        until SelectedGLEntries.Next() = 0;
                        Message('%1 G/L entries have been modified successfully.', ModifiedCount);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
}
