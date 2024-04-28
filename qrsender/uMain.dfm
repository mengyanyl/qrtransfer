object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Myan QrSender'
  ClientHeight = 404
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  TextHeight = 15
  object StatusBar1: TStatusBar
    Left = 0
    Top = 382
    Width = 620
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
    ExplicitTop = 466
    ExplicitWidth = 955
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 401
    Width = 620
    Height = 3
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 592
    ExplicitWidth = 1090
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 620
    Height = 313
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 40
    ExplicitTop = 8
    ExplicitWidth = 1090
    ExplicitHeight = 504
    object Panel2: TPanel
      Left = 320
      Top = 1
      Width = 299
      Height = 311
      Align = alRight
      Caption = 'Panel2'
      TabOrder = 0
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 297
        Height = 309
        Align = alClient
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitLeft = 46
        ExplicitWidth = 546
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 319
      Height = 311
      Margins.Top = 30
      Margins.Right = 30
      Align = alClient
      BevelInner = bvLowered
      TabOrder = 1
      ExplicitWidth = 94
      object PaintBox1: TPaintBox
        Left = 2
        Top = 2
        Width = 315
        Height = 307
        Align = alClient
        Color = clBtnShadow
        ParentColor = False
        ExplicitWidth = 255
        ExplicitHeight = 287
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 313
    Width = 620
    Height = 69
    Margins.Top = 10
    Margins.Right = 10
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 504
    ExplicitWidth = 1090
    object Label1: TLabel
      Left = 8
      Top = 41
      Width = 91
      Height = 15
      Caption = #26410#35782#21035#30340#20108#32500#30721
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 52
      Height = 15
      Caption = #30721#21253#22823#23567
    end
    object edtQrPage: TEdit
      Left = 114
      Top = 8
      Width = 121
      Height = 23
      TabOrder = 0
      Text = '1024'
    end
    object edtFps: TEdit
      Left = 352
      Top = 8
      Width = 121
      Height = 23
      TabOrder = 1
      Text = '100'
    end
    object Button1: TButton
      Left = 518
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
      OnClick = Button1Click
    end
    object btnStart: TButton
      Left = 437
      Top = 37
      Width = 75
      Height = 25
      Caption = #24320' '#22987
      TabOrder = 3
      OnClick = btnStartClick
    end
    object btnPause: TButton
      Left = 518
      Top = 37
      Width = 75
      Height = 25
      Caption = #26242' '#20572
      TabOrder = 4
      OnClick = btnPauseClick
    end
    object btnOpenFile: TButton
      Left = 359
      Top = 38
      Width = 75
      Height = 25
      Caption = #25171#24320#25991#20214
      TabOrder = 5
      OnClick = btnOpenFileClick
    end
    object memRecidue: TMemo
      Left = 114
      Top = 37
      Width = 239
      Height = 25
      TabOrder = 6
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 584
    Top = 136
  end
end
