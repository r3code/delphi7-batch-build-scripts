object frmMain: TfrmMain
  Left = 565
  Top = 367
  Width = 251
  Height = 228
  Caption = 'DIV A by B'
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object lblA: TLabel
    Left = 24
    Top = 8
    Width = 8
    Height = 16
    Caption = 'A'
  end
  object lblB: TLabel
    Left = 72
    Top = 8
    Width = 7
    Height = 16
    Caption = 'B'
  end
  object lblTotal: TLabel
    Left = 176
    Top = 8
    Width = 29
    Height = 16
    Caption = 'Total'
  end
  object lblLog: TLabel
    Left = 16
    Top = 56
    Width = 20
    Height = 16
    Caption = 'Log'
  end
  object lblBuildDate: TLabel
    Left = 16
    Top = 160
    Width = 91
    Height = 16
    Caption = 'r3code (c) 2016'
  end
  object edtA: TEdit
    Left = 16
    Top = 24
    Width = 49
    Height = 24
    TabOrder = 0
    Text = '1'
  end
  object edtB: TEdit
    Left = 72
    Top = 24
    Width = 49
    Height = 24
    TabOrder = 1
    Text = '2'
  end
  object edtSum: TEdit
    Left = 176
    Top = 24
    Width = 49
    Height = 24
    TabOrder = 3
  end
  object btnSum: TButton
    Left = 128
    Top = 24
    Width = 41
    Height = 25
    Caption = 'DIV'
    TabOrder = 2
    OnClick = btnSumClick
  end
  object mmoLog: TMemo
    Left = 16
    Top = 72
    Width = 209
    Height = 73
    Lines.Strings = (
      'mmoLog')
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
