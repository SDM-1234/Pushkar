
page 50115 "WF Mandatory Fields List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WF Mandatory Fields";
    DelayedInsert = true;
    Caption = 'WF Mandatory Fields';

    layout
    {
        area(Content)
        {
            group("Table")
            {
                ShowCaption = false;
                field("Table Name"; TableName)
                {
                    ApplicationArea = All;
                    Caption = 'Table No.';
                    ToolTip = 'Specifies the table number.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Object: Page "All Objects";
                    begin
                        AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                        Object.SetTableView(AllObj);
                        Object.LookupMode(true);
                        if Object.RunModal() = ACTION::LookupOK then begin
                            Object.GetRecord(AllObj);
                            TableName := AllObj."Object Name";
                            Rec.SetRange("Table No.", AllObj."Object ID");
                            CurrPage.Update(false);
                        end;
                    end;
                }
            }
            repeater(General)
            {
                field(Name; Rec."Field No.")
                {
                    ApplicationArea = All;
                    Caption = 'Field No.';
                    ToolTip = 'Specifies the field number.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldLookup: Page "Field Lookup";
                    begin
                        Field.SetRange(TableNo, AllObj."Object ID");
                        FieldLookup.SetTableView(Field);
                        FieldLookup.LookupMode(true);
                        if FieldLookup.RunModal() = ACTION::LookupOK then begin
                            FieldLookup.GetRecord(Field);
                            Rec."Field No." := Field."No.";
                        end;
                    end;

                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                    Caption = 'Field Caption';
                    Editable = false;
                    ToolTip = 'Specifies the field caption.';
                }
                field("Mandatory Condition"; Rec."Mandatory Condition")
                {
                    Visible = Rec."Parent Table No." = 0;
                    ToolTip = 'Specifies the value of the Mandatory Condition field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RelatedTables)
            {
                Caption = 'Related Tables';
                ApplicationArea = All;
                ToolTip = 'View related tables.';
                Image = Table;

                trigger OnAction()
                var
                    Field: Record Field;
                    Page: Page "WF Mandatory Fields List";
                begin
                    field.Get(Rec."Table No.", Rec."Field No.");
                    if Field.RelationTableNo = 0 then
                        Error('No related table found');
                    Page.SetValues(Field.RelationTableNo, AllObj."Object ID");
                    Page.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            actionref(RelatedTables_Ref; RelatedTables)
            {

            }
        }

    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate("Table No.", AllObj."Object ID");
        Rec.Validate("Parent Table No.", ParentTableNo);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Table No.", TableNo);
        Rec.SetRange("Parent Table No.", ParentTableNo);
    end;

    procedure SetValues(pTableNo: Integer; pParentTableNo: Integer)
    begin
        TableNo := pTableNo;
        ParentTableNo := pParentTableNo;
    end;

    var
        AllObj: Record AllObj;
        Field: Record Field;
        TableName: Text[100];
        TableNo, ParentTableNo : Integer;
}