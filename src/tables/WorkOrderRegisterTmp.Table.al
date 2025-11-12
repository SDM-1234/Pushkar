table 50120 WorkOrderRegisterTmp
{
    DataClassification = ToBeClassified;
    //TableType = Temporary;
    fields
    {
        field(15; EntryNo; Integer)
        {
            DataClassification = ToBeClassified;
            //AutoIncrement = true;
        }
        field(18; UOM; Text[50])
        {
            DataClassification = ToBeClassified;
            //AutoIncrement = true;
        }
        field(21; FGUOM; Text[50])
        {
            DataClassification = ToBeClassified;
            //AutoIncrement = true;
        }
        field(19; ItemDescription; Text[100])
        {
            DataClassification = ToBeClassified;
            //AutoIncrement = true;
        }
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(16; ItemNo; Text[60])
        {
            DataClassification = ToBeClassified;

        }
        field(17; LineNo; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; DateOfDispatch; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; Delay; Text[60])
        {
            DataClassification = ToBeClassified;

        }
        field(4; DescriptionOfGoodsDispatch; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; QtyDispatchedToJobWorker; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; FinishedGoodQtyProduced; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; NameAddJobWorker; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; NatureOfProcessing; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; JobWorkerDlvDocDate; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; FacGoodReciptDocDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; DateOfClearence; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; DescriptionOfGoods; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; QtyProduced; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; BalanceQty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; Type; Option)
        {
            OptionMembers = Shipment,Receipt;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }
}