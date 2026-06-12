unit ClientRegister_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXPickers,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmClientRegister = class(TForm)
    imgClientRegister: TImage;
    lblClientRegister: TLabel;
    grpClientRegister: TGroupBox;
    edtCell_Num: TEdit;
    edtSurname: TEdit;
    edtName: TEdit;
    lblClientCell_Num: TLabel;
    lblSurname: TLabel;
    lblName: TLabel;
    btnClientRegister_Register: TButton;
    btnClientRegisterLogout: TButton;
    procedure btnClientRegister_RegisterClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientRegister: TfrmClientRegister;

implementation

uses
  Invoice_U, dmPAT_DB_U, Purchase_U;
{$R *.dfm}

procedure TfrmClientRegister.btnClientRegister_RegisterClick(Sender: TObject);
begin
  //Validate cellphone number
  if (Length(edtCell_Num.Text) <> 10) then
  begin
    ShowMessage('Please make sure your cellphone number is 10 digits long.');
    exit;
  end;

  if (edtCell_Num.Text[1] <> '0') then
  begin
    ShowMessage('Please make sure your cellphone number starts with a "0".');
    exit;
  end;

  //Check for any cell number duplicates in the client table
  If (dmPAT_DB.tblClients.Locate('Cell_Number', edtCell_Num.Text, []) = True)
  then
  begin
    ShowMessage
      ('The cellphone number entered is already registered, please make sure the customer is not registered and that the cellphone number is correct.');
    exit;
  end;

  sCell_Num := edtCell_Num.Text;

  // Save Name, Surname, Cell Number, Points(0) and Current Date to Clients Table
  dmPAT_DB.tblClients.Insert;
  dmPAT_DB.tblClients['Name'] := edtName.Text;
  dmPAT_DB.tblClients['Surname'] := edtSurname.Text;
  dmPAT_DB.tblClients['Cell_Number'] := sCell_Num;
  dmPAT_DB.tblClients['Points'] := '0';
  dmPAT_DB.tblClients['Date_Registered'] := Now;
  dmPAT_DB.tblClients.Post;

  frmInvoice.Show;
  frmClientRegister.Hide;
end;

procedure TfrmClientRegister.FormActivate(Sender: TObject);
begin
  dmPAT_DB.tblClients.Open;
end;

end.
