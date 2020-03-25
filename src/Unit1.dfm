object frmMain: TfrmMain
  Left = 624
  Top = 271
  Width = 506
  Height = 502
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Siemens S7 200/300/400 Test'
  Color = clBtnFace
  Constraints.MaxWidth = 510
  Constraints.MinHeight = 350
  Constraints.MinWidth = 385
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 490
    Height = 443
    Align = alClient
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 488
      Height = 73
      Align = alTop
      Caption = 'Ba'#287'lant'#305
      TabOrder = 0
      object lblIP: TLabel
        Left = 8
        Top = 16
        Width = 12
        Height = 13
        Caption = 'IP:'
      end
      object Label1: TLabel
        Left = 5
        Top = 44
        Width = 27
        Height = 13
        Caption = 'Port :'
      end
      object lblRack: TLabel
        Left = 240
        Top = 14
        Width = 30
        Height = 13
        Caption = 'Rack :'
      end
      object lblSloat: TLabel
        Left = 240
        Top = 42
        Width = 26
        Height = 13
        Caption = 'Slot :'
      end
      object edtIP: TEdit
        Left = 40
        Top = 13
        Width = 186
        Height = 21
        TabOrder = 0
        Text = '192.168.0.41'
      end
      object edtMPort: TEdit
        Left = 41
        Top = 39
        Width = 94
        Height = 21
        TabOrder = 1
        Text = '102'
      end
      object seRack: TSpinEdit
        Left = 275
        Top = 11
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object seSlot: TSpinEdit
        Left = 275
        Top = 38
        Width = 64
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 1
      end
      object btnConnect: TButton
        Left = 368
        Top = 9
        Width = 73
        Height = 25
        Caption = 'Ba'#287'lan'
        TabOrder = 4
        OnClick = btnConnectClick
      end
      object btnDisconnect: TButton
        Left = 368
        Top = 41
        Width = 73
        Height = 25
        Caption = 'Ba'#287'lant'#305' Kes'
        TabOrder = 5
        OnClick = btnDisconnectClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 337
      Width = 488
      Height = 105
      Align = alBottom
      Caption = 'Durum'
      TabOrder = 1
      object mmoDurum: TMemo
        Left = 8
        Top = 15
        Width = 473
        Height = 82
        Align = alCustom
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 74
      Width = 488
      Height = 263
      Align = alClient
      Caption = 'Test DB'
      TabOrder = 2
      DesignSize = (
        488
        263)
      object Label99: TLabel
        Left = 9
        Top = 11
        Width = 221
        Height = 13
        Caption = 'DB                   Ba'#351'lang'#305#231'       Uzunluk (Bytes)'
      end
      object Label4: TLabel
        Left = 249
        Top = 11
        Width = 221
        Height = 13
        Caption = 'DB                   Ba'#351'lang'#305#231'       Uzunluk (Bytes)'
      end
      object seDataBlock: TSpinEdit
        Left = 8
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 26
        OnChange = seDataBlockChange
      end
      object seLength: TSpinEdit
        Left = 152
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 4
        OnChange = seLengthChange
      end
      object seStart: TSpinEdit
        Left = 80
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
        OnChange = seStartChange
      end
      object edtRepeatCount: TEdit
        Left = 225
        Top = 26
        Width = 16
        Height = 21
        TabOrder = 3
        Text = '1'
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 56
        Width = 225
        Height = 201
        Anchors = [akLeft, akTop, akBottom]
        Caption = 'Okuma'
        TabOrder = 4
        DesignSize = (
          225
          201)
        object mmoSonuc: TMemo
          Left = 8
          Top = 15
          Width = 209
          Height = 160
          Align = alCustom
          Anchors = [akLeft, akTop, akBottom]
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object btnStart: TButton
          Left = 82
          Top = 177
          Width = 48
          Height = 20
          Anchors = [akLeft, akBottom]
          Caption = 'Ba'#351'la'
          TabOrder = 1
          OnClick = btnStartClick
        end
        object btnFinish: TButton
          Left = 132
          Top = 177
          Width = 52
          Height = 21
          Anchors = [akLeft, akBottom]
          Caption = 'Durdur'
          TabOrder = 2
          OnClick = btnFinishClick
        end
        object btnOku: TButton
          Left = 27
          Top = 177
          Width = 53
          Height = 21
          Anchors = [akLeft, akBottom]
          Caption = 'Oku'
          TabOrder = 3
          OnClick = btnOkuClick
        end
      end
      object GroupBox5: TGroupBox
        Left = 240
        Top = 56
        Width = 241
        Height = 201
        Anchors = [akLeft, akTop, akBottom]
        Caption = 'Yazma'
        TabOrder = 5
        DesignSize = (
          241
          201)
        object Label2: TLabel
          Left = 8
          Top = 156
          Width = 33
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Metre '
        end
        object Label3: TLabel
          Left = 120
          Top = 155
          Width = 24
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Tart'#305' '
        end
        object btnWrite: TButton
          Left = 40
          Top = 178
          Width = 55
          Height = 20
          Anchors = [akLeft, akBottom]
          Caption = 'Yaz'
          TabOrder = 0
          OnClick = btnWriteClick
        end
        object mmoWrite: TMemo
          Left = 8
          Top = 16
          Width = 225
          Height = 135
          Anchors = [akLeft, akTop, akBottom]
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object edtMeter: TEdit
          Left = 48
          Top = 155
          Width = 65
          Height = 21
          Anchors = [akLeft, akBottom]
          TabOrder = 2
          Text = '0'
        end
        object edtWeight: TEdit
          Left = 150
          Top = 153
          Width = 81
          Height = 21
          Anchors = [akLeft, akBottom]
          TabOrder = 3
          Text = '0'
        end
        object btnWriteStart: TButton
          Left = 97
          Top = 178
          Width = 55
          Height = 20
          Anchors = [akLeft, akBottom]
          Caption = 'Ba'#351'la'
          TabOrder = 4
          OnClick = btnWriteStartClick
        end
        object btnWriteStop: TButton
          Left = 154
          Top = 178
          Width = 55
          Height = 20
          Anchors = [akLeft, akBottom]
          Caption = 'Durdur'
          TabOrder = 5
          OnClick = btnWriteStopClick
        end
      end
      object seWLength: TSpinEdit
        Left = 392
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 6
        Value = 2
        OnChange = seLengthChange
      end
      object seWStart: TSpinEdit
        Left = 320
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 7
        Value = 0
        OnChange = seStartChange
      end
      object seWDataBlock: TSpinEdit
        Left = 248
        Top = 27
        Width = 65
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 8
        Value = 26
        OnChange = seDataBlockChange
      end
    end
  end
  object YLNThread1: TYLNThread
    Priority = tpNormal
    OnExecute = YLNThread1Execute
    Left = 216
    Top = 360
  end
  object MainMenu1: TMainMenu
    Left = 153
    Top = 362
    object Dosya1: TMenuItem
      Caption = 'Dosya'
      object pbtnAyarlar: TMenuItem
        Caption = 'Ayarlar'
        OnClick = pbtnAyarlarClick
      end
      object pbtnN1: TMenuItem
        Caption = '-'
      end
      object pbtnCikis: TMenuItem
        Caption = #199#305'k'#305#351
      end
    end
    object pbtnYardim: TMenuItem
      Caption = 'Yard'#305'm'
    end
  end
  object XPManifest1: TXPManifest
    Left = 185
    Top = 361
  end
  object YLNThread2: TYLNThread
    Priority = tpNormal
    OnExecute = YLNThread2Execute
    Left = 249
    Top = 361
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 281
    Top = 361
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 313
    Top = 361
  end
  object YLNTimerThread1: TYLNTimerThread
    Priority = tpNormal
    OnExecute = YLNTimerThread1Execute
    Interval = 500
    Left = 216
    Top = 392
  end
  object YLNTimerThread2: TYLNTimerThread
    Priority = tpNormal
    OnExecute = YLNTimerThread2Execute
    Interval = 500
    Left = 248
    Top = 392
  end
end
