program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  MahBit8 in 'MahBit8.pas',
  MahBit32 in 'MahBit32.pas',
  nodave in 'nodave.pas',
  dlgUAyarlar in 'SimensPLS.Dialogs\dlgUAyarlar.pas' {dlgAyarlar},
  dlgUSplashLoading in 'SimensPLS.Dialogs\dlgUSplashLoading.pas' {dlgSplashLoading},
  PropSaver in 'SimensPLS.Lib\PropSaver.pas',
  PropSaverSelectCompDlg in 'SimensPLS.Lib\PropSaverSelectCompDlg.pas' {dlgPropSaverCompSelect};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
