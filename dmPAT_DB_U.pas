unit dmPAT_DB_U;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmPAT_DB = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    conDM_PAT_DB: TADOConnection;

    tblPersonel: TADOTable;
    dsPersonel: TDataSource;

    tblMenu: TADOTable;
    dsMenu: TDataSource;

    tblClients: TADOTable;
    dsClients: TDataSource;

    tblOrders: TADOTable;
    dsOrders: TDataSource;

    tblOrder_Items: TADOTable;
    dsOrder_Items: TDataSource;
  end;

var
  dmPAT_DB: TdmPAT_DB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TdmPAT_DB.DataModuleCreate(Sender: TObject);
begin
//Create and set connection
  conDM_PAT_DB := TADOConnection.Create(dmPAT_DB);
  conDM_PAT_DB.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
    ExtractFilePath(ParamStr(0)) + 'PAT_DB.MDB;Persist Security Info=False';
  conDM_PAT_DB.LoginPrompt := false;

  //Create and set tables and datasources
  tblPersonel := TADOTable.Create(dmPAT_DB);
  dsPersonel := TDataSource.Create(dmPAT_DB);

  tblMenu := TADOTable.Create(dmPAT_DB);
  dsMenu := TDataSource.Create(dmPAT_DB);

  tblClients := TADOTable.Create(dmPAT_DB);
  dsClients := TDataSource.Create(dmPAT_DB);

  tblOrders := TADOTable.Create(dmPAT_DB);
  dsOrders := TDataSource.Create(dmPAT_DB);

  tblOrder_Items := TADOTable.Create(dmPAT_DB);
  dsOrder_Items := TDataSource.Create(dmPAT_DB);

  //Assign table connections and table names
  tblPersonel.Connection := conDM_PAT_DB;
  tblPersonel.TableName := 'Personel';

  tblMenu.Connection := conDM_PAT_DB;
  tblMenu.TableName := 'Menu';

  tblClients.Connection := conDM_PAT_DB;
  tblClients.TableName := 'Clients';

  tblOrders.Connection := conDM_PAT_DB;
  tblOrders.TableName := 'Orders';

  tblOrder_Items.Connection := conDM_PAT_DB;
  tblOrder_Items.TableName := 'Order_Items';

  //Assign datasets and open tables
  dsPersonel.DataSet := tblPersonel;
  dsMenu.DataSet := tblMenu;
  dsClients.DataSet := tblClients;
  dsOrders.DataSet := tblClients;
  dsOrder_Items.DataSet := tblClients;

  tblPersonel.Open;
  tblMenu.Open;
  tblClients.Open;
  tblOrders.Open;
  tblOrder_Items.Open;
end;

end.
