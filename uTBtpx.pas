unit uTBtpx;

interface
uses
  Classes,
  SysUtils;

function tpxGet(id:integer):string; overload;
function tpxGet(id:string):integer; overload;

var
  tpxList : TStringList;

implementation

function tpxGet(id:integer):string;
begin
  try
    result := tpxList.Names[id];
  except
    result := '';
  end;
end;

function tpxGet(id:string):integer;
begin
  try
    result := StrToInt(tpxList.Values[UpperCase(id)]);
  except
    result := -1;
  end;
end;

procedure tpxInsert(id:integer;s:string);
begin
  tpxList.Add(UpperCase(s)+'='+IntToStr(id));
end;

initialization

  tpxList := TStringList.Create;

  tpxInsert(200,'QuotePrefix');
  tpxInsert(201,'WrapJustify');
  tpxInsert(202,'Clear');
  tpxInsert(203,'IsSignature');
  tpxInsert(204,'SignComplete');
  tpxInsert(205,'EncryptComplete');
  tpxInsert(206,'UseSMIME');
  tpxInsert(207,'UsePGP');
  tpxInsert(208,'RCR');
  tpxInsert(209,'RRQ');
  tpxInsert(210,'Split');
  tpxInsert(211,'Charset');
  tpxInsert(212,'Priority');
  tpxInsert(214,'Account');
  tpxInsert(215,'From');
  tpxInsert(216,'ReplyTo');
  tpxInsert(217,'ReturnPath');
  tpxInsert(218,'To');
  tpxInsert(219,'CC');
  tpxInsert(220,'BCC');
  tpxInsert(221,'Org');
  tpxInsert(222,'Subject');
  tpxInsert(223,'FullSubject');
  tpxInsert(224,'Comment');
  tpxInsert(225,'OldTo');
  tpxInsert(226,'OldFrom');
  tpxInsert(227,'OldReplyTo');
  tpxInsert(228,'OldCC');
  tpxInsert(229,'OldBCC');
  tpxInsert(230,'OldSubject');
  tpxInsert(231,'OldComment');
  tpxInsert(232,'Matter');
  tpxInsert(233,'OldMatter');
  tpxInsert(234,'MsgID');
  tpxInsert(235,'OldMsgID');
  tpxInsert(236,'OldDate');
  tpxInsert(237,'OldRcvDate');
  tpxInsert(238,'OldReturn');
  tpxInsert(239,'OldOrg');
  tpxInsert(240,'OldText');
  tpxInsert(241,'Text');
  tpxInsert(243,'Headers');
  tpxInsert(244,'Attachments');
  tpxInsert(245,'OldAttachments');
  tpxInsert(247,'OldCharset');
  tpxInsert(248,'Tracking');
  tpxInsert(249,'QuoteStyle');
  tpxInsert(251,'RegExpPattern');
  tpxInsert(252,'RegExpText');
  tpxInsert(254,'FullText');
  tpxInsert(257,'LastAddress');
  tpxInsert(261,'CursorHeader');
  tpxInsert(262,'TotalPages');
  tpxInsert(263,'CurrentPage');
  tpxInsert(259,'FullTextDifferent');
  tpxInsert(260,'CursorBody');

finalization

  tpxList.Free();

end.
