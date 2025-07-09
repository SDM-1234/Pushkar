report 50101 "Purchase Order Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/POReport.rdl';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = filter(order));

            column(CompinfoName; recCompinfo.Name)
            {
            }
            column(CompinfoAddress; recCompinfo.Address)
            {
            }
            column(CompinfoAddress2; recCompinfo."Address 2")
            {
            }
            column(CompinfoCity; recCompinfo.City)
            {
            }
            column(CompinfoCountry; recCompinfo."Country/Region Code")
            {
            }
            column(CompinfoPostcode; recCompinfo."Post Code")
            {
            }
            column(CompinfoGSTRegNo; recCompinfo."GST Registration No.")
            {
            }
            column(CompinfoPhone; recCompinfo."Phone No.")
            {
            }
#pragma warning disable AL0432
            column(CompinfoHpage; recCompinfo."Home Page")
#pragma warning restore AL0432
            {
            }
            column(CompinfoEmail; recCompinfo."E-Mail")
            {
            }
            column(CompinfoVARRegno; recCompinfo."VAT Registration No.")
            {
            }
            column(CompinfoGiro; recCompinfo."Giro No.")
            {
            }
            column(txtStatecoun; txtStatecoun)
            {
            }
            column(No_; "No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {
            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {
            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {
            }
            column(Buy_from_Address; "Buy-from Address")
            {
            }
            column(Buy_from_Address_2; "Buy-from Address 2")
            {
            }
            column(Buy_from_Post_Code; "Buy-from Post Code")
            {
            }
            column(Buy_from_City; "Buy-from City")
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(txtcaption; txtcaption)
            {
            }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.")
            {
            }
            column(intPage; intPage)
            {
            }
            column(txtComment; txtComment)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(ItemNo; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_of_Measure; "Unit of Measure Code")
                {
                }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }
                column(CGSTAmt; CGSTAmt)
                {
                }
                column(SGSTAmt; SGSTAmt)
                {
                }
                column(IGSSTAmt; IGSSTAmt)
                {
                }
                column(decCGSTPer; decCGSTPer)
                {
                }
                column(decSGSTPer; decSGSTPer)
                {
                }
                column(decIGSTPer; decIGSTPer)
                {
                }
                trigger OnAfterGetRecord()
                var
                    rectaxtrans: Record "Tax Transaction Value";
                begin
                    Clear(decCGSTPer);
                    clear(decSGSTPer);
                    clear(decIGSTPer);
                    GetGSTAmounts(rectaxtrans, "Purchase Line", GSTSetup);
                end;
            }
            trigger OnAfterGetRecord()
            var
                intI: Integer;
            begin
                Clear(CGSTAmt);
                Clear(SGSTAmt);
                Clear(IGSSTAmt);
                if "Transaction Type" = 'WORK ORDER' then
                    txtcaption := 'Work Order'
                else
                    txtcaption := 'Purchase Order';
                Clear(txtComment);
                Clear(intI);
                recpurcomline.Reset();
                recpurcomline.SetRange("Document Type", PurchaseHeader."Document Type");
                recpurcomline.SetRange("No.", PurchaseHeader."No.");
                recpurcomline.SetRange("Document Line No.", 0);
                if recpurcomline.FindSet() then
                    repeat
                        txtComment += recpurcomline.Comment + ' ';
                        intI += 1;
                    until (recpurcomline.Next() = 0) or (intI = 3);
                intPage += 1;
            end;
        }
    }
    trigger OnPreReport()
    begin
        recCompinfo.Get();
        GSTSetup.get();
        if recState.Get(recCompinfo."State Code") then txtStatecoun := recState.Description;
        if recCoun.get(recCompinfo."Country/Region Code") then txtStatecoun += ' ' + reccoun.Name;
    end;

    local procedure GetGSTAmounts(TaxTransactionValue: Record "Tax Transaction Value"; PurchaseLine: Record "Purchase Line"; GSTSetup: Record "GST Setup")
    var
        ComponentName: Code[30];
    begin
        ComponentName := GetComponentName(PurchaseLine, GSTSetup);
        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                decSGSTPer := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                decCGSTPer := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGSSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                decIGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line"; GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then exit;
        GSTSetup.TestField("GST Tax Type");
        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    var
        myInt: Integer;
        txtcaption: Text;
        intPage: Integer;
        recCompinfo: Record "Company Information";
        recState: Record State;
        recCoun: Record "Country/Region";
        txtStatecoun: Text;
        txtComment: Text;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        decCGSTPer: Decimal;
        decSGSTPer: Decimal;
        decIGSTPer: Decimal;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        GSTLbl: Label 'GST';
        GSTSetup: Record "GST Setup";
        recpurcomline: Record "Purch. Comment Line";
}
