unit uQrMsgManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes;

type
  TQrMsg = Record
    position: Integer;
    len: Integer;
    data: array [0 .. 1024] of Byte;
  End;

  PTQrMsg = ^TQrMsg;
  TQrMsgArray = array of TQrMsg;

  TQrMsgManager = class
  private
    FFileBuffer: TArray<Byte>;
    function GetFileSize(aFile: String): Integer;
  public
    constructor Create;
    destructor Destroy;
    function LoadFromFile(aFile: string; aPageSize: Integer = 1024): TList;
  end;

implementation

{ TQrMsgManager }

constructor TQrMsgManager.Create;
begin
  FFileBuffer := nil;
end;

destructor TQrMsgManager.Destroy;
begin
  if FFileBuffer <> nil then
    FreeMem(@FFileBuffer[0]);
end;

function TQrMsgManager.GetFileSize(aFile: String): Integer;
var
  fh: Integer;
begin
  fh := FileOpen(aFile, 0);
  try
    Result := FileSeek(fh, 0, 2);
  finally
    FileClose(fh);
  end;
end;

function TQrMsgManager.LoadFromFile(aFile: string;
  aPageSize: Integer = 1024): TList;
var
  fileLen, offset: Integer;
  reader: TStreamReader;
  fileStream: TFileStream;
  buf: TArray<Byte>;
  pQrMsg: PTQrMsg;
begin
  if not FileExists(aFile) then
    Result := nil;

  Result := TList.Create;
  offset := 0;
  fileLen := GetFileSize(aFile);
  SetLength(FFileBuffer, fileLen + 1);
  ZeroMemory(FFileBuffer, fileLen + 1);

  if (fileLen < aPageSize) then
  begin
    SetLength(buf, fileLen + 1);
    ZeroMemory(@buf[0], fileLen + 1);
    reader := TStreamReader.Create(aFile);
    fileStream := TFileStream.Create(aFile, fmOpenRead);
    fileStream.Read(buf, fileLen + 1);
    // reader.ReadBlock(buf, 0, fileLen + 1);
    GetMem(pQrMsg, sizeof(TQrMsg));
    ZeroMemory(@pQrMsg.data[0], Length(pQrMsg.data));
    CopyMemory(@pQrMsg.data[0], @buf[0], fileLen);
    Result.Add(pQrMsg);
    buf := nil;
    fileStream.Free;
  end
  else
  begin
    // reader := TStreamReader.Create(aFile, TEncoding.UTF8);
    fileStream := TFileStream.Create(aFile, fmOpenRead);
    fileStream.position := 0;
    try
      while fileStream.Position<fileLen do
      begin
        SetLength(buf, aPageSize + 1);
        ZeroMemory(@buf[0], aPageSize + 1);
        fileStream.Read(buf, 0, aPageSize);
        GetMem(pQrMsg, sizeof(TQrMsg));
        ZeroMemory(@pQrMsg.data[0], Length(pQrMsg.data));
        CopyMemory(@pQrMsg.data[0], @buf[0], aPageSize);
        Result.Add(pQrMsg);
      end;

      buf := nil;
    finally
      fileStream.Free;
    end;

  end;

end;

end.
