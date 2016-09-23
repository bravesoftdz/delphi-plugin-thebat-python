library Pyxie;

uses
  MultiMM,
  globals,
  CSIntf,
  SysUtils,
  BatAPI,
  Macros,
  MacrosExtra,
  uPyTB,
  uTBtpx in 'uTBtpx.pas';

{$E TBP}

{.$R *.res}

procedure TBP_Initialize; stdcall;
begin
  Randomize;
end;

procedure TBP_Finalize; stdcall;
begin
end;

function TBP_GetName(ABuf: PChar; ABufSize: Integer): Integer; stdcall;
begin
  Result := PutStr('Pyxie', ABuf, ABufSize);
end;

function TBP_GetVersion(ABuf: PChar; ABufSize: Integer): Integer; stdcall;
begin
  Result := PutStr(Version, ABuf, ABufSize);
end;

function TBP_GetStatus: Integer; stdcall;
begin
  Result := 0;
end;

function TBP_GetInfo(ABuf: PChar; ABufSize: Integer): Integer; stdcall;
begin
  Result := PutStr(Info(), ABuf, ABufSize);
end;

function TBP_NeedConfig: Integer; stdcall;
begin
  Result := 0;
end;

function TBP_Setup: Integer; stdcall;
begin
  Result := 0;
end;

// TBP_GetConfigData not defined
// TBP_SetConfigData not defined

function TBP_NeedCOM: Integer; stdcall;
begin
  Result := 1;
end;

function TBP_GetMacroList(ABuf: PChar; ABufSize: Integer): Integer; stdcall;
var
  List: AnsiString;
  I: Integer;
begin
  List := '';
  for I := 0 to High(MacrosDef) do
    List := List + MacrosDef[I].Name + #13#10;
  Result := PutStr(PChar(List), ABuf, ABufSize);
end;

function TBP_ExecMacro(AMacro: Pointer; MaxLen: Integer; Template, Params: ITBPDataProvider): Integer; stdcall;
var
  Ready: AnsiString;
  I: Integer;
begin
  CS.Acquire();
  gTemplate := Template;
  gParams := Params;
  Result := -1;
  if (MaxLen > 0) then
    for I := 0 to High(MacrosDef) do
      if StrIComp(AMacro, PChar(MacrosDef[I].Name)) = 0 then
      begin
        Ready := MacrosDef[I].Func(Template, Params);
        Result := 0;
        Template.SetDataByID(Result, PChar(Ready), Length(Ready));
        Break;
      end;
  CS.Release();
end;

exports
  TBP_NeedConfig, TBP_GetStatus, TBP_GetVersion, TBP_GetName,
  TBP_Finalize, TBP_Initialize, TBP_Setup, TBP_NeedCOM,
  TBP_GetMacroList, TBP_ExecMacro, TBP_GetInfo;

begin
end.
