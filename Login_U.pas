unit Login_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TfrmLogin = class(TForm)
    imgLogin: TImage;
    edtPassword: TEdit;
    edtUsername: TEdit;
    btnLogin: TButton;
    grpLogin: TGroupBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblLogin: TLabel;
    btnExit: TButton;
    btnForgotPassWord: TButton;
    procedure BtnPurchClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure DataManagementClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    function SpaceCheck(sLogin: string): Boolean;
    procedure edtUsernameMouseLeave(Sender: TObject);
    procedure btnForgotPassWordClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure JobTypeCheck(sJob: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses Purchase_U, DatabaseManagement_U, dmPAT_DB_U, Register_U;

procedure TfrmLogin.btnForgotPassWordClick(Sender: TObject);
var
  sPassword: string;
begin
  if InputBox('Name', 'Please enter your name:', '') <> dmPAT_DB.tblPersonel
    ['Name'] then
  begin
    Showmessage('Please make sure your name is spelled correctly.');
    exit;
  end;

  if InputBox('Surname', 'Please enter your surname:', '') <>
    dmPAT_DB.tblPersonel['Surname'] then
  begin
    Showmessage('Please make sure your surname is spelled correctly.');
    exit;
  end;

  if InputBox('Cell Number', 'Please enter your cell number:', '') <>
    dmPAT_DB.tblPersonel['Cell_Number'] then
  begin
    Showmessage('Please make sure your cell number is correct.');
    exit;
  end;

  sPassword := InputBox('New Password', 'Please enter your new password:', '');
  IF (SpaceCheck(edtUsername.text) = True) then
  begin
    Showmessage('Please make sure your username has no spaces in.');
    exit;
  end;

  IF (SpaceCheck(sPassword) = True) then
  begin
    Showmessage('Please make sure your password has no spaces in.');
    exit;
  end;

  if (Length(edtPassword.text) < 10) then
  begin
    Showmessage
      ('Please make sure your password is more than 10 characters long.');
    exit;
  end;

  dmPAT_DB.tblPersonel.Edit;
  dmPAT_DB.tblPersonel['Pass_Word'] := sPassword;
  dmPAT_DB.tblPersonel.Post;
  Showmessage(Format('Your new password is %s', [sPassword]));
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  sJob: string;
  bFound: Boolean;
begin
  if (Length(edtPassword.text) < 10) then
  begin
    Showmessage
      ('Please make sure your password is more than 10 characters long.');
    exit;
  end;

  if (SpaceCheck(edtUsername.text) = False) AND
    (SpaceCheck(edtPassword.text) = False) then
  begin
    dmPAT_DB.tblPersonel.First;
    bFound := False;

    while NOT(dmPAT_DB.tblPersonel.Eof) AND (bFound = False) do
    begin

      // Checks if username and password is correct.
      if (dmPAT_DB.tblPersonel['Username'] = edtUsername.text) AND
        ((dmPAT_DB.tblPersonel['Pass_Word']) = edtPassword.text) then
      begin

        // Determine Job type and therefore the form to go to
        bFound := True;
        JobTypeCheck(dmPAT_DB.tblPersonel['Job_Position']);

      end
      else
        dmPAT_DB.tblPersonel.Next;
      // Above goes to next record to loop and check the username and record

    end;
    // A full loop or check in the database has been made and no username and password has matched
    if bFound = False then
      Showmessage('Username or password is incorrect.');
  end;
end;

procedure TfrmLogin.BtnPurchClick(Sender: TObject);
begin
  frmPurchases.Show;
end;

procedure TfrmLogin.btnRegisterClick(Sender: TObject);
begin
  frmRegister.Show;
end;

procedure TfrmLogin.Button1Click(Sender: TObject);
begin
  frmPurchases.Show;
end;

procedure TfrmLogin.DataManagementClick(Sender: TObject);
begin
  frmDatabaseManagement.Show;
end;

procedure TfrmLogin.edtUsernameMouseLeave(Sender: TObject);
begin
  dmPAT_DB.tblPersonel.Locate('Job_Position', 'Administrator', []);
  if (edtUsername.text = dmPAT_DB.tblPersonel['Username']) then
    btnForgotPassWord.Visible := True;

end;

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  edtPassword.Clear;
  edtUsername.Clear;
  btnForgotPassWord.Visible := False;
end;

function TfrmLogin.SpaceCheck(sLogin: string): Boolean;
var
  iCount: Integer;
begin
  // determine if the strinhg has spaces
  result := False;
  for iCount := 1 to Length(sLogin) do
  begin
    if (sLogin[iCount] = ' ') then
    begin
      Showmessage
        ('Please make sure your username and password has no spaces in it.');
      result := True;
      exit;
    end
  end;
end;

procedure TfrmLogin.JobTypeCheck(sJob: string);
begin
  // Checks the record for job type and changes forms accordingly.
  if sJob = 'Administrator' then
  begin
    frmLogin.Hide;
    frmDatabaseManagement.Show;
  end;

  if sJob = 'Owner' then
  begin
    frmLogin.Hide;
    frmRegister.Show;
  end;

  if sJob = 'Waiter' then
  begin
    frmLogin.Hide;
    frmPurchases.Show;
  end;

  if sJob = 'HeadChef' then
    Showmessage
      ('Please make sure you have the right username, headchefs do not have permission to access this system, please ask your admin to change your user rights (Job position)');

  if sJob = 'Manager' then
  begin
    frmLogin.Hide;
    frmPurchases.Show;
  end;
end;

procedure TfrmLogin.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
