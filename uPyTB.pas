unit uPyTB;

// Template.ExecuteMacro(PChar(Macro), Length(Macro), nil, Template);

interface
uses
  PythonEngine,
  vPython,
  CSIntf;

procedure uPyTB_initialization();
procedure uPyTB_finalization();

var
  PyTB: TPythonModule;

implementation
uses
  SysUtils,
  globals,
  BatAPI,
  uTBtpx;

function TB_itemcount( self, args : PPyObject ) : PPyObject; cdecl;
begin
  result := vPy.PyInt_FromLong( gTemplate.ItemCount() );
  vPy.Py_IncRef(result);
end;

function TB_get( self, args : PPyObject ) : PPyObject; cdecl;
var
  skey : pchar;
  key : integer;
  val : string;
begin
  if vPy.PyArg_ParseTuple( args, 's:tb.get', [@skey] ) <> 0 then begin
    try
      key := StrToInt(skey);
    except
      key := tpxGet(skey);
    end;
    val := GetDataStr(key,gTemplate);
    result := vPy.PyString_FromString( pchar(val) );
    vPy.Py_IncRef(result);
  end else begin
    result := nil;
  end;
end;

function TB_geti( self, args : PPyObject ) : PPyObject; cdecl;
var
  skey : pchar;
  key : integer;
  val : integer;
begin
  if vPy.PyArg_ParseTuple( args, 's:tb.get', [@skey] ) <> 0 then begin
    try
      key := StrToInt(skey);
    except
      key := tpxGet(skey);
    end;
    val := GetDataInt(key,gTemplate);
    result := vPy.PyInt_FromLong( val );
    vPy.Py_IncRef(result);
  end else begin
    result := nil;
  end;
end;

function TB_set( self, args : PPyObject ) : PPyObject; cdecl;
var
  skey : pchar;
  key : integer;
  val : pchar;
begin
  if vPy.PyArg_ParseTuple( args, 'ss:tb.macro', [@skey,@val] ) <> 0 then begin
    try
      key := StrToInt(skey);
    except
      key := tpxGet(skey);
    end;
    gTemplate.SetDataByID(key,val,Length(val));
    result := vPy.PyString_FromString( val );
    vPy.Py_IncRef(result);
  end else begin
    result := nil;
  end;
end;

function TB_seti( self, args : PPyObject ) : PPyObject; cdecl;
var
  skey : pchar;
  key : integer;
  val : integer;
begin
  if vPy.PyArg_ParseTuple( args, 'si:tb.macro', [@skey,@val] ) <> 0 then begin
    try
      key := StrToInt(skey);
    except
      key := tpxGet(skey);
    end;
    gTemplate.SetIntValue(key,val);
    result := vPy.PyInt_FromLong( val );
    vPy.Py_IncRef(result);
  end else begin
    result := nil;
  end;
end;

function TB_macro( self, args : PPyObject ) : PPyObject; cdecl;
var
  Macro: PChar;
  MacroResult: AnsiString;
begin
  if vPy.PyArg_ParseTuple( args, 's:tb.macro', [@Macro] ) <> 0 then begin
    codesite.Send('Macro',Macro);

    gTemplate.ExecuteMacro(Macro, Length(Macro), nil, gTemplate);
    MacroResult := GetDataStr(0, gTemplate);
    codesite.Send('MacroResult',MacroResult);

    result := vPy.PyString_FromString( pchar(MacroResult) );
    vPy.Py_IncRef(result);
  end else begin
    result := nil;
  end;
end;

function TB_param( self, args : PPyObject ) : PPyObject; cdecl;
var
  i : integer;
  s : AnsiString;
begin
  if vPy.PyArg_ParseTuple( args, 'i:tb.value', [@i] ) <> 0 then begin
    s := GetDataStr(i,gParams);
    result := vPy.PyString_FromString(pchar(s));
    vPy.Py_incRef(result)
  end else begin
    result := nil;
  end;
end;

function TB_paramcount( self, args : PPyObject ) : PPyObject; cdecl;
begin
  result := vPy.PyInt_FromLong( gParams.ItemCount() );
  vPy.Py_IncRef(result);
end;

procedure uPyTB_initialization();
begin
  PyTB := TPythonModule.Create(nil);
  PyTB.Engine := vPy;
  PyTB.ModuleName := 'tb';
  PyTB.AddMethod( 'itemcount', TB_itemcount, 'return TB template item count (no clue)' );
  PyTB.AddMethod( 'get', TB_get, 'get TB template value..');
  PyTB.AddMethod( 'set', TB_set, 'set TB template value..');
  PyTB.AddMethod( 'geti', TB_geti, 'get TB template int value..');
  PyTB.AddMethod( 'seti', TB_seti, 'set TB template int value..');
  PyTB.AddMethod( 'macro', TB_macro, 'execute TB macro');
  PyTB.AddMethod( 'param', TB_param, 'get TB parameter to this macro call');
  PyTB.AddMethod( 'paramcount', TB_paramcount, 'return TB parameter count');
  // TODO : figure out what the hell itemcount does for template, i know what it does for params

  // TODO : make get and set scriptable index interfaces... maybe ;->
  // or perhaps at least like iterable lists or something...
  // maybe only care about this in the future when i see what other dataproviders the tb api adds

  // TODO : refactor geti/get seti/set, so much shared code...
end;

procedure uPyTB_finalization();
begin
  PyTB.Free();
end;

end.
