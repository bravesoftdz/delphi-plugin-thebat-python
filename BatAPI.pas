unit BatAPI;

interface

uses
  SysUtils;

type

  ITBPDataProvider = interface ['{9DD91B89-A551-4180-8A81-2CCF584CD4BF}']
    function GetDataByID(ID: Integer; ABuf: PChar; ABufSize: Integer): Integer;
      stdcall;
    function SetDataByID(ID: Integer; ABuf: PChar; ABufSize: Integer): Integer;
      stdcall;
    function GetIntValue(ID: Integer): Integer; stdcall;
    function SetIntValue(ID, Value: Integer): Integer; stdcall;
    function GetIDType(ID: Integer): Integer; stdcall;
    function ItemCount: Integer; stdcall;
    function ExecuteMacro(AMacro: Pointer; MaxLen: Integer;
      InData, OutData: ITBPDataProvider): HResult; stdcall;
  end;

const

  tpxQuotePrefix       = 200; // String
  tpxWrapJustify       = 201; // Boolean
  tpxClear             = 202; // Boolean
  tpxIsSignature       = 203; // Boolean
  tpxSignComplete      = 204; // Integer
  tpxEncryptComplete   = 205; // Integer
  tpxUseSMIME          = 206; // Integer
  tpxUsePGP            = 207; // Integer
  tpxRCR               = 208; // Integer
  tpxRRQ               = 209; // Integer
  tpxSplit             = 210; // Integer
  tpxCharset           = 211; // String
  tpxPriority          = 212; // Integer
  tpxAccount           = 214; // String
  tpxFrom              = 215; // String
  tpxReplyTo           = 216; // String
  tpxReturnPath        = 217; // String
  tpxTo                = 218; // String
  tpxCC                = 219; // String
  tpxBCC               = 220; // String
  tpxOrg               = 221; // String
  tpxSubject           = 222; // String
  tpxFullSubject       = 223; // String
  tpxComment           = 224; // String
  tpxOldTo             = 225; // String
  tpxOldFrom           = 226; // String
  tpxOldReplyTo        = 227; // String
  tpxOldCC             = 228; // String
  tpxOldBCC            = 229; // String
  tpxOldSubject        = 230; // String
  tpxOldComment        = 231; // String
  tpxMatter            = 232; // String
  tpxOldMatter         = 233; // String
  tpxMsgID             = 234; // String
  tpxOldMsgID          = 235; // String
  tpxOldDate           = 236; // String
  tpxOldRcvDate        = 237; // String
  tpxOldReturn         = 238; // String
  tpxOldOrg            = 239; // String
  tpxOldText           = 240; // String
  tpxText              = 241; // String
  tpxHeaders           = 243; // String
  tpxAttachments       = 244; // String
  tpxOldAttachments    = 245; // String
  tpxOldCharset        = 247; // String
  tpxTracking          = 248; // Integer
  tpxQuoteStyle        = 249; // Integer
  tpxRegExpPattern     = 251; // String
  tpxRegExpText        = 252; // String
  tpxFullText          = 254; // String
  tpxLastAddress       = 257; // String
  tpxCursorHeader      = 261; // String
  tpxTotalPages        = 262; // String
  tpxCurrentPage       = 263; // String
  tpxFullTextDifferent = 259; // Boolean
  tpxCursorBody        = 260; // Boolean

  dtcUndef             = -1; // Introduced by AP.
  dtcChar              = 0;
  dtcInt               = 1;
  dtcInt64             = 2;
  dtcWChar             = 3;
  dtcBool              = 5;
  dtcBinary            = 6;
  dtcFloat             = 7;

  errUnknown           = ' *** Error *** ';
  errWrongParamCount   = ' *** Error: wrong number of parameters *** ';
  errWrongParamValue   = ' *** Error: invalid parameter value *** ';

function PutStr(const S: String; B: PChar; BSize: Integer): Integer;
function GetDataStr(Idx: Integer; DataProvider: ITBPDataProvider): AnsiString;
function GetDataInt(Idx: Integer; DataProvider: ITBpDataProvider): Integer;

implementation

function PutStr(const S: String; B: PChar; BSize: Integer): Integer;
begin
  if (B = nil) or (BSize < 0) then
    Result:=Length(S)
  else
    try
      if BSize > Length(S) then
        BSize := Length(S);
      if BSize > 0 then
        Move(S[1], B[0], BSize);
      Result := BSize;
    except
      Result := 0;
    end;
end;

function GetDataStr(Idx: Integer; DataProvider: ITBPDataProvider): AnsiString;
var
  I: Integer;
  P: PChar;
  Sz: Integer;
begin
  P := nil;
  Sz := 0;
  Result := '';
  try
    I := DataProvider.GetDataByID(Idx, nil, 0);
    if I > 0 then begin
      if I > Sz then begin
        ReallocMem(P, I);
        Sz := I;
      end;
      I := DataProvider.GetDataByID(Idx, P, Sz);
      if I > 0 then
        SetString(Result, P, I);
    end;
  except
    Result := '';
  end;
  FreeMem(P);
end;

function GetDataInt(Idx: Integer; DataProvider: ITBpDataProvider): Integer;
begin
  Result := DataProvider.GetIntValue(Idx);
end;

end.
