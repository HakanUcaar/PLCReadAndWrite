unit Unit1;

//Yardým
//function daveReadBytes( dc : PdaveConnection;
//                      area : longint;
//                      DB   : longint;
//                     start : longint;
//                       len : longint;
//                    buffer : pointer) : longint; stdcall; cdecl;
//
//dc     - connection.
//aria   - Datablok , Merker, Input, Output.
//DB     - when a data block give data block number. Other areas simply give zero.
//start  - location of first byte you want to read.
//len    - number of bytes you want to read.
//buffer - buffer.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,  MahBit32, MahBit8, nodave, YLNThread,
  ExtCtrls, Menus, XPMan, IniFiles, MyThreadComp;

type
  Protocols = (ptMPI,ptPPI,ptISOTCP,ptISOTCP243,ptIBH);
  ReadSpeeds = (rs9k,rs19k,rs187k,rs500k,rs1500k,rs45k,rs93k);

  ReadTypes = (rtAnalogIn,rtAnalogOut,rtInputs,rtOutputs,rtFlags,rtDB);
  Converters = (ctFloat,ctInteger,ctDWORD,ctUnsignedInteger,ctWORD);

  PLCSetting = packed  record
    IPAdress  : string;
    Port      : Integer;
    Rack      : Integer;
    Slot      : Integer;
    DB        : Integer;
    Start     : Integer;
    Length    : Integer;
    Protocol  : Protocols;
    ReadSpeed : ReadSpeeds;
    ReadType  : ReadTypes;
    Converter : Converters;
  end;

  TfrmMain = class(TForm)
    YLNThread1: TYLNThread;
    pnlMain: TPanel;
    GroupBox1: TGroupBox;
    lblIP: TLabel;
    Label1: TLabel;
    lblRack: TLabel;
    lblSloat: TLabel;
    edtIP: TEdit;
    edtMPort: TEdit;
    seRack: TSpinEdit;
    seSlot: TSpinEdit;
    btnConnect: TButton;
    btnDisconnect: TButton;
    GroupBox3: TGroupBox;
    mmoDurum: TMemo;
    GroupBox2: TGroupBox;
    Label99: TLabel;
    seDataBlock: TSpinEdit;
    seLength: TSpinEdit;
    seStart: TSpinEdit;
    btnStart: TButton;
    btnFinish: TButton;
    btnOku: TButton;
    MainMenu1: TMainMenu;
    Dosya1: TMenuItem;
    XPManifest1: TXPManifest;
    pbtnAyarlar: TMenuItem;
    pbtnCikis: TMenuItem;
    pbtnN1: TMenuItem;
    pbtnYardim: TMenuItem;
    edtRepeatCount: TEdit;
    GroupBox4: TGroupBox;
    mmoSonuc: TMemo;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    btnWrite: TButton;
    mmoWrite: TMemo;
    edtMeter: TEdit;
    edtWeight: TEdit;
    btnWriteStart: TButton;
    btnWriteStop: TButton;
    seWLength: TSpinEdit;
    seWStart: TSpinEdit;
    seWDataBlock: TSpinEdit;
    Label4: TLabel;
    YLNThread2: TYLNThread;
    Timer1: TTimer;
    Timer2: TTimer;
    YLNTimerThread1: TYLNTimerThread;
    YLNTimerThread2: TYLNTimerThread;
    procedure btnStartClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure YLNThread1Execute(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure btnOkuClick(Sender: TObject);
    procedure pbtnCikisClick(Sender: TObject);
    procedure pbtnAyarlarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seDataBlockChange(Sender: TObject);
    procedure seLengthChange(Sender: TObject);
    procedure seStartChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnWriteClick(Sender: TObject);
    procedure btnWriteStartClick(Sender: TObject);
    procedure YLNThread2Execute(Sender: TObject);
    procedure btnWriteStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure YLNTimerThread1Execute(Sender: TObject);
    procedure YLNTimerThread2Execute(Sender: TObject);

  private
    PLCAyarlari : PLCSetting;
    connected : boolean;
    dc   : pdaveConnection;
    dcIn : pdaveInterface;

    function GetReadType(RT:ReadTypes):Integer;
    function GetReadSpeed(RS:ReadSpeeds):Integer;
    function GetProtocol(PT:Protocols):Integer;
    function GetConverter(CT:Converters):Integer;

    function Connect:Boolean;
    function Disconnect : Boolean;

    procedure AddReadFunction;
    
    procedure TestDB;
    procedure TestFlags;
    procedure TestOutputs;
    procedure TestInputs;
    procedure TestAnalogOutputs;
    procedure TestAnalogInputs;

    procedure Test;
  public
    function SetPLCSetting : Boolean;
  end;

var
  frmMain: TfrmMain;
  ini : TIniFile;
  WarW : Integer;
  WarH : Integer;
  ReadTypeArr : array[ReadTypes] of string = ('daveAnaIn','daveAnaOut','daveInputs','daveOutputs','daveFlags','daveDB');
implementation

uses dlgUAyarlar;

{$R *.dfm}

function TfrmMain.Connect:Boolean;
Var
 Fds:_daveOSserialType;
 I,N:Integer;
begin
    //StatusBar1.Panels[0].Text:='IpAdres: '+ComName+ ', port = 102';
    mmoDurum.Lines.Add('-IPAdres = '+Trim(edtIP.Text)+' , Port = '+ Trim(edtMPort.Text) );
    mmoDurum.Lines.Add('-Baðlanmaya çalýþýlýyor.');
    mmoDurum.Lines.Add('-Bu iþlem biraz uzun sürebilir.');
    fds.rfd:=openSocket(102,PChar(edtIP.Text));
    fds.wfd:=fds.rfd;

    connected := false;
    //StatusBar1.Panels[1].Text :='Attempt of creation of the connection';
    //creation of the interface
    if (fds.rfd>0) then
    begin
      dcIn:=daveNewInterface(fds, 'IF1',0,daveProtoISOTCP, daveSpeed187k);
      dcIn^.timeout:=500;
      //StatusBar1.Panels[1].Text :='New interface: '+ 'protocol = '+inttostr(daveProtoISOTCP) + ', speed 187k = '+inttostr(daveSpeed187k);
      mmoDurum.Lines.Add('-Yeni baðlantý arayüzü : protokol = '+inttostr(daveProtoISOTCP) + ', speed 187k = '+inttostr(daveSpeed187k));

      //initialize the adapter
      if (daveInitAdapter(dcIn)=0) then
      begin
        dc :=daveNewConnection(dcIn,2, StrToInt(seRack.Text), StrToInt(seSlot.Text));
        //StatusBar1.Panels[1].Text :='Connection: MPI = 2, rack = '+rack+', slot = '+slot;
        mmoDurum.Lines.Add('-Baðlantý: MPI = 2, rack = '+seRack.Text+', slot = '+seSlot.Text);
        //connection
          connected := true;
        if (daveConnectPLC(dc)=0) then
          begin
            //StatusBar1.Panels[0].Text := 'Connected Siemens '+ComName+ ', port=102';
            mmoDurum.Lines.Add('-PLC baðlantýsý saðlandý : IPAdres ='+Trim(edtIP.Text)+', Port = '+Trim(edtMPort.Text));
            connected := true;
          end
        else mmoDurum.Lines.Add('-PLC baðlantýsý saðlanamadý.');;//StatusBar1.Panels[0].Text :='Not successful attempt of connection!';
      end
      else mmoDurum.Lines.Add('-Adaptör yüklenirken hata oluþtu.');//StatusBar1.Panels[0].Text :='Not successful attempt to initialize  the adapter!';
    end
    else mmoDurum.Lines.Add('-Baðlantý arayüzü oluþturulamadý.');//StatusBar1.Panels[0].Text :='Not successful attempt of creation of the interface!';
end;   

procedure TfrmMain.testDB;
var
 Res:LongInt;
 S:String;
 i,j:Integer;
 Buff:Array[0..1023] of Byte;
begin
   if connected then
    begin
      Try
        AddReadFunction;
        Res:=daveReadBytes(dc,GetReadType(PLCAyarlari.ReadType),PLCAyarlari.DB,PLCAyarlari.Start,PLCAyarlari.Length,@Buff);
        if (Res=0) Then
          Begin
            //mmoSonuc.Lines.Add(ByteToString(Buff));
            for j := 1 To StrToInt(edtRepeatCount.Text) do
              begin
                S:=EmptyStr;
                for i:=1 To PLCAyarlari.Length Do
                Begin
                  if i <> PLCAyarlari.Length Then
                    S:=S+IntToStr(Buff[i-1])+' , '
                  else
                    S:=S+IntToStr(Buff[i-1]);
                End;
                  mmoSonuc.Lines.Add(S);

                if PLCAyarlari.Converter <> null Then
                  case PLCAyarlari.Converter of
                    ctFloat   : mmoSonuc.Lines.Add(FloatToStr(daveGetFloat(dc)));
                    ctInteger : mmoSonuc.Lines.Add(FloatToStr(daveGetU32(dc)));
                    ctDWORD   : mmoSonuc.Lines.Add(FloatToStr(daveGetS32(dc)));
                    ctUnsignedInteger : mmoSonuc.Lines.Add(FloatToStr(daveGetU32(dc)));
                    ctWORD    : mmoSonuc.Lines.Add(FloatToStr(daveGetS32(dc)));
                  end;
              end;
          End
        Else mmoSonuc.Lines.Add('-Veri okunamadý.');

        Res:=daveReadBytes(dc,GetReadType(PLCAyarlari.ReadType),PLCAyarlari.DB,PLCAyarlari.Start,PLCAyarlari.Length,nil);
        if Res = 0 Then
          begin
            for j := 1 To StrToInt(edtRepeatCount.Text) do
              begin
                mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
              end;
          end;
      except
        on E : Exception do
          begin
            mmoDurum.Lines.Add('-Veri okunurken hata oluþtu.')
          end;
      end;
    end;
end;

function TfrmMain.Disconnect: Boolean;
begin
  if connected then
  begin
    daveDisconnectPLC(dc);
    daveDisconnectAdapter(dcIn);
    connected := false;
    mmoDurum.Clear;
    mmoDurum.Lines.Add('-Baðlantý Kapatýldý.')
  end;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  if connected then
//    YLNThread1.Execute
//    Timer1.Enabled := True
    YLNTimerThread1.Execute
  Else
    mmoDurum.Lines.Add('-Baðlantý yok. Baðlantý ayarlarýný gözden geçirip tekrar deneyiniz.')
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  Disconnect;
end;

procedure TfrmMain.YLNThread1Execute(Sender: TObject);
var Res : LongInt;
begin
  Sleep(1000);
  mmoSonuc.Clear;
  Res:=daveReadBytes(dc,daveDB,26,seWStart.Value,seWLength.Value,nil);
  if Res = 0 then
    begin
      mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
      mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
    end;
//  mmoSonuc.Lines.Add('Metre : ' + FormatFloat('00.00',(daveGetU32(dc)/100)));
//  mmoSonuc.Lines.Add('Tartý : ' + FormatFloat('00.00',(daveGetU32(dc)/100)));
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  mmoDurum.Clear;
  Connect;
end;

procedure TfrmMain.btnFinishClick(Sender: TObject);
begin
//  YLNThread1.Terminate;
//  Timer1.Enabled := FalsE;
    YLNTimerThread1.Terminate;
end;

procedure TfrmMain.btnOkuClick(Sender: TObject);
var
 Res:LongInt;
 S:String;
 i,j:Integer;
 Buff:Array[0..1023] of Byte;
begin
   if connected then
    begin
      Try
        Res:=daveReadBytes(dc,daveDB,26,0,8,@Buff);

        S:=EmptyStr;
        for i:=1 To PLCAyarlari.Length Do
        Begin
          if i <> PLCAyarlari.Length Then
            S:=S+IntToStr(Buff[i-1])+' , '
          else
            S:=S+IntToStr(Buff[i-1]);
        End;
          mmoSonuc.Lines.Add(S);

        //Res:=daveReadBytes(dc,daveDB,26,0,8,nil);
        mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
        mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));

      except
        on E : Exception do
          begin
            mmoDurum.Lines.Add('-Veri okunurken hata oluþtu.')
          end;
      end;
    end;
//  mmoSonuc.Clear;
//  if not connected then mmoDurum.Lines.Add('-Baðlantý Yok');
//  If PLCAyarlari.ReadType = rtDB Then
//    TestDB
//  Else
//    Test;
end;

procedure TfrmMain.pbtnCikisClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.pbtnAyarlarClick(Sender: TObject);
begin
  Application.CreateForm(TdlgAyarlar,dlgAyarlar);
  if dlgAyarlar.ShowModal = MrOk then
    begin
      if connected then Disconnect;
      if SetPLCSetting Then ;//Connect;
    end;
end;

function TfrmMain.SetPLCSetting : Boolean;
begin
  Result := False;

  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Setting.ini');
  PLCAyarlari.IPAdress  := ini.ReadString('Setting','IPAdres','');
  PLCAyarlari.Port      := ini.ReadInteger('Setting','Port',0);
  PLCAyarlari.Rack      := ini.ReadInteger('Setting','Rack',0);
  PLCAyarlari.Slot      := ini.ReadInteger('Setting','Slot',0);
  PLCAyarlari.Start     := ini.ReadInteger('Setting','Start',0);
  PLCAyarlari.Length    := ini.ReadInteger('Setting','Length',0);
  PLCAyarlari.DB        := ini.ReadInteger('Setting','DB',0);

  case ini.ReadInteger('Setting','ProtocolIx',0) of
    0 : PLCAyarlari.Protocol := ptMPI;
    1 : PLCAyarlari.Protocol := ptPPI;
    2 : PLCAyarlari.Protocol := ptISOTCP;
    3 : PLCAyarlari.Protocol := ptISOTCP243;
    4 : PLCAyarlari.Protocol := ptIBH;
  end;

  case ini.ReadInteger('Setting','ReadSpeedIx',0) of
    0 : PLCAyarlari.ReadSpeed := rs9k;
    1 : PLCAyarlari.ReadSpeed := rs19k;
    2 : PLCAyarlari.ReadSpeed := rs187k;
    3 : PLCAyarlari.ReadSpeed := rs500k;
    4 : PLCAyarlari.ReadSpeed := rs1500k;
    5 : PLCAyarlari.ReadSpeed := rs45k;
    6 : PLCAyarlari.ReadSpeed := rs93k;
  end;

  case ini.ReadInteger('Setting','ReadTypeIx',0) of
    0 : PLCAyarlari.ReadType := rtAnalogIn;
    1 : PLCAyarlari.ReadType := rtAnalogOut;
    2 : PLCAyarlari.ReadType := rtInputs;
    3 : PLCAyarlari.ReadType := rtOutputs;
    4 : PLCAyarlari.ReadType := rtFlags;
    5 : PLCAyarlari.ReadType := rtDB;
  end;

  case ini.ReadInteger('Setting','ConvertIx',0) of
    0 : PLCAyarlari.Converter := ctFloat;
    1 : PLCAyarlari.Converter := ctInteger;
    2 : PLCAyarlari.Converter := ctDWORD;
    3 : PLCAyarlari.Converter := ctUnsignedInteger;
    4 : PLCAyarlari.Converter := ctWORD;
  end;

  //ini.ReadString('Setting','LogKlasorYolu',0);
  //ini.ReadBool('Setting','DurumKaydet',0);
  //ini.ReadBool('Setting','CeviriKullan',0);

  edtIP.Text       := PLCAyarlari.IPAdress;
  edtMPort.Text    := IntToStr(PLCAyarlari.Port);
  seRack.Text      := IntToStr(PLCAyarlari.Rack);
  seSlot.Text      := IntToStr(PLCAyarlari.Slot);
  seDataBlock.Text := IntToStr(PLCAyarlari.DB);
  seLength.Text    := IntToStr(PLCAyarlari.Length);
  seStart.Text     := IntToStr(PLCAyarlari.Start);

  Result := True;
end;

procedure TfrmMain.TestAnalogInputs;
begin
  //
end;

procedure TfrmMain.TestAnalogOutputs;
begin
//
end;

procedure TfrmMain.TestFlags;
begin
//
end;

procedure TfrmMain.TestInputs;
begin
//
end;

procedure TfrmMain.TestOutputs;
begin
//
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SetPLCSetting;
end;

function TfrmMain.GetConverter(CT: Converters): Integer;
begin
//
end;

function TfrmMain.GetProtocol(PT: Protocols): Integer;
begin
  case PT of
    ptMPI       : Result := daveProtoMPI;
    ptPPI       : Result := daveProtoPPI;
    ptISOTCP    : Result := daveProtoISOTCP;
    ptISOTCP243 : Result := daveProtoISOTCP243;
    ptIBH       : Result := daveProtoMPI_IBH;
  end;
end;

function TfrmMain.GetReadSpeed(RS: ReadSpeeds): Integer;
begin
  case RS of
    rs9k    : Result := daveSpeed9k;
    rs19k   : Result := daveSpeed19k;
    rs187k  : Result := daveSpeed187k;
    rs500k  : Result := daveSpeed500k;
    rs1500k : Result := daveSpeed1500k;
    rs45k   : Result := daveSpeed45k;
    rs93k   : Result := daveSpeed93k;
  end;
end;

function TfrmMain.GetReadType(RT: ReadTypes): Integer;
begin
  case RT of
    rtAnalogIn  : Result := daveAnaIn;
    rtAnalogOut : Result := daveAnaOut;
    rtInputs    : Result := daveInputs;
    rtOutputs   : Result := daveOutputs;
    rtFlags     : Result := daveFlags;
    rtDB        : Result := daveDB;
  end;
end;

procedure TfrmMain.seDataBlockChange(Sender: TObject);
begin
  PLCAyarlari.DB := StrToIntDef(seDataBlock.Text,0);
end;

procedure TfrmMain.seLengthChange(Sender: TObject);
begin
  PLCAyarlari.Length := StrToIntDef(seLength.Text,0);
end;

procedure TfrmMain.seStartChange(Sender: TObject);
begin
  PLCAyarlari.Start := StrToIntDef(seStart.Text,0);
end;

procedure TfrmMain.AddReadFunction;
begin
  mmoSonuc.Lines.Add('-Kullanýlan fonksiyon');
  mmoSonuc.Lines.Add('-function daveReadBytes(                      '+#13#10+
    '                                          dc : PdaveConnection; '+#13#10+
    '                                          area : longint;       '+#13#10+
    '                                          DB : longint;         '+#13#10+
    '                                          start : longint;      '+#13#10+
    '                                          len : longint;        '+#13#10+
    '                                          buffer : pointer      '+#13#10+
    '                                          ) : longint;');
  mmoSonuc.Lines.Add('-daveReadBytes(Connection,'+ReadTypeArr[PLCAyarlari.ReadType]+','+IntToStr(PLCAyarlari.DB)+','+IntToStr(PLCAyarlari.Start)+','+IntToStr(PLCAyarlari.Length)+',NILL)');
  mmoSonuc.Lines.Add('---------------------------------------------------------------');
end;

procedure TfrmMain.Test;
var
   Res:LongInt;
begin
  AddReadFunction;
  if connected then
    begin
      try
        Res:=daveReadBytes(dc,GetReadType(PLCAyarlari.ReadType),PLCAyarlari.DB,PLCAyarlari.Start,PLCAyarlari.Length,NIL);
        if Res = 0 then
          Begin
            try
                if PLCAyarlari.Converter <> null Then
                  case PLCAyarlari.Converter of
                    ctFloat   : mmoSonuc.Lines.Add(FloatToStr(daveGetFloat(dc)));
                    ctInteger : mmoSonuc.Lines.Add(FloatToStr(daveGetU32(dc)));
                    ctDWORD   : mmoSonuc.Lines.Add(FloatToStr(daveGetS32(dc)));
                    ctUnsignedInteger : mmoSonuc.Lines.Add(FloatToStr(daveGetU32(dc)));
                    ctWORD    : mmoSonuc.Lines.Add(FloatToStr(daveGetS32(dc)));
                  end;
              mmoSonuc.Lines.Add('---------------------------------');
            except
              on E : Exception do
                mmoSonuc.Lines.Add(e.Message);
            end;
          end
        else mmoSonuc.Lines.Add('-Veri okunamadý girdiðiniz parametreleri kontrol ediniz.');
      except
        on e : Exception do
          begin
            mmoDurum.Lines.Add('-Veri Okunamadý.(Hata)');
          end;
      end;
    end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  YLNThread1.Terminate;
  YLNThread1.Free;
  YLNThread2.Terminate;
  YLNThread2.Free;
end;

procedure TfrmMain.btnWriteClick(Sender: TObject);
var
  A,B:Integer;
  Res:LongInt;
  s : string;
begin
   if connected then
    begin
      Try
//        A := daveSwapIed_32(StrToInt(edtMeter.Text));
//        Res := daveWriteManyBytes(dc, daveDB, 26, se, 8, @A);

        WarW := StrToInt(edtMeter.Text);
        WarH := StrToInt(edtWeight.Text);

        mmoWrite.Clear;
        A := daveSwapIed_32(WarW);
        Inc(WarW);
        Res := daveWriteBytes(dc, daveDB, 26, seWStart.Value, seWLength.Value, @A);
        S := IntToStr(WarW);
        mmoWrite.Lines.Add('Metre : '+S);
        B := daveSwapIed_32(WarH);
        Inc(WarH);
        Res := daveWriteBytes(dc, daveDB, 26, seWStart.Value, seWLength.Value, @B);
        S := IntToStr(WarH);
        mmoWrite.Lines.Add('Tarti : '+S);

//        Res := daveWriteBytes(dc, daveDB, seWDataBlock, seWStart, seWLength, @varW)
////        varW := daveSwapIed_32(StrToInt(edtMeter.Text));
////        Res := daveWriteBytes(dc, daveDB, 26, 0 ,4, @varW);
//        S := IntToStr(Res);
//        mmoWrite.Lines.Add('Metre : '+S);
////        varW := daveSwapIed_32(StrToInt(edtWeight.Text));
////        Res := daveWriteBytes(dc, daveDB, 26, 4, 4, @varW);
//        S := IntToStr(Res);
//        mmoWrite.Lines.Add('Tarti : '+S);
      except
        on E : Exception do
          begin
            mmoDurum.Lines.Add('-Veri yazarken hata oluþtu.')
          end;
      end;
    end;
end;

procedure TfrmMain.btnWriteStartClick(Sender: TObject);
begin
  WarW := StrToInt(edtMeter.Text);
  WarH := StrToInt(edtWeight.Text);
//  YLNThread2.Execute;
//  Timer2.Enabled := True;
  YLNTimerThread2.Execute;
end;

procedure TfrmMain.YLNThread2Execute(Sender: TObject);
var
  A,B:Integer;
  Res:LongInt;
  s : string;
begin
  Sleep(1000);
  mmoWrite.Clear;
  A := daveSwapIed_32(WarW);
  Inc(WarW);
  Res := daveWriteBytes(dc, daveDB, 26, 0 ,4, @A);
  S := IntToStr(WarW);
  mmoWrite.Lines.Add('Metre : '+S);
  B := daveSwapIed_32(WarH);
  Inc(WarH);
  Res := daveWriteBytes(dc, daveDB, 26, 4, 4, @B);
  S := IntToStr(WarH);
  mmoWrite.Lines.Add('Tarti : '+S);
end;

procedure TfrmMain.btnWriteStopClick(Sender: TObject);
begin
//  YLNThread2.Terminate;
//  Timer2.Enabled := False;
  YLNTimerThread2.Terminate;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var Res : LongInt;
begin
  Sleep(500);
  mmoSonuc.Clear;
  Res:=daveReadBytes(dc,daveDB,26,0,8,nil);
  if Res = 0 then
    begin
      mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
      mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
    end;
end;

procedure TfrmMain.Timer2Timer(Sender: TObject);
var
  A,B:Integer;
  Res:LongInt;
  s : string;
begin
  Sleep(1000);
  mmoWrite.Clear;
  A := daveSwapIed_32(WarW);
  Inc(WarW);
  Res := daveWriteBytes(dc, daveDB, 26, 0 ,4, @A);
  S := IntToStr(WarW);
  mmoWrite.Lines.Add('Metre : '+S);
  B := daveSwapIed_32(WarH);
  Inc(WarH);
  Res := daveWriteBytes(dc, daveDB, 26, 4, 4, @B);
  S := IntToStr(WarH);
  mmoWrite.Lines.Add('Tarti : '+S);
end;

procedure TfrmMain.YLNTimerThread1Execute(Sender: TObject);
var Res : LongInt;
begin
  Sleep(500);
  mmoSonuc.Clear;
  Res:=daveReadBytes(dc,daveDB,26,0,8,nil);
  if Res = 0 then
    begin
      mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
      mmoSonuc.Lines.Add(IntToStr(daveGetU32(dc)));
    end;
end;

procedure TfrmMain.YLNTimerThread2Execute(Sender: TObject);
var
  A,B:Integer;
  Res:LongInt;
  s : string;
begin
  mmoWrite.Clear;
  A := daveSwapIed_32(WarW);
  Inc(WarW);
  Res:=daveReadBytes(dc,daveDB,26,seWStart.Value,seWLength.Value,@A);
  S := IntToStr(WarW);
  mmoWrite.Lines.Add('Metre : '+S);
//  B := daveSwapIed_32(WarH);
//  Inc(WarH);
//  Res:=daveReadBytes(dc,daveDB,26,seWStart.Value,seWLength.Value,@B);
//  S := IntToStr(WarH);
//  mmoWrite.Lines.Add('Tarti : '+S);
end;

end.


