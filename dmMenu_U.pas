unit dmMenu_U;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmMenu = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  conMenu: TADOConnection;
  tblMenu: TADOTable;
  dsMenu: TDataSource;
  end;

var
  dmMenu: TdmMenu;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmMenu.DataModuleCreate(Sender: TObject);
begin
  conMenu := TADOConnection.Create(dmMenu);
  tblMenu := TADOTable.Create(dmMenu);
  dsMenu := TDataSource.Create(dmMenu);

  conMenu.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
    ExtractFilePath(ParamStr(0)) +
    'Menu.MDB;Persist Security Info=False';
   conMenu.LoginPrompt := false;
   conMenu.Open;

  tblMenu.Connection :=  conMenu;
  tblMenu.TableName := 'Beverages';

  dsMenu.DataSet := tblMenu;

  tblMenu.Open;
end;

end.
