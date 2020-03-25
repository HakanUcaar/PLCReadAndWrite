unit dlgUAyarlar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, RzShellDialogs, nodave, PropSaver,
  IniFiles;

type
  TdlgAyarlar = class(TForm)
    btnKapat: TButton;
    PageControl1: TPageControl;
    tsGenel: TTabSheet;
    tsCikti: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    lblVeriAlmaSuresi: TLabel;
    edtDelay: TEdit;
    lblMiliSaniye: TLabel;
    chkLogKaydet: TCheckBox;
    lblKlasorYolu: TLabel;
    edtKlasorYolu: TEdit;
    btnSec: TButton;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    rgReadType: TRadioGroup;
    GroupBox2: TGroupBox;
    lblDataBlock: TLabel;
    lblBaslangic: TLabel;
    lblUzunluk: TLabel;
    lblBaslangicByte: TLabel;
    lblUzunlukByte: TLabel;
    edtDataBlock: TEdit;
    edtCount: TEdit;
    edtLength: TEdit;
    GroupBox4: TGroupBox;
    lblIPAdress: TLabel;
    edtIPAdres: TEdit;
    lblPort: TLabel;
    edtPort: TEdit;
    GroupBox5: TGroupBox;
    lblRack: TLabel;
    edtRack: TEdit;
    lblSlot: TLabel;
    edtSlot: TEdit;
    rgProtocols: TRadioGroup;
    rgReadSpeed: TRadioGroup;
    btnBaglantiTest: TButton;
    GroupBox6: TGroupBox;
    rgConventers: TRadioGroup;
    chkCevirici: TCheckBox;
    btnSaveCompList: TButton;
    tsYazma: TTabSheet;
    GroupBox7: TGroupBox;
    procedure btnKapatClick(Sender: TObject);
    procedure btnSecClick(Sender: TObject);
    procedure chkLogKaydetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkCeviriciClick(Sender: TObject);
    procedure btnBaglantiTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveCompListClick(Sender: TObject);
  private
    function ConnectTest:Boolean;
  public
    { Public declarations }
  end;

var
  dlgAyarlar: TdlgAyarlar;
  dc    : pdaveConnection;
  dcIn  : pdaveInterface;
  AItem : THUPropSave;
  ini   : TIniFile;

implementation

uses dlgUSplashLoading, PropSaverSelectCompDlg;

{$R *.dfm}

procedure TdlgAyarlar.btnKapatClick(Sender: TObject);
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Setting.ini');
  ini.WriteString('Setting','IPAdres',edtIPAdres.Text);
  ini.WriteInteger('Setting','Port',StrToInt(edtPort.Text));
  ini.WriteInteger('Setting','Rack',StrToInt(edtRack.Text));
  ini.WriteInteger('Setting','Slot',StrToInt(edtSlot.Text));
  ini.WriteInteger('Setting','Count',StrToInt(edtCount.Text));
  ini.WriteInteger('Setting','Length',StrToInt(edtLength.Text));
  ini.WriteInteger('Setting','DB',StrToInt(edtDataBlock.Text));
  ini.WriteInteger('Setting','ProtocolIx',rgProtocols.ItemIndex);
  ini.WriteInteger('Setting','ReadSpeedIx',rgReadSpeed.ItemIndex);
  ini.WriteInteger('Setting','ReadTypeIx',rgReadType.ItemIndex);
  ini.WriteInteger('Setting','ConvertIx',rgConventers.ItemIndex);
  ini.WriteString('Setting','LogKlasorYolu',edtKlasorYolu.Text);
  ini.WriteBool('Setting','DurumKaydet',chkLogKaydet.Checked);
  ini.WriteBool('Setting','CeviriKullan',chkCevirici.Checked);

  ModalResult := mrOk;
end;

procedure TdlgAyarlar.btnSecClick(Sender: TObject);
begin
  if RzSelectFolderDialog1.Execute Then
    begin
      edtKlasorYolu.Text := RzSelectFolderDialog1.SelectedPathName;
    end;
end;

procedure TdlgAyarlar.chkLogKaydetClick(Sender: TObject);
begin
  edtKlasorYolu.Enabled := chkLogKaydet.Checked;
  btnSec.Enabled := chkLogKaydet.Checked;  
end;

procedure TdlgAyarlar.FormShow(Sender: TObject);
begin
  rgConventers.Enabled := chkCevirici.Checked;
  edtKlasorYolu.Enabled := chkLogKaydet.Checked;
  btnSec.Enabled := chkLogKaydet.Checked;
end;

procedure TdlgAyarlar.chkCeviriciClick(Sender: TObject);
begin
  if not chkCevirici.Checked then rgConventers.ItemIndex := -1;
  rgConventers.Enabled := chkCevirici.Checked;
end;

function TdlgAyarlar.ConnectTest: Boolean;
Var
 Fds:_daveOSserialType;
 I,N:Integer;
begin
  fds.rfd:=openSocket(StrToInt(edtPort.Text),PChar(edtIPAdres.Text));
  fds.wfd:=fds.rfd;

  if (fds.rfd>0) then
  begin
    dcIn:=daveNewInterface(fds, 'IF1',0,daveProtoISOTCP, daveSpeed187k);
    dcIn^.timeout:=500;

    if (daveInitAdapter(dcIn)=0) then
    begin
      dc :=daveNewConnection(dcIn,2, StrToInt(edtRack.Text), StrToInt(edtSlot.Text));
      if (daveConnectPLC(dc)=0) then
        Result := True
      else
        Result := False;
    end
    else Result := False;
  end
  else Result := False;
end;

procedure TdlgAyarlar.btnBaglantiTestClick(Sender: TObject);
begin
  Application.CreateForm(TdlgSplashLoading,dlgSplashLoading);
  dlgSplashLoading.Show;
  dlgSplashLoading.Update;
  
  if not ConnectTest Then
    begin
      dlgSplashLoading.Free;
      ShowMessage('Baðlantý baþarýsýz')
    end
  else
    begin
      dlgSplashLoading.Free;
      ShowMessage('Baðlantý baþarýlý.');
    end;
end;

procedure TdlgAyarlar.FormCreate(Sender: TObject);
begin
  AItem := THUPropSave.Create(Self);
end;

procedure TdlgAyarlar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  AItem.Save;
  AItem.Free;
end;

procedure TdlgAyarlar.btnSaveCompListClick(Sender: TObject);
begin
  Application.CreateForm(TdlgPropSaverCompSelect,dlgPropSaverCompSelect);
  dlgPropSaverCompSelect.OS := AItem;
  if dlgPropSaverCompSelect.ShowModal=mrok Then
    begin                         
      
    end;
  dlgPropSaverCompSelect.Free;
end;

end.
