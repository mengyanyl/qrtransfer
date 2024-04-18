object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 727
  ClientWidth = 1171
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Image1: TImage
    Left = 24
    Top = 32
    Width = 457
    Height = 393
    Stretch = True
  end
  object PaintBox1: TPaintBox
    Left = 592
    Top = 72
    Width = 169
    Height = 169
  end
  object btnOpen: TButton
    Left = 720
    Top = 519
    Width = 75
    Height = 25
    Caption = #25171#24320#25991#20214
    TabOrder = 0
    OnClick = btnOpenClick
  end
  object btnSend: TButton
    Left = 720
    Top = 583
    Width = 75
    Height = 25
    Caption = #21457#36865
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 24
    Top = 461
    Width = 377
    Height = 258
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button1: TButton
    Left = 632
    Top = 636
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 640
    Top = 680
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Memo2: TMemo
    Left = 816
    Top = 32
    Width = 329
    Height = 449
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    Left = 800
    Top = 584
  end
end
