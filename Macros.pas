unit Macros;

interface
uses
  BatAPI;

function MacroTrim(Template, Params: ITBPDataProvider): AnsiString;
function MacroExec(Template, Params: ITBPDataProvider): AnsiString;
function MacroPython(Template, Params: ITBPDataProvider): AnsiString;
function MacroPyEval(Template, Params: ITBPDataProvider): AnsiString;

const
  Version = '0.4';
  MacrosDef: array[0..3] of record
    Name: AnsiString;
    Func: function(Template, Params: ITBPDataProvider): AnsiString;
    Info: AnsiString;
  end = (
    (Name: 'PY';    Func: MacroPython;  Info: 'Execute Python code, redirects print'),
    (Name: 'PYX';   Func: MacroPyEval;  Info: 'Evaluate Python expression, return results'),
    (Name: 'EXEC';  Func: MacroExec;    Info: 'Execute DOS command, return output'),
    (Name: 'TRIM';  Func: MacroTrim;    Info: 'Trim whitespace, return result')
  );

implementation
uses
  globals,
  CSIntf,
  MacrosExtra,
  SysUtils,
  vDOS,
  vPython,
  PythonEngine;

function MacroPython(Template, Params: ITBPDataProvider): AnsiString;
begin
  result := WrapPyPythonMacros(template,params,false);
end;

function MacroPyEval(Template, Params: ITBPDataProvider): AnsiString;
begin
  result := WrapPyPythonMacros(template,params,true);
end;

function MacroExec(Template, Params: ITBPDataProvider): AnsiString;
var
  cmd : AnsiString;
  i : integer;
begin
  cmd := GetDataStr(0, Params);
  i := Params.ItemCount;
  if (i=1) then begin
    result := vExec(cmd);
  end else begin
    result := errWrongParamCount;
  end;
end;

function MacroTrim(Template, Params: ITBPDataProvider): AnsiString;
begin
  if Params.ItemCount = 1 then begin
    Result := Trim(GetDataStr(0, Params))
  end else begin
    Result := errWrongParamCount;
  end;
end;

end.
