unit MacrosExtra;

interface
uses
  PythonEngine,
  BatAPI,
  CSIntf,
  vPython,
  SysUtils,
  Macros;

function Info(): AnsiString;
function WrapPyPythonMacros(Template, Params: ITBPDataProvider; evalMode:boolean=false): AnsiString;

implementation

function Info: AnsiString;
var
  I: Integer;
begin
  Result :=
    '<html><body>'+
    '<b>TBPyxie v' + Version + '</b>'+
    '<br>'+
    '<a href="http://---.org/software/tbpyxie">http://---.org/software/tbpyxie</a>' +
    '<br>'+
    '<a href="mailto:tbpyxie@---.org">tbpyxie@---.org</a>'+
    '<hr>'+
    '<br>';


  for I := 0 to High(MacrosDef) do begin
    Result := Result + '<b>' + MacrosDef[I].Name + '</b>';
    Result := Result + '<br>';
    Result := Result + '&nbsp;&nbsp;&nbsp;'+MacrosDef[I].Info;
    Result := Result + '<br>';
    Result := Result + '<br>';
  end;

  Result := Result + '<hr>';
  Result := Result + '<br>';
  Result := Result + 'For Python code, the tb module is imported on startup.';
  Result := Result + '</body></html>';
end;

function WrapPyPythonMacros(Template, Params: ITBPDataProvider; evalMode:boolean=false): AnsiString;
var
  code : string;
begin

//  if Params.ItemCount = 1 then begin
    code := GetDataStr(0, Params);

    try
      if (evalMode) then begin
        result := vPythonEval(code);
      end else begin
        result := vPythonExec(code);
      end;
      codesite.send('vPython result',result);
    except
      on e:Exception do begin
        codesite.sendexception;

        result :=
        #13#10+
        '--- Python Macro Exception -------------------------------------------'+
        #13#10+
        '*** ' + e.Message + ' ***'+
        #13#10+
        vPythonStackTrace()+
        #13#10+
        '----------------------------------------------------------------------'+
        #13#10;
      end else begin
        result := '*** EXCEPTION ***';
      end
    end;

//  end else begin
//    result := errWrongParamCount;
//  end;

end;

end.
