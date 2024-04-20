object frmRecv: TfrmRecv
  Left = 0
  Top = 0
  Caption = 'frmRecv'
  ClientHeight = 494
  ClientWidth = 899
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 16
    Top = 22
    Width = 425
    Height = 371
    BevelInner = bvLowered
    BevelKind = bkFlat
    TabOrder = 0
    object paintBox: TPaintBox
      Left = 2
      Top = 2
      Width = 417
      Height = 363
      Align = alClient
      Color = clBtnShadow
      ParentColor = False
      ExplicitLeft = -14
      ExplicitTop = -2
    end
  end
  object Memo1: TMemo
    Left = 520
    Top = 26
    Width = 337
    Height = 363
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object btnRecv: TButton
    Left = 782
    Top = 434
    Width = 75
    Height = 25
    Caption = #24320#22987#25509#25910
    TabOrder = 2
    OnClick = btnRecvClick
  end
  object Panel2: TPanel
    Left = 20
    Top = 406
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
end
