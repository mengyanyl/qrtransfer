unit uQrManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DelphiZXingQRCode;

type
  TQrManager = class
  private
    FQrCode: TDelphiZXingQRCode;
  public
    constructor Create;
    destructor Destroy;
    function createQrcode(aStr: String): TBitmap; overload;
    function createQrcode(aStrList: TStringList): TList; overload;
    procedure destroyQrList(aQrBmps: TList);
    function scanQrcode: TBitmap;
  end;

implementation

constructor TQrManager.Create;
begin
  FQrCode := TDelphiZXingQRCode.Create;
end;

function TQrManager.createQrcode(aStr: String):TBitmap;
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  Result := TBitmap.Create;
  try
    QRCode.Data := aStr;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;
    QRCode.QuietZone := StrToIntDef('4', 4);
    Result.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          Result.Canvas.Pixels[Column, Row] := clBlack;
        end else
        begin
          Result.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
end;

function TQrManager.createQrcode(aStrList: TStringList): TList;
var
  qrBmp: TBitmap;
  i: Integer;
begin
  Result := TList.Create;
  for i:=0 to aStrList.Count-1 do begin
     qrBmp := self.createQrcode(aStrList.Strings[i]);
     Result.Add(qrBmp);
  end;
end;

destructor TQrManager.Destroy;
begin
  FQrCode.Free;
end;

procedure TQrManager.destroyQrList(aQrBmps: TList);
var
  I: Integer;
begin
  for I := 0 to aQrBmps.Count-1 do
     (TBitmap(aQrBmps.Items[I])).Free;
//  aQrBmps.Free;
end;

function TQrManager.scanQrcode: TBitmap;
begin

end;

end.
