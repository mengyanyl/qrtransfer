object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 510
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Image1: TImage
    Left = 40
    Top = 48
    Width = 187
    Height = 169
  end
  object PaintBox1: TPaintBox
    Left = 248
    Top = 48
    Width = 169
    Height = 169
  end
  object btnOpen: TButton
    Left = 688
    Top = 279
    Width = 75
    Height = 25
    Caption = #25171#24320#25991#20214
    TabOrder = 0
    OnClick = btnOpenClick
  end
  object btnSend: TButton
    Left = 688
    Top = 343
    Width = 75
    Height = 25
    Caption = #21457#36865
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 40
    Top = 223
    Width = 377
    Height = 258
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 768
    Top = 344
  end
end