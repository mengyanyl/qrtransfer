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
    Left = 456
    Top = 409
    Width = 65
    Height = 15
    Caption = #20108#32500#30721#24635#25968
  end
  object Label3: TLabel
    Left = 456
    Top = 435
    Width = 65
    Height = 15
    Caption = #21097#20313#20108#32500#30721
  end
  object Panel1: TPanel
    Left = 8
    Top = 11
    Width = 400
    Height = 400
    BevelInner = bvLowered
    BevelKind = bkFlat
    TabOrder = 0
    object paintBox: TPaintBox
      Left = 2
      Top = 2
      Width = 392
      Height = 392
      Align = alClient
      Color = clBtnShadow
      ParentColor = False
      ExplicitLeft = -2
      ExplicitTop = -5
    end
  end
  object Memo1: TMemo
    Left = 499
    Top = 15
    Width = 337
    Height = 367
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object btnRecv: TButton
    Left = 606
    Top = 461
    Width = 75
    Height = 25
    Caption = #24320' '#22987
    TabOrder = 2
    OnClick = btnRecvClick
  end
  object Panel2: TPanel
    Left = 8
    Top = 429
    Width = 417
    Height = 80
    TabOrder = 3
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
      TextHint = 'left'
    end
    object edtTop: TEdit
      Left = 156
      Top = 11
      Width = 121
      Height = 23
      TabOrder = 1
      TextHint = 'top'
    end
    object edtRight: TEdit
      Left = 12
      Top = 40
      Width = 121
      Height = 23
      TabOrder = 2
      TextHint = 'right'
    end
    object edtBottom: TEdit
      Left = 156
      Top = 40
      Width = 121
      Height = 23
      TabOrder = 3
      TextHint = 'bottom'
    end
  end
  object edtTotal: TEdit
    Left = 527
    Top = 406
    Width = 266
    Height = 23
    ReadOnly = True
    TabOrder = 4
  end
  object btnPause: TButton
    Left = 718
    Top = 461
    Width = 75
    Height = 25
    Caption = #26242' '#20572
    TabOrder = 5
    OnClick = btnPauseClick
  end
  object edtResidue: TEdit
    Left = 527
    Top = 432
    Width = 266
    Height = 23
    ReadOnly = True
    TabOrder = 6
  end
  object btnResidue: TButton
    Left = 496
    Top = 461
    Width = 75
    Height = 25
    Caption = #26597#30475#21097#20313
    TabOrder = 7
    OnClick = btnResidueClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 376
    Top = 262
  end
end
