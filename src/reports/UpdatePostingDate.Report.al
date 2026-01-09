namespace Pushkar.Pushkar;
using Microsoft.Bank.Ledger;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GST.Base;
using Microsoft.Finance.TCS.TCSBase;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.History;
using Microsoft.Purchases.History;
using Microsoft.Sales.Receivables;
using System.Utilities;
using Microsoft.Purchases.Payables;
report 50108 "Update Posting Date"
{
    ApplicationArea = All;
    Caption = 'Update Posting Date';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions =
        TableData "Sales Invoice Header" = RM,
        TableData "Sales Invoice Line" = RM,
        TableData "G/L Entry" = RM,
        TableData "Cust. Ledger Entry" = RM,
        TableData "Bank Account Ledger Entry" = RM,
        TableData "GST Ledger Entry" = RM,
        TableData "Detailed GST Ledger Entry" = RM,
        TableData "VAT Entry" = RM,
        TableData "TCS Entry" = RM,
        TableData "Item Ledger Entry" = RM,
        TableData "Detailed Cust. Ledg. Entry" = RM,
        TableData "Value Entry" = RM;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1));
            trigger OnAfterGetRecord()
            begin
                UpdatePostingDateForPostedInvoice(SalesInvNo, PostingDate)
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    Caption = 'Update Posting Date for Posted Sales Invoice';
                    field(SalesInvNo; SalesInvNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Invoice No.';
                        tablerelation = "Sales Invoice Header"."No.";
                    }

                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'New Posting Date';
                    }
                }
            }
        }
    }
    var
        SalesInvNo: Code[20];
        PostingDate: Date;

    local procedure UpdatePostingDateForPostedInvoice(SalesInvNo: Code[20]; NewPostingDate: Date)
    var
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLed: Record "Bank Account Ledger Entry";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        GSTLedgerEntry: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        VATEntry: Record "VAT Entry";
        TCSEntry: Record "TCS Entry";
        ItemLedg: Record "Item Ledger Entry";
        DetailedCustLedg: Record "Detailed Cust. Ledg. Entry";
        ValueEntry: Record "Value Entry";
        SalesShipHdr: Record "Sales Shipment Header";
        SalesShipLine: Record "Sales Shipment Line";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ReturnShptHdr: Record "Return Shipment Header";
        ReturnShptLine: Record "Return Shipment Line";
        ReturnRcptHdr: Record "Return Receipt Header";
        ReturnRcptLine: Record "Return Receipt Line";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchInvHdr: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";

    begin

        VendLedgEntry.SetRange("Document No.", SalesInvNo);
        if VendLedgEntry.FindSet() then
            repeat
                VendLedgEntry.Validate("Posting Date", NewPostingDate);
                VendLedgEntry.Modify();
            until VendLedgEntry.Next() = 0;

        DtldVendLedgEntry.SetRange("Document No.", SalesInvNo);
        if DtldVendLedgEntry.FindSet() then
            repeat
                DtldVendLedgEntry.Validate("Posting Date", NewPostingDate);
                DtldVendLedgEntry.Modify();
            until DtldVendLedgEntry.Next() = 0;


        ReturnRcptHdr.SetRange("No.", SalesInvNo);
        if ReturnRcptHdr.FindSet() then
            repeat
                ReturnRcptHdr.Validate("Posting Date", NewPostingDate);
                ReturnRcptHdr.Modify();
            until ReturnRcptHdr.Next() = 0;


        ReturnRcptLine.SetRange("Document No.", SalesInvNo);
        if ReturnRcptLine.FindSet() then
            repeat
                ReturnRcptLine.Validate("Posting Date", NewPostingDate);
                ReturnRcptLine.Modify();
            until ReturnRcptLine.Next() = 0;

        PurchRcptHdr.SetRange("No.", SalesInvNo);
        if PurchRcptHdr.FindSet() then
            repeat
                PurchRcptHdr.Validate("Posting Date", NewPostingDate);
                PurchRcptHdr.Modify();
            until PurchRcptHdr.Next() = 0;

        PurchRcptLine.SetRange("Document No.", SalesInvNo);
        if PurchRcptLine.FindSet() then
            repeat
                PurchRcptLine.Validate("Posting Date", NewPostingDate);
                PurchRcptLine.Modify();
            until PurchRcptLine.Next() = 0;

        PurchCrMemoHdr.SetRange("No.", SalesInvNo);
        if PurchCrMemoHdr.FindSet() then
            repeat
                PurchCrMemoHdr.Validate("Posting Date", NewPostingDate);
                PurchCrMemoHdr.Modify();
            until PurchCrMemoHdr.Next() = 0;

        PurchCrMemoLine.SetRange("Document No.", SalesInvNo);
        if PurchCrMemoLine.FindSet() then
            repeat
                PurchCrMemoLine.Validate("Posting Date", NewPostingDate);
                PurchCrMemoLine.Modify();
            until PurchCrMemoLine.Next() = 0;


        PurchInvHdr.SetRange("No.", SalesInvNo);
        if PurchInvHdr.FindSet() then
            repeat
                PurchInvHdr.Validate("Posting Date", NewPostingDate);
                PurchInvHdr.Modify();
            until PurchInvHdr.Next() = 0;


        PurchInvLine.SetRange("Document No.", SalesInvNo);
        if PurchInvLine.FindSet() then
            repeat
                PurchInvLine.Validate("Posting Date", NewPostingDate);
                PurchInvLine.Modify();
            until PurchInvLine.Next() = 0;



        BankLed.SetRange("Document No.", SalesInvNo);
        if BankLed.FindSet() then
            repeat
                BankLed.Validate("Posting Date", NewPostingDate);
                BankLed.Modify();
            until BankLed.Next() = 0;
        GSTLedgerEntry.SetRange("Document No.", SalesInvNo);
        if GSTLedgerEntry.FindSet() then
            repeat
                GSTLedgerEntry.Validate("Posting Date", NewPostingDate);
                GSTLedgerEntry.Modify();
            until GSTLedgerEntry.Next() = 0;
        DetailedGSTLedgerEntry.SetRange("Document No.", SalesInvNo);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                DetailedGSTLedgerEntry.Validate("Posting Date", NewPostingDate);
                DetailedGSTLedgerEntry.Modify();
            until DetailedGSTLedgerEntry.Next() = 0;
        VATEntry.SetRange("Document No.", SalesInvNo);
        if VATEntry.FindSet() then
            repeat
                VATEntry.Validate("Posting Date", NewPostingDate);
                VATEntry.Modify();
            until VATEntry.Next() = 0;
        TCSEntry.SetRange("Document No.", SalesInvNo);
        if TCSEntry.FindSet() then
            repeat
                TCSEntry.Validate("Posting Date", NewPostingDate);
                TCSEntry.Modify();
            until TCSEntry.Next() = 0;
        DetailedCustLedg.SetRange("Document No.", SalesInvNo);
        if DetailedCustLedg.FindSet() then
            repeat
                DetailedCustLedg.Validate("Posting Date", NewPostingDate);
                DetailedCustLedg.Modify();
            until DetailedCustLedg.Next() = 0;
        ItemLedg.SetRange("Document No.", SalesInvNo);
        if ItemLedg.FindSet() then
            repeat
                ItemLedg.Validate("Posting Date", NewPostingDate);
                ItemLedg.Modify();
            until ItemLedg.Next() = 0;
        ValueEntry.SetRange("Document No.", SalesInvNo);
        if ValueEntry.FindSet() then
            repeat
                ValueEntry.Validate("Posting Date", NewPostingDate);
                ValueEntry.Modify();
            until ValueEntry.Next() = 0;

        // Update G/L Entry posting dates for this document
        GLEntry.SetRange("Document No.", SalesInvNo);
        if GLEntry.FindSet() then
            repeat
                GLEntry.Validate("Posting Date", NewPostingDate);
                GLEntry.Modify();
            until GLEntry.Next() = 0;
        // Update Customer Ledger Entries
        CustLed.SetRange("Document No.", SalesInvNo);
        if CustLed.FindSet() then
            repeat
                CustLed.Validate("Posting Date", NewPostingDate);
                CustLed.Modify();
            until CustLed.Next() = 0;
        // Update Bank Account Ledger Entries
        BankLed.SetRange("Document No.", SalesInvNo);
        if BankLed.FindSet() then
            repeat
                BankLed.Validate("Posting Date", NewPostingDate);
                BankLed.Modify();
            until BankLed.Next() = 0;
        // Update Sales Header Archive (if present)
        SalesInvLine.SetRange("Document No.", SalesInvNo);
        if SalesInvLine.FindSet() then
            repeat
                SalesInvLine.Validate("Posting Date", NewPostingDate);
                SalesInvLine.Modify();
            until SalesInvLine.Next() = 0;
        // Update Sales Header (if present)
        SalesInvHdr.SetRange("No.", SalesInvNo);
        if SalesInvHdr.FindSet() then
            repeat
                SalesInvHdr.Validate("Posting Date", NewPostingDate);
                SalesInvHdr.Modify();
            until SalesInvHdr.Next() = 0;



        SalesShipHdr.SetRange("No.", SalesInvNo);
        if SalesShipHdr.FindSet() then
            repeat
                SalesShipHdr.Validate("Posting Date", NewPostingDate);
                SalesShipHdr.Modify();
            until SalesShipHdr.Next() = 0;

        SalesShipLine.SetRange("Document No.", SalesInvNo);
        if SalesShipLine.FindSet() then
            repeat
                SalesShipLine.Validate("Posting Date", NewPostingDate);
                SalesShipLine.Modify();
            until SalesShipLine.Next() = 0;

        SalesCrMemoHdr.SetRange("No.", SalesInvNo);
        if SalesCrMemoHdr.FindSet() then
            repeat
                SalesCrMemoHdr.Validate("Posting Date", NewPostingDate);
                SalesCrMemoHdr.Modify();
            until SalesCrMemoHdr.Next() = 0;

        SalesCrMemoLine.SetRange("Document No.", SalesInvNo);
        if SalesCrMemoLine.FindSet() then
            repeat
                SalesCrMemoLine.Validate("Posting Date", NewPostingDate);
                SalesCrMemoLine.Modify();
            until SalesCrMemoLine.Next() = 0;


        ReturnShptHdr.SetRange("No.", SalesInvNo);
        if ReturnShptHdr.FindSet() then
            repeat
                ReturnShptHdr.Validate("Posting Date", NewPostingDate);
                ReturnShptHdr.Modify();
            until ReturnShptHdr.Next() = 0;

        ReturnShptLine.SetRange("Document No.", SalesInvNo);
        if ReturnShptLine.FindSet() then
            repeat
                ReturnShptLine.Validate("Posting Date", NewPostingDate);
                ReturnShptLine.Modify();
            until ReturnShptLine.Next() = 0;

    end;
}