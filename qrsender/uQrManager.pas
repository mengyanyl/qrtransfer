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
    function createQrcode: TBitmap;
    function scanQrcode: TBitmap;
  end;

implementation

constructor TQrManager.Create;
begin
  FQrCode := TDelphiZXingQRCode.Create;
end;

function TQrManager.createQrcode():TBitmap;
begin

end;

destructor TQrManager.Destroy;
begin
  FQrCode.Free;
end;

function TQrManager.scanQrcode: TBitmap;
begin

end;

end.
