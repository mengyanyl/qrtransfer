unit uSrcQrcodeThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.NetEncoding;

type

  TSrcQrcodeThread = class(TThread)
  private
    FQrBmpList: TList;
    FStoped: Boolean;
    procedure updateImage;
  protected
    procedure Execute; override;
  public
    procedure StopThread;
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

  if (not Assigned(FQrBmpList)) or (FQrBmpList.Count = 0) then
    Exit;
  FStoped := False;
  Synchronize(updateImage);
end;

procedure TSrcQrcodeThread.StopThread;
begin
  FStoped := True;
end;

procedure TSrcQrcodeThread.updateImage;
var
  I: Integer;
begin
  while not FStoped do
  begin
    for I := 0 to FQrBmpList.Count - 1 do
    begin
      if FStoped then
        Break;
      Form1.Image1.Picture.Bitmap.Assign(FQrBmpList.Items[I]);
      Form1.Image1.Repaint;
      Sleep(100);
    end;
  end;
end;

end.
