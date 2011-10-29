//***************************************************************************
// Little Big Architect: DePack unit - provides hqr opening, unpacking
//                                     and saving routines
//
// Copyright (C) 2004 Zink
//
// e-mail: zink@poczta.onet.pl
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//***************************************************************************

//Modified by Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.  (2007-2007)
//Modified so it fit LBA Image Creator

{$mode objfpc}{$H+}

unit DePack;

interface

uses LCLIntf,Classes, SysUtils, Dialogs, StrUtils, Math, LICEngine;

{Since some functions dont exist in Lazarus I'll create em here. //LWO}

function LOBYTE(w : longint) : BYTE;

function LOWORD(l : longint) : WORD;

function HIBYTE(w : longint) : BYTE;

function HIWORD(l : longint) : WORD;

{Rest written by Zink}




type
TImagetype= (spriraw, sprite, raw, brick,rawdata, palette,rawS,rawM,rawL);
 TPackEntry = record


  Offset: DWORD;
  CpSize: DWORD;
  RlSize: DWORD;
  Comp: WORD;
  FType: Integer; {-3=hidden, -2=blank, -1=normal, >-1=repeated}
  Data: string;
  //heredown are added stuff for the Image Creator
  modsinceanalyze:boolean;
  modified:boolean;
  Imagetype:TImagetype;
  Image:TLBAImage;
 end;



 TPackEntries = array of TPackEntry;
 TWhatEntries = (weGrids, weFrags, weLibs, weBricks, weTransparent);
 TBkgKinds = set of (bkGrid, bkFrag, bkLib, bkBrk);

var
 f: file;
 OpOffsets: array of record
  D: DWORD;
  T: Integer;
 end;
 PackSize: DWord;

Function ExtIs(path, ext: String): Boolean;
Function IsBkg(path: String): Boolean;
function ReadStrInt(d: String; pos: DWord): Integer;
procedure WriteStrInt(var d: String; pos, val: Integer);
function GetStrInt(val: Integer): ShortString;
function ReadStrWord(d: String; pos: DWord): Word;
procedure WriteStrWord(var d: String; pos, val: Integer);
function GetStrWord(val: Word): ShortString;
//Procedure CheckFile(path: String);
function CompressNewEx(InData: String; const CType: Word):string; stdcall; //by Obrasilo
Function OpenPack(const data: TStream; First: Integer=-1; Last: Integer=-1): TPackEntries;
Function OpenPackFile(path: String; First: Integer=-1; Last: Integer=-1): TPackEntries;
Procedure SavePackToFile(data: TPackEntries; path: String);
Function UnpackToStream(src: TPackEntry): TMemoryStream;
Function UnpackToString(const src: TPackEntry): String;
Procedure UnpackSelf(var src: TPackEntry);
Procedure UnpackAll(var src: TPackEntries);
Procedure PackEntry(NewData: String;var Entry:TPackentry; FType: Integer = -1; Comp: Word = 0;
 Offset: DWORD = 0);Function OpenSingleEntry(data: TStream; Index: Integer): TPackEntry;
//procedure ReplaceEntry(path: String; Index: Integer; data: String); //not used
Function PackEntriesCount(path: String): Integer;
Function BkgEntriesCountS(data: TFileStream; What: TWhatEntries): TSmallPoint;
Function BkgEntriesCountF(path: String; What: TWhatEntries): TSmallPoint;
procedure BkgHeadFix(var Bkg: TPackEntries; const GrCnt, FrCnt, LbCnt, BkCnt,
 TranspBrk: Integer);
Function NumberDialog(PType: String; First, Last: Integer; var val: Integer): Boolean;

const

emptypackentry:  TPackEntry   =
  (Offset:0;
  CpSize:1;
  RlSize:1;
  Comp: 0;
  FType: -1; {-3=hidden, -2=blank, -1=normal, >-1=repeated}
  Data: 'E'; //Could be anything...
  
  modsinceanalyze:true;
  modified:false;
  Imagetype:rawdata);
implementation

{Since some functions dont exist in Lazarus I'll create em here. //LWO}

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function HIBYTE(w : longint) : BYTE;
    begin
       HIBYTE:=BYTE(((WORD(w)) shr 8) and $FF);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function HIWORD(l : longint) : WORD;
    begin
       HIWORD:=WORD(((DWORD(l)) shr 16) and $FFFF);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LOBYTE(w : longint) : BYTE;
    begin
       LOBYTE:=BYTE(w);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LOWORD(l : longint) : WORD;
    begin
       LOWORD:=WORD(l);
    end;


{Rest written by Zink}


Function ExtIs(path, ext: String): Boolean;
begin
 Result:= AnsiSameText(ExtractFileExt(path),ext);
end;

Function IsBkg(path: String): Boolean;
begin
 Result:= AnsiContainsText(path,'lba_bkg') and ExtIs(path,'.hqr');
end;

Procedure Error(Code: Integer; path: String = ''; Param: Integer = 0);
var msg, offset: String;
begin
 offset:=IntToStr(Param)+' (Hex: '+IntToHex(Param,0)+').';
 Case Code of
   1:msg:='Last offset does not match file size.';
   2:msg:='File doesn''t exist.';
   3:msg:='Unexpected end of file.';
   4:msg:='Erroneous data at offset '+offset;
   5:msg:='Invalid entry size information at offset '+offset;
   6:msg:='Invalid compression information at offset '+offset;
   7:msg:='Erroneous data at line '+IntToStr(Param)+'.';
   8:msg:='Unknown project/script file extension.';
   9:msg:='Unknown package file extension.';
  10:msg:='No such entry';
  11:msg:='File access denied.';
  else msg:='Unknown error.';
 end;
 //MessageBox(Form1.handle,PChar('During processing the file "'+path+'" the following problem occured:'#13#13+'#'+IntToStr(code)+': '+msg),'LBA Package Engine',MB_ICONERROR+MB_OK);
 try     //¿eby nie by³o b³êdu jeœli plik nie jest otwarty
  CloseFile(f);
 except
 end;
 Abort;
end;

function ReadStrInt(d: String; pos: DWord): Integer;
begin
 Result:=Byte(d[pos])+Byte(d[pos+1])*256+Byte(d[pos+2])*256*256+Byte(d[pos+3])*256*256*256;
end;

procedure WriteStrInt(var d: String; pos, val: Integer);
begin
 d[pos]  :=Char(LoByte(LoWord(val)));
 d[pos+1]:=Char(HiByte(LoWord(val)));
 d[pos+2]:=Char(LoByte(HiWord(val)));
 d[pos+3]:=Char(HiByte(HiWord(val)));
end;

function GetStrInt(val: Integer): ShortString;
begin
 Result:=Char(LoByte(LoWord(val)))+Char(HiByte(LoWord(val)))+Char(LoByte(HiWord(val)))+Char(HiByte(HiWord(val)));
end;

function ReadStrWord(d: String; pos: DWord): Word;
begin
 Result:=Byte(d[pos])+Byte(d[pos+1])*256;
end;

procedure WriteStrWord(var d: String; pos, val: Integer);
begin
 d[pos]  :=Char(LoByte(val));
 d[pos+1]:=Char(HiByte(val));
end;

function GetStrWord(val: Word): ShortString;
begin
 Result:=Char(LoByte(val))+Char(HiByte(val));
end;

{Procedure CheckFile(path: String); stdcall;
begin
 If not FileExists(path) then begin
  MessageDlg('File "'+path+'" doesn''t exist!'#13#13'Loading of files aborted.',mtError,[mbOK],0);
  //dlg.Close;
  Abort;
 end;
end; }

Function FindNextOffset(current: Integer): Integer;
var a: Integer;
begin
 for a:=current+1 to Length(OpOffsets)-2 do
  If OpOffsets[a].T=-1 then begin
   Result:=a;
   Exit;
  end;
 Result:=Length(OpOffsets)-1;
end;

  Function OpenPack(const data: TStream; First: Integer=-1; Last: Integer=-1): TPackEntries;
var a, b, c: Integer;
    Buffer: DWORD;
begin
 SetLength(OpOffsets,1);
 with data do begin
  Seek(0,soBeginning);
  Read(OpOffsets[0].D,4);
  OpOffsets[0].T:= -1;  //first entry is always normal
  SetLength(OpOffsets,(OpOffsets[0].D div 4)-1);
  for a:= 1 to Length(OpOffsets) - 1 do begin
   Read(OpOffsets[a].D,4);
   OpOffsets[a].T:= -1;
   If OpOffsets[a].D = 0 then
    OpOffsets[a].T:= -2
   else
    For b:= 0 to a - 1 do
     If OpOffsets[a].D = OpOffsets[b].D then begin
      OpOffsets[a].T:= b;
      Break;
     end;
  end;

  If First < 0 then First:= 0;
  If Last < 0 then Last:= Length(OpOffsets) - 1
  else if Last >= Length(OpOffsets) then Last:= Length(OpOffsets) - 1;

  SetLength(Result,Last-First+1);
  b:=0;
  For a:=First to Last do begin
   If OpOffsets[a].T=-1 then begin
    Buffer:=OpOffsets[a].D;
    repeat
     If Length(Result)<b+1 then SetLength(Result,b+1);
     If Buffer=OpOffsets[a].D then Result[b].FType:=-1
     else Result[b].FType:=-3;
     Seek(Buffer,soBeginning);
     Result[b].Offset:=Buffer;
     Read(Result[b].RlSize,4);
     Read(Result[b].CpSize,4);
     Read(Result[b].Comp,2);
     If (Result[b].Comp>2) then Result[b].Comp:=0;

     SetLength(Result[b].Data,Result[b].CpSize);
     Read(Result[b].Data[1],Result[b].CpSize);

     Inc(Buffer,Result[b].CpSize+10);

     Inc(b);
     c:=FindNextOffset(a);
    until Buffer>=OpOffsets[c].D;
   end
   else begin
    If Length(Result)<b+1 then SetLength(Result,b+1);
    if OpOffsets[a].T>-1 then begin
     Result[b].Offset:=OpOffsets[a].D;
     Result[b].CpSize:=Result[OpOffsets[a].T].CpSize;
     Result[b].RlSize:=Result[OpOffsets[a].T].RlSize;
     Result[b].Comp:=Result[OpOffsets[a].T].Comp;
     Result[b].Data:=Result[OpOffsets[a].T].Data;
    end
    else begin
     Result[b].CpSize:=0;
     Result[b].RlSize:=0;
    end;
    Result[b].FType:=OpOffsets[a].T;
    Inc(b);
   end;
  end;
 end;
 SetLength(Result,b);
 SetLength(OpOffsets,0);
end;

Function OpenPackFile(path: String; First: Integer=-1; Last: Integer=-1): TPackEntries;
var FStr: TFileStream;
begin
 FStr:=TFileStream.Create(path,fmOpenRead);
 Result:=OpenPack(FStr,First,Last);
 FStr.Free;
end;

procedure CalcOffsets(var data: TPackEntries);
var a, c: Integer;
    b: DWORD;
begin
 b:=4;
 for a:=0 to High(data) do
  If data[a].FType<>-3 then Inc(b,4); //skip hidden

 For a:=0 to High(data) do begin
  case data[a].FType of
   -1: data[a].Offset:=b;   //normal
   -2: data[a].Offset:=0;   //blank
   else if data[a].FType>=0 then  //repeated
    data[a].Offset:=data[data[a].FType].Offset
  end;

  If data[a].FType<>-2 then begin
   c:=10+data[a].CpSize;
   If data[a].FType<0 then Inc(b,c);
  end;
 end;
 PackSize:=b;
end;

Procedure SavePackToFile(data: TPackEntries; path: String);
var a: Integer;
    f: File;
begin
 CalcOffsets(data);
 AssignFile(f,path);
 Rewrite(f,1);
 For a:=0 to High(data) do
  If data[a].FType<>-3 then
   BlockWrite(f,data[a].Offset,4);
 BlockWrite(f,PackSize,4);
 For a:=0 to High(data) do
  If (data[a].FType=-1) or (data[a].FType=-3) then begin
   BlockWrite(f,data[a].RlSize,4);
   BlockWrite(f,data[a].CpSize,4);
   BlockWrite(f,data[a].Comp,2);
   BlockWrite(f,data[a].Data[1],data[a].CpSize);
  end;
 CloseFile(f);
end;

Function UnpackToStream(src: TPackEntry): TMemoryStream;
var a: Integer;
    b, d, f, g: Byte;
    e: Word;
    Buffer: String;
begin
 With src do begin
  Result:= TMemoryStream.Create;
  Result.Clear;
  If FType = -2 then Exit;
  If Comp = 0 then begin Result.Write(data[1],Length(data)); Exit; end;
  Buffer:= '';
  a:= 1;
  repeat
   b:= Byte(Data[a]);
   for d:=0 to 7 do begin
    inc(a);
    if (b and (1 shl d))<>0 then
     Buffer:= Buffer + Data[a]
    else begin
     e:= Byte(Data[a])*256 + Byte(Data[a+1]);
     f:=((e shr 8) and $000f)+Comp+1; //tutaj mamy d³ugoœæ do skopiowania
     e:=((e shl 4) and $0ff0)+((e shr 12) and $000f);  //tutaj mamy adres od koñca bufora
     for g:=1 to f do
      Buffer:=Buffer+Buffer[Length(Buffer)-e];
     Inc(a);
    end;
    If a>=Length(Data) then Break;
   end;
   Inc(a);
  until a>=Length(Data);
  SetLength(Buffer,RlSize);
  Result.Write(Buffer[1],Length(Buffer));
 end;
end;

Function UnpackToString(const src: TPackEntry): String;
var a: Integer;
    b, d, f, g: Byte;
    e: Word;
begin
 With src do begin
  If FType=-2 then Exit;
  If Comp=0 then begin Result:=data; Exit; end;
  Result:='';
  a:=1;
  repeat
   b:=Byte(Data[a]);
   for d:=0 to 7 do begin
    inc(a);
    if (b and (1 shl d))<>0 then
     Result:=Result+Data[a]
    else begin
     e:=Byte(Data[a])*256+Byte(Data[a+1]);
     f:=((e shr 8) and $000f)+Comp+1; //tutaj mamy d³ugoœæ do skopiowania
     e:=((e shl 4) and $0ff0)+((e shr 12) and $000f);  //tutaj mamy adres od koñca bufora
     for g:=1 to f do
      Result:=Result+Result[Length(Result)-e];
     Inc(a);
    end;
    If a>=Length(Data) then Break;
   end;
   Inc(a);
  until a>=Length(Data);
  SetLength(Result,RlSize);
 end;
end;

Procedure UnpackSelf(var src: TPackEntry);
begin
 If src.Comp=0 then Exit;
 src.Data:=UnpackToString(src);
 src.Comp:=0;
 src.CpSize:=src.RlSize;
end;

Procedure UnpackAll(var src: TPackEntries);
var a: Integer;
begin
 for a:=0 to Length(src)-1 do begin
  src[a].Data:=UnpackToString(src[a]);
  src[a].Comp:=0;
  src[a].CpSize:=src[a].RlSize;
 end;
end;

Function Compress(InData: String; const CType: Word): String;
var a, b, c, d, Pos, MaxSize, MaxPos, InLen: Integer;
    Buff, Needle: String;
    e: Word;
begin
 If (CType<>1) and (CType<>2) then begin Result:=InData; Exit; end;
 InLen:= Length(InData);
 Pos:=1;
 Result:='';
 repeat
  Buff:=#00;
  for a:=0 to 7 do begin
   MaxSize:= 0;
   c:= 3;
   d:= 0;
   b:= PosEx(Copy(InData,Pos,c),InData,Max(1,Pos-4096));
   while (b > 0) and (b < Pos) and (Pos < InLen-1) do begin
    While (Pos+c <= InLen) and (InData[b+c] = InData[Pos+c]) and (c < 16+CType) do Inc(c); //find whole string
    If c > MaxSize then begin MaxSize:= c; MaxPos:= b; end;
    If c >= 16+CType then Break;
    If c <> d then Needle:= Copy(InData,Pos,c);
    b:= PosEx(Needle,InData,b+1);
    d:= c;
   end;

   If MaxSize>0 then begin
    b:= Pos - MaxPos - 1;
    Inc(Pos,MaxSize);
    c:= MaxSize - CType - 1;
    e:= ((b and $0FFF) shl 4) + (c and $000F);
    Buff:= Buff + Char(e and $00FF) + Char((e and $FF00) shr 8);
    Buff[1]:= Char(Byte(Buff[1]) and ($FF xor (1 shl a)));
   end
   else begin
    Buff:= Buff + InData[Pos];
    Inc(Pos);
    Buff[1]:= Char(Byte(Buff[1]) or (1 shl a));
   end;
   If Pos > InLen then Break;
  end;
  Result:= Result + Buff;
 until Pos > InLen;
end;

function CompressNewEx(InData: String; const CType: Word):string; stdcall;
var a, b, c, d, Pos, MaxSize, MaxPos, InLen: Integer;
    Buff, Needle: String;
    e: Word;
begin
 If (CType<>1) and (CType<>2) then begin result:=InData; Exit; end;
 InLen:= Length(InData);
 Pos:=1;
 result:='';
 repeat
  Buff:=#00;
  for a:=0 to 7 do begin
   MaxSize:= 0;
   {Modified by OBrasilo.}
   c:= 1 + CType;
   d:= 0;
   b:= PosEx(Copy(InData,Pos,c),InData,Max(1,Pos-4096));
   while (b > 0) and (b < Pos) and (Pos < InLen-1) do begin
    While (Pos+c <= InLen) and (InData[b+c] = InData[Pos+c]) and (c < 16+CType) do Inc(c); //find whole string
   {Modified by OBrasilo.}
     If c >= MaxSize then begin MaxSize:= c; MaxPos:= b; end;
    If c >= 16+CType then Break;
   {Modified by OBrasilo.}
    If (((Pos - b - 1) mod 4) <> 0) or (((Pos - b - 1) mod 6) <> 0) then begin
        If c <> d then Needle:= Copy(InData,Pos,c);
        b:= PosEx(Needle,InData,b+1);
        d:= c;
    end
    else begin
        If c+1 <> d then Needle:= Copy(InData,Pos,c+1);
        b:= PosEx(Needle,InData,b+2);
        d:= c+1;
    end;
   end;

   If MaxSize>0 then begin
    b:= Pos - MaxPos - 1;
    Inc(Pos,MaxSize);
    c:= MaxSize - CType - 1;
    e:= ((b and $0FFF) shl 4) + (c and $000F);
    Buff:= Buff + Char(e and $00FF) + Char((e and $FF00) shr 8);
    Buff[1]:= Char(Byte(Buff[1]) and ($FF xor (1 shl a)));
   end
   else begin
    Buff:= Buff + InData[Pos];
    Inc(Pos);
    Buff[1]:= Char(Byte(Buff[1]) or (1 shl a));
   end;
   If Pos > InLen then Break;
  end;
  result:= result + Buff;
 until Pos > InLen;
end;

Procedure PackEntry(NewData: String;var Entry:TPackentry; FType: Integer = -1; Comp: Word = 0;
 Offset: DWORD = 0);
begin
 Entry.Comp:= Comp;
 Entry.Data:= Compress(NewData,Comp);
 Entry.RlSize:= Length(NewData);
 Entry.CpSize:= Length(Entry.Data);
 Entry.FType:= FType;
 Entry.Offset:= Offset;
end;

Function OpenSingleEntry(data: TStream; Index: Integer): TPackEntry;
var a: Integer;
begin
 with data do begin
  Seek(0,soBeginning);
  Read(a,4);
  //If Index*4>a div 4 then Error(10,path);
  Seek(Index*4,soBeginning);
  Read(Result.Offset,4);
  Seek(Result.Offset,soBeginning);
  Read(Result.RlSize,4);
  Read(Result.CpSize,4);
  Read(Result.Comp,2);
  If Result.Comp>2 then Result.Comp:=0;
  SetLength(Result.Data,Result.CpSize);
  Read(Result.Data[1],Result.CpSize);
 end;
end;

{procedure ReplaceEntry(path: String; Index: Integer; data: String);
var s: String;                               //data must not be compressed !!!
    FCount, a, b, FOffset, FSize, FCSize: Integer;
    FComp: Word;
begin
 AssignFile(f,path);
 FileMode:=fmOpenReadWrite;
 Reset(f,1);
 try
  SetLength(s,FileSize(f));
  BlockRead(f,s[1],Length(s));
  FCount:=ReadStrInt(s,1) div 4;
  If FCount<Index-1 then Error(10,path);
  FOffset:=ReadStrInt(s,Index*4+1);
  FSize:=ReadStrInt(s,FOffset+1);
  FCSize:=ReadStrInt(s,FOffset+1+4);
  FComp:=ReadStrWord(s,FOffset+1+8);
  Delete(s,FOffset+1+10,FCSize);
  Insert(data,s,FOffset+1+10);
  WriteStrInt(s,FOffset+1,Length(data));
  WriteStrInt(s,FOffset+1+4,Length(data));
  WriteStrWord(s,FOffset+1+8,0);
  for a:=0 to FCount-1 do begin
   b:=ReadStrInt(s,a*4+1);
   if b>FOffset then Inc(b,Length(data)-FCSize);
   WriteStrInt(s,a*4+1,b);
  end;
  Seek(f,0);
  Truncate(f);
  BlockWrite(f,s[1],Length(s));
  CloseFile(f);
 except
  Error(11,path);
 end;
end;}

Function PackEntriesCount(path: String): Integer;
var f: File;
    a: DWORD;
begin
 //CheckFile(path);
 AssignFile(f,path);
 Reset(f,1);
 BlockRead(f,a,4);
 CloseFile(f);
 Result:=(a div 4)-1;
end;

Function BkgEntriesCountS(data: TFileStream; What: TWhatEntries): TSmallPoint;
var Temp: TPackEntry;
    Buff: TMemoryStream;
    a: WORD;
begin
 data.Seek(0,soBeginning);
 data.Read(Temp.Offset,4);
 data.Seek(Temp.Offset,soBeginning);
 data.Read(Temp.RlSize,4);
 data.Read(Temp.CpSize,4);
 data.Read(Temp.Comp,2);
 If (Temp.Comp>2) then Temp.Comp:=0;
 SetLength(Temp.Data,Temp.CpSize);
 data.Read(Temp.Data[1],Temp.CpSize);
 Buff:=UnpackToStream(Temp);
 a:=Ord(What)*2;
 Buff.Seek(a,soBeginning);
 Buff.Read(Result.X,2);
 Inc(Result.X);
 Buff.Read(Result.Y,2);
 Buff.Free;
end;

Function BkgEntriesCountF(path: String; What: TWhatEntries): TSmallPoint;
var FStr: TFileStream;
begin
 //CheckFile(path);
 FStr:=TFileStream.Create(path,fmOpenRead,fmShareDenyWrite);
 Result:=BkgEntriesCountS(FStr, What);
 FStr.Free;
end;

procedure BkgHeadFix(var Bkg: TPackEntries; const GrCnt, FrCnt, LbCnt, BkCnt,
 TranspBrk: Integer);
var Dt2, Dt3, Dt4: Word;
    a: Integer;
    max: DWord;
begin
 If Bkg[0].Comp>0 then UnpackSelf(Bkg[0]);
 If Length(Bkg[0].Data)<>28 then Exit;
 WriteStrWord(Bkg[0].Data,1,$0001);
 If GrCnt>-1 then Dt2:=GrCnt+1 else Dt2:=ReadStrWord(Bkg[0].Data,3);
 If FrCnt>-1 then Dt3:=Dt2+FrCnt else Dt3:=ReadStrWord(Bkg[0].Data,5);
 If LbCnt>-1 then Dt4:=Dt3+LbCnt else Dt4:=ReadStrWord(Bkg[0].Data,7);
 WriteStrWord(Bkg[0].Data,3,Dt2);
 WriteStrWord(Bkg[0].Data,5,Dt3);
 WriteStrWord(Bkg[0].Data,7,Dt4);
 If BkCnt>-1 then WriteStrWord(Bkg[0].Data,9,BkCnt);
 If TranspBrk>-1 then WriteStrWord(Bkg[0].Data,11,TranspBrk);
 max:=0;
 for a:=1 to Dt2-1 do
  If Bkg[a].RlSize>max then max:=Bkg[a].RlSize;
 WriteStrInt(Bkg[0].Data,13,max-2);
 max:=0;
 for a:=Dt3 to Dt4-1 do
  If Bkg[a].RlSize>max then max:=Bkg[a].RlSize;
 WriteStrInt(Bkg[0].Data,17,max);
end;

Function NumberDialog(PType: String; First, Last: Integer; var val: Integer): Boolean;
var res: String;
begin
 Result:=False;
 repeat
  res:=InputBox('Specify package entry',
   Format('This package contains more than one %s.'#13'Please enter the index of which one has to be used (from %d to %d):',[PType,First,Last]),'');
  if res='' then Exit;
  val:=StrToIntDef(res,First-1);
 until (val>=First) and (val<=Last);
 Result:=True;
end;

end.
