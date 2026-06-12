unit Register_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids, Math;

type
  TfrmRegister = class(TForm)
    imgRegister: TImage;
    btnRegisterLogout: TButton;
    lblRegister: TLabel;
    grpDatabaseManagement: TGroupBox;
    btnPrevious: TButton;
    btnNext: TButton;
    btnFirst: TButton;
    btnLast: TButton;
    btnInsert: TButton;
    btnDelete: TButton;
    dbgRegister: TDBGrid;
    btnSearch: TButton;
    cmbJob_Position: TComboBox;
    edtName: TEdit;
    edtSurname: TEdit;
    edtCell_Number: TEdit;
    grpDatabaseSearch: TGroupBox;
    cmbSortField: TComboBox;
    lblSortField: TLabel;
    lblSortOrder: TLabel;
    cmbSortOrder: TComboBox;
    btnSort: TButton;
    grpSort: TGroupBox;
    btnChange: TButton;
    cmbUsernames: TComboBox;
    grpPasswordChange: TGroupBox;
    lblChangePassword: TLabel;
    btnReceipts: TButton;
    btnAddCoupons: TButton;
    procedure btnRegisterLogoutClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnReceiptsClick(Sender: TObject);
    procedure btnAddCouponsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegister: TfrmRegister;

implementation

uses
  dmPAT_DB_U, Purchase_U, Receipts_U, Login_U;

{$R *.dfm}

procedure TfrmRegister.btnAddCouponsClick(Sender: TObject);
var
  tCoupon: Textfile;
  sCode: String;
  sValue: String;
  iValueCount: Integer;
  bCouponValidated: Boolean;
  iPos: Integer;
  bDuplicate: Boolean;
  sLine: string;
begin
  if NOT(FileExists('Coupons.txt')) then
  begin
    ShowMessage('Textfile "Coupons.txt" not found');
    exit;
  end;

  AssignFile(tCoupon, 'Coupons.txt');
  Append(tCoupon);
  bCouponValidated := False;
  while (bCouponValidated = False) do
  begin
    sValue := Inputbox('Value', 'Please enter the value of the coupon:', '');
    bCouponValidated := True;
    for iValueCount := 1 to Length(sValue) do
    begin
      if (ord(sValue[iValueCount]) < 48) OR (ord(sValue[iValueCount]) > 57) then
      begin
        bCouponValidated := False;
        ShowMessage('Please make sure you have entered in a whole number');
      end;
    end;

  end;

  bDuplicate := True;
  while (bDuplicate = True) do
  begin
    sCode := Char(RandomRange(65, 90)) + Char(RandomRange(65, 90)) +
      Char(RandomRange(65, 90)) + Char(RandomRange(65, 90)) +
      Char(RandomRange(65, 90));
      bDuplicate := False;

    while NOT(EOF(tCoupon)) AND (bDuplicate = False) do
    begin
      Readln(tCoupon, sLine);
      iPos := Pos('#', sLine);
      if (sCode = Copy(sLine, 1, (iPos - 1))) then
        bDuplicate := True;
    end

  end;

  Writeln(tCoupon, (sCode + '#' + sValue));
  CloseFile(tCoupon);
  ShowMessageFmt('The code for the %m valued coupon is %s',
    [strtocurr(sValue), sCode]);
end;

procedure TfrmRegister.btnChangeClick(Sender: TObject);

begin
  If (dmPAT_DB.tblPersonel.Locate('Username',
    cmbUsernames.Items[cmbUsernames.ItemIndex], []) = False) then
  begin
    ShowMessage('Username not found.');
  end
  else
  begin
    dmPAT_DB.tblPersonel.Edit;
    dmPAT_DB.tblPersonel['Username'] := Inputbox('New Username',
      'Please enter new username:', '');
    dmPAT_DB.tblPersonel['Pass_Word'] := Inputbox('New Password',
      'Please enter new password:', '');
    dmPAT_DB.tblPersonel.Post;
    ShowMessage('Data has been correctly changed');
  end;
end;

procedure TfrmRegister.btnFirstClick(Sender: TObject);
begin
  dmPAT_DB.tblPersonel.First;
end;

procedure TfrmRegister.btnInsertClick(Sender: TObject);
begin
  with dmPAT_DB do
  begin
    tblPersonel.Insert;
    tblPersonel['Name'] := Inputbox('Name', 'Please enter a name:', '');
    tblPersonel['Surname'] := Inputbox('Surname', 'Please enter a surname', '');
    tblPersonel['Cell_Number'] := Inputbox('Cell_Number',
      'Please enter a cell number', '');
    tblPersonel['Job_Position'] := Inputbox('Job_Position',
      'Please enter a job position', '');
    tblPersonel['Username'] := Inputbox('Username',
      'Please enter a username', '');
    tblPersonel['Pass_Word'] := Inputbox('Pass_Word',
      'Please enter a password', '');
  end;
end;

procedure TfrmRegister.btnNextClick(Sender: TObject);
begin
  dmPAT_DB.tblPersonel.Next;
end;

procedure TfrmRegister.btnPreviousClick(Sender: TObject);
begin
  dmPAT_DB.tblPersonel.Prior;
end;

procedure TfrmRegister.btnReceiptsClick(Sender: TObject);
begin
  frmRegister.Hide;
  frmReceipts.Show;
end;

procedure TfrmRegister.btnRegisterLogoutClick(Sender: TObject);
begin
  frmLogin.Show;
  frmRegister.Hide;
end;

procedure TfrmRegister.btnSearchClick(Sender: TObject);
var
  bFound: Boolean;
  iCount: Integer;
begin
  if (Length(edtCell_Number.Text) > 0) then
  begin
    bFound := False;
    dmPAT_DB.tblPersonel.First;
    while NOT(dmPAT_DB.tblPersonel.EOF) AND (bFound = False) do
    begin
      if ((dmPAT_DB.tblPersonel['Cell_Number']) = edtCell_Number.Text) then
      begin
        bFound := True;
      end
      else
        dmPAT_DB.tblPersonel.Next;
    end;
    if (bFound = False) then
    begin
      ShowMessageFmt('No record with the cell number %s was found.',
        [edtCell_Number.Text]);
    end;
  end
  else
  begin
    if (Length(edtName.Text) < 0) then
    begin
      bFound := False;
      dmPAT_DB.tblPersonel.First;
      while NOT(dmPAT_DB.tblPersonel.EOF) AND (bFound = False) do
      begin
        if ((dmPAT_DB.tblPersonel['Name']) = edtName.Text) then
        begin
          bFound := True;
        end
        else
          dmPAT_DB.tblPersonel.Next;
      end;
      if (bFound = False) then
      begin
        ShowMessageFmt('No record with the name %s was found.', [edtName.Text]);
      end;
    end;

    if (Length(edtSurname.Text) > 0) then
    begin
      ShowMessage('Please make sure you have typed a surname.');
      exit;
    end;
    bFound := False;
    dmPAT_DB.tblPersonel.First;
    while NOT(dmPAT_DB.tblPersonel.EOF) AND (bFound = False) do
    begin
      if ((dmPAT_DB.tblPersonel['Surname']) = edtSurname.Text) then
      begin
        bFound := True;
      end
      else
        dmPAT_DB.tblPersonel.Next;
    end;

    if (bFound = False) then
    begin
      ShowMessageFmt('No record with the surname %s was found.',
        [edtSurname.Text]);
    end;

  end;

  if (cmbJob_Position.ItemIndex < 0) then
  begin
    ShowMessage
      ('Please make sure you have selected a job position in the combo box.');
  end;

  bFound := False;
  dmPAT_DB.tblPersonel.First;

  while NOT(dmPAT_DB.tblPersonel.EOF) AND (bFound = False) do
  begin
    if ((dmPAT_DB.tblPersonel['Job_Position']) = cmbJob_Position.Items
      [cmbJob_Position.ItemIndex]) then
    begin
      bFound := True;
    end
    else
      dmPAT_DB.tblPersonel.Next;
  end;

  if (bFound = False) then
  begin
    ShowMessage('No record matches your search.');
  end;

end;

procedure TfrmRegister.btnSortClick(Sender: TObject);
var
  sSort: string;
begin
  if (cmbSortOrder.ItemIndex = 0) then
  begin
    sSort := cmbSortField.Items[cmbSortField.ItemIndex] + ' ASC';
  end
  else
    sSort := cmbSortField.Items[cmbSortField.ItemIndex] + ' DESC';

  dmPAT_DB.tblPersonel.Sort := sSort;
end;

procedure TfrmRegister.FormActivate(Sender: TObject);
var
  arrUsername: array of string;
  arrPass_Word: array of string;
  iCount: Integer;
  iCount2: Integer;
  iNum: Integer;
  sTemp: string;
  iSizeArr: Integer;
  sPassTemp: string;
begin
  // Transfers data from database to array
  dbgRegister.DataSource := dmPAT_DB.dsPersonel;
  dmPAT_DB.tblPersonel.First;
  iCount := 0;
  iSizeArr := 10;
  SetLength(arrUsername, iSizeArr);
  SetLength(arrPass_Word, iSizeArr);

  while NOT(dmPAT_DB.tblPersonel.EOF) do
  begin
    if iCount < iSizeArr then
    begin
      arrUsername[iCount] := dmPAT_DB.tblPersonel['Username'];
      arrPass_Word[iCount] := dmPAT_DB.tblPersonel['Pass_Word'];
    end
    else
    begin
      iSizeArr := iSizeArr + 2 * iSizeArr;
      SetLength(arrUsername, iSizeArr);
      SetLength(arrPass_Word, iSizeArr);
      arrUsername[iCount] := dmPAT_DB.tblPersonel['Username'];
      arrPass_Word[iCount] := dmPAT_DB.tblPersonel['Pass_Word'];
    end;
    // showmessagefmt('%d >>> %d',[iCount, length(arrUsername) ]);
    Inc(iCount);
    dmPAT_DB.tblPersonel.Next;
  end;

  dec(iCount);
  // sort array of usernames
  for iNum := 0 to (iCount) do
  begin
    for iCount2 := 0 to (iCount - 1) do
    begin
      if (arrUsername[iCount2] > arrUsername[(iCount2 + 1)]) then
      begin
        sTemp := arrUsername[iCount2];
        arrUsername[iCount2] := arrUsername[iCount2 + 1];
        arrUsername[iCount2 + 1] := sTemp;

        sPassTemp := arrPass_Word[iCount2];
        arrPass_Word[iCount2] := arrPass_Word[iCount2 + 1];
        arrPass_Word[iCount2 + 1] := sPassTemp;
      end;
    end;
  end;

  // add to combo box(sorted)
  for iNum := 0 to iCount do
  begin
    cmbUsernames.Items.Add(arrUsername[iNum]);
  end;

end;

end.
