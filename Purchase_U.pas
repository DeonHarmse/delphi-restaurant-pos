unit Purchase_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ButtonGroup, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.ComCtrls,
  Vcl.Samples.Spin;

type
  TfrmPurchases = class(TForm)
    lblPurchases: TLabel;
    BtnGrpFood: TButtonGroup;
    ImgPurchases: TImage;
    BtnGrpDrinks: TButtonGroup;
    btnPurchasesLogout: TButton;
    btnCheckout: TButton;
    btnSwitch: TButton;
    redPurchases: TRichEdit;
    btnReset: TButton;
    sedQty: TSpinEdit;
    lblQuantity: TLabel;
    procedure btnSwitchClick(Sender: TObject);
    procedure BtnGrpFoodItems0Click(Sender: TObject);
    procedure BtnGrpFoodItems1Click(Sender: TObject);
    procedure BtnGrpFoodItems2Click(Sender: TObject);
    procedure BtnGrpFoodItems3Click(Sender: TObject);
    procedure BtnGrpFoodItems4Click(Sender: TObject);
    procedure BtnGrpFoodItems5Click(Sender: TObject);
    procedure BtnGrpFoodItems6Click(Sender: TObject);
    procedure BtnGrpFoodItems7Click(Sender: TObject);
    procedure BtnGrpFoodItems8Click(Sender: TObject);
    procedure BtnGrpFoodItems9Click(Sender: TObject);
    procedure BtnGrpFoodItems10Click(Sender: TObject);
    procedure BtnGrpFoodItems11Click(Sender: TObject);
    procedure BtnGrpFoodItems12Click(Sender: TObject);
    procedure BtnGrpFoodItems13Click(Sender: TObject);
    procedure BtnGrpFoodItems14Click(Sender: TObject);
    procedure BtnGrpFoodItems15Click(Sender: TObject);
    procedure BtnGrpFoodItems16Click(Sender: TObject);
    procedure BtnGrpFoodItems17Click(Sender: TObject);
    procedure BtnGrpFoodItems18Click(Sender: TObject);
    procedure BtnGrpFoodItems19Click(Sender: TObject);
    procedure BtnGrpFoodItems20Click(Sender: TObject);
    procedure BtnGrpFoodItems21Click(Sender: TObject);
    procedure BtnGrpFoodItems22Click(Sender: TObject);
    procedure BtnGrpDrinksItems0Click(Sender: TObject);
    procedure BtnGrpDrinksItems1Click(Sender: TObject);
    procedure BtnGrpDrinksItems2Click(Sender: TObject);
    procedure BtnGrpDrinksItems3Click(Sender: TObject);
    procedure BtnGrpDrinksItems4Click(Sender: TObject);
    procedure BtnGrpDrinksItems5Click(Sender: TObject);
    procedure BtnGrpDrinksItems6Click(Sender: TObject);
    procedure BtnGrpDrinksItems7Click(Sender: TObject);
    procedure BtnGrpDrinksItems8Click(Sender: TObject);
    procedure BtnGrpDrinksItems9Click(Sender: TObject);
    procedure BtnGrpDrinksItems10Click(Sender: TObject);
    procedure BtnGrpDrinksItems11Click(Sender: TObject);
    procedure BtnGrpDrinksItems12Click(Sender: TObject);
    procedure BtnGrpDrinksItems13Click(Sender: TObject);
    procedure BtnGrpDrinksItems14Click(Sender: TObject);
    procedure BtnGrpDrinksItems15Click(Sender: TObject);
    procedure BtnGrpDrinksItems16Click(Sender: TObject);
    procedure BtnGrpDrinksItems17Click(Sender: TObject);
    procedure BtnGrpDrinksItems18Click(Sender: TObject);
    procedure BtnGrpDrinksItems19Click(Sender: TObject);
    procedure BtnGrpDrinksItems20Click(Sender: TObject);
    procedure BtnGrpDrinksItems21Click(Sender: TObject);
    procedure BtnGrpDrinksItems22Click(Sender: TObject);
    procedure BtnGrpDrinksItems23Click(Sender: TObject);
    procedure BtnGrpDrinksItems24Click(Sender: TObject);
    procedure BtnGrpDrinksItems25Click(Sender: TObject);
    procedure BtnGrpDrinksItems26Click(Sender: TObject);
    procedure BtnGrpDrinksItems27Click(Sender: TObject);
    procedure BtnGrpDrinksItems28Click(Sender: TObject);
    procedure BtnGrpDrinksItems29Click(Sender: TObject);
    procedure BtnGrpDrinksItems30Click(Sender: TObject);
    procedure BtnGrpDrinksItems31Click(Sender: TObject);
    procedure BtnGrpDrinksItems32Click(Sender: TObject);
    procedure BtnGrpDrinksItems33Click(Sender: TObject);
    procedure BtnGrpDrinksItems34Click(Sender: TObject);
    procedure BtnGrpDrinksItems35Click(Sender: TObject);
    procedure BtnGrpDrinksItems36Click(Sender: TObject);
    procedure BtnGrpDrinksItems37Click(Sender: TObject);
    procedure BtnGrpDrinksItems38Click(Sender: TObject);
    function Search(sItem: String): String;
    procedure FormActivate(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnPurchasesLogoutClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure NumIntegerCheck;
    procedure CellNumber_DigitCheck;
    procedure Locate_Cell;
  private
  var
    iSizeArr: Integer;
    bCellRetry: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPurchases: TfrmPurchases;
  cSubtotal: Currency;
  sRegDate: string;
  cPoint: Currency;
  sCell_Num: string;
  iItemCount: Integer;
  arrItem_ID: array of Integer;
  arrItem_Quantity: array of Integer;

implementation

uses
  Login_U, ClientRegister_U, dmPAT_DB_U, Invoice_U;
{$R *.dfm}

procedure TfrmPurchases.btnCheckoutClick(Sender: TObject);
begin
  // Add totals
  redPurchases.Lines.Add
    (Format('%s%s----------%s%sSubtotal:%sR%m%s%s%s----------',
    [#9, #9, sLinebreak, #9, #9, cSubtotal, sLinebreak, #9, #9]));

  // Ask if client is registered through a message dialog
  If (MessageDlg('Is the client registered?', mtCustom, [mbYes, mbNo], 0) = 6)
  then
  begin
  //Validate cell number
    bCellRetry := True;

    CellNumber_DigitCheck;
    if (bCellRetry = False) then      //Exit to stop multiple errors from overwhelming the user
      exit;

    NumIntegerCheck;
    if (bCellRetry = False) then
      exit;

    Locate_Cell;
    if (bCellRetry = False) then
      exit;

    //Get data from database to calculate
    cPoint := strtocurr(dmPAT_DB.tblClients['Points']);
    sRegDate := dmPAT_DB.tblClients['Date_Registered'];

    dmPAT_DB.tblClients.First;

    frmInvoice.show;
    frmPurchases.Hide;
  end
  else
  begin
    // "No", client not registered so change forms to register.
    frmClientRegister.show;
    frmPurchases.Hide;

  end;
end;

procedure TfrmPurchases.BtnGrpDrinksItems0Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[0].caption);
end;

procedure TfrmPurchases.BtnGrpDrinksItems10Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[10].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems11Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[11].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems12Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[12].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems13Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[13].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems14Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[14].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems15Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[15].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems16Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[16].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems17Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[17].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems18Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[18].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems19Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[19].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems1Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[1].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems20Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[20].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems21Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[21].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems22Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[22].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems23Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[23].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems24Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[24].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems25Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[25].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems26Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[26].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems27Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[27].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems28Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[28].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems29Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[29].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems2Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[2].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems30Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[30].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems31Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[31].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems32Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[32].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems33Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[33].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems34Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[34].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems35Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[35].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems36Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[36].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems37Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[37].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems38Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[38].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems3Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[3].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems4Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[4].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems5Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[5].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems6Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[6].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems7Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[7].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems8Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[8].caption)
end;

procedure TfrmPurchases.BtnGrpDrinksItems9Click(Sender: TObject);
begin
  Search(BtnGrpDrinks.Items[9].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems0Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[0].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems10Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[10].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems11Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[11].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems12Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[12].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems13Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[13].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems14Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[14].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems15Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[15].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems16Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[16].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems17Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[17].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems18Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[18].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems19Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[19].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems1Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[1].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems20Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[20].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems21Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[21].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems22Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[22].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems2Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[2].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems3Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[3].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems4Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[4].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems5Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[5].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems6Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[6].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems7Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[7].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems8Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[8].caption)
end;

procedure TfrmPurchases.BtnGrpFoodItems9Click(Sender: TObject);
begin
  Search(BtnGrpFood.Items[9].caption)
end;

procedure TfrmPurchases.btnPurchasesLogoutClick(Sender: TObject);
begin
  // Go to login form
  frmPurchases.Hide;
  frmLogin.show;
end;

procedure TfrmPurchases.btnResetClick(Sender: TObject);
begin
  // Clear and reset subtotal
  redPurchases.Clear;
  frmInvoice.redInvoice.Clear;
  cSubtotal := 0;
  BtnGrpFood.Visible := False;
  BtnGrpDrinks.Visible := True;
end;

procedure TfrmPurchases.btnSwitchClick(Sender: TObject);
begin
  // Changes button group based on what is already visible
  if (BtnGrpDrinks.Visible = True) then
  begin
    BtnGrpFood.Visible := True;
    BtnGrpDrinks.Visible := False;
  end
  else
  begin
    BtnGrpFood.Visible := False;
    BtnGrpDrinks.Visible := True;
  end;
end;

procedure TfrmPurchases.FormActivate(Sender: TObject);
begin
  // Set quantity spinner min, max and value.
  sedQty.MinValue := 1;
  sedQty.MaxValue := 100;
  sedQty.Value := 1;

  cSubtotal := 0;

  // Set tabs for Purchases and Invoice
  redPurchases.Clear;
  redPurchases.Paragraph.TabCount := 2;
  redPurchases.Paragraph.Tab[0] := 25;
  redPurchases.Paragraph.Tab[1] := 150;

  frmInvoice.redInvoice.Clear;
  frmInvoice.redInvoice.Paragraph.TabCount := 2;
  frmInvoice.redInvoice.Paragraph.Tab[0] := 25;
  frmInvoice.redInvoice.Paragraph.Tab[1] := 150;

  // Add titles to line
  redPurchases.Lines.Add(Format('%s%s%s%s%s', ['Qty', #9, 'Item', #9,
    'Price']));
  frmInvoice.redInvoice.Lines.Add(Format('%s%s%s%s%s', ['Qty', #9, 'Item', #9,
    'Price']));

  iItemCount := 0;
  iSizeArr := 10;
  SetLength(arrItem_Quantity, iSizeArr);
  SetLength(arrItem_ID, iSizeArr);

end;

procedure TfrmPurchases.NumIntegerCheck;
var
  iCount: Integer;
begin
  //Checks if all digits are integers
  for iCount := 1 to Length(sCell_Num) do
  begin
    if (ord(sCell_Num[iCount]) < 48) OR (ord(sCell_Num[iCount]) > 57)
    then
    begin
      ShowMessage('Please make sure you have entered numbers only.');
      exit
    end;
  end;
end;

procedure TfrmPurchases.CellNumber_DigitCheck;
begin
  sCell_Num := InputBox('Cellphone Number',
    'Please enter client cellphone number', '');
  // Check if cell number is 10 digits
  while (sCell_Num.Length <> 10) do
  begin
    // Incorrect length and retries, asks if wants to retry
    if (MessageDlg
      ('The cellphone number is the incorrect length.  Please make sure the number is 10 digits long.  Do you want to retry',
      mtCustom, [mbYes, mbNo], 0) = 6) then
    begin
      // Retry cellphone number
      sCell_Num := InputBox('Cellphone Number',
        '  Please re-enter client cellphone number.', '');
    end
    else
    begin
      bCellRetry := False;
      exit
    end;
  end;
end;

procedure TfrmPurchases.Locate_Cell;
begin
  while (dmPAT_DB.tblClients.locate('Cell_Number', sCell_Num, []) = False) do
  begin
    // Cell phone number is not verified
    if (MessageDlg('Cell phone number was not found.  Do you want to retry?',
      mtCustom, [mbYes, mbNo], 0) = 6) then
    begin
      sCell_Num := InputBox('Cellphone Number',
        'Please enter client cellphone number', '');
    end
    else
    begin
      bCellRetry := False;
      exit
    end;
  end;
end;

function TfrmPurchases.Search(sItem: String): String;
begin
  //Search for the item and assign the value accordingly
  dmPAT_DB.tblMenu.First;
  if (dmPAT_DB.tblMenu.locate('Item_Description', sItem, []) = False) then
  begin
    ShowMessage('Record not found.')
  end
  else
  begin
    redPurchases.Lines.Add(Format('%d%s%s%s%m', [sedQty.Value, #9,
      dmPAT_DB.tblMenu['Item_Description'], #9,
      strtofloat(dmPAT_DB.tblMenu['Price']) * sedQty.Value]));
    cSubtotal := cSubtotal + dmPAT_DB.tblMenu['Price'] * sedQty.Value;

    if (iItemCount < iSizeArr) then
    begin
      arrItem_ID[iItemCount] := dmPAT_DB.tblMenu['Item_ID'];
      arrItem_Quantity[iItemCount] := arrItem_Quantity[iItemCount] +
        sedQty.Value;
    end
    else
    begin
      // Array too small, therefore makes array larger
      iSizeArr := iSizeArr + 2 * iSizeArr;
      SetLength(arrItem_Quantity, iSizeArr);
      SetLength(arrItem_ID, iSizeArr);

      arrItem_ID[iItemCount] := dmPAT_DB.tblMenu['Item_ID'];
      arrItem_Quantity[iItemCount] := arrItem_Quantity[iItemCount] +
        sedQty.Value;
    end;
    Inc(iItemCount);
  end;

  sedQty.Value := 1;
end;

end.
