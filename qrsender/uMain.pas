unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  ZXing.ScanManager,
  ZXing.ResultMetaDataType,
  ZXing.BarcodeFormat,
  ZXing.ReadResult,
  ZXing.ResultPoint,
  DelphiZXingQRCode,
  uQrMsgManager;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    btnOpen: TButton;
    btnSend: TButton;
    Image1: TImage;
    PaintBox1: TPaintBox;
    Memo1: TMemo;
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenClick(Sender: TObject);
var
  qmm: TQrMsgManager;
  recList: TList;
  pQrMsg: PTQrMsg;
  s: String;
  i: Integer;
begin

  if OpenDialog1.Execute() then
  begin
    Memo1.Clear;
    qmm := TQrMsgManager.Create;
    Memo1.Lines.Add(OpenDialog1.FileName);
    recList := qmm.LoadFromFile(OpenDialog1.FileName);
    pQrMsg := PTQrMsg(recList.Items[0]);
    s := PChar(@pQrMsg.data[0]);
    Memo1.Lines.Add(s);
    Memo1.Lines.Add(IntToStr(recList.Count));
    for i := 0 to recList.Count-1 do begin
      FreeMem(recList.Items[i]);
    end;
    recList.Free;
    qmm.Free;
  end;
end;

end.
