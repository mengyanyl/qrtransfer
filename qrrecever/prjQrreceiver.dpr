program prjQrreceiver;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmRecv};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRecv, frmRecv);
  Application.Run;
end.
