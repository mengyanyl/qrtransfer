unit uQrMsgManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.NetEncoding;

type
  TQrMsg = Record
    position: Integer;
    len: Integer;
    data: array [0 .. 1024] of Char;
  End;

  PTQrMsg = ^TQrMsg;
  TQrMsgArray = array of TQrMsg;

  TQrMsgManager = class
  private
    FBase64: TBase64Encoding;
    FFileBuffer: TArray<Byte>;
    FStrings: TStringList;
    FBase64String: string;

    function GetFileSize(aFile: String): Integer;
  public
    constructor Create;
    destructor Destroy;
    procedure LoadFileToBuffer(aFile: string);
    function LoadFromFile(aFile: string; aPageSize: Integer = 1024)
      : TList; overload;
    function LoadFromFile(aPageSize: Integer = 1024): TList; overload;
    property Strings: TStringList read FStrings;
    property Base64Text: string read FBase64String;
    property FileBuf: TArray<Byte> read FFileBuffer;
  end;

implementation

{ TQrMsgManager }

constructor TQrMsgManager.Create;
begin
  FFileBuffer := nil;
  FBase64String := '';
  FStrings := TStringList.Create;
  FBase64 := TBase64Encoding.Create();
end;

destructor TQrMsgManager.Destroy;
begin
  if FFileBuffer <> nil then
    FFileBuffer := nil;
  FreeAndNil(FBase64);
  FreeAndNil(FStrings);
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

procedure TQrMsgManager.LoadFileToBuffer(aFile: string);
var
  fileStream: TFileStream;
  reader: TStreamReader;
  buf, tmpbuf: TArray<Byte>;
  fileLen, len: Integer;
  str: string;
  I, offset: Integer;
begin
  if not FileExists(aFile) then
    Exit;

  fileLen := GetFileSize(aFile);

  offset := 0;
  FBase64String := '';
  FStrings.Clear;
  SetLength(FFileBuffer, fileLen);
  ZeroMemory(@FFileBuffer[0], fileLen);

  fileStream := TFileStream.Create(aFile, fmOpenRead);
  fileStream.position := 0;
  try
    while fileStream.position < fileLen do
    begin
      SetLength(buf, 1024);
      ZeroMemory(@buf[0], 1024);
      len := fileStream.Read(buf, 1024);
      if (len < 1024) then // 说明读到最后了
      begin
        SetLength(tmpbuf, len);
        ZeroMemory(@tmpbuf[0], len);
        CopyMemory(@tmpbuf[0], @buf[0], len);
        CopyMemory(@FFileBuffer[offset], @buf[0], len);
        str := FBase64.EncodeBytesToString(tmpbuf);
        tmpbuf := nil;
      end
      else
      begin
        CopyMemory(@FFileBuffer[offset], @buf[0], len);
        Inc(offset, len);
        str := TNetEncoding.Base64.EncodeBytesToString(buf);
      end;
      // FStrings.Add(str);
      FBase64String := FBase64String + str;
      buf := nil;
    end;
  finally
    fileStream.Free;
  end;

  // for I := 0 to FStrings.Count-1 do begin
  // FString := FString + FStrings[I]
  // end;
end;

function TQrMsgManager.LoadFromFile(aPageSize: Integer): TList;
var
  buf: TArray<Char>;
begin
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
    fileStream.Free;
  end
  else
  begin
    // reader := TStreamReader.Create(aFile, TEncoding.UTF8);
    fileStream := TFileStream.Create(aFile, fmOpenRead);
    fileStream.position := 0;
    try
      while fileStream.position < fileLen do
      begin
        SetLength(buf, aPageSize + 1);
        ZeroMemory(@buf[0], aPageSize + 1);
        fileStream.Read(buf, 0, aPageSize);
        GetMem(pQrMsg, sizeof(TQrMsg));
        ZeroMemory(@pQrMsg.data[0], Length(pQrMsg.data));
        CopyMemory(@pQrMsg.data[0], @buf[0], aPageSize);
        Result.Add(pQrMsg);
      end;
    finally
      fileStream.Free;
    end;

  end;
  buf := nil;
end;

end.
