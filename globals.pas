unit globals;

interface
uses
  CSIntf,
  SyncObjs,
  BatAPI;

var
  CS : TCriticalSection;
  gTemplate, gParams: ITBPDataProvider;

implementation
uses
  vPython,
  uPyTB;

initialization

  codesite.enabled := false;

  CS := TCriticalSection.Create();

  vPython_initialization();
  uPyTB_initialization();
  vPython_start();
  // import the PyTB/TB module
  vPy.ExecString('import tb');

finalization

  CS.Free();

  uPyTB_finalization();
  vPython_finalization();

end.
