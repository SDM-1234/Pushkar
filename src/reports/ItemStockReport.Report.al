report 50115 "Item Stock Report"
{
    Caption = 'Item Stock Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/ItemStockMovement.rdl';

    dataset
    {
        dataitem(Item; Item)                // grouping on the based on Item table 
        {
            RequestFilterFields = "No.", "Inventory Posting Group";

            dataitem("Item Ledger Entry"; "Item Ledger Entry")          // data come from item ledger entry table based on the date filter and item number
            {
                DataItemLink = "Item No." = field("No.");
                //PrintOnlyIfDetail = true;       // it links with current entry with item table

                column(ItemNo; "Item No.") { }
                column(ItemName; Description) { }

                column(OpeningQty; OpeningQty) { }
                column(OpeningAmount; OpeningAmount) { }

                column(ClosingQty; ClosingQty) { }
                column(ClosingAmount; ClosingAmount) { }

                column(PostingDate; "Posting Date") { }
                column(EntryType; "Entry Type") { }
                column(Qty; Quantity) { }
                column(Cost; "Cost Amount (Actual)") { }

                column(RunningQty; RunningQty) { }
                column(RunningAmount; RunningAmount) { }

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", FromDate, ToDate);
                end;

                trigger OnAfterGetRecord()
                begin
                    RunningQty += Quantity;
                    RunningAmount += "Cost Amount (Actual)";
                end;
            }

            trigger OnAfterGetRecord()
            var
                ILE: Record "Item Ledger Entry";          // by the help of this it will reset all calculation
            begin



                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Posting Date", FromDate, ToDate);
                if ILE.IsEmpty() then
                    CurrReport.Skip();

                OpeningQty := 0;
                OpeningAmount := 0;
                ClosingQty := 0;
                ClosingAmount := 0;
                RunningQty := 0;
                RunningAmount := 0;


                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Posting Date", 0D, CalcDate('<-1D>', FromDate));
                if ILE.FindSet() then
                    ILE.CalcFields("Cost Amount (Actual)");

                repeat
                    OpeningQty += ILE.Quantity;

                    if ILE."Cost Amount (Actual)" <> 0 then
                        OpeningAmount += ILE."Cost Amount (Actual)";
                until ILE.Next() = 0;



                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Posting Date", 0D, ToDate);
                if ILE.FindSet() then
                    ILE.CalcFields("Cost Amount (Actual)");

                repeat
                    ClosingQty += ILE.Quantity;
                    if ILE."Cost Amount (Actual)" <> 0 then
                        ClosingAmount += ILE."Cost Amount (Actual)";
                until ILE.Next() = 0;

                RunningQty := OpeningQty;
                RunningAmount := OpeningAmount;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }

                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            // Mandatory Date Validation
            if (FromDate = 0D) or (ToDate = 0D) then
                Error('Please enter From Date and To Date to run the report.');

            exit(true);
        end;
    }

    var                             // these all are variable used in the code
        FromDate: Date;
        ToDate: Date;

        OpeningQty: Decimal;
        OpeningAmount: Decimal;

        ClosingQty: Decimal;
        ClosingAmount: Decimal;

        RunningQty: Decimal;
        RunningAmount: Decimal;
}