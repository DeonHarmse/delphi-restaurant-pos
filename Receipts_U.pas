unit Receipts_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Samples.Spin;

type
  TfrmReceipts = class(TForm)
    imgReceipts: TImage;
    lblReceipt: TLabel;
    redReceipts: TRichEdit;
    btnRead: TButton;
    sedReceiptNumber: TSpinEdit;
    lblReceiptNumber: TLabel;
    btnLogout: TButton;
    btnReceiptsBack: TButton;
    procedure btnReadClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnReceiptsBackClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  private
    { Private declarations }
  var
    sFileName: String;
    iFileCount: Integer;
  public
    { Public declarations }
  end;

var
  frmReceipts: TfrmReceipts;

implementation
uses
Register_U, Login_U;
{$R *.dfm}

procedure TfrmReceipts.btnLogoutClick(Sender: TObject);
begin
 frmReceipts.Hide;
 frmLogin.Show;
end;

procedure TfrmReceipts.btnReadClick(Sender: TObject);
begin
  sFileName := 'Receipt_No_' + IntToStr(sedReceiptNumber.Value);
  redReceipts.Lines.LoadFromFile(sFileName);
end;

procedure TfrmReceipts.btnReceiptsBackClick(Sender: TObject);
begin
 frmReceipts.Hide;
 frmRegister.Show;
end;

procedure TfrmReceipts.FormActivate(Sender: TObject);
begin
  iFileCount := 101;
  sedReceiptNumber.MinValue := 101;
  sedReceiptNumber.Value := 101;
  sFileName := 'Receipt_No_' + IntToStr(iFileCount);
  while (FileExists(sFileName)) do
  begin;
    sedReceiptNumber.MaxValue := iFileCount;
    Inc(iFileCount);
    sFileName := 'Receipt_No_' + IntToStr(iFileCount);
  end;
end;

end.
