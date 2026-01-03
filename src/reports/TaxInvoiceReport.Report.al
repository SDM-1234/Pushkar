namespace Pushkar.Pushkar;

using Microsoft.Finance.GST.Base;
using Microsoft.Finance.Reports;
using Microsoft.Finance.TaxBase;
using Microsoft.Finance.TCS.TCSBase;
using Microsoft.Finance.TaxEngine.TaxTypeHandler;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Location;
using Microsoft.QRGeneration;
using Microsoft.Sales.Customer;
using Microsoft.Sales.History;
using System.Utilities;

report 50100 "Tax Invoice Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayouts/TaxInvoiceReport.rdl';
    Caption = 'Tax Invoice Report';
    Permissions = TableData "Sales Shipment buffer" = rimd;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';

            column(CompanyName; CompanyName)
            {

            }
            column(CompanyAdd1; CompanyAdd1)
            {

            }
            column(CompanyAdd2; CompanyAdd2)
            {

            }
            column(PS_Vehicle_No_; "PS Vehicle No.")
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
            column(InvoiceNo; "Sales Invoice Header"."No.")
            { }
            column(InvoiceDate; "Sales Invoice Header"."Posting Date")
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
            column(ShipToName; BillToName) { }
            column(ShipToAdd1; BillToAdd1) { }
            column(ShipToAdd2; BillToAdd2) { }
            column(ShipToCity; BillToCity) { }
            column(ShipToPin; BillToPin) { }
            column(ShipToState; BillToState) { }
            column(ShipToStateCode; BillToStateCode) { }
            column(ShipToCountry; BillToCountry) { }
            column(ShipToGSTIN; BillToGSTIN) { }
            column(PONumber; "Sales Invoice Header"."External Document No.") { }
            column(PODate; "Sales Invoice Header"."Document Date") { }
            column(ChalanNo; "Sales Invoice Header"."No.") { }
            column(ChalanDate; "Sales Invoice Header"."Posting Date") { }
            column(TCSAmount; TCSAmount) { }

            column(RRCNoteNo; '') { }
            column(RRCNoteDate; '') { }
            column(CareeerName; '') { }
            column(ReturnChalanNo; '') { }
            column(DispatchNoteNo; '') { }
            column(DispatchNoteDate; '') { }
            column(StoreLoc; "Sales Invoice Header"."Location Code") { }
            column(PallateNo; '') { }
            column(VideInvoiceNo; '') { }
            column(VideInvoiceDate; '') { }
            column(IRNNO; "Sales Invoice Header"."IRN Hash") { }
            column(Vehicle_No_; "Vehicle No.") { }
            column(ASNNo; '') { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");

                column(UOM; "Sales Invoice Line"."Unit of Measure Code") { }
                column(Commodity; Commodity) { }
                column(ItemName; "Sales Invoice Line".Description) { }
                column(No_; "No.") { }
                column(UnitPrice; "Sales Invoice Line"."Unit Price") { }
                column(LineAmount; "Sales Invoice Line"."Line Amount") { }
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
                column(ShipQty; "Sales Invoice Line".Quantity) { }
                column(TextTotalAmount; TextTotalAmount) { }
                column(QtyToText; QtyToText[1] + QtyToText[2]) { }
                column(QtyToText1; QtyToText1) { }
                column(QRCode; "Sales Invoice Header"."QR Code") { }


                trigger OnAfterGetRecord() // sales invoice line
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
                    DetailedGSTLedgerEntry.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    if DetailedGSTLedgerEntry.FindSet() then
                        repeat
                            if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) And ("Sales Invoice Header"."Currency Code" <> '') then begin
                                CGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Sales Invoice Header"."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                CGSTPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) then begin
                                    CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    CGSTPer := DetailedGSTLedgerEntry."GST %";
                                end;
                            if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And ("Sales Invoice Header"."Currency Code" <> '') then begin
                                SGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Sales Invoice Header"."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                SGSTPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) then begin
                                    SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    SGSTPer := DetailedGSTLedgerEntry."GST %";
                                end;

                            if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) And ("Sales Invoice Header"."Currency Code" <> '') then begin
                                IGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Sales Invoice Header"."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
                                IGSTPer := DetailedGSTLedgerEntry."GST %";
                            end
                            else
                                if (DetailedGSTLedgerEntry."GST Component Code" = IGSTLbl) then begin
                                    IGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                                    IGSTPer := DetailedGSTLedgerEntry."GST %";
                                end;
                            if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) And ("Sales Invoice Header"."Currency Code" <> '') then begin
                                CessAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * "Sales Invoice Header"."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"));
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
                    Cheque.FormatNoText(AmountToText, TextTotalAmount, "Sales Invoice Header"."Currency Code");
                    Cheque.InitTextVariable();
                    Cheque.FormatNoText(QtyToText, Round(Quantity, 0.01, '='), '');

                    QtyToText1 := QtyToText[1] + QtyToText[2];

                    QtyToText1 := QtyToText1.Replace('RUPEES', '');
                    QtyToText1 := QtyToText1.Replace('PAISA', '');
                    QtyToText1 := QtyToText1.Replace('AND', '');
                    QtyToText1 := QtyToText1.Replace('ZERO', '');
                    "Sales Invoice Header".CalcFields("QR Code");
                    CustomQR();
                end;

            }
            trigger OnAfterGetRecord() // sales invoice header
            begin



                TCSEntry.Reset();
                TCSEntry.SetRange("Document No.", "No.");
                if TCSEntry.FindFirst() then
                    TCSAmount := TCSEntry."TCS Amount Including Surcharge";
                CompanyName := CompanyInfo.Name;
                CompanyAdd1 := CompanyInfo.Address;
                CompanyAdd2 := CompanyInfo."Address 2";
                CompanyCity := CompanyInfo.City;
                CompanyPin := CompanyInfo."Post Code";
                CompanyGSTIN := CompanyInfo."GST Registration No.";
                CompanyPAN := CompanyInfo."P.A.N. No.";
                CompanyCIN := CompanyInfo."Circle No.";
                if (CompanyInfo."State Code" <> '') then begin
                    States.Reset();
                    States.Get(CompanyInfo."State Code");
                    CompanyState := States.Description;
                    CompanyStateCode := States."State Code (GST Reg. No.)";
                end;

                if ("Location Code" <> '') then begin
                    location.get("Location Code");
                    States.Get(location."State Code");
                    LocationState := States.Description;
                    LocationStateCode := states."State Code (GST Reg. No.)";
                end;
                Customers.Reset();
                Customers.get("Sell-to Customer No.");
                BillToName := "Sell-to Customer Name";
                BillToAdd1 := Customers.Address;
                BillToAdd2 := Customers."Address 2";
                BillToCity := Customers.City;
                BillToPin := Customers."Post Code";
                SupplierCode := Customers."Supplier Code";
                States.Reset();
                if Customers."State Code" <> '' then begin
                    States.Get(Customers."State Code");
                    BillToState := states.Description;
                    BillToStateCode := states."State Code (GST Reg. No.)";
                end;
                if Customers."Country/Region Code" <> '' then begin
                    CountryRegion.Get(Customers."Country/Region Code");
                    BillToCountry := CountryRegion.Name;
                    BillToGSTIN := Customers."GST Registration No.";
                end;
                if "Ship-to Customer" <> '' then begin
                    Customers.Reset();
                    Customers.get("Sell-to Customer No.");
                    BillToName := "Sell-to Customer Name";
                    BillToAdd1 := Customers.Address;
                    BillToAdd2 := Customers."Address 2";
                    BillToCity := Customers.City;
                    BillToPin := Customers."Post Code";
                    States.Reset();
                    if Customers."State Code" <> '' then begin
                        States.Get(Customers."State Code");
                        ShipToState := states.Description;
                        ShipToStateCode := states."State Code (GST Reg. No.)";
                    end;
                    if Customers."Country/Region Code" <> '' then begin
                        CountryRegion.Get(Customers."Country/Region Code");
                        ShipToCountry := CountryRegion.Name;
                        ShipToGSTIN := Customers."GST Registration No.";
                    end;
                end;

                ShipToName := "Ship-to Name";
                ShipToAdd1 := "Ship-to Address";
                ShipToAdd2 := "Ship-to Address 2";
                ShipToCity := "Ship-to City";
                ShipToPin := "Ship-to Post Code";
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
        Customer: Record Customer;
        SalesInvoiceLine: Record "Sales Invoice Line";
        TempBlob: Codeunit "Temp Blob";
        QRGenerator: Codeunit "QR Generator";
        RecRef: RecordRef;
        VarText1, VarText2, VarText3, QRCodeInput : Text;
    begin
        IF not QRCodePrint THEN
            Exit;
        Customer.Get("Sales Invoice Header"."Sell-to Customer No.");
        SalesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        SalesInvoiceLine.FindFirst();
        VarText1 := COPYSTR(FORMAT("Sales Invoice Header"."Posting Date"), 1, 2);
        VarText2 := COPYSTR(FORMAT("Sales Invoice Header"."Posting Date"), 4, 2);
        VarText3 := COPYSTR(FORMAT("Sales Invoice Header"."Posting Date"), 7, 2);
        //QR Code
        // Save a QR code image into a file in a temporary folder
        QRCodeInput := "Sales Invoice Header"."External Document No." + ',' +
        '10' + ',' +
        DELCHR(FORMAT(SalesInvoiceLine.Quantity), '<=>', ',') + ',' +
        "Sales Invoice Header"."No." + ',' +
        VarText1 + '.' + VarText2 + '.20' + VarText3 + ',' +
        DELCHR(FORMAT(SalesInvoiceLine."Unit Price", 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
        DELCHR(FORMAT(SalesInvoiceLine."Unit Price", 0, '<Integer Thousand><Decimals,3>'), '<=>', ',') + ',' +
        Customer."Supplier Code" + ',' + SalesInvoiceLine."No." + ',' +
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
        SalesInvoiceLine."HSN/SAC Code";
        RecRef.GetTable("Sales Invoice Header");
        QRGenerator.GenerateQRCodeImage(QRCodeInput, TempBlob);
        TempBlob.ToRecordRef(RecRef, "Sales Invoice Header".FieldNo("QR Code"));
        RecRef.SetTable("Sales Invoice Header");
    end;


    var
        CompanyInfo: Record "Company Information";
        States: Record State;
        TariffNo: Code[20];//Same field replaced by variable
        HSNTable: Record "HSN/SAC";
        Customers: Record Customer;
        CountryRegion: Record "Country/Region";
        location: Record Location;
        Cheque: Report "Posted Voucher";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        CompanyName: Text[60];
        CompanyAdd1: Text[60];
        CompanyAdd2: Text[60];
        CompanyCity: Text[60];
        CompanyPin: Text[10];
        CompanyGSTIN: Text[15];
        CompanyPAN: Code[20];
        SupplierCode: Code[20];
        CompanyCIN: Text[30];
        CompanyState: Text[30];
        CompanyStateCode: Text[5];
        LocationState: Text[30];
        LocationStateCode: Text[5];
        Commodity: Text[60];
        BillToName: Text[60];
        BillToAdd1: Text[60];
        BillToAdd2: Text[60];
        BillToCity: Text[60];
        BillToPin: Text[10];
        BillToGSTIN: Text[15];
        BillToState: Text[30];
        BillToStateCode: Text[5];
        BillToCountry: Text[30];
        ShipToCountry: Text[30];
        ShipToName: Text[60];
        ShipToAdd1: Text[60];
        ShipToAdd2: Text[60];
        ShipToCity: Text[60];
        ShipToPin: Text[10];
        ShipToGSTIN: Text[15];
        ShipToState: Text[30];
        ShipToStateCode: Text[5];
        ChallanNo: Text[30];
        Chalandate: Date;
        AmountInWords: Text[200];
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        CessAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        CessPer: Decimal;
        CGSTLbl: Label 'CGST';
        SGSTLbl: Label 'SGST';
        IGSTLbl: Label 'IGST';
        CessLbl: Label 'CESS';
        TextTotalAmount: Decimal;
        TotalInvAmt: Decimal;
        QRCodePrint: Boolean;
        AmountToText: array[2] of Text[80];
        QtyToText: array[2] of Text[80];
        QtyToText1: Text[200];
        TCSEntry: Record "TCS Entry";
        TCSAmount: Decimal;
}

