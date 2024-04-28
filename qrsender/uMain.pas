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
  uQrManager, uSrcQrcodeThread, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    PaintBox1: TPaintBox;
    Memo1: TMemo;
    btnOpenFile: TButton;
    btnStart: TButton;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    btnPause: TButton;
    memRecidue: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    edtQrPage: TEdit;
    Panel1: TPanel;
    Button1: TButton;
    edtFps: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    function getStringList(aText: string): TStringList;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FQrBmpList: TList;
    FOpened: Boolean;
    FStringList: TStringList;
    FStrRecidueList: TStringList;
        Fqrmgr: TQrManager;
    procedure applicationOnIdle(Sender: TObject; var Done: Boolean);
    procedure OnQrCreateProgress(Sender: TObject; AProgress:Integer);
    procedure OnQrCreateCostTime(Sender: TObject; AIndex, ACostTime:Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenFileClick(Sender: TObject);
var
  qmm: TQrMsgManager;
  fs: TFileStream;
  strlist: TStringList;
  qrMgr: TQrManager;
  qrBmpList: TList;
  qrThread: TSrcQrcodeThread;
  i: Integer;
begin
  ProgressBar1.Position := 0;
  FOpened := False;
  if OpenDialog1.Execute() then
  begin
    //clear list
    FStringList.Clear;
    for I := 0 to FQrBmpList.Count-1 do begin
      FreeMem(FQrBmpList.Items[I]);
    end;
    FQrBmpList.Clear;
    paintBox1.Canvas.Brush.Color := clWhite;
    paintBox1.Canvas.FillRect(Rect(0, 0, paintBox1.Width, paintBox1.Height));

    Memo1.Lines.Clear;
    // create base64 string
    qmm := TQrMsgManager.Create;
    qmm.LoadFileToBuffer(OpenDialog1.FileName);
    Memo1.Clear;
//     Memo1.Lines.Add(TNetEncoding.Base64.EncodeBytesToString(qmm.FileBuf));
//     Memo2.Lines.Text := strlist.Text;
    strlist := getStringList(TNetEncoding.Base64.EncodeBytesToString
                              (qmm.FileBuf));
    Memo1.Lines.Add('读取文件完成，开始生成二维码信息');
    FStringList := strlist;
    ProgressBar1.Max := strlist.Count-1;

    // create qrcode list
    qrMgr := TQrManager.Create;
    qrBmpList := TList.Create;
    qrMgr.OnQrCreateProgress := OnQrCreateProgress;
    qrMgr.OnQrcodeCreateCostTime := OnQrCreateCostTime;
    FQrBmpList := qrMgr.createQrcode(strlist);
    Memo1.Lines.Add('共生成: ' + IntToStr(FQrBmpList.Count) + '二维码数据包');

    FreeAndNil(qrMgr);
    FreeAndNil(qmm);
  end;
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
  FOpened := False;
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  FOpened := True;
  FStrRecidueList.Clear;
  if memRecidue.Text<>'' then begin
    FStrRecidueList.Delimiter := ',';
    FStrRecidueList.StrictDelimiter:= True;
    FStrRecidueList.DelimitedText := memRecidue.Text;    
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  paintBox: TPaintBox;
  qrBmp: TBitmap;
  scale: Double;
  qrmgr: TQrManager;
begin
  if memRecidue.Text='' then Exit;

  Memo1.Lines.Add(FStringList.Strings[strtoint(FStrRecidueList.Strings[0])]);

  paintBox := Form1.PaintBox1;
  paintBox.Canvas.Brush.Color := clWhite;
  paintBox.Canvas.FillRect(Rect(0, 0, paintBox.Width, paintBox.Height));

    qrmgr := TQrManager.Create;
    qrBmp := qrmgr.createQrcode(FStringList.Strings[strtoint(FStrRecidueList.Strings[0])]);

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
    paintBox.Repaint;
    qrBmp.Free;
        qrmgr.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FOpened := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  FQrBmpList := TList.Create;
  FStringList := TStringList.Create;
  FStrRecidueList := TStringList.Create;
  FOpened := False;
  Application.OnIdle := applicationOnIdle;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  FStringList.Clear;
  FreeAndNil(FStringList);
  for I := 0 to FQrBmpList.Count-1 do begin
      FreeMem(FQrBmpList.Items[I]);
  end;
  FreeAndNil(FQrBmpList);
  FreeAndNil(FStrRecidueList);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=TMouseButton.mbRight) then begin
    Memo1.Lines.Add('left=' + IntToStr(ClientToScreen(Point(x, y)).X+4)
       + '; top=' + IntToStr(ClientToScreen(Point(x, y)).Y+4)
       + '; right=' + IntToStr(ClientToScreen(Point(x, y)).X + PaintBox1.Width)
       + '; bottom=' + IntToStr(ClientToScreen(Point(x, y)).Y + PaintBox1.Height));
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
  i, cnt, total, page: Integer;
  c: Char;
begin
  s := '';
  Result := TStringList.Create;
  page := StrToInt(edtQrPage.Text);
  cnt := 0;
  for c in aText do
  begin
    s := s + c;
    Inc(cnt);
    if cnt = page then
    begin
      cnt := 0;
      Result.Add(IntToStr(Result.Count) + '$$$$' + s);
      s := '';
    end;
  end;
  if cnt > 0 then
    Result.Add(IntToStr(Result.Count) + '$$$$' + s);
  //add total count into message
  total := Result.Count;
  for I := 0 to Result.Count-1 do
    Result[I] := IntToStr(total) + '||||' + Result[I];
end;

procedure TForm1.OnQrCreateProgress(Sender: TObject; AProgress: Integer);
begin
  ProgressBar1.Position := AProgress;
//  Application.ProcessMessages;
end;

procedure TForm1.OnQrCreateCostTime(Sender: TObject; AIndex, ACostTime: Integer);
begin
  Memo1.Lines.Add('qrcode index=' + IntToStr(AIndex)
          + '; cost time=' + IntToStr(ACostTime));
  Application.ProcessMessages;
end;

procedure TForm1.applicationOnIdle(Sender: TObject; var Done: Boolean);
var
  i: Integer;
  scale: Double;
  paintBox: TPaintBox;
  qrBmp: TBitmap;
  strRecidueList: TStringList;
  
  function isInList(n: Integer; aStrList: TStringList):Boolean;
  var
    j: Integer;
  begin
    Result:=False;
    for j := 0 to aStrList.Count-1 do begin
      if inttostr(n)=aStrList.Strings[j] then begin
        Result:=true;
        break;
      end;
    end;
  end;
begin
  Done := False;

  if not FOpened then Exit;

  if not Assigned(FStringList) then Exit;
  
  if FQrBmpList.Count<>FStringList.Count then
    Exit;

  paintBox := Form1.PaintBox1;
  paintBox.Canvas.Brush.Color := clWhite;
  paintBox.Canvas.FillRect(Rect(0, 0, paintBox.Width, paintBox.Height));

  for i := 0 to FQrBmpList.Count - 1 do
  begin
    if not FOpened then break;
    if FStrRecidueList.Count>0 then begin
      if not isInList(i, FStrRecidueList) then continue;
    end;
    
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
    Sleep(Trunc(1000/strtoint(edtFps.Text)));
    Application.ProcessMessages;
  end;

end;

end.
