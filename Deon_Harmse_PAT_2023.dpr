program Deon_Harmse_PAT_2023;

uses
  Vcl.Forms,
  Login_U in 'Login_U.pas' {frmLogin},
  Register_U in 'Register_U.pas' {frmRegister},
  Purchase_U in 'Purchase_U.pas' {frmPurchases},
  ClientRegister_U in 'ClientRegister_U.pas' {frmClientRegister},
  DatabaseManagement_U in 'DatabaseManagement_U.pas' {frmDatabaseManagement},
  Invoice_U in 'Invoice_U.pas' {frmInvoice},
  Receipts_U in 'Receipts_U.pas' {frmReceipts},
  dmPAT_DB_U in 'dmPAT_DB_U.pas' {dmPAT_DB: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmPurchases, frmPurchases);
  Application.CreateForm(TfrmClientRegister, frmClientRegister);
  Application.CreateForm(TfrmDatabaseManagement, frmDatabaseManagement);
  Application.CreateForm(TfrmInvoice, frmInvoice);
  Application.CreateForm(TfrmReceipts, frmReceipts);
  Application.CreateForm(TdmPAT_DB, dmPAT_DB);
  Application.Run;
end.
