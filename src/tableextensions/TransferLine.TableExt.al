namespace Pushkar.Pushkar;

using Microsoft.Inventory.Transfer;

tableextension 50104 "TransferLine" extends "Transfer Line"
{
    fields
    {
        field(50105; "Posted Transfer Shipment Nos."; Text[2048])
        {
            Caption = 'Posted Transfer Shipment Nos.';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TempTransferShipmentHeader: Record "Transfer Shipment Header" temporary;
                TransferShipmentHeader: Record "Transfer Shipment Header";
                SelectedNos: Text[2048];
                First: Boolean;
            begin
                TempTransferShipmentHeader.Init();
                TransferShipmentHeader.SetRange("Item No.", "Item No.");
                TransferShipmentHeader.SetRange("Transfer-from Code", "Transfer-to Code");
                if TransferShipmentHeader.FindSet() then
                    repeat
                        TempTransferShipmentHeader := TransferShipmentHeader;
                        TempTransferShipmentHeader.Insert();
                    until TransferShipmentHeader.Next() = 0;

                if Page.RunModal(Page::"Temp Posted Transfer Shipments", TempTransferShipmentHeader) = Action::LookupOK then begin
                    TempTransferShipmentHeader.SetRange("Assign Shipment to FG", true);
                    SelectedNos := '';
                    First := true;
                    if TempTransferShipmentHeader.FindSet() then
                        repeat
                            if not First then
                                SelectedNos += '|';
                            SelectedNos += TempTransferShipmentHeader."No.";
                            First := false;
                        until TempTransferShipmentHeader.Next() = 0;
                    Validate("Posted Transfer Shipment Nos.", SelectedNos);
                end;
            end;
        }
    }
}
