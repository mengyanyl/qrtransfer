unit uQrManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DelphiZXingQRCode,
  System.DateUtils;

type

  TOnQrcodeCreateProgress = procedure(Sender: TObject; AProgress: Integer)
    of object;
  TOnQrcodeCreateCostTime = procedure(Sender: TObject; AIndex, ACostTime: Integer)
    of object;

type
  TQrManager = class
  private
    FQrCode: TDelphiZXingQRCode;
    FOnQrCreateProgress: TOnQrcodeCreateProgress;
    FOnQrcodeCreateCostTime: TOnQrcodeCreateCostTime;
    FWorkerThreads: TList;
    FTaskList: TThreadList;
    FProgressVal: Integer;
    FQrResultList: TThreadList;
  public
    constructor Create;
    destructor Destroy;
    function createQrcode(aStr: String): TBitmap; overload;
    function createQrcode(aStrList: TStringList): TList; overload;
    function createQrcodeWithThread(aStrList: TStringList): TList;
    procedure destroyQrList(aQrBmps: TList);
    function scanQrcode: TBitmap;
    property OnQrCreateProgress: TOnQrcodeCreateProgress
      read FOnQrCreateProgress write FOnQrCreateProgress;
    property OnQrcodeCreateCostTime: TOnQrcodeCreateCostTime 
      read FOnQrcodeCreateCostTime write FOnQrcodeCreateCostTime;    
  end;

type
  TWorkerThread = class(TThread)
  private
    FTaskList: TThreadList;
    FQrManager: TQrManager;
    FCount: Integer;
    FResultList: TThreadList;
    FStoped: Boolean;
  protected
    procedure Execute; override;
  public
    procedure Stop;
    property TaskList: TThreadList read FTaskList write FTaskList;
    property QrManager: TQrManager write FQrManager;
    property ProgressVal: Integer read FCount write FCount;
    property ResultList: TThreadList write FResultList;
    property Stoped: boolean read FStoped write FStoped;
  end;

implementation

{ TQrManager }
constructor TQrManager.Create;
var
  t: TWorkerThread;
  I: Integer;
begin
  FProgressVal := 0;
  FQrCode := TDelphiZXingQRCode.Create;
  FTaskList := TThreadList.Create;
  FWorkerThreads := TList.Create;
  FQrResultList := TThreadList.Create;
//  // creart 3 worker thread
//  for I := 0 to 2 do
//  begin
//    t := TWorkerThread.Create(True);
//    t.ProgressVal := FProgressVal;
//    t.TaskList := FTaskList;
//    t.ResultList := FQrResultList;
//    t.QrManager := self;
//    t.Stoped := False;
//    t.Start;
//    FWorkerThreads.Add(t);
//  end;
end;

function TQrManager.createQrcode(aStr: String): TBitmap;
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  Result := TBitmap.Create;
  Result.Canvas.Lock;
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
        end
        else
        begin
          Result.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
    Result.Canvas.Unlock;
  end;
end;

function TQrManager.createQrcode(aStrList: TStringList): TList;
var
  qrBmp: TBitmap;
  I: Integer;
  p: PChar;
  st, et: TDateTime;
begin
  Result := TList.Create;
  for I := 0 to aStrList.Count - 1 do
  begin
    st := Now;
    if Assigned(FOnQrCreateProgress) then
      self.FOnQrCreateProgress(self, I);
    qrBmp := self.createQrcode(aStrList.Strings[I]);
    Result.Add(qrBmp);
    if Assigned(FOnQrcodeCreateCostTime) then begin
      self.FOnQrcodeCreateCostTime(self, I, SecondsBetween(Now, st));
    end;
  end;
end;

function TQrManager.createQrcodeWithThread(aStrList: TStringList): TList;
var
  I: Integer;
  list: TList;
begin
  Result := TList.Create;

  for I := 0 to aStrList.Count - 1 do
  begin
    FTaskList.Add(PChar(aStrList.Strings[I]));
  end;

  
  list := FTaskList.LockList;
  try
    while(list.Count>0) do begin
      Sleep(500);
    end;
  finally
    FTaskList.UnlockList;
  end;
      for I := 0 to FWorkerThreads.Count - 1 do
    begin
      TWorkerThread(FWorkerThreads.Items[I]).Stop;
    end;


  list := FQrResultList.LockList;
  try
    for I := 0 to list.Count - 1 do
    begin
      Result.Add(list.Items[I]);
    end;
  finally
    FQrResultList.UnlockList;
  end;

  // finish all task, clear all list
  FProgressVal := 0;
  FTaskList.Clear;
  FQrResultList.Clear;
end;

destructor TQrManager.Destroy;
var
  I: Integer;
begin
  FQrCode.Free;
  FTaskList.Free;
  FQrResultList.Free;
//  for I := 0 to FWorkerThreads.Count - 1 do
//  begin
//    TWorkerThread(FWorkerThreads[I]).Stop;
//    TThread(FWorkerThreads[I]).Terminate;
//  end;
//  FWorkerThreads.Free;
end;

procedure TQrManager.destroyQrList(aQrBmps: TList);
var
  I: Integer;
begin
  for I := 0 to aQrBmps.Count - 1 do
    (TBitmap(aQrBmps.Items[I])).Free;
  // aQrBmps.Free;
end;

function TQrManager.scanQrcode: TBitmap;
begin

end;

{ TWorkerThread }

procedure TWorkerThread.Execute;
var
  list: TList;
  s: string;
begin
  while not Stoped do begin
    list := FTaskList.LockList;
    try
      if list.Count > 0 then
      begin
        s := string(list.Extract(list.Items[0]));
        FResultList.Add(FQrManager.createQrcode(s));
        Inc(FCount);
        if Assigned(FQrManager.FOnQrCreateProgress) then
          FQrManager.FOnQrCreateProgress(self, FCount);
      end;
    finally
      FTaskList.UnlockList;
    end;
  end;
end;

procedure TWorkerThread.Stop;
begin
  FStoped := True;
end;

end.
