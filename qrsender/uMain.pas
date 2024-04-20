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
  uQrMsgManager, System.NetEncoding,
  uQrManager, uSrcQrcodeThread;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    btnOpen: TButton;
    btnSend: TButton;
    Image1: TImage;
    PaintBox1: TPaintBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Memo2: TMemo;
    procedure btnOpenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function getStringList(aText: string): TStringList;
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
    for i := 0 to recList.Count - 1 do
    begin
      FreeMem(recList.Items[i]);
    end;
    recList.Free;
    qmm.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  qmm: TQrMsgManager;
  fs: TFileStream;
  strlist: TStringList;
  qrMgr: TQrManager;
  qrBmpList: TList;
    qrThread: TSrcQrcodeThread;
begin
  if OpenDialog1.Execute() then
  begin
    //create base64 string
    qmm := TQrMsgManager.Create;
    qmm.LoadFileToBuffer(OpenDialog1.FileName);
    Memo1.Clear;
    Memo1.Lines.Text := TNetEncoding.Base64.EncodeBytesToString(qmm.FileBuf);
    strlist := getStringList(
      TNetEncoding.Base64.EncodeBytesToString(qmm.FileBuf));
//    Memo2.Lines.Text := strlist.Text;

    //create qrcode list
    qrMgr := TQrManager.Create;
    qrBmpList := qrMgr.createQrcode(strlist);
    Memo2.Text := IntToStr(qrBmpList.Count);

    //load bmp in image1
//    Image1.Picture.Bitmap.Assign(qrBmpList.Items[8]);
//    Image1.Refresh;

    //start qrcode thread
    qrThread := TSrcQrcodeThread.Create(True);
    qrThread.QrBmpList:=qrBmpList;
    qrThread.Start;

    if qrThread.Stoped then  begin
      qrMgr.destroyQrList(qrBmpList);
      qrBmpList.Free;
      qrMgr.Free;
      strlist.Clear;
      strlist.Free;
      qmm.Free;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  b64: TBase64Encoding;
  bs: TArray<Byte>;
  fs: TFileStream;
begin
  b64 := TBase64Encoding.Create();
  bs := TNetEncoding.Base64.DecodeStringToBytes(Memo1.Text);
  fs := TFileStream.Create('./test.txt', fmCreate);
  fs.Write(bs, Length(bs));
  fs.Free;
  b64.Free;

end;

function TForm1.getStringList(aText: string): TStringList;
var
  s: string;
  I, cnt: Integer;
  c: Char;
begin
  s := '';
  Result := TStringList.Create;
  cnt := 0;
  for c in aText do begin
    s := s + c;
    Inc(cnt);
    if cnt=1024 then begin
      cnt := 0;
      Result.Add(s);
      s := '';
    end;
  end;
  if cnt>0 then
    Result.Add(s)
end;

end.
