unit uQrManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TQrManager = class
  public
    function createQrcode: TBitmap;
    function scanQrcode: TBitmap;
  end;

implementation

function TQrManager.createQrcode():TBitmap;
begin

end;

function TQrManager.scanQrcode: TBitmap;
begin

end;

end.
