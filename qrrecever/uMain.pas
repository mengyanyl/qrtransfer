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
  ZXing.ResultPoint;

type
  TfrmRecv = class(TForm)
    Panel1: TPanel;
    paintBox: TPaintBox;
    Memo1: TMemo;
    btnRecv: TButton;
    edtLeft: TEdit;
    edtTop: TEdit;
    edtRight: TEdit;
    edtBottom: TEdit;
    Panel2: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRecvClick(Sender: TObject);
  private
    FQrFlagList: TStringList;
    FRcvFlag: Boolean;
    { Private declarations }
    procedure applicationOnIdle(Sender: TObject; var Done: Boolean);
    function CaptureQrcode: TBitmap;
    function isHaveFlag(flag: string): boolean;
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
  bmp:TBitmap;
  scanManager: TScanManager;
  rs: TReadResult;
  pageFlag: string;
  scale: Double;
begin
  Done := False;

  if not FRcvFlag then Exit;
  if (edtLeft.Text='') and (edtBottom.Text='') then Exit;
  


  bmp := CaptureQrcode;

  if not Assigned(bmp) then Exit;

  //show qrcode
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

  //scan qrcode
  scanManager := TScanManager.Create(TBarcodeFormat.QR_CODE, nil);
  rs := scanManager.Scan(bmp);
  if (rs <> nil) then
    begin
      if (rs.ResultMetaData <> nil) and
          rs.ResultMetaData.ContainsKey(TResultMetaDataType.ERROR_CORRECTION_LEVEL) then
      begin
        
      end;
      pageFlag := rs.text.Substring(0,rs.text.IndexOf('|||'));
      if not isHaveFlag(pageFlag) then begin
        FQrFlagList.Add(pageFlag);
        Memo1.Lines.Add(pageFlag);
      end;
    end;

  FreeAndNil(scanManager);
  FreeAndNil(bmp);
end;

procedure TfrmRecv.btnRecvClick(Sender: TObject);
begin
  FRcvFlag := True;
end;

function TfrmRecv.CaptureQrcode: TBitmap;
Var
  srcCanvas: TCanvas;
begin
  srcCanvas := TCanvas.Create;
  srcCanvas.Handle := GetDC(GetDesktopWindow);
  Result := TBitmap.Create;
  try
    Result.Width:=425;
    Result.Height:=371;
    Result.Canvas.CopyRect(Rect(0,0,Result.Width,Result.Height),
              srcCanvas,
              Rect(StrToInt(edtLeft.Text),
                    StrToInt(edtTop.Text),
                    StrToInt(edtRight.Text),
                    StrToInt(edtBottom.Text))
              );
  finally
    ReleaseDC(GetDesktopWindow, srcCanvas.Handle);
    srcCanvas.Free;
  end;
end;

procedure TfrmRecv.FormCreate(Sender: TObject);
begin
  FRcvFlag := False;
  FQrFlagList := TStringList.Create;
  Memo1.Lines.Clear;
  Application.OnIdle := applicationOnIdle;
end;

function TfrmRecv.isHaveFlag(flag: string): boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FQrFlagList.Count-1 do begin
    if FQrFlagList.Strings[I]=flag then begin
      Result:=True;
      Break;
    end;
  end;
end;

end.
