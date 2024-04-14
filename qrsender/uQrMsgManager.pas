unit uQrMsgManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes;

type
  TQrMsg = Record
    position: Integer;
    len: Integer;
    data: TArray<Char>;
  End;

  PTQrMsg = ^TQrMsg;
  TQrMsgArray = array of TQrMsg;

  TQrMsgManager = class
  private
    FFileBuffer: TArray<Char>;
    function GetFileSize(aFile: String): Integer;
  public
    function LoadFromFile(aFile: string; aPageSize: Integer = 1024): TList;
  end;

implementation

{ TQrMsgManager }

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
  buf: TArray<Char>;
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
    reader.ReadBlock(buf, 0, fileLen + 1);
    GetMem(pQrMsg, sizeof(TQrMsg));
    SetLength(pQrMsg.data, fileLen + 1);
    ZeroMemory(@pQrMsg.data[0], fileLen + 1);
    CopyMemory(@pQrMsg.data[0], @buf[0], fileLen);
    Result.Add(pQrMsg);
    buf := nil;
    reader.Free;
  end
  else
  begin
    reader := TStreamReader.Create(aFile);
    try
      while not reader.EndOfStream do
      begin
        SetLength(buf, aPageSize + 1);
        ZeroMemory(@buf[0], aPageSize + 1);
        reader.ReadBlock(buf, 0, aPageSize);
        GetMem(pQrMsg, sizeof(TQrMsg));
        SetLength(pQrMsg.data, aPageSize + 1);
        ZeroMemory(@pQrMsg.data[0], aPageSize + 1);
        CopyMemory(@pQrMsg.data[0], @buf[0], aPageSize);
        Result.Add(pQrMsg);
      end;

      buf := nil;
    finally
      reader.Free;
    end;

  end;

end;

end.