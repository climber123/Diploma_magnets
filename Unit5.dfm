object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 681
  ClientWidth = 984
  Color = clBtnFace
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
  object Splitter2: TSplitter
    Left = 798
    Top = 0
    Height = 681
    Align = alRight
    ExplicitLeft = 569
    ExplicitTop = -8
    ExplicitHeight = 691
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 798
    Height = 681
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 1
      Top = 329
      Width = 796
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = -4
      ExplicitTop = 349
      ExplicitWidth = 762
    end
    object Chart1: TChart
      Left = 1
      Top = 1
      Width = 796
      Height = 328
      Legend.Visible = False
      Title.Text.Strings = (
        #1044#1080#1092#1092'. '#1057#1080#1075#1085#1072#1083)
      DepthAxis.Automatic = False
      DepthAxis.AutomaticMaximum = False
      DepthAxis.AutomaticMinimum = False
      DepthAxis.Maximum = -1.000000000000001000
      DepthAxis.Minimum = -2.000000000000001000
      DepthTopAxis.Automatic = False
      DepthTopAxis.AutomaticMaximum = False
      DepthTopAxis.AutomaticMinimum = False
      DepthTopAxis.Maximum = -1.000000000000001000
      DepthTopAxis.Minimum = -2.000000000000001000
      RightAxis.Automatic = False
      RightAxis.AutomaticMaximum = False
      RightAxis.AutomaticMinimum = False
      View3D = False
      Align = alTop
      TabOrder = 0
      PrintMargins = (
        15
        28
        15
        28)
      object Series2: TPointSeries
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
    end
    object Chart2: TChart
      Left = 1
      Top = 332
      Width = 796
      Height = 348
      Foot.CustomPosition = True
      Foot.Left = 0
      Foot.Top = 0
      Title.CustomPosition = True
      Title.Left = 475
      Title.Text.Strings = (
        #1055#1048#1044)
      Title.Top = 10
      DepthAxis.Automatic = False
      DepthAxis.AutomaticMaximum = False
      DepthAxis.AutomaticMinimum = False
      DepthAxis.Maximum = -0.339999999999992200
      DepthAxis.Minimum = -1.339999999999988000
      DepthTopAxis.Automatic = False
      DepthTopAxis.AutomaticMaximum = False
      DepthTopAxis.AutomaticMinimum = False
      DepthTopAxis.Maximum = -0.339999999999992200
      DepthTopAxis.Minimum = -1.339999999999988000
      RightAxis.Automatic = False
      RightAxis.AutomaticMaximum = False
      RightAxis.AutomaticMinimum = False
      View3D = False
      Align = alClient
      TabOrder = 1
      PrintMargins = (
        15
        29
        15
        29)
      object Series1: TPointSeries
        Marks.Callout.Brush.Color = clBlack
        Marks.Visible = False
        Title = #1056#1077#1072#1083#1100#1085#1072#1103
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
      object Series3: TLineSeries
        Marks.Callout.Brush.Color = clBlack
        Marks.Visible = False
        Title = #1058#1077#1086#1088#1077#1090#1080#1095
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        Pointer.Visible = False
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
  object Panel2: TPanel
    Left = 801
    Top = 0
    Width = 183
    Height = 681
    Align = alRight
    TabOrder = 1
    OnResize = Panel2Resize
    object Label4: TLabel
      Left = 86
      Top = 20
      Width = 42
      Height = 13
      Caption = #1063#1072#1089#1090#1086#1090#1072
    end
    object Label5: TLabel
      Left = 86
      Top = 47
      Width = 56
      Height = 13
      Caption = #1040#1084#1087#1083#1080#1090#1091#1076#1072
    end
    object Label6: TLabel
      Left = 86
      Top = 181
      Width = 49
      Height = 13
      Caption = 'Max Temp'
    end
    object Label7: TLabel
      Left = 86
      Top = 203
      Width = 57
      Height = 13
      Caption = 'Step Grad/s'
    end
    object Label1: TLabel
      Left = 86
      Top = 227
      Width = 54
      Height = 13
      Caption = 'K1 = Kprop'
    end
    object Label2: TLabel
      Left = 86
      Top = 250
      Width = 44
      Height = 13
      Caption = 'K2 = Kint'
    end
    object Label3: TLabel
      Left = 86
      Top = 277
      Width = 48
      Height = 13
      Caption = 'K3 = Kdiff'
    end
    object Label9: TLabel
      Left = 87
      Top = 412
      Width = 77
      Height = 13
      Caption = #1057#1084#1077#1097#1077#1085#1080#1077' '#1089#1080#1075#1085
    end
    object Label10: TLabel
      Left = 87
      Top = 437
      Width = 83
      Height = 13
      Caption = #1052#1085#1086#1078#1080#1090#1077#1083#1100' '#1089#1080#1075#1085
    end
    object Label11: TLabel
      Left = 87
      Top = 462
      Width = 75
      Height = 13
      Caption = #1044#1077#1083#1080#1090#1077#1083#1100' '#1040#1062#1055
    end
    object Label12: TLabel
      Left = 87
      Top = 487
      Width = 77
      Height = 13
      Caption = #1057#1084#1077#1097#1077#1085#1080#1077' '#1040#1062#1055
    end
    object Label14: TLabel
      Left = 87
      Top = 512
      Width = 75
      Height = 13
      Caption = #1055#1048#1044' '#1089#1084#1077#1097#1077#1085#1080#1077
    end
    object Label15: TLabel
      Left = -80
      Top = 333
      Width = 80
      Height = 13
      Caption = #1055#1048#1044' '#1084#1085#1086#1076#1080#1090#1077#1083#1100
    end
    object Label16: TLabel
      Left = 86
      Top = 299
      Width = 42
      Height = 13
      Caption = 'dTIntegr'
    end
    object Label18: TLabel
      Left = 87
      Top = 323
      Width = 39
      Height = 13
      Caption = 'dTDiffer'
    end
    object Label17: TLabel
      Left = 87
      Top = 537
      Width = 74
      Height = 13
      Caption = #1055#1048#1044' '#1076#1077#1083#1080#1090#1077#1083#1100
    end
    object Label19: TLabel
      Left = 87
      Top = 562
      Width = 74
      Height = 13
      Caption = #1076#1077#1083#1080#1090#1077#1083#1100' '#1062#1040#1055
    end
    object Edit1: TEdit
      Left = 6
      Top = 12
      Width = 74
      Height = 21
      TabOrder = 0
      Text = '200'
    end
    object Edit2: TEdit
      Left = 6
      Top = 39
      Width = 74
      Height = 21
      TabOrder = 1
      Text = '10000'
    end
    object Edit6: TEdit
      Left = 6
      Top = 66
      Width = 74
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object Button8: TButton
      Left = 86
      Top = 66
      Width = 75
      Height = 21
      Caption = 'StartSound'
      TabOrder = 3
      OnClick = Button8Click
    end
    object Button3: TButton
      Left = 86
      Top = 128
      Width = 75
      Height = 21
      Caption = 'WrTemperat'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Edit3: TEdit
      Left = 6
      Top = 128
      Width = 74
      Height = 21
      TabOrder = 5
      Text = '680'
    end
    object CheckBox1: TCheckBox
      Left = 6
      Top = 153
      Width = 97
      Height = 17
      Caption = #1075#1088#1072#1092#1080#1082' '#1055#1048#1044
      TabOrder = 6
      OnClick = CheckBox1Click
    end
    object Edit10: TEdit
      Left = 5
      Top = 176
      Width = 75
      Height = 21
      TabOrder = 7
      Text = '680'
      OnChange = Edit10Change
    end
    object Edit11: TEdit
      Left = 6
      Top = 200
      Width = 74
      Height = 21
      TabOrder = 8
      Text = '1'
      OnChange = Edit10Change
    end
    object Edit7: TEdit
      Left = 7
      Top = 224
      Width = 73
      Height = 21
      TabOrder = 9
      Text = '1'
      OnChange = Edit10Change
    end
    object Edit8: TEdit
      Left = 7
      Top = 248
      Width = 73
      Height = 21
      TabOrder = 10
      Text = '1'
      OnChange = Edit10Change
    end
    object Edit9: TEdit
      Left = 7
      Top = 272
      Width = 73
      Height = 21
      TabOrder = 11
      Text = '1'
      OnChange = Edit10Change
    end
    object Edit5: TEdit
      Left = 6
      Top = 351
      Width = 74
      Height = 21
      Enabled = False
      TabOrder = 12
    end
    object Button5: TButton
      Left = 86
      Top = 351
      Width = 75
      Height = 21
      Caption = 'AcceptParam'
      TabOrder = 13
      OnClick = Button5Click
    end
    object Button7: TButton
      Left = 87
      Top = 587
      Width = 75
      Height = 21
      Caption = 'Button7'
      TabOrder = 14
      OnClick = Button7Click
    end
    object Button6: TButton
      Left = 6
      Top = 608
      Width = 75
      Height = 25
      Caption = 'Start Test'
      TabOrder = 15
      OnClick = Button6Click
    end
    object CheckBox2: TCheckBox
      Left = 6
      Top = 105
      Width = 97
      Height = 17
      Caption = 'const Temp'
      TabOrder = 16
      OnClick = CheckBox2Click
    end
    object Edit4: TEdit
      Left = 6
      Top = 296
      Width = 75
      Height = 21
      TabOrder = 17
      Text = '1'
      OnChange = Edit10Change
    end
    object Edit13: TEdit
      Left = 6
      Top = 409
      Width = 75
      Height = 21
      TabOrder = 18
      Text = '0'
    end
    object Edit14: TEdit
      Left = 6
      Top = 434
      Width = 75
      Height = 21
      TabOrder = 19
      Text = '1'
    end
    object Edit15: TEdit
      Left = 6
      Top = 459
      Width = 75
      Height = 21
      TabOrder = 20
      Text = '4'
    end
    object Edit16: TEdit
      Left = 6
      Top = 484
      Width = 75
      Height = 21
      TabOrder = 21
      Text = '0'
    end
    object Edit18: TEdit
      Left = 6
      Top = 509
      Width = 75
      Height = 21
      TabOrder = 22
      Text = '0'
    end
    object Edit19: TEdit
      Left = 6
      Top = 534
      Width = 75
      Height = 21
      TabOrder = 23
      Text = '1'
    end
    object Edit20: TEdit
      Left = 7
      Top = 559
      Width = 75
      Height = 21
      TabOrder = 24
      Text = '1'
    end
    object Edit21: TEdit
      Left = 6
      Top = 320
      Width = 75
      Height = 21
      TabOrder = 25
      Text = '1'
      OnChange = Edit10Change
    end
    object CheckBox3: TCheckBox
      Left = 86
      Top = 153
      Width = 97
      Height = 17
      Caption = #1055#1048#1044' '#1076#1083#1103' '#1088#1086#1089#1090#1072' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1099
      TabOrder = 26
      OnClick = CheckBox3Click
    end
  end
  object Timer1: TTimer
    Left = 728
    Top = 8
  end
end
