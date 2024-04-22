object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Myan QrSender'
  ClientHeight = 486
  ClientWidth = 959
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
  object SpeedButton1: TSpeedButton
    Left = 520
    Top = 248
    Width = 23
    Height = 22
  end
  object Label1: TLabel
    Left = 17
    Top = 423
    Width = 91
    Height = 15
    Caption = #26410#35782#21035#30340#20108#32500#30721
  end
  object PaintBox1: TPaintBox
    Left = 17
    Top = 18
    Width = 380
    Height = 380
    Color = clBtnShadow
    ParentColor = False
  end
  object Memo1: TMemo
    Left = 424
    Top = 18
    Width = 513
    Height = 380
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnOpenFile: TButton
    Left = 652
    Top = 420
    Width = 75
    Height = 25
    Caption = #25171#24320#25991#20214
    TabOrder = 1
    OnClick = btnOpenFileClick
  end
  object btnStart: TButton
    Left = 762
    Top = 419
    Width = 75
    Height = 25
    Caption = #24320' '#22987
    TabOrder = 2
    OnClick = btnStartClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 467
    Width = 959
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
    ExplicitTop = 449
    ExplicitWidth = 974
  end
  object ProgressBar1: TProgressBar
    Left = 400
    Top = 469
    Width = 642
    Height = 17
    TabOrder = 4
  end
  object btnPause: TButton
    Left = 866
    Top = 420
    Width = 75
    Height = 25
    Caption = #26242' '#20572
    TabOrder = 5
    OnClick = btnPauseClick
  end
  object memRecidue: TMemo
    Left = 114
    Top = 420
    Width = 479
    Height = 25
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Left = 584
    Top = 136
  end
end
