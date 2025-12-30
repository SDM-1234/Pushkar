namespace Pushkar.Pushkar;

using Microsoft.Foundation.AuditCodes;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using System.Utilities;

table 50101 DailyScheduleList
{
    Caption = 'DailyScheduleList';
    DataClassification = CustomerContent;
    DrillDownPageId = DailyScheduleList;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = "Item"."No.";
            ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';

            trigger OnValidate()
            begin
                Validate("Pending Quantity", Quantity);
            end;
        }
        field(4; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';

        }
        field(5; Updated; Boolean)
        {
            Caption = 'Updated';
            ToolTip = 'Specifies the value of the Updated field.', Comment = '%';
        }
        field(6; "SO No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "Sell-to Customer No." = const('1007'));
            ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
            Editable = false;
        }
        field(7; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            trigger OnValidate()
            var
                ReasonCode: Record "Reason Code";
            begin
                if "Reason Code" <> '' then begin
                    ReasonCode.SetRange("Code", "Reason Code");
                    if ReasonCode.FindFirst() then
                        "Reason Description" := ReasonCode.Description
                end else
                    "Reason Description" := '';
            end;

        }

        field(8; "Reason Description"; Text[100])
        {
            Caption = 'Reason Description';
            Editable = false;
        }

        field(9; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
        }
        field(10; "Delivered Quantity"; Decimal)
        {
            Caption = 'Delivered Quantity';
            ToolTip = 'Specifies the value of the Delivered Quantity field.', Comment = '%';

            trigger OnValidate()
            begin
                if "Delivered Quantity" > 0 then
                    "Pending Quantity" := Quantity - "Delivered Quantity";
            end;

        }
        field(12; "Pending Quantity"; Decimal)
        {
            Caption = 'Pending Quantity';
            ToolTip = 'Specifies the value of the Pending Quantity field.', Comment = '%';

        }

        field(14; "Sales Line Unit Price"; Decimal)
        {
            Caption = 'Sales Line Unit Price';
            ToolTip = 'Specifies the value of the Sales Line Unit Price field.', Comment = '%';
        }


    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Item No.", Quantity, "Shipment Date", Updated)
        { }
    }



    procedure ArchiveRecords(SelectedRecords: Record DailyScheduleList)
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if not ConfirmManagement.GetResponseOrDefault('Do you want to process records?', true) then
            exit;
        SelectedRecords.SetFilter("SO No.", '<>%1', '');
        if SelectedRecords.FindSet() then
            repeat
                SelectedRecords.Updated := true;
                SelectedRecords.Modify();
            until SelectedRecords.Next() = 0;
        Message('Sales Order(s) processed successfully.');
    end;


    procedure UpdateSalesOrderNo(SelectedRecords: Record DailyScheduleList)

    var
        SalesLine: Record "Sales Line";
        EndDateFormula: DateFormula;
        StartDateFormula: DateFormula;
        EndDate: Date;
        StartDate: Date;
        FormulaText: Text;
        SoUpdated: Boolean;

    begin
        // Get all selected records from the current page
        if not SelectedRecords.FindSet() then begin
            Message('No records selected.');
            exit;
        end;
        FormulaText := 'CM-1M+1D';
        Evaluate(StartDateFormula, FormulaText);
        FormulaText := 'CM';
        Evaluate(EndDateFormula, FormulaText);


        // Loop through each selected record and update
        repeat
            //if SelectedRecords.FindSet() then begin
            StartDate := CalcDate(StartDateFormula, SelectedRecords."Shipment Date");
            EndDate := CalcDate(EndDateFormula, SelectedRecords."Shipment Date");

            SalesLine.SetRange("No.", SelectedRecords."Item No.");
            SalesLine.SetRange("Shipment Date", StartDate, EndDate);

            if SalesLine.FindFirst() then begin
                SelectedRecords."SO No." := SalesLine."Document No.";
                SelectedRecords."Sales Line Unit Price" := SalesLine."Unit Price";

                if SelectedRecords.Modify() then
                    SoUpdated := true;
            end;
        //end;
        until SelectedRecords.Next() = 0;
        if SoUpdated then
            Message('Sales Order updated successfully.');
    end;


    procedure UpdatePostedShipmentQuantity(var SelectedRecords: Record DailyScheduleList)
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        DailyScheduleList: Record DailyScheduleList;
        NextShipmentDate: Date;
        QtytoUpdate: Decimal;
        QtyUpdatedCount: Integer;

    begin
        Clear(QtyUpdatedCount);

        if not SelectedRecords.FindSet() then begin
            Message('No records selected.');
            exit;
        end;

        // Loop through each selected record and update
        repeat
            // Get all selected records from the current page
            Clear(NextShipmentDate);
            Clear(QtytoUpdate);

            DailyScheduleList.SetCurrentKey("Entry No.", "Shipment Date");
            DailyScheduleList.Ascending(true);
            DailyScheduleList.SetFilter("Entry No.", '>%1', SelectedRecords."Entry No.");
            DailyScheduleList.Setrange("Item No.", SelectedRecords."Item No.");
            DailyScheduleList.Setrange("SO No.", SelectedRecords."SO No.");
            DailyScheduleList.SetFilter("Shipment Date", '>%1', SelectedRecords."Shipment Date");
            if DailyScheduleList.FindFirst() then
                NextShipmentDate := CalcDate('<-1D>', DailyScheduleList."Shipment Date")
            else
                NextShipmentDate := CalcDate('<CM>', SelectedRecords."Shipment Date");

            SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
            SalesShipmentLine.SetRange("No.", SelectedRecords."Item No.");


            // Set range based on next shipment date
            case true of
                NextShipmentDate = 0D:
                    SalesShipmentLine.SetRange("Posting Date", SelectedRecords."Shipment Date");
                NextShipmentDate = SelectedRecords."Shipment Date":
                    SalesShipmentLine.SetRange("Posting Date", SelectedRecords."Shipment Date");
                NextShipmentDate > SelectedRecords."Shipment Date":
                    SalesShipmentLine.SetFilter("Posting Date", '%1..%2', SelectedRecords."Shipment Date", NextShipmentDate);
            end;

            if SalesShipmentLine.FindSet() then
                repeat
                    QtytoUpdate += SalesShipmentLine.Quantity;
                until SalesShipmentLine.Next() = 0;
            if QtytoUpdate <> 0 then begin
                SelectedRecords.Validate("Delivered Quantity", QtytoUpdate);
                SelectedRecords.Modify();
                QtyUpdatedCount += 1;
            end;
        until SelectedRecords.Next() = 0;
        if QtyUpdatedCount > 0 then
            Message('Quantity updated successfully in %1 records.', QtyUpdatedCount);
    end;

}
