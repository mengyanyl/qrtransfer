unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes;

type

  TWorkerThread = class(TThread)
  protected
    procedure Execute; override;
  end;

implementation

{ TWorkerThread }

procedure TWorkerThread.Execute;
begin
  inherited;

end;

end.
