unit DatabaseManagement_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TfrmDatabaseManagement = class(TForm)
    imgDatabaseManagement: TImage;
    dbgMenu: TDBGrid;
    lblDatabaseManagement: TLabel;
    btnPrevious: TButton;
    btnNext: TButton;
    btnFirst: TButton;
    btnLast: TButton;
    btnInsert: TButton;
    grpDatabaseManagement: TGroupBox;
    btnDataManagementLogout: TButton;
    procedure btnLastClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnDataManagementLogoutClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDatabaseManagement: TfrmDatabaseManagement;

implementation
uses
dmPAT_DB_U, Purchase_U, Login_U;
{$R *.dfm}

procedure TfrmDatabaseManagement.btnDataManagementLogoutClick(Sender: TObject);
begin
frmDatabaseManagement.Hide;
frmLogin.show;
end;

procedure TfrmDatabaseManagement.btnDeleteClick(Sender: TObject);
begin
  dmPAT_DB.tblMenu.Delete;
end;

procedure TfrmDatabaseManagement.btnFirstClick(Sender: TObject);
begin
  dmPAT_DB.tblMenu.First;
end;

procedure TfrmDatabaseManagement.btnInsertClick(Sender: TObject);
var
  sItem: string;
begin
    //Change Item Price
    dmPAT_DB.tblMenu.Edit;
    sItem:= dmPAT_DB.tblMenu['Item_Description'];
    dmPAT_DB.tblMenu['Price'] := InputBox(sItem,
      'Please enter the new price of the item:', '');
      dmPAT_DB.tblMenu.Post;

end;

procedure TfrmDatabaseManagement.btnLastClick(Sender: TObject);
begin
  dmPAT_DB.tblMenu.Last;
end;

procedure TfrmDatabaseManagement.btnNextClick(Sender: TObject);
begin
  dmPAT_DB.tblMenu.Next;
end;

procedure TfrmDatabaseManagement.btnPreviousClick(Sender: TObject);
begin
  dmPAT_DB.tblMenu.Prior;
end;

procedure TfrmDatabaseManagement.FormActivate(Sender: TObject);
begin
  dbgMenu.DataSource := dmPAT_DB.dsMenu;
end;

end.
