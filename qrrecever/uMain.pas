unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ZXing.ScanManager,
  ZXing.ResultMetaDataType,
  ZXing.BarcodeFormat,
  ZXing.ReadResult,
  ZXing.ResultPoint,
  System.NetEncoding,
  uQrMsgManager, Math;

type

  TIndexQrMsg = class
  public
    msg: String;
    index: Integer;
  End;

  TfrmRecv = class(TForm)
    paintBox: TPaintBox;
    Memo1: TMemo;
    btnRecv: TButton;
    edtLeft: TEdit;
    edtTop: TEdit;
    edtRight: TEdit;
    edtBottom: TEdit;
    Panel2: TPanel;
    Label1: TLabel;
    edtTotal: TEdit;
    Label2: TLabel;
    btnPause: TButton;
    Timer1: TTimer;
    edtResidue: TEdit;
    Label3: TLabel;
    btnResidue: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnRecvClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnResidueClick(Sender: TObject);
  private
    FQrFlagList: TStringList;
    FQrMsgList: TList;
    FRcvFlag: Boolean;
    FTotalPage: Integer;
    FStartTime: TDateTime;
    { Private declarations }
    procedure applicationOnIdle(Sender: TObject; var Done: Boolean);
    function CaptureQrcode: TBitmap;
    function isHaveFlag(flag: string): Boolean;
    function getBufferFromStrings(aList: TList): TArray<Byte>;
    function compareItem(Item1, Item2: Pointer): Integer;
  public
    { Public declarations }
  end;

var
  frmRecv: TfrmRecv;

implementation

{$R *.dfm}
{ TForm2 }

procedure TfrmRecv.applicationOnIdle(Sender: TObject; var Done: Boolean);
var
  bmp: TBitmap;
  ScanManager: TScanManager;
  rs: TReadResult;
  pageFlag, tmp: string;
  scale: Double;
  endTime, elapsedTime: TDateTime;
  buf: TArray<Byte>;
  qmm: TQrMsgManager;
  IndexQrMsg: TIndexQrMsg;
begin
  Done := False;

  if not FRcvFlag then
    Exit;
  if (edtLeft.Text = '') and (edtBottom.Text = '') then
    Exit;

  bmp := CaptureQrcode;

  if not Assigned(bmp) then
    Exit;

  // show qrcode
  paintBox.Canvas.Brush.Color := clWhite;
  paintBox.Canvas.FillRect(Rect(0, 0, paintBox.Width, paintBox.Height));
  if (paintBox.Width < paintBox.Height) then
  begin
    scale := paintBox.Width / bmp.Width;
  end
  else
  begin
    scale := paintBox.Height / bmp.Height;
  end;
  paintBox.Canvas.StretchDraw(Rect(0, 0, Trunc(bmp.Width * scale),
    Trunc(bmp.Height * scale)), bmp);

  // scan qrcode
  ScanManager := TScanManager.Create(TBarcodeFormat.QR_CODE, nil);
  rs := ScanManager.Scan(bmp);
  if (rs <> nil) then
  begin
    if (rs.ResultMetaData <> nil) and rs.ResultMetaData.ContainsKey
      (TResultMetaDataType.ERROR_CORRECTION_LEVEL) then
    begin

    end;

    if FTotalPage = 0 then
    begin
      FTotalPage := StrToInt(rs.Text.Substring(0, rs.Text.IndexOf('||||')));
      edtTotal.Text := IntToStr(FTotalPage);
    end;
    pageFlag := rs.Text.Substring(rs.Text.IndexOf('||||') + 4,
      rs.Text.IndexOf('$$$$') - rs.Text.IndexOf('||||') - 4);
    if not isHaveFlag(pageFlag) then
    begin
      FQrFlagList.Add(pageFlag);
      IndexQrMsg := TIndexQrMsg.Create;
      IndexQrMsg.msg := rs.Text.Substring(rs.Text.IndexOf('$$$$') + 4);
      IndexQrMsg.index := StrToInt(pageFlag);
      FQrMsgList.Add(IndexQrMsg);
      Memo1.Lines.Add(pageFlag);
    end;
  end;
  FreeAndNil(rs);

  // finish receiving qrcode
  if (FQrMsgList.Count = FTotalPage) and (FTotalPage<>0) then
  begin
    endTime := Time;
    elapsedTime := endTime - FStartTime;
    Memo1.Lines.Add('接收完成, 二维码数量: ' + IntToStr(FTotalPage) + ' 用时: ' +
      FloatToStr(elapsedTime));
    FQrMsgList.SortList(compareItem);
    buf := getBufferFromStrings(FQrMsgList);
    qmm := TQrMsgManager.Create;
    qmm.WriteFileFromBytes(buf);
    buf := nil;
    qmm.Free;
    FRcvFlag := False;
  end;

  FreeAndNil(ScanManager);
  FreeAndNil(bmp);
end;

procedure TfrmRecv.btnPauseClick(Sender: TObject);
begin
  FRcvFlag := False;
end;

procedure TfrmRecv.btnRecvClick(Sender: TObject);
var
  I: Integer;
begin
  FRcvFlag := True;
  FTotalPage := 0;
  for I := 0 to FQrMsgList.Count - 1 do
  begin
    TIndexQrMsg(FQrMsgList.Items[I]).Free;
  end;
  FQrMsgList.Clear;
  FQrFlagList.Clear;
  FStartTime := Time;
end;

procedure TfrmRecv.btnResidueClick(Sender: TObject);
var
  I: Integer;
  strs: TStringList;
begin
  if (FTotalPage=0) or (edtResidue.Text='') then begin
    ShowMessage('没有未识别的剩余二维码');
    Exit;
  end;

  strs := TStringList.Create;
  for I := 0 to FTotalPage-1 do begin
    if not isHaveFlag(intToStr(I)) then begin
      strs.Add(inttostr(I));
    end;
  end;

  strs.Delimiter := ',';
  Memo1.Lines.Add(strs.CommaText);
  strs.Free;
end;

function TfrmRecv.CaptureQrcode: TBitmap;
Var
  srcCanvas: TCanvas;
begin
  srcCanvas := TCanvas.Create;
  srcCanvas.Handle := GetDC(GetDesktopWindow);
  Result := TBitmap.Create;
  try
    Result.Width := 400;
    Result.Height := 400;
    Result.Canvas.CopyRect(Rect(0, 0, Result.Width, Result.Height), srcCanvas,
      Rect(StrToInt(edtLeft.Text), StrToInt(edtTop.Text),
      StrToInt(edtRight.Text), StrToInt(edtBottom.Text)));
  finally
    ReleaseDC(GetDesktopWindow, srcCanvas.Handle);
    srcCanvas.Free;
  end;
end;

procedure TfrmRecv.FormCreate(Sender: TObject);
begin
  FRcvFlag := False;
  FQrFlagList := TStringList.Create;
  FQrMsgList := TList.Create;
  Memo1.Lines.Clear;
  FTotalPage := 0;
  Application.OnIdle := applicationOnIdle;
end;

procedure TfrmRecv.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  FQrFlagList.Clear;
  FreeAndNil(FQrFlagList);
  for I := 0 to FQrMsgList.Count - 1 do
  begin
    FreeMem(FQrMsgList.Items[I]);
  end;
  FreeAndNil(FQrMsgList);
end;

function TfrmRecv.getBufferFromStrings(aList: TList): TArray<Byte>;
var
  I, offset: Integer;
  buf: TArray<Byte>;
  totalLen: Integer;
  s: string;
begin
  totalLen := 0;
  offset := 0;
  s := '';
  for I := 0 to aList.Count - 1 do
  begin
    s := s + TIndexQrMsg(aList.Items[I]).msg;
  end;
//  Memo1.Lines.Add(s);
  buf := TNetEncoding.Base64.DecodeStringToBytes(s);
  totalLen := Length(buf);
  SetLength(Result, totalLen);
  ZeroMemory(@Result[0], totalLen);
  CopyMemory(@Result[0], @buf[0], Length(buf));
  buf := nil;
end;

function TfrmRecv.isHaveFlag(flag: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FQrFlagList.Count - 1 do
  begin
    if FQrFlagList.Strings[I] = flag then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TfrmRecv.Timer1Timer(Sender: TObject);
begin
  if FTotalPage=0 then Exit;

  edtResidue.Text := IntToStr(FTotalPage - FQrFlagList.Count);
end;

function TfrmRecv.compareItem(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(CompareValue(TIndexQrMsg(Item1).index,
    TIndexQrMsg(Item2).index));
  // if (PTIndexQrMsg(Item1).index > PTIndexQrMsg(Item2).index) then
  // Result := 1
  // else if (PTIndexQrMsg(Item1).index < PTIndexQrMsg(Item2).index) then
  // Result := -1;
end;

end.
