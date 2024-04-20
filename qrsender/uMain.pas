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
  uQrManager, uSrcQrcodeThread, GR32_Image, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    PaintBox1: TPaintBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Memo2: TMemo;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function getStringList(aText: string): TStringList;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FQrBmpList: TList;
    FPaintBoxList: TList;
    FOpened: Boolean;
    FStringList: TStringList;
    procedure applicationOnIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
    property PaintBoxList: TList read FPaintBoxList;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  qmm: TQrMsgManager;
  fs: TFileStream;
  strlist: TStringList;
  qrMgr: TQrManager;
  qrBmpList: TList;
  qrThread: TSrcQrcodeThread;
  i: Integer;
begin
  if OpenDialog1.Execute() then
  begin
    // create base64 string
    qmm := TQrMsgManager.Create;
    qmm.LoadFileToBuffer(OpenDialog1.FileName);
    Memo1.Clear;
    // Memo1.Lines.Text := TNetEncoding.Base64.EncodeBytesToString(qmm.FileBuf);
    strlist := getStringList(TNetEncoding.Base64.EncodeBytesToString
      (qmm.FileBuf));
    // Memo2.Lines.Text := strlist.Text;
    FStringList := strlist;

    // create qrcode list
    qrMgr := TQrManager.Create;
    qrBmpList := qrMgr.createQrcode(strlist);
    FQrBmpList := qrBmpList;
    Memo2.Text := IntToStr(qrBmpList.Count);


    // load bmp in image1
    // Image1.Picture.Bitmap.Assign(qrBmpList.Items[8]);
    // Image1.Refresh;

    // start qrcode thread
    qrThread := TSrcQrcodeThread.Create(True);
    qrThread.qrBmpList := qrBmpList;
//    qrThread.OnThreadPaint := PaintBox1Paint;
//    qrThread.Start;

    if qrThread.Stoped then
    begin
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  FQrBmpList := TList.Create;
  FPaintBoxList := TList.Create;
  FOpened := False;
  Application.OnIdle := applicationOnIdle;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=TMouseButton.mbRight) then begin
    Memo1.Lines.Clear;
    Memo1.Lines.Add('left=' + IntToStr(ClientToScreen(Point(x, y)).X)
       + '; top=' + IntToStr(ClientToScreen(Point(x, y)).Y)
       + '; right=' + IntToStr(ClientToScreen(Point(x, y)).X + Panel1.Width)
       + '; bottom=' + IntToStr(ClientToScreen(Point(x, y)).Y + Panel1.Height));
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  screen:TPoint;
begin
  screen := ClientToScreen(Point(X, Y));
  StatusBar1.Panels[0].Text := 'x=' + IntToStr(screen.X) + ';y='+inttostr(screen.Y);
end;

function TForm1.getStringList(aText: string): TStringList;
var
  s: string;
  i, cnt: Integer;
  c: Char;
begin
  s := '';
  Result := TStringList.Create;
  cnt := 0;
  for c in aText do
  begin
    s := s + c;
    Inc(cnt);
    if cnt = 1024 then
    begin
      cnt := 0;
      Result.Add(IntToStr(Result.Count+1) + '||||' + s);
      s := '';
    end;
  end;
  if cnt > 0 then
    Result.Add(IntToStr(Result.Count+1) + '||||' + s);
end;

procedure TForm1.applicationOnIdle(Sender: TObject; var Done: Boolean);
var
  i: Integer;
  scale: Double;
  paintBox: TPaintBox;
  qrBmp: TBitmap;
begin
  Done := False;

  if not Assigned(FStringList) then Exit;
  
  if FQrBmpList.Count<>FStringList.Count then
    Exit;

  paintBox := Form1.PaintBox1;
  paintBox.Canvas.Brush.Color := clWhite;
  paintBox.Canvas.FillRect(Rect(0, 0, paintBox.Width, paintBox.Height));

  for i := 0 to FQrBmpList.Count - 1 do
  begin
    qrBmp := TBitmap(FQrBmpList.Items[i]);
    if (paintBox.Width < paintBox.Height) then
    begin
      scale := paintBox.Width / qrBmp.Width;
    end
    else
    begin
      scale := paintBox.Height / qrBmp.Height;
    end;
    paintBox.Canvas.StretchDraw(Rect(0, 0, Trunc(qrBmp.Width * scale),
      Trunc(qrBmp.Height * scale)), qrBmp);
    Sleep(100);
  end;
end;

end.
