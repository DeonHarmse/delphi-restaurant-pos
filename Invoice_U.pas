unit Invoice_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, System.DateUtils,
  Math;

type
  TfrmInvoice = class(TForm)
    imgInvoice: TImage;
    lblInvoice: TLabel;
    lblPointsUsed: TLabel;
    lblCouponCode: TLabel;
    edtPointsUsed: TEdit;
    edtCouponCode: TEdit;
    grpInvoiceData: TGroupBox;
    lblDiscount: TLabel;
    edtDiscounts: TEdit;
    redInvoice: TRichEdit;
    btnPaid: TButton;
    btnInvoice_Back: TButton;
    btnInvoiceCalculate: TButton;
    procedure btnInvoice_BackClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure InsertionSort(iCount: Integer; sline: string);
    procedure btnInvoiceCalculateClick(Sender: TObject);
    procedure btnPaidClick(Sender: TObject);
    procedure AddLine;
  private
  var
    arrCode: Array of String;
    arrValue: Array of Currency;
    iDiscount: Integer;
    iMax: Integer;
    tReceipts: Textfile;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInvoice: TfrmInvoice;

implementation

uses
  dmPAT_DB_U,
  Purchase_U;

{$R *.dfm}

procedure TfrmInvoice.btnInvoiceCalculateClick(Sender: TObject);
var
  sizeArr: Integer;
  tCoupon: Textfile;
  sline: string;
  iCount: Integer;
  iEnterCoupons: Integer;
  cCouponValue: Currency;
  tReceipts: Textfile;
  cTotal: Currency;
begin
  if (edtPointsUsed.Text = '') then
    edtPointsUsed.Text := '0';

  if (strtoint(edtPointsUsed.Text) > cPoint) then
  begin
    ShowMessage('Insufficient customer points.');
    exit;
  end;

  // Check if coupon file exists, then assign file for reading
  if NOT(FileExists('Coupons.txt')) then
  begin
    ShowMessage('File not found.');
    exit;
  end;

  AssignFile(tCoupon, 'Coupons.txt');
  Reset(tCoupon);

  // Set array position and size
  iCount := 0;
  sizeArr := 10;
  SetLength(arrCode, sizeArr);
  SetLength(arrValue, sizeArr);

  // Read data Copy into arrays
  while NOT(EOF(tCoupon)) do //
  begin
    Readln(tCoupon, sline);
    if (Length(sline) > 6) then
    begin
      if (iCount < sizeArr) then
      begin
        arrCode[iCount] := Copy(sline, 1, 5);
        Delete(sline, 1, 6);
        arrValue[iCount] := StrToCurr(sline);
      end
      else
      begin
        // Array too small, therefore makes array larger
        sizeArr := sizeArr + 2 * sizeArr;
        SetLength(arrCode, sizeArr);
        SetLength(arrValue, sizeArr);

        arrCode[iCount] := Copy(sline, 1, 5);
        Delete(sline, 1, 6);
        arrValue[iCount] := StrToCurr(sline);
      end;
      Inc(iCount);
    end;
  end;

  Dec(iCount);
  InsertionSort(iCount, sline);

  Rewrite(tCoupon);
  for iEnterCoupons := 0 to iCount do
  begin
    if (edtCouponCode.Text <> arrCode[iEnterCoupons]) then
    begin
      Writeln(tCoupon, Format('%s#%f', [arrCode[iEnterCoupons],
        arrValue[iEnterCoupons]]));
    end
    else
      cCouponValue := arrValue[iEnterCoupons];
  end;

  Closefile(tCoupon);
  btnPaid.Visible := True;

  dmPAT_DB.tblOrders.First;

  iMax := 1;
  while NOT(dmPAT_DB.tblOrders.EOF) do
  begin
    if (iMax < dmPAT_DB.tblOrders['Order_ID']) then
      iMax := dmPAT_DB.tblOrders['Order_ID'];
    dmPAT_DB.tblOrders.Next;
  end;

  if (cCouponValue = 0) AND (iDiscount = 0) AND
    (strtoint(edtPointsUsed.Text) > 0) then
  begin
    cTotal := cSubtotal;
    redInvoice.Lines.Add(Format('%s%sTotal:%s%m', [sLineBreak, #9, #9,
      cSubtotal]));
    redInvoice.Lines.Add(Format('%s%sPoints earned:%s%m', [sLineBreak, #9, #9,
      (Round(dmPAT_DB.tblClients['Points'] - StrToCurr(edtPointsUsed.Text) +
      cSubtotal * 0.01))]));
  end
  else
  begin
    redInvoice.Lines.Add(Format('%s%sSubtotal:%s%m', [sLineBreak, #9, #9,
      cSubtotal]));
    if (strtoint(edtPointsUsed.Text) > 0) then
      redInvoice.Lines.Add(Format('%sPoints Used:%s%m',
        [#9, #9, cCouponValue]));

    if (cCouponValue > 0) then
      redInvoice.Lines.Add(Format('%sCoupon Value:%s%m',
        [#9, #9, StrToCurr(edtPointsUsed.Text)]));

    if (iDiscount > 0) then
      redInvoice.Lines.Add(Format('%s%sDiscount:%s%d%%', [sLineBreak, #9, #9,
        iDiscount]));

    cTotal := (cSubtotal - StrToCurr(edtPointsUsed.Text) - cCouponValue) * 100 /
      (100 + iDiscount);

    redInvoice.Lines.Add(Format('%s%sPoints earned:%s%m', [sLineBreak, #9, #9,
      (Round(dmPAT_DB.tblClients['Points'] - StrToCurr(edtPointsUsed.Text) +
      cSubtotal * 0.01))]));

    redInvoice.Lines.Add(Format('%sTotal:%s%m', [#9, #9, cTotal]));

  end;

  AddLine;

  redInvoice.Lines.Add
    (Format('%sOrder Number:%s%d%s%sCell Number:%s%s%s%sDate:%s%s%s',
    [#9, #9, iMax, sLineBreak, #9, #9, sCell_Num, sLineBreak, #9, #9,
    datetostr(Now), sLineBreak]));

  With dmPAT_DB do
  begin
    tblClients.Locate('Cell_Number', sCell_Num, []);
    tblClients.Edit;
    tblClients['Points'] := Round(dmPAT_DB.tblClients['Points'] -
      StrToCurr(edtPointsUsed.Text) + cSubtotal * 0.01);
    tblClients.Post;
  end;

  btnInvoiceCalculate.Hide;
end;

procedure TfrmInvoice.InsertionSort(iCount: Integer; sline: string);
var
  iSortCount: Integer;
  iKey: Integer;
  sTemp: string;
  iKeyDec: Integer;
  cTemp: Currency;
begin
  // Insertion sort :
  for iSortCount := 0 to iCount do
  begin
    iKey := iSortCount;
    // Store the key value in a temporary variable
    sTemp := arrCode[iKey];
    cTemp := arrValue[iKey];
    // Compare the key with each element on the left of it
    iKeyDec := iKey - 1;
    while (iKeyDec >= 0) and (arrCode[iKeyDec] > sTemp) do
    begin
      // Shift the elements to the right
      arrCode[iKeyDec + 1] := arrCode[iKeyDec];
      arrValue[iKeyDec + 1] := arrValue[iKeyDec];
      Dec(iKeyDec);
    end;
    // Place the key in its correct position
    arrCode[iKeyDec + 1] := sTemp;
    arrValue[iKeyDec + 1] := cTemp;
  end;
end;

procedure TfrmInvoice.btnPaidClick(Sender: TObject);
var
  iArrLoop: Integer;
  sFileName: String;
begin
  with dmPAT_DB do
  begin
    tblOrders.Insert;
    tblOrders['Order_ID'] := iMax + 1;
    tblOrders['Order_Date'] := datetostr(Now);
    tblOrders['Client_Cell_Number'] := sCell_Num;
    tblOrders.Post;
  end;

  for iArrLoop := 0 to (iItemCount - 1) do
  begin
    if (arrItem_Quantity[iArrLoop] > 0) then
    begin
      with dmPAT_DB do
      begin
        tblOrder_Items.Insert;
        tblOrder_Items['Item_ID'] := arrItem_ID[iArrLoop];
        tblOrder_Items['Item_Quantity'] := arrItem_Quantity[iArrLoop];
        tblOrder_Items['Order_ID'] := iMax + 1;
        tblOrder_Items.Post;

      end;
    end;
  end;

  sFileName := 'Receipt_No_' + inttostr(iMax + 1);
  redInvoice.Lines.SaveToFile(sFileName);
  ShowMessage('Successfully saved data.');
  frmInvoice.Hide;
  frmPurchases.Show;
end;

procedure TfrmInvoice.AddLine;
begin
  redInvoice.Paragraph.TabCount := 0;
  redInvoice.Lines.Add
    ('_________________________________________________________');
  frmInvoice.redInvoice.Paragraph.TabCount := 2;
  frmInvoice.redInvoice.Paragraph.Tab[0] := 25;
  frmInvoice.redInvoice.Paragraph.Tab[1] := 150;
end;

procedure TfrmInvoice.btnInvoice_BackClick(Sender: TObject);
begin
  frmPurchases.Show;
  frmInvoice.Hide;
end;

procedure TfrmInvoice.FormActivate(Sender: TObject);
var
  iArrLoop: Integer;
  iDuplicateLoop: Integer;
  sline: String;
begin
  edtPointsUsed.Clear;
  edtCouponCode.Clear;
  edtDiscounts.Clear;
  btnPaid.Visible := True;
  btnInvoiceCalculate.Visible := True;

  for iArrLoop := 0 to (iItemCount - 1) do
  begin
    if (arrItem_Quantity[iArrLoop] > 0) then
    begin
      for iDuplicateLoop := (iArrLoop + 1) to (iItemCount - 1) do
      begin
        if (arrItem_ID[iDuplicateLoop] = arrItem_ID[iArrLoop]) AND
          (arrItem_ID[iDuplicateLoop] > 0) then
        begin
          arrItem_Quantity[iArrLoop] := arrItem_Quantity[iArrLoop] +
            arrItem_Quantity[iDuplicateLoop];
          arrItem_Quantity[iDuplicateLoop] := 0;
        end;
      end;

      dmPAT_DB.tblMenu.Locate('Item_ID', arrItem_ID[iArrLoop], []);
      sline := Format('%d%s%s%s%m ', [arrItem_Quantity[iArrLoop], #9,
        dmPAT_DB.tblMenu['Item_Description'], #9,
        (StrToCurr(dmPAT_DB.tblMenu['Price']) * arrItem_Quantity[iArrLoop])]);
      redInvoice.Lines.Add(sline);

    end;
  end;

  // Point able to use is added to point text hint
  edtPointsUsed.TextHint := Format('%m available', [(cPoint)]);
  if (sRegDate = '') then
    sRegDate := datetostr(Now);

  if (Floor((YearsBetween(Now, strtodate(sRegDate)) / 2)) > 10) then
  begin
    edtDiscounts.Text := '10%';
    iDiscount := 10;
  end
  else
  begin
    iDiscount := Floor((YearsBetween(Now, strtodate(sRegDate)) / 2));
    edtDiscounts.Text := inttostr(iDiscount) + '%';
  end;
  AddLine;

  // Make paid button transparent
  btnPaid.Visible := False;
end;

end.
