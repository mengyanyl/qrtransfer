object frmRecv: TfrmRecv
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Myan QrReceiver'
  ClientHeight = 517
  ClientWidth = 811
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label2: TLabel
    Left = 432
    Top = 421
    Width = 65
    Height = 15
    Caption = #20108#32500#30721#24635#25968
  end
  object Label3: TLabel
    Left = 432
    Top = 447
    Width = 65
    Height = 15
    Caption = #21097#20313#20108#32500#30721
  end
  object Memo1: TMemo
    Left = 432
    Top = 15
    Width = 371
    Height = 400
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnRecv: TButton
    Left = 639
    Top = 473
    Width = 75
    Height = 25
    Caption = #24320' '#22987
    TabOrder = 1
    OnClick = btnRecvClick
  end
  object Panel2: TPanel
    Left = 14
    Top = 421
    Width = 400
    Height = 80
    TabOrder = 2
    object Label1: TLabel
      Left = 320
      Top = 32
      Width = 52
      Height = 15
      Caption = #23631#24149#22352#26631
    end
    object edtLeft: TEdit
      Left = 12
      Top = 11
      Width = 121
      Height = 23
      TabOrder = 0
      Text = '100'
      TextHint = 'left'
    end
    object edtTop: TEdit
      Left = 156
      Top = 11
      Width = 121
      Height = 23
      TabOrder = 1
      Text = '100'
      TextHint = 'top'
    end
    object edtRight: TEdit
      Left = 12
      Top = 40
      Width = 121
      Height = 23
      TabOrder = 2
      Text = '500'
      TextHint = 'right'
    end
    object edtBottom: TEdit
      Left = 156
      Top = 40
      Width = 121
      Height = 23
      TabOrder = 3
      Text = '500'
      TextHint = 'bottom'
    end
  end
  object edtTotal: TEdit
    Left = 503
    Top = 418
    Width = 300
    Height = 23
    ReadOnly = True
    TabOrder = 3
  end
  object btnPause: TButton
    Left = 728
    Top = 473
    Width = 75
    Height = 25
    Caption = #26242' '#20572
    TabOrder = 4
    OnClick = btnPauseClick
  end
  object edtResidue: TEdit
    Left = 503
    Top = 444
    Width = 300
    Height = 23
    ReadOnly = True
    TabOrder = 5
  end
  object btnResidue: TButton
    Left = 544
    Top = 473
    Width = 75
    Height = 25
    Caption = #26597#30475#21097#20313
    TabOrder = 6
    OnClick = btnResidueClick
  end
  object Panel1: TPanel
    Left = 14
    Top = 15
    Width = 384
    Height = 384
    BevelInner = bvLowered
    TabOrder = 7
    object paintBox: TPaintBox
      Left = 2
      Top = 2
      Width = 380
      Height = 380
      Align = alClient
      Color = clBtnShadow
      ParentColor = False
      ExplicitLeft = -195
      ExplicitTop = -339
    end
  end
  object btnImg: TButton
    Left = 448
    Top = 473
    Width = 75
    Height = 25
    Caption = #20445#23384#22270#29255
    TabOrder = 8
    OnClick = btnImgClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 376
    Top = 262
  end
end
