namespace Pushkar.Pushkar;

using Microsoft.Finance.GST.Base;
using Microsoft.Finance.Reports;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.TaxBase;
using Microsoft.Finance.TaxEngine.TaxTypeHandler;
using Microsoft.Finance.TCS.TCSBase;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Location;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;
using Microsoft.QRGeneration;
using Microsoft.Sales.Customer;
using Microsoft.Sales.History;
using System.Utilities;
using Microsoft.Sales.Comment;

report 50116 "Purchase Return Billing"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/PurchaseReturnBilling.rdl';
    Caption = 'Purchase Return Billing';
    Permissions = TableData "Sales Shipment buffer" = rimd;
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Credit Memo';
            column(VendorInvNo; PurchInvHeader."Vendor Invoice No.")
            { }
            column(VendorInvDate; PurchInvHeader."Document Date")
            { }
            column(CompanyName; CompanyName)
            {
            }
            column(CompanyAdd1; CompanyAdd1)
            {
            }
            column(CompanyAdd2; CompanyAdd2)
            {
            }
            column(PS_Vehicle_No_; "Vehicle No.")
            {
            }
            column(CompanyCity; CompanyCity)
            {
            }
            column(CompanyPin; CompanyPin)
            {
            }
            column(CompanyGSTIN; CompanyGSTIN)
            {

            }
            column(CompanyPAN; CompanyPAN)
            {

            }
            column(CompanyCIN; CompanyCIN)
            {

            }

            column(CompanyState; CompanyState) { }
            column(CompanyStateCode; CompanyStateCode) { }
            column(InvoiceNo; "Purch. Cr. Memo Hdr."."No.")
            { }
            column(InvoiceDate; "Purch. Cr. Memo Hdr."."Posting Date")
            { }
            column(SupplierCode; SupplierCode)
            { }
            column(BillToName; BillToName) { }
            column(BillToAdd1; BillToAdd1) { }
            column(BillToAdd2; BillToAdd2) { }
            column(BillToCity; BillToCity) { }
            column(BillToPin; BillToPin) { }
            column(BillToState; BillToState) { }
            column(BillToStateCode; BillToStateCode) { }
            column(BillToCountry; BillToCountry) { }
            column(BillToGSTIN; BillToGSTIN) { }
            column(ShipToName; ShipToName) { }
            column(ShipToAdd1; ShipToAdd1) { }
            column(ShipToAdd2; ShipToAdd2) { }
            column(ShipToCity; ShipToCity) { }
            column(ShipToPin; ShipToPin) { }
            column(ShipToState; ShipToState) { }
            column(Comnt; Comnt) { }
            column(ShipToStateCode; ShipToStateCode) { }
            column(ShipToCountry; ShipToCountry) { }
            column(ShipToGSTIN; BillToGSTIN) { }
            column(PONumber; 'NA') { }
            column(PODate; "Purch. Cr. Memo Hdr."."Document Date") { }
            column(ChalanNo; "Purch. Cr. Memo Hdr."."No.") { }
            column(ChalanDate; "Purch. Cr. Memo Hdr."."Posting Date") { }
            column(TCSAmount; TCSAmount) { }

            column(RRCNoteNo; '') { }
            column(RRCNoteDate; '') { }
            column(CareeerName; '') { }
            column(ReturnChalanNo; '') { }
            column(DispatchNoteNo; '') { }
            column(DispatchNoteDate; '') { }
            column(StoreLoc; "Purch. Cr. Memo Hdr."."Location Code") { }
            column(PallateNo; '') { }
            column(VideInvoiceNo; '') { }
            column(VideInvoiceDate; '') { }
            column(IRNNO; 'NA') { }
            column(Vehicle_No_; "Vehicle No.") { }
            column(ASNNo; '') { }


            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Purch. Cr. Memo Hdr.";
                DataItemLink = "Document No." = field("No.");

                column(UOM; "Purch. Cr. Memo Line"."Unit of Measure Code") { }
                column(Commodity; Commodity) { }
                column(ItemName; "Purch. Cr. Memo Line".Description) { }
                column(No_; "No.") { }
                column(UnitPrice; "Purch. Cr. Memo Line"."Unit Cost") { }
                column(LineAmount; "Purch. Cr. Memo Line"."Line Amount") { }
                column(Location_Code; "Location Code") { }

                column(HSN; "HSN/SAC Code") { }
                column(SGSTAmt; SGSTAmt) { }
                column(SGSTPer; SGSTPer) { }
                column(IGSTAmt; IGSTAmt) { }
                column(IGSTPer; IGSTPer) { }
                column(CGSTAmt; CGSTAmt) { }
                column(CGSTPer; CGSTPer) { }
                column(CessAmt; CessAmt) { }
                column(CessPer; CessPer) { }
                column(AmountToText; AmountToText[1] + AmountToText[2]) { }
                column(ShipQty; "Purch. Cr. Memo Line".Quantity) { }
                column(TextTotalAmount; TextTotalAmount) { }
                column(QtyToText; QtyToText[1] + QtyToText[2]) { }
                column(QtyToText1; QtyToText1) { }
                column(QRCode; 'NA') { }

                trigger OnPreDataItem()
                begin
                    SetFilter(Quantity, '<>%1', 0);
                end;

                trigger OnAfterGetRecord() // Purchase Credit Memo Line
                begin
                    Clear(IGSTAmt);
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(CessAmt);
                    Clear(HSNTable);
                    HSNTable.SetRange(Code, "HSN/SAC Code");
                    if HSNTable.Find('-') then
                        Commodity := HSNTable.Description;
                    DetailedGSTLedgerEntry.Reset();
                    DetailedGSTLedgerEntry.SetRange("Document No.", "Purch. Cr. Memo Line"."Document No.");
                    DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    if DetailedGSTLedgerEntry.FindSet() then
                        repeat
                            if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) And ("Purch. Cr. Memo Hdr."."Currency Code" <> '') then begin
                                CGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Purch. Cr. Memo Hdr."."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                CGSTPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) then begin
                                    CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    CGSTPer := DetailedGSTLedgerEntry."GST %";
                                end;
                            if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And ("Purch. Cr. Memo Hdr."."Currency Code" <> '') then begin
                                SGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Purch. Cr. Memo Hdr."."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                SGSTPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) then begin
                                    SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    SGSTPer := DetailedGSTLedgerEntry."GST %";
                                end;

                            if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) And ("Purch. Cr. Memo Hdr."."Currency Code" <> '') then begin
                                IGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Purch. Cr. Memo Hdr."."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                IGSTPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) then begin
                                    IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    IGSTPer := DetailedGSTLedgerEntry."GST %";
                                end;
                            if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) And ("Purch. Cr. Memo Hdr."."Currency Code" <> '') then begin
                                CessAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Purch. Cr. Memo Hdr."."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                CessPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) then begin
                                    CessAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    CessPer := DetailedGSTLedgerEntry."GST %";
                                end;
                        until DetailedGSTLedgerEntry.Next() = 0;
                    TextTotalAmount := "Line Amount" + SGSTAmt + CGSTAmt + IGSTAmt + CessAmt + TCSAmount;

                    Cheque.InitTextVariable();
                    Cheque.FormatNoText(AmountToText, TextTotalAmount, "Purch. Cr. Memo Hdr."."Currency Code");
                    Cheque.InitTextVariable();
                    Cheque.FormatNoText(QtyToText, Round(Quantity, 0.01, '='), '');

                    QtyToText1 := QtyToText[1] + QtyToText[2];

                    QtyToText1 := QtyToText1.Replace('RUPEES', '');
                    QtyToText1 := QtyToText1.Replace('PAISA', '');
                    QtyToText1 := QtyToText1.Replace('AND', '');
                    QtyToText1 := QtyToText1.Replace('ZERO', '');
                    //"Purch. Cr. Memo Hdr.".CalcFields("QR Code");
                    CustomQR();
                end;

            }
            trigger OnAfterGetRecord() // Purchase Credit Memo Header
            begin

                DtldVendLedgerEntry.Reset();
                DtldVendLedgerEntry.SetRange("Entry Type", DtldVendLedgerEntry."Entry Type"::Application);
                DtldVendLedgerEntry.SetRange("Document No.", "No.");
                DtldVendLedgerEntry.SetFilter("Applied Vend. Ledger Entry No.", '<>%1', DtldVendLedgerEntry."Vendor Ledger Entry No.");
                if DtldVendLedgerEntry.FindFirst() then begin
                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.Get(DtldVendLedgerEntry."Vendor Ledger Entry No.");
                    PurchInvHeader.Reset();
                    PurchInvHeader.Get(VendorLedgerEntry."Document No.");
                end;
                SalesCommentLine.RESET();
                SalesCommentLine.SETRANGE("No.", "No.");
                IF SalesCommentLine.FINDSET() THEN
                    REPEAT
                        Comnt := Comnt + ' ' + SalesCommentLine.Comment;
                    UNTIL SalesCommentLine.NEXT() = 0;

                if ("Location Code" <> '') then begin
                    location.get("Location Code");
                    States.Get(location."State Code");
                    LocationState := States.Description;
                    LocationStateCode := states."State Code (GST Reg. No.)";
                end;



                CompanyName := location.Name;
                CompanyAdd1 := location.Address;
                CompanyAdd2 := location."Address 2";
                CompanyCity := location.City;
                CompanyPin := location."Post Code";
                CompanyGSTIN := location."GST Registration No.";


                if (location."State Code" <> '') then begin
                    States.Reset();
                    States.Get(location."State Code");
                    CompanyState := States.Description;
                    CompanyStateCode := States."State Code (GST Reg. No.)";
                end;


                // CompanyName := CompanyInfo.Name;
                // CompanyAdd1 := CompanyInfo.Address;
                // CompanyAdd2 := CompanyInfo."Address 2";
                // CompanyCity := CompanyInfo.City;
                // CompanyPin := CompanyInfo."Post Code";
                // CompanyGSTIN := CompanyInfo."GST Registration No.";
                CompanyPAN := CompanyInfo."P.A.N. No.";
                CompanyCIN := CompanyInfo."Circle No.";
                if (CompanyInfo."State Code" <> '') then begin
                    States.Reset();
                    States.Get(CompanyInfo."State Code");
                    CompanyState := States.Description;
                    CompanyStateCode := States."State Code (GST Reg. No.)";
                end;

                VendorVar.Reset();
                VendorVar.get("Buy-from Vendor No.");
                BillToName := "Buy-from Vendor Name";
                BillToAdd1 := VendorVar.Address;
                BillToAdd2 := VendorVar."Address 2";
                BillToCity := VendorVar.City;
                BillToPin := VendorVar."Post Code";
                //SupplierCode := VendorVar."Supplier Code";
                States.Reset();
                if VendorVar."State Code" <> '' then begin
                    States.Get(VendorVar."State Code");
                    BillToState := states.Description;
                    BillToStateCode := states."State Code (GST Reg. No.)";


                    ShipToState := states.Description;
                    ShipToStateCode := states."State Code (GST Reg. No.)";


                end;
                if VendorVar."Country/Region Code" <> '' then begin
                    CountryRegion.Get(VendorVar."Country/Region Code");
                    BillToCountry := CountryRegion.Name;
                    BillToGSTIN := VendorVar."GST Registration No.";

                    ShipToCountry := CountryRegion.Name;
                    ShipToGSTIN := VendorVar."GST Registration No.";

                end;
                if "Ship-to Address" <> '' then begin
                    VendorVar.Reset();
                    VendorVar.get("Buy-from Vendor No.");
                    BillToName := "Buy-from Vendor Name";
                    BillToAdd1 := VendorVar.Address;
                    BillToAdd2 := VendorVar."Address 2";
                    BillToCity := VendorVar.City;
                    BillToPin := VendorVar."Post Code";
                    States.Reset();
                    if VendorVar."State Code" <> '' then begin
                        States.Get(VendorVar."State Code");
                        ShipToState := states.Description;
                        ShipToStateCode := states."State Code (GST Reg. No.)";
                    end;
                    if VendorVar."Country/Region Code" <> '' then begin
                        CountryRegion.Get(VendorVar."Country/Region Code");
                        ShipToCountry := CountryRegion.Name;
                        ShipToGSTIN := VendorVar."GST Registration No.";
                    end;
                end;

                ShipToName := "Ship-to Name";
                ShipToAdd1 := "Ship-to Address";
                ShipToAdd2 := "Ship-to Address 2";
                ShipToCity := "Ship-to City";
                ShipToPin := "Ship-to Post Code";


                TCSEntry.Reset();
                TCSEntry.SetRange("Document No.", "No.");
                if TCSEntry.FindFirst() then
                    TCSAmount := TCSEntry."TCS Amount Including Surcharge";
            end;
        }

    }

    requestpage
    {

        layout
        {

            area(content)
            {
                group(Options)
                {

                    field(QRCodePrint; QRCodePrint)
                    {
                        Caption = 'Print QR Code';
                        ApplicationArea = All;
                        ToolTip = 'When selected, QR code generation will run.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        GSTSetup: Record "GST Setup";
        TaxComponent: Record "Tax Component";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
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


    local procedure CustomQR()
    var
        Vendor: Record Vendor;
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        QRGenerator: Codeunit "QR Generator";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        VarText1, VarText2, VarText3, QRCodeInput : Text;
    begin
        IF not QRCodePrint THEN
            Exit;
        Vendor.Get("Purch. Cr. Memo Hdr."."Buy-from Vendor No.");
        PurchCrMemoLine.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
        PurchCrMemoLine.SetRange(Type, PurchCrMemoLine.Type::Item);
        PurchCrMemoLine.FindFirst();
        VarText1 := COPYSTR(FORMAT("Purch. Cr. Memo Hdr."."Posting Date"), 1, 2);
        VarText2 := COPYSTR(FORMAT("Purch. Cr. Memo Hdr."."Posting Date"), 4, 2);
        VarText3 := COPYSTR(FORMAT("Purch. Cr. Memo Hdr."."Posting Date"), 7, 2);
        /* 
                DELCHR(FORMAT(PurchCrMemoLine.Quantity), '<=>', ',') + ',' +
                "Purch. Cr. Memo Hdr."."No." + ',' +
                VarText1 + '.' + VarText2 + '.20' + VarText3 + ',' +
                DELCHR(FORMAT(PurchCrMemoLine."Unit Cost", 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                DELCHR(FORMAT(PurchCrMemoLine."Unit Cost", 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                Vendor."Supplier Code" + ',' + PurchCrMemoLine."No." + ',' +
                DELCHR(FORMAT(CGSTAmt, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                DELCHR(FORMAT(SGSTAmt, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                DELCHR(FORMAT(IGSTAmt, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                '0.00' + ',' +
                DELCHR(FORMAT(CGSTPer, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                DELCHR(FORMAT(SGSTPer, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                DELCHR(FORMAT(IGSTPer, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                '0.00' + ',' +
                '0.00' + ',' +
                DELCHR(FORMAT(TextTotalAmount, 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
                PurchCrMemoLine."HSN/SAC Code";
         */
        RecRef.GetTable("Purch. Cr. Memo Hdr.");
        QRGenerator.GenerateQRCodeImage(QRCodeInput, TempBlob);
        //TempBlob.ToRecordRef(RecRef, "Purch. Cr. Memo Hdr.".FieldNo("QR Code"));
        RecRef.SetTable("Purch. Cr. Memo Hdr.");
    end;


    var
        DtldVendLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        VendorVar: Record Vendor;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        HSNTable: Record "HSN/SAC";
        location: Record Location;
        SalesCommentLine: Record "Sales Comment Line";
        States: Record State;
        TCSEntry: Record "TCS Entry";
        Cheque: Report "Posted Voucher";
        QRCodePrint: Boolean;
        CompanyPAN: Code[20];
        SupplierCode: Code[20];
        CessAmt: Decimal;
        CessPer: Decimal;
        CGSTAmt: Decimal;
        CGSTPer: Decimal;
        IGSTAmt: Decimal;
        IGSTPer: Decimal;
        SGSTAmt: Decimal;
        SGSTPer: Decimal;
        TCSAmount: Decimal;
        TextTotalAmount: Decimal;
        AmountToText: array[2] of Text[80];
        BillToAdd1: Text[100];
        BillToAdd2: Text[100];
        BillToCity: Text[100];
        BillToCountry: Text[50];
        BillToGSTIN: Text[20];
        BillToName: Text[100];
        BillToPin: Text[20];
        BillToState: Text[50];
        BillToStateCode: Text[10];
        Commodity: Text[100];
        Comnt: Text[2048];
        CompanyAdd1: Text[100];
        CompanyAdd2: Text[100];
        CompanyCIN: Text[30];
        CompanyCity: Text[100];
        CompanyGSTIN: Text[20];
        CompanyName: Text[100];
        CompanyPin: Text[20];
        CompanyState: Text[50];
        CompanyStateCode: Text[10];
        LocationState: Text[50];
        LocationStateCode: Text[10];
        QtyToText1: Text[200];
        QtyToText: array[2] of Text[80];
        ShipToAdd1: Text[100];
        ShipToAdd2: Text[100];
        ShipToCity: Text[100];
        ShipToCountry: Text[50];
        ShipToGSTIN: Text[20];
        ShipToName: Text[100];
        ShipToPin: Text[20];
        ShipToState: Text[50];
        ShipToStateCode: Text[10];
        CessLbl: Label 'CESS';
        CGSTLbl: Label 'CGST';
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
}

