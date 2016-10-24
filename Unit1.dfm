object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'stat'
  ClientHeight = 474
  ClientWidth = 735
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object coo: TStatusBar
    Left = 0
    Top = 455
    Width = 735
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 735
    Height = 29
    ButtonHeight = 29
    ButtonWidth = 26
    Caption = 'ToolBar1'
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 0
    end
    object ToolButton2: TToolButton
      Left = 26
      Top = 0
      Caption = 'ToolButton2'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = False
      OnClick = ToolButton2Click
    end
    object ToolButton3: TToolButton
      Left = 52
      Top = 0
      Caption = 'ToolButton3'
      ImageIndex = 2
      OnClick = ToolButton3Click
    end
    object ToolButton4: TToolButton
      Left = 78
      Top = 0
      Caption = 'ToolButton4'
      ImageIndex = 3
      OnClick = ToolButton4Click
    end
    object ToolButton5: TToolButton
      Left = 104
      Top = 0
      Caption = 'ToolButton5'
      ImageIndex = 4
      OnClick = ToolButton5Click
    end
    object ToolButton6: TToolButton
      Left = 130
      Top = 0
      Caption = 'ToolButton6'
      ImageIndex = 5
      OnClick = ToolButton6Click
    end
    object ToolButton7: TToolButton
      Left = 156
      Top = 0
      Caption = 'ToolButton7'
      ImageIndex = 6
      OnClick = ToolButton7Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 185
    Height = 426
    Align = alLeft
    TabOrder = 2
    object Label1: TLabel
      Left = 94
      Top = 201
      Width = 42
      Height = 13
      Caption = #1063#1072#1089#1090#1086#1090#1072
    end
    object Label2: TLabel
      Left = 94
      Top = 228
      Width = 56
      Height = 13
      Caption = #1040#1084#1087#1083#1080#1090#1091#1076#1072
    end
    object Label3: TLabel
      Left = 94
      Top = 255
      Width = 30
      Height = 13
      Caption = #1064#1072#1075'/'#1089
    end
    object Label4: TLabel
      Left = 94
      Top = 282
      Width = 52
      Height = 13
      Caption = #1052#1072#1082#1089' '#1058#1077#1084#1087
    end
    object Label5: TLabel
      Left = 94
      Top = 154
      Width = 59
      Height = 13
      Caption = #1048#1084#1103' '#1057#1087#1083#1072#1074#1072
    end
    object Label6: TLabel
      Left = 94
      Top = 336
      Width = 31
      Height = 13
      Caption = 'Label1'
      Visible = False
    end
    object Label7: TLabel
      Left = 2
      Top = 63
      Width = 179
      Height = 13
      Caption = #1086#1090#1082#1083#1102#1095#1077#1085#1072' '#1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1086' '#1084#1072#1082#1089#1080#1084#1091#1084#1091
    end
    object Label9: TLabel
      Left = 4
      Top = 82
      Width = 32
      Height = 13
      Caption = #1080' '#1079#1074#1091#1082
    end
    object Edit1: TEdit
      Left = 23
      Top = 193
      Width = 65
      Height = 21
      TabOrder = 0
      Text = '1000'
    end
    object Edit2: TEdit
      Left = 23
      Top = 220
      Width = 65
      Height = 21
      TabOrder = 1
      Text = '10000'
    end
    object Edit3: TEdit
      Left = 23
      Top = 247
      Width = 65
      Height = 21
      TabOrder = 2
      Text = '1'
    end
    object Edit4: TEdit
      Left = 23
      Top = 274
      Width = 65
      Height = 21
      TabOrder = 3
      Text = '500'
    end
    object Edit5: TEdit
      Left = 23
      Top = 146
      Width = 65
      Height = 21
      TabOrder = 4
    end
    object Edit6: TEdit
      Left = 23
      Top = 328
      Width = 65
      Height = 21
      TabOrder = 5
    end
    object Button1: TButton
      Left = 23
      Top = 355
      Width = 65
      Height = 25
      Caption = 'Start'
      TabOrder = 6
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 94
      Top = 355
      Width = 65
      Height = 25
      Caption = 'Stop'
      TabOrder = 7
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 94
      Top = 386
      Width = 65
      Height = 25
      Caption = 'Save Result'
      TabOrder = 8
      OnClick = Button3Click
    end
    object CheckBox2: TCheckBox
      Left = 23
      Top = 40
      Width = 97
      Height = 17
      Caption = #1057#1082#1088#1099#1090#1100' '#1043#1088#1072#1092#1080#1082
      TabOrder = 9
      OnClick = CheckBox2Click
    end
  end
  object Chart1: TChart
    Left = 193
    Top = 29
    Width = 542
    Height = 426
    Legend.Visible = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    View3D = False
    Align = alClient
    TabOrder = 3
    PrintMargins = (
      15
      12
      15
      12)
    object Series1: TPointSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ClickableLine = False
      Pointer.HorizSize = 2
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 2
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TPointSeries
      Active = False
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TPointSeries
      Active = False
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Panel2: TPanel
    Left = 185
    Top = 29
    Width = 8
    Height = 426
    Align = alLeft
    TabOrder = 4
    OnClick = Panel2Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 152
    Top = 32
  end
end
