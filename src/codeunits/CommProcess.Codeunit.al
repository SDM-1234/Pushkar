codeunit 50102 CommProcess
{
    trigger OnRun()
    begin
    end;

    procedure CreatePostSaleJson(recpostsale: Record "Sales Invoice Header")
    var
        recCompinfo: Record "Company Information";
        reccustledent: Record "Cust. Ledger Entry";
        recdetgstledent: Record "Detailed GST Ledger Entry";
        recpostsaleline: Record "Sales Invoice Line";
        Tempblop: Codeunit "Temp Blob";
        salejsonobj: JsonObject;
        InsStream: InStream;
        OutStream: OutStream;
        decCGSTAmt: Decimal;
        decCGSTPer: Decimal;
        decIGSTAmt: Decimal;
        decIGSTPer: Decimal;
        decInvoiceAmt: Decimal;
        decSGSTAmt: Decimal;
        decSGSTPer: Decimal;
        FileName: Text;
        txtdate: Text;
    begin
        Clear(decCGSTAmt);
        Clear(decSGSTAmt);
        Clear(decIGSTAmt);
        Clear(decCGSTPer);
        Clear(decIGSTPer);
        Clear(decSGSTPer);
        recCompinfo.FindFirst();
        recpostsaleline.Reset();
        recpostsaleline.SetRange("Document No.", recpostsale."No.");
        recpostsaleline.SetRange(Type, recpostsaleline.Type::Item);
        if recpostsaleline.FindFirst() then;
        reccustledent.Reset();
        reccustledent.SetRange("Document Type", reccustledent."Document Type"::Invoice);
        reccustledent.SetRange("Document No.", recpostsale."No.");
        if reccustledent.FindFirst() then begin
            reccustledent.CalcFields(reccustledent."Amount (LCY)");
            decInvoiceAmt := reccustledent."Amount (LCY)";
        end;
        recdetgstledent.Reset();
        recdetgstledent.SetRange("Document Type", recdetgstledent."Document Type"::Invoice);
        recdetgstledent.SetRange("Document No.", recpostsale."No.");
        recdetgstledent.SetRange("GST Component Code", 'CGST');
        if recdetgstledent.FindFirst() then begin
            decCGSTAmt := recdetgstledent."GST Amount";
            decCGSTPer := recdetgstledent."GST %";
        end;
        recdetgstledent.Reset();
        recdetgstledent.SetRange("Document Type", recdetgstledent."Document Type"::Invoice);
        recdetgstledent.SetRange("Document No.", recpostsale."No.");
        recdetgstledent.SetRange("GST Component Code", 'SGST');
        if recdetgstledent.FindFirst() then begin
            decSGSTAmt := recdetgstledent."GST Amount";
            decSGSTPer := recdetgstledent."GST %";
        end;
        recdetgstledent.Reset();
        recdetgstledent.SetRange("Document Type", recdetgstledent."Document Type"::Invoice);
        recdetgstledent.SetRange("Document No.", recpostsale."No.");
        recdetgstledent.SetRange("GST Component Code", 'IGST');
        if recdetgstledent.FindFirst() then begin
            decIGSTAmt := recdetgstledent."GST Amount";
            decIGSTPer := recdetgstledent."GST %";
        end;
        txtdate := Format(recpostsale."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
        salejsonobj.Add('PORefr', recpostsale."External Document No.");
        salejsonobj.Add('SlNo', '10');
        salejsonobj.Add('Qty', fnRemovedecimals(Format(recpostsaleline.Quantity)));
        salejsonobj.Add('Inv_No', recpostsale."No.");
        salejsonobj.Add('Inv_Dt', txtdate);
        salejsonobj.Add('UnitPrice', fnRemovedecimals(Format(recpostsaleline."Unit Price")));
        salejsonobj.Add('NetUnitPrice', fnRemovedecimals(Format(recpostsaleline."Unit Price")));
        salejsonobj.Add('TotAmt', fnRemovedecimals(Format(recpostsaleline."Line Amount")));
        salejsonobj.Add('AssAmt', fnRemovedecimals(Format(recpostsaleline."Line Amount")));
        salejsonobj.Add('SgstVal', fnRemovedecimals(Format(Abs(decSGSTAmt))));
        salejsonobj.Add('CgstVal', fnRemovedecimals(Format(Abs(decCGSTAmt))));
        salejsonobj.Add('IgstVal', fnRemovedecimals(Format(Abs(decIGSTAmt))));
        salejsonobj.Add('SGstRt', fnRemovedecimals(Format(decSGSTPer)));
        salejsonobj.Add('CGstRt', fnRemovedecimals(Format(decCGSTPer)));
        salejsonobj.Add('IGstRt', fnRemovedecimals(Format(decIGSTPer)));
        salejsonobj.Add('TotItemVal', fnRemovedecimals(Format(decInvoiceAmt)));
        if recpostsale."Currency Code" = '' then
            salejsonobj.Add('ForCur', 'INR')
        else
            salejsonobj.Add('ForCur', recpostsale."Currency Code");
        salejsonobj.Add('Sup_Gstin', recCompinfo."GST Registration No.");
        salejsonobj.Add('VehNo', recpostsale."Vehicle No.");
        salejsonobj.Add('Part_Rev', 'A');
        salejsonobj.Add('Buy_Gstin', recpostsale."Customer GST Reg. No.");
        salejsonobj.Add('Irn', recpostsale."IRN Hash");
        salejsonobj.Add('file', '');
        Tempblop.CreateInStream(InsStream);
        Tempblop.CreateOutStream(OutStream);
        salejsonobj.WriteTo(OutStream);
        FileName := recpostsale."No." + '.json';
        DownloadFromStream(InsStream, 'Download', '', '', FileName);
    end;

    procedure fnRemovedecimals(txtVal: Text) txtResult: Text
    var
        intCheck1: Integer;
        intCheck: Integer;
        intVal1: Integer;
        txtVal1: Text;
    begin
        Clear(intCheck);
        Clear(intCheck1);
        Clear(intVal1);
        Clear(txtVal1);
        intCheck := StrPos(txtVal, '.');
        if (intCheck = 0) then
            txtResult := txtVal
        else begin
            txtVal1 := CopyStr(txtVal, intCheck + 1, (StrLen(txtVal) - intCheck));
            Evaluate(intVal1, txtVal1);
            if (intVal1 = 0) then
                txtResult := CopyStr(txtVal, 1, intCheck - 1)
            else
                txtResult := txtVal;
        end;
        intCheck1 := StrPos(txtResult, ',');
        if (intCheck1 > 0) then txtResult := DelStr(txtResult, StrPos(txtResult, ','), 1);
        exit(txtResult);
    end;

    var
        myInt: Integer;
}
