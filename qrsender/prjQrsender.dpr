program prjQrsender;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  uQrManager in 'uQrManager.pas',
  uQrMsgManager in 'uQrMsgManager.pas';

{$R *.res}

      begin
        Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
