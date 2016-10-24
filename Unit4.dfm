object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 493
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 225
    Top = 0
    Height = 416
    ExplicitLeft = 130
    ExplicitTop = 8
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 225
    Height = 416
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    ExplicitLeft = -3
  end
  object Panel1: TPanel
    Left = 0
    Top = 416
    Width = 502
    Height = 77
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 105
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 1
    end
  end
  object ListBox2: TListBox
    Left = 228
    Top = 0
    Width = 274
    Height = 416
    Align = alClient
    ItemHeight = 13
    TabOrder = 2
    ExplicitLeft = 231
  end
end
