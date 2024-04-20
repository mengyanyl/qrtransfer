unit uSrcQrcodeThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.NetEncoding, Vcl.ExtCtrls, Vcl.Graphics;

type

  TSrcQrcodeThread = class(TThread)
  private
    FQrBmpList: TList;
    FPaintBoxList: TPaintBox;
    FStoped: Boolean;
    FOnThreadPaint : TNotifyEvent;
    procedure updateImage;
    procedure sync;
  protected
    procedure Execute; override;
  public
    procedure StopThread;
    property OnThreadPaint: TNotifyEvent write FOnThreadPaint;
    property QrBmpList: TList write FQrBmpList;
    property Stoped: Boolean read FStoped write FStoped;
  end;

implementation

uses
  uMain;

{ TSrcQrcodeThread }


procedure TSrcQrcodeThread.Execute;

begin
  inherited;
  FreeOnTerminate := True;

  if (not Assigned(FQrBmpList)) or (FQrBmpList.Count = 0) then
    Exit;
  FStoped := False;
  if Assigned(FOnThreadPaint) then begin
    Synchronize(sync);
  end else begin
    Synchronize(updateImage);
  end;
end;

procedure TSrcQrcodeThread.StopThread;
begin
  FStoped := True;
end;

procedure TSrcQrcodeThread.updateImage;
var
  I: Integer;
  scale: Double;
  paintBox: TPaintBox;
  qrBmp: TBitmap;
begin
  paintBox := Form1.PaintBox1;
  paintBox.Canvas.Brush.Color := clWhite;
  paintBox.Canvas.FillRect(Rect(0, 0, paintBox.Width, paintBox.Height));

  while not FStoped do
  begin
    for I := 0 to FQrBmpList.Count - 1 do
    begin
      if FStoped then
        Break;
      qrBmp := TBitmap(FQrBmpList.Items[I]);
      if (paintBox.Width < paintBox.Height) then
      begin
        scale := paintBox.Width / qrBmp.Width;
      end
      else
      begin
        scale := paintBox.Height / qrBmp.Height;
      end;
      paintBox.Canvas.StretchDraw(Rect(0,0,Trunc(qrBmp.Width*scale),
            Trunc(qrBmp.Height*scale)), qrBmp);
      Sleep(150);
    end;
  end;

end;

procedure TSrcQrcodeThread.sync;
begin
  FOnThreadPaint(self);
end;


end.
