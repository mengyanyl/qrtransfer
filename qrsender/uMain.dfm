object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 486
  ClientWidth = 1050
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  TextHeight = 15
  object Memo1: TMemo
    Left = 496
    Top = 26
    Width = 513
    Height = 328
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button1: TButton
    Left = 776
    Top = 412
    Width = 75
    Height = 25
    Caption = #25171#24320#25991#20214
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 934
    Top = 412
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo2: TMemo
    Left = 496
    Top = 360
    Width = 513
    Height = 33
    Lines.Strings = (
      'Memo2')
    TabOrder = 3
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 467
    Width = 1050
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
    ExplicitLeft = 592
    ExplicitTop = 376
    ExplicitWidth = 0
  end
  object Panel1: TPanel
    Left = 24
    Top = 22
    Width = 425
    Height = 371
    BevelInner = bvLowered
    BevelKind = bkFlat
    TabOrder = 5
    object PaintBox1: TPaintBox
      Left = 2
      Top = 2
      Width = 417
      Height = 363
      Align = alClient
      Color = clBtnShadow
      ParentColor = False
      ExplicitLeft = -24
      ExplicitTop = -30
      ExplicitWidth = 449
      ExplicitHeight = 401
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 584
    Top = 136
  end
end
