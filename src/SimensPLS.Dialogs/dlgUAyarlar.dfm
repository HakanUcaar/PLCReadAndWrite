object dlgAyarlar: TdlgAyarlar
  Left = 791
  Top = 262
  BorderStyle = bsDialog
  Caption = 'Ayarlar'
  ClientHeight = 429
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnKapat: TButton
    Left = 268
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Kapat'
    TabOrder = 0
    OnClick = btnKapatClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 340
    Height = 385
    ActivePage = tsYazma
    TabOrder = 1
    object tsGenel: TTabSheet
      Caption = 'Genel'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 313
        Height = 233
        Caption = 'Ba'#287'lant'#305
        TabOrder = 0
        object GroupBox4: TGroupBox
          Left = 8
          Top = 16
          Width = 297
          Height = 73
          Caption = 'Soket'
          TabOrder = 0
          object lblIPAdress: TLabel
            Left = 8
            Top = 24
            Width = 47
            Height = 13
            Caption = 'IP Adresi '
          end
          object lblPort: TLabel
            Left = 8
            Top = 48
            Width = 21
            Height = 13
            Caption = 'Port'
          end
          object edtIPAdres: TEdit
            Left = 64
            Top = 20
            Width = 225
            Height = 21
            TabOrder = 0
            Text = '192.168.0.41'
          end
          object edtPort: TEdit
            Left = 64
            Top = 45
            Width = 89
            Height = 21
            TabOrder = 1
            Text = '102'
          end
          object btnBaglantiTest: TButton
            Left = 213
            Top = 43
            Width = 75
            Height = 23
            Caption = 'Test'
            TabOrder = 2
            OnClick = btnBaglantiTestClick
          end
        end
        object GroupBox5: TGroupBox
          Left = 8
          Top = 96
          Width = 297
          Height = 129
          Caption = 'Aray'#252'z'
          TabOrder = 1
          object lblRack: TLabel
            Left = 8
            Top = 20
            Width = 24
            Height = 13
            Caption = 'Rack'
          end
          object lblSlot: TLabel
            Left = 168
            Top = 20
            Width = 20
            Height = 13
            Caption = 'Slot'
          end
          object edtRack: TEdit
            Left = 64
            Top = 16
            Width = 81
            Height = 21
            TabOrder = 0
            Text = '0'
          end
          object edtSlot: TEdit
            Left = 208
            Top = 16
            Width = 81
            Height = 21
            TabOrder = 1
            Text = '1'
          end
          object rgProtocols: TRadioGroup
            Left = 8
            Top = 40
            Width = 145
            Height = 81
            Caption = 'Protokol'
            ItemIndex = 2
            Items.Strings = (
              'MPI'
              'PPI'
              'ISOTCP'
              'ISOTCP243'
              'IBH')
            TabOrder = 2
          end
          object rgReadSpeed: TRadioGroup
            Left = 160
            Top = 40
            Width = 129
            Height = 81
            Caption = 'Okuma H'#305'z'#305
            Columns = 2
            ItemIndex = 2
            Items.Strings = (
              '9k'
              '19k'
              '187k'
              '500k'
              '1500k'
              '45k'
              '93k')
            TabOrder = 3
          end
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 248
        Width = 313
        Height = 105
        Caption = 'Di'#287'er'
        Enabled = False
        TabOrder = 1
        object lblVeriAlmaSuresi: TLabel
          Left = 24
          Top = 20
          Width = 118
          Height = 13
          Caption = 'Veri Alma S'#252'resi (Delay)'
        end
        object lblMiliSaniye: TLabel
          Left = 262
          Top = 20
          Width = 14
          Height = 13
          Caption = 'ms'
        end
        object lblKlasorYolu: TLabel
          Left = 16
          Top = 68
          Width = 58
          Height = 13
          Caption = 'Klas'#246'r Yolu '
        end
        object edtDelay: TEdit
          Left = 160
          Top = 16
          Width = 97
          Height = 21
          TabOrder = 0
          Text = '20000'
        end
        object chkLogKaydet: TCheckBox
          Left = 16
          Top = 44
          Width = 249
          Height = 17
          Caption = 'Durum Ge'#231'mi'#351'i Kaydet'
          TabOrder = 1
          OnClick = chkLogKaydetClick
        end
        object edtKlasorYolu: TEdit
          Left = 80
          Top = 64
          Width = 177
          Height = 21
          TabOrder = 2
        end
        object btnSec: TButton
          Left = 264
          Top = 62
          Width = 43
          Height = 24
          Caption = 'Se'#231
          TabOrder = 3
          OnClick = btnSecClick
        end
      end
    end
    object tsCikti: TTabSheet
      Caption = #199#305'kt'#305
      ImageIndex = 1
      object rgReadType: TRadioGroup
        Left = 8
        Top = 112
        Width = 313
        Height = 97
        Caption = 'Veri Okuma '#350'ekli'
        Columns = 2
        ItemIndex = 5
        Items.Strings = (
          'AnalogIn'
          'AnalogOut'
          'Inputs'
          'Outputs'
          'Flags'
          'DB')
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 313
        Height = 97
        Caption = 'Veri Alma'
        TabOrder = 1
        object lblDataBlock: TLabel
          Left = 16
          Top = 24
          Width = 76
          Height = 13
          Caption = 'DB(Data Block)'
        end
        object lblBaslangic: TLabel
          Left = 16
          Top = 48
          Width = 49
          Height = 13
          Caption = 'Ba'#351'lang'#305#231
        end
        object lblUzunluk: TLabel
          Left = 16
          Top = 73
          Width = 43
          Height = 13
          Caption = 'Uzunluk'
        end
        object lblBaslangicByte: TLabel
          Left = 272
          Top = 48
          Width = 22
          Height = 13
          Caption = 'Byte'
        end
        object lblUzunlukByte: TLabel
          Left = 272
          Top = 72
          Width = 22
          Height = 13
          Caption = 'Byte'
        end
        object edtDataBlock: TEdit
          Left = 126
          Top = 20
          Width = 139
          Height = 21
          TabOrder = 0
          Text = '26'
        end
        object edtCount: TEdit
          Left = 126
          Top = 44
          Width = 139
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object edtLength: TEdit
          Left = 126
          Top = 70
          Width = 139
          Height = 21
          TabOrder = 2
          Text = '16'
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 216
        Width = 313
        Height = 137
        Caption = #199#305'kt'#305' '#199'eviricileri'
        TabOrder = 2
        object rgConventers: TRadioGroup
          Left = 8
          Top = 32
          Width = 297
          Height = 97
          Caption = #199'eviriciler'
          Items.Strings = (
            'Float'
            'Integer'
            'DWORD'
            'UnsignedInteger'
            'WORD')
          TabOrder = 0
        end
        object chkCevirici: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #199'evirici Kullan'
          TabOrder = 1
          OnClick = chkCeviriciClick
        end
      end
    end
    object tsYazma: TTabSheet
      Caption = 'Yazma'
      ImageIndex = 2
      object GroupBox7: TGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 105
        Caption = 'GroupBox7'
        TabOrder = 0
      end
    end
  end
  object btnSaveCompList: TButton
    Left = 8
    Top = 400
    Width = 153
    Height = 25
    Caption = 'Kaydedilecek Complar'
    TabOrder = 2
    Visible = False
    OnClick = btnSaveCompListClick
  end
  object RzSelectFolderDialog1: TRzSelectFolderDialog
    Left = 212
    Top = 400
  end
end
