{$mode objfpc}{$H+}
//This is now GNU Licensed due to entangling from DePack unit by Zink.  (2007-2008)
//By Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.

unit Main;


interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, DePack, LICEngine
  , Buttons, StdCtrls, ExtCtrls, ComCtrls, Spin, ActnList, Menus,virtualkeys , Editor,ZStream, OldSchool,LazJPEG;

type


  { TMainForm }

  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn9: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    ColorDialog1: TColorDialog;
    Image1: TImage;
    Image2: TImage;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    LeftPanel: TPanel;
    PopupMenu2: TPopupMenu;
    PopupMenu8: TPopupMenu;
    Timer2: TTimer;
    TopPanel: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    PopupMenu6: TPopupMenu;
    PopupMenu7: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IndexEditChange(Sender: TObject);
    procedure LeftPanelClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TopPanelClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox1Click(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }
  end;
{    function filetostr(plats:TFilename):ansistring;
    procedure strtofile(const Data:ansistring;plats:TFilename;autooverwrite:boolean = true); } //this slow shit has been vanished...
    procedure Openproject(plats:TFilename); //open .HQR,.LUP and .LCP
    procedure OpenHQR(plats:TFilename);  //Open HQR, never to be used, instead openproject
    procedure analyzeentry(entry:integer=-1);//nothing visual is done
    procedure showimage(entry:integer=-1);   //visual actions
    function Closeproject:boolean;
    {
    function filetopackage(plats:TFilename):TPackentry;
    procedure packagetofile(const Data:TPackentry;plats:TFilename);
    }
    function GetCorrectData(Entry:TPackentry):ansistring;
    procedure FillWithCorrectData(first,last:DWORD);
    function isimage(Imagetype:TImagetype):boolean;
    function istransimagetype(Imagetype:TImagetype):boolean;
    function isNottransimagetype(Imagetype:TImagetype):boolean;
    procedure SaveFile(const FileName: TFileName;const content: string);
    function LoadFile(const FileName: TFileName): string;
    function findnextimage(startvalue:integer=-1;forwards:boolean =true):dword;
    function ImageTypetostring(Imagetype:TImagetype):string;
    procedure packentriestostream(Stream:TStream);
    procedure streamtopackentries(Stream:TStream);
    procedure packentrytostream(Stream:TStream;entry:TPackentry);
    //procedure streamtopackentry(Stream:TStream);
    procedure removeentries(fromentry:DWORD;count:word=1);
    procedure addentries(fromentry:DWORD;count:word);
{$EXTERNALSYM GetExitCodeProcess}

var
  MainForm: TMainForm;
  Opened:boolean;
  Path:string;
  Packentries:TPackentries;
  lastindex:Dword;
  tempImage:TLBAImage;
  respectoffset:boolean;
  maximizethedimensionsbool:boolean;

implementation



uses Palette, Typeeditor,Options, MPImgEditUnit,OPImgEditUnit;

procedure removeentries(fromentry:DWORD;count:word=1);
var
Stream:TMemoryStream;             //new project stream.
forer:Dword;
begin
if (fromentry=0) and (count>high(packentries)) then begin
  showmessage('There always has to be one entry, so no entry was removed');
  exit;
end;
if (fromentry>high(packentries)) or (fromentry<0) then
exit;
if (fromentry+count-1)>=length(packentries) then begin
  count:=length(packentries)-fromentry;
  showmessage('Only '+inttostr(count)+' entries will be deleted');
end;

Stream:=TMemoryStream.Create;
Stream.WriteAnsiString(path);
Stream.WriteDWord(length(packentries)-count);
Stream.WriteDWord(lastindex);
for forer:=0 to high(packentries)-count do
packentrytostream(Stream,packentries[forer+byte(forer>=fromentry)*count]);
Stream.Position:=0;
streamtopackentries(stream);
stream.Free;
end;


procedure addentries(fromentry:DWORD;count:word);
var
Stream:TMemoryStream;             //new project stream.
forer:Dword;
emptypackvar:TPackentry;
begin
Stream:=TMemoryStream.Create;
Stream.WriteAnsiString(path);
Stream.WriteDWord(length(packentries)+count);
Stream.WriteDWord(lastindex);

if fromentry<>0 then
for forer:=0 to fromentry-1 do
packentrytostream(Stream,packentries[forer]);

emptypackvar:=emptypackentry;
emptypackvar.Image:=TLBAImage.Create;
Loadtemppalette;
emptypackvar.Image.Palette:=temppalette;
for forer:=fromentry to fromentry+count-1 do
packentrytostream(Stream,emptypackvar);

if fromentry<>length(packentries) then
for forer:=fromentry+count to high(packentries)+count do
packentrytostream(Stream,packentries[forer-count]);


Stream.Position:=0;
streamtopackentries(stream);
stream.Free;
end;


procedure Openproject(plats:TFilename);
var
randomobject:TObject;
ds:TDecompressionStream;
fs:TFilestream;
begin

if not fileexists(plats) then begin
   showmessage('File at '+plats+' doesn''t exist');
   exit;
end;

  if uppercase(ExtractFileExt (plats)) = '.HQR' then begin
  if closeproject then
  OpenHQR(plats);
  Mainform.spinedit1.Value:=0;
  end;

  if uppercase(ExtractFileExt (plats)) = '.LUP' then begin
  if closeproject then begin
  fs:=TFilestream.Create(plats,fmopenread);
  streamtopackentries(fs);
  fs.free;
  end;
  end;

  if uppercase(ExtractFileExt (plats)) = '.LCP' then begin
  if closeproject then begin
  fs:=TFilestream.Create(plats,fmopenread);
  ds:=TDecompressionStream.Create(fs);
  streamtopackentries(ds);
  fs.free;
  end;
  end;

  MainForm.StatusBar1.Panels[7].Text:=path;


  MainForm.spinedit1.MaxValue:=high(packentries);

MainForm.Spinedit1Change(randomobject);

end;

function Closeproject:boolean;
var forer:dword;
begin
result:=true;
if opened then
if  MessageDlg('Close current project? All progress will be removed. (unless you saved output HQR)',mtconfirmation,mbyesno,0)=mryes then
begin
 for forer:=0 to high(packentries) do
   packentries[forer].Image.destroy;
result:=true;
opened:=false;
end
else begin
  result:=false;
  exit;
end;
end;

procedure packentrytostream(Stream:TStream;entry:TPackentry);
begin
    Stream.WriteDWord(entry.CpSize);
    Stream.WriteDWord(entry.RlSize);
    Stream.WriteByte(entry.Comp);
    Stream.Write(entry.FType,sizeof(entry.FType));
    Stream.WriteByte(byte(entry.modified));
    Stream.WriteByte(byte(entry.Imagetype));
    Stream.Write(entry.Image.palette,SizeOf(TPalette));
    Stream.Write(entry.Data[1],entry.CpSize);
end;

procedure packentriestostream(Stream:TStream);
var
forer     :DWORD;
begin
Stream.WriteAnsiString(path);;
Stream.WriteDWord(length(packentries));
Stream.WriteDWord(lastindex);
for forer:=0 to high(packentries) do
    packentrytostream(Stream,packentries[forer]); {begin
    Stream.WriteDWord(packentries[forer].CpSize);
    Stream.WriteDWord(packentries[forer].RlSize);
    Stream.WriteByte(packentries[forer].Comp);
    Stream.Write(packentries[forer].FType,sizeof(packentries[forer].FType));
    Stream.WriteByte(byte(packentries[forer].modified));
    Stream.WriteByte(byte(packentries[forer].Imagetype));
    Stream.Write(packentries[forer].Image.palette,SizeOf(TPalette));
    Stream.Write(packentries[forer].Data[1],packentries[forer].CpSize);
end;    }
end;


procedure streamtopackentries(Stream:TStream);
var
forer    : DWORD;
begin
try
path:=Stream.ReadAnsiString;
if not (DirectoryExists(ExtractFileDir(path)))
then
path:=ExtractFilePath(paramstr(0))+ExtractFileName(path);

setlength(packentries,Stream.ReadDWord);
MainForm.SpinEdit1.MaxValue:=high(packentries);
MainForm.SpinEdit1.Value:=Stream.ReadDWord;
for forer:= 0 to high(packentries) do begin
    packentries[forer].Image:=TLBAImage.create;
    packentries[forer].CpSize:=Stream.ReadDWord;
    packentries[forer].RlSize:=Stream.ReadDWORD;
    packentries[forer].Comp:=Stream.ReadByte;
    Stream.Read(packentries[forer].FType,sizeof(packentries[forer].FType));
    Stream.Read(packentries[forer].modified,1);
    Stream.Read(packentries[forer].Imagetype,1);  //sizeof results in 4, which is to high
    Stream.Read(packentries[forer].Image.Palette,SizeOf(TPalette));
    setlength(packentries[forer].Data,packentries[forer].CpSize);
    Stream.Read(packentries[forer].Data[1],packentries[forer].CpSize);

    packentries[forer].modsinceanalyze:=true;
end;
opened:=true;
MainForm.StatusBar1.Panels[7].Text:=path;
finally
if not opened then Raise Exception.Create('Uncompressed data could not been read, make sure you loaded a LIC-project');
end;
end;


function ImageTypetostring(Imagetype:TImagetype):string;
begin
case Imagetype of
rawS:Result:='Small Raw';
rawM:Result:='Medium Raw';
rawL:Result:='Large Raw';
depack.Sprite:Result:='Sprite';
depack.Brick:Result:='Brick';
Spriraw:Result:='Spriraw';
DePack.palette:Result:='Palette';
DePack.raw:Result:='Raw (unidentified!!)';
rawdata:Result:='Other';
end;
end;

function findnextimage(startvalue:integer=-1;forwards:boolean =true):dword;
var
atvalue:integer;
begin
  if startvalue=-1 then
  startvalue:=MainForm.SpinEdit1.Value;
  atvalue:=startvalue;
  repeat
  if forwards then
  inc(atvalue)
  else
  dec(atvalue);
  if atvalue=length(Packentries) then atvalue:=0;
  if atvalue=-1 then atvalue:=high(packentries);
  analyzeentry(atvalue);
  until (isimage(Packentries[atvalue].Imagetype)) or (atvalue=startvalue);

analyzeentry(atvalue);
result:=atvalue;
end;

function LoadFile(const FileName: TFileName): string;
begin
  with TFileStream.Create(FileName,
      fmOpenRead or fmShareDenyWrite) do begin
    try
      SetLength(Result, Size);
      Read(Pointer(Result)^, Size);
    except
      Result := '';  // Deallocates memory
      Free;
      raise;
    end;
    Free;
  end;
end;

procedure SaveFile(const FileName: TFileName;
                   const content: string);
begin
  with TFileStream.Create(FileName, fmCreate) do
    try
      Write(Pointer(content)^, Length(content));
    finally
      Free;
    end;
end;

function istransimagetype(Imagetype:TImagetype):boolean;
begin
if isimage(imagetype) and ((imagetype=depack.brick) or (imagetype=depack.sprite) or (imagetype=depack.spriraw))
then
result:=true
else result:=false;
end;

function isNottransimagetype(Imagetype:TImagetype):boolean;
begin
if isimage(imagetype) and not(istransimagetype(imagetype))
then
result:=true
else result:=false;
end;

function isimage(Imagetype:TImagetype):boolean;
begin
if (imagetype=depack.brick) or (imagetype=depack.sprite) or (imagetype=depack.spriraw) or (imagetype=depack.rawS) or (imagetype=depack.rawM) or (imagetype=depack.rawL) or (imagetype=depack.raw)
then
result:=true
else result:=false;
end;

procedure FillWithCorrectData(first,last:DWORD);
var forer:DWORD;
begin
for forer:=first to last do begin
  analyzeentry(forer);
  if packentries[forer].modified then DePack.PackEntry(GetCorrectData(packentries[forer]),packentries[forer],-1,0);
  packentries[forer].modified:=false;
  analyzeentry(forer);
  end;
end;

function GetCorrectData(Entry:TPackentry):ansistring; //try to use FillWithCorrectData instead
begin
case entry.Imagetype of
depack.brick:result:=entry.Image.sparaSPRITE(LICEngine.brick);
depack.sprite: result:=entry.Image.sparaSPRITE;
depack.spriraw: result:=entry.Image.sparaSPRIRAW;
depack.rawdata: result:=Entry.Image.sparaRAW;
depack.palette: result:=Entry.Image.palettetostring;
depack.rawL,depack.rawM,depack.rawS:result:=Entry.Image.sparaRAW;
end;
if not(entry.modified) then result:= unpacktostring(entry);
entry.modsinceanalyze:=true;
end;

procedure analyzeentry(entry:integer=-1);
var
index:integer;
rawresult:             byte;
loadedproperly:boolean;
begin
if entry = -1
then
index:=MainForm.spinedit1.Value
else
index:=entry;

if index>high(packentries) then exit;

if packentries[index].modsinceanalyze=true then begin

if (packentries[index].Imagetype=RawS) or (packentries[index].Imagetype=RawM) or (packentries[index].Imagetype=RawL)
then
packentries[index].Imagetype:=DePack.Raw;

if packentries[index].Imagetype=DePack.raw then begin
rawresult:=packentries[index].Image.laddaRAW(UnpackToString(packentries[index]));
case rawresult of
0: loadedproperly:=false;
1: begin loadedproperly:=true; packentries[index].Imagetype:=rawS;end;
2: begin loadedproperly:=true; packentries[index].Imagetype:=rawM;end;
3: begin loadedproperly:=true; packentries[index].Imagetype:=rawL;end;
end;
end;

if packentries[index].Imagetype=spriraw then
loadedproperly:=packentries[index].Image.laddaSPRIRAW(UnpackToString(packentries[index]));

if packentries[index].Imagetype=depack.sprite then
loadedproperly:=packentries[index].Image.laddaSPRITE(UnpackToString(packentries[index]));

if packentries[index].Imagetype=depack.brick then
loadedproperly:=packentries[index].Image.laddaSPRITE(UnpackToString(packentries[index]),LICEngine.brick);

if not(loadedproperly) then
  if length(UnpackToString(packentries[index]))=768 then
  begin
    packentries[index].Imagetype:=Depack.palette;
    packentries[index].Image.laddapalett(UnpackToString(packentries[index]));
  end
  else
  begin
    packentries[index].Imagetype:=rawdata;
    packentries[index].Data:=unpacktostring(packentries[index]);
  end;

packentries[index].modsinceanalyze:=false;

end;
//No action will be taken if no modification has happend since last analyze
end;

procedure showimage(entry:integer=-1);
var
index:integer;
begin
if entry = -1
then
index:=MainForm.spinedit1.Value
else
index:=entry;
{$IFDEF Win32}
MainForm.Image1.Picture.Bitmap.FreeImage;
{$ENDIF}


if index>high(packentries) then exit;

if isimage(packentries[index].Imagetype) then begin
//MainForm.Image1.Picture.Bitmap.FreeImage;
//Mainform.Image1.Picture.Clear;
if packentries[index].Image.Height<>0 then
packentries[index].Image.Sparabitmap(MainForm.Image1.Picture.Bitmap);
MainForm.StatusBar1.Panels.Items[5].Text:=inttostr(packentries[index].Image.Width)+'*'+inttostr(packentries[index].Image.Height);
end;

if (packentries[index].Imagetype=Depack.palette) then begin
//MainForm.Image1.Picture.Bitmap.FreeImage;
packentries[index].Image.palettetoimage(MainForm.Image1.Picture.Bitmap);
MainForm.StatusBar1.Panels.Items[5].Text:='';
end;

if (packentries[index].Imagetype=Depack.rawdata) then begin
{$IFDEF Win32}
MainForm.Image1.Picture.Bitmap.FreeImage;
{$ELSE}
MainForm.Image1.Picture.Clear;
{$ENDIF}
MainForm.StatusBar1.Panels.Items[5].Text:='';
end;

MainForm.StatusBar1.Panels.Items[1].Text:='s: '+inttostr(packentries[index].RlSize);

MainForm.StatusBar1.Panels.Items[2].Text:='cs: '+inttostr(packentries[index].CpSize);

case packentries[index].FType of {-3=hidden, -2=blank, -1=normal, >-1=repeated}
-3:MainForm.StatusBar1.Panels.Items[3].Text:='hidden';
-2:MainForm.StatusBar1.Panels.Items[3].Text:='blank';
-1:MainForm.StatusBar1.Panels.Items[3].Text:='normal';
else
MainForm.StatusBar1.Panels.Items[3].Text:='rep. '+inttostr(packentries[index].FType);
end;

MainForm.StatusBar1.Panels.Items[4].Text:=ImageTypetostring(packentries[index].Imagetype);


if istransimagetype(packentries[index].Imagetype) then
MainForm.StatusBar1.Panels.Items[6].Text:=inttostr(packentries[index].Image.Widthoffset)+'*'+inttostr(packentries[index].Image.Heightoffset)
else
MainForm.StatusBar1.Panels.Items[6].Text:='';

lastindex:=index;

MainForm.Image1.Left:=MainForm.LeftPanel.Width+byte(respectoffset)*packentries[index].Image.Widthoffset;
MainForm.Image1.Top:=MainForm.TopPanel.Height+byte(respectoffset)*packentries[index].Image.Heightoffset;

if isimage(packentries[index].Imagetype) then begin
   MainForm.Image1.Height:=packentries[index].Image.Height;
   MainForm.Image1.Width:=packentries[index].Image.Width;
end;

if packentries[index].Imagetype=DePack.palette then begin
   MainForm.Image1.Height:=50;//see LICEngine.TGeneralRaw.palettetoimage why
   MainForm.Image1.Width:=256;
end;
//{$IFDEF Win32}
 MainForm.Image1.Picture.Bitmap.TransparentColor:=1;
//{$ENDIF}
 MainForm.Image1.Refresh;
end;




procedure OpenHQR(plats:TFilename);
var forer   :integer;
lba1pal:boolean;
types:TImagetype;
onlyonepal:boolean=true;
begin

path:=plats;
lba1pal:=true;
types:=DePack.raw;
opened:=true;
Packentries:=Openpackfile(plats);

UnpackAll(Packentries);



if uppercase(extractfilename(plats))='SPRIRAW.HQR' then
begin
 types:=spriraw;
 lba1pal:=false;
end;
if uppercase(extractfilename(plats))='SCREEN.HQR' then
begin
      onlyonepal:=false;
      for forer:=0 to high(Packentries) do begin
  Packentries[forer].Imagetype:=DePack.raw;
  Packentries[forer].modified:=false;
  packentries[forer].modsinceanalyze:=true;
  Packentries[forer].Image :=TLBAImage.create;
  end;

      for forer:=0 to high(Packentries) do begin
          if Packentries[forer].RlSize=307200 then
             if findnextpal(forer)>=0 then
                   packentries[forer].Image.laddapalett(unpacktostring(Packentries[findnextpal(forer,true)]))

      end;


end;
if uppercase(extractfilename(plats))='RESS.HQR' then
begin
 types:=DePack.raw;
 if Packentries[3].Ftype=-2 then     //nr 4 entry in lba2 is blank
 lba1pal:=false
 else begin //LBA1 RESS.HQR has another orientation between image and palettes, due to there is no SCREEN.HQR for LBA1
      lba1pal:=true;
      onlyonepal:=false;
      for forer:=0 to high(Packentries) do begin
  Packentries[forer].Imagetype:=DePack.raw;
  Packentries[forer].modified:=false;
  packentries[forer].modsinceanalyze:=true;
  Packentries[forer].Image :=TLBAImage.create;
  end;

      for forer:=0 to high(Packentries) do begin
          if Packentries[forer].RlSize=65536 then
             if findnextpal(forer)>=0 then
                packentries[forer].Image.laddapalett(unpacktostring(Packentries[findnextpal(forer,false)]));

          if Packentries[forer].RlSize=307200 then
             if findnextpal(forer)>=0 then begin
              //showmessage(inttostr(findnextimage(forer,true))+' '+inttostr(findnextpal(forer,true)));
                if findnextimage(forer,true)>(findnextpal(forer,true)*byte(findnextimage(forer,true)>forer)) then
                   packentries[forer].Image.laddapalett(unpacktostring(Packentries[findnextpal(forer,true)]))
                   else
                   packentries[forer].Image.laddapalett(unpacktostring(Packentries[0])); //assuming the main pal is always @ 0
                end;
          end;
      end;

end;

if uppercase(extractfilename(plats))='SPRITES.HQR' then
begin
 types:=depack.sprite;
 if high(Packentries)>300 then     //lba2 has more entries
 lba1pal:=false
 else
 lba1pal:=true;
end;

if uppercase(extractfilename(plats))='LBA_BRK.HQR' then
begin
 types:=depack.brick;
 lba1pal:=true;
end;

if uppercase(extractfilename(plats))='LBA_BKG.HQR' then
begin
 types:=depack.brick;
 lba1pal:=false;
end;


if uppercase(extractfilename(plats))='HOLOMAP.HQR' then
begin
 types:=DePack.raw;
 lba1pal:=false;
end;


if onlyonepal then
for forer:=0 to length(Packentries)-1 do
begin
  Packentries[forer].Imagetype:=types;
  Packentries[forer].modified:=false;
  packentries[forer].modsinceanalyze:=true;
  Packentries[forer].Image :=TLBAImage.create;


//  if onlyonepal then
  if lba1pal then Packentries[forer].Image.SetLba1Palette
  else  Packentries[forer].Image.SetLba2Palette;
end;

end;
{
function filetostr(plats:TFilename):ansistring;
var
strfil:ansistring;
tmpchar:  char;
filen:  file of char;
begin
strfil:='';
try
assign(filen,plats);
reset(filen);
  while not Eof(filen) do
  begin
    Read(filen, tmpchar);
    strfil:=strfil+tmpchar;
  end;
finally closefile(filen);
result:=strfil;
end;

end;

procedure strtofile(const Data:ansistring;plats:TFilename;autooverwrite:boolean = true);
var
filen :file of char;
forer : integer;
begin
if Fileexists(plats) and not(autooverwrite) then begin
showmessage('File at '+plats+' existed, not overwritten');
exit;
end;
try
assign(filen,plats);
rewrite(filen);
for forer := 1 to length(Data) do
write(filen,Data[forer]);
finally closefile(filen);
end;

end;
}

{ TMainForm }

procedure TMainForm.TopPanelClick(Sender: TObject);
begin

end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
  if Respectoffset then popupmenu1.Items.Items[3].Caption:='Don''t Respect offset'
  else popupmenu1.Items.Items[3].Caption:='Respect offset';
end;

procedure TMainForm.RadioGroup1Click(Sender: TObject);
begin

end;

procedure TMainForm.SpinEdit1Change(Sender: TObject);
begin
  if not(opened) then
  exit;
  if (spinedit1.value<0) or (spinedit1.value>high(packentries))  then
  exit;
  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var FNTemplate :string;
    Index : Integer;
    savepath:TFilename;
    fs                 :TFileStream;
    cs                 :TCompressionStream;
    foldername:        string;

begin


 if not(opened and Optionsform.ToggleBox1.Checked) then exit;

foldername:=ExtractFilePath(paramstr(0))+'AutoSave/';
{$IFDEF Win32}
foldername:=ExtractFilePath(paramstr(0))+'AutoSave\';
{$ENDIF}
if not directoryexists(foldername) then createdir(foldername);

FNTemplate:= '%s'+foldername+copy(extractfilename(path),0,length(extractfilename(path))-length(ExtractFileExt(path)))+'%.3d.LCP';
 Index := -1;
 repeat
  Inc(Index);
  savepath:=Format(FNTemplate, ['', Index]) ;
 until not FileExists(savepath);

 fs:=TFileStream.Create(savepath,fmcreate);
 cs:=TCompressionStream.Create(clfastest,fs);
 packentriestostream(cs);
 cs.Destroy;
 fs.Free;
 caption:=savepath;
end;

procedure TMainForm.ToggleBox1Change(Sender: TObject);
begin

end;

procedure TMainForm.ToggleBox1Click(Sender: TObject);
begin
  if opened then begin
  analyzeentry;
  showimage;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var packagelocation:TFileName;{
str:ansistring;                   }
forer:integer;
begin



  MainForm.width:=640+LeftPanel.Width;
  MainForm.height:=TopPanel.Height+500;

  maximizethedimensionsbool:=false;
  opened:=false;
  tempimage:=TLBAImage.create;

  {for forer:=0 to 255 do begin
  tempimage.Palette[forer].red:=forer;
  tempimage.Palette[forer].green:=forer;
  tempimage.Palette[forer].blue:=forer;
  end;}
  //tempimage.SetLba1Palette;
{                                                         //LIC-project/Tutorialimages
  image1.Picture.LoadFromFile('/home/arash/lion_600.jpg');
  tempimage.laddaBMP(Image1.picture.bitmap,false,true,255,640,480);
  image1.Picture.Clear;
  tempimage.Sparabitmap(image1.picture.Bitmap);
  image1.Picture.SaveToFile('/home/arash/blabla.bmp');
}
{
  Palette.tempimage:=TLBAImage.create;
  Palette.tempbmp:=TBitmap.Create;
}
  if paramcount>0 then
packagelocation:=paramstr(1)
else if (paramcount=0) and fileexists(ExtractFilePath(paramstr(0))+'Recoverysave.LUP') then
packagelocation:=ExtractFilePath(paramstr(0))+'Recoverysave.LUP'
else
if (paramcount=0) and fileexists(ExtractFilePath(paramstr(0))+'afterclosesave.LCP')  then
packagelocation:=ExtractFilePath(paramstr(0))+'afterclosesave.LCP' else
exit;
try
   Openproject(packagelocation);
except
   if Dialogs.MessageDlg('Autoload-Project failed to open','File '+packagelocation+' is corrupt (or doesn''t exist if you specified parameter), do you wan''t to delete it? (recommended)',mtError,mbyesno,0)=mryes
   then begin
        if not sysutils.DeleteFile(packagelocation) then showmessage ('File '+packagelocation+' couldn''t be deleted (perhaps because it doesn''t exist)');
        end;
   end;

{
if fileexists(ExtractFilePath(paramstr(0))+'afterclosesave.LCP') then
if not(sysutils.DeleteFile(ExtractFilePath(paramstr(0))+'afterclosesave.LCP')) then
showmessage('Failed to remove '+ExtractFilePath(paramstr(0))+'afterclosesave.LCP'+'. Note that you are not supposed to run several LIC at once!');
}

end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
  if color =clbtnface then
  color := clblack
  else color:=clbtnface;
end;

procedure TMainForm.FormDestroy(Sender: TObject);

begin
end;

procedure TMainForm.FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin

end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  cs:TCompressionstream;
fs:TFilestream;
ds:TDecompressionStream;
slotfoldername:string;
slotfilename:string;

begin


if opened then begin
if  MainForm.SpinEdit1.Enabled then begin
  if key=VK_LEFT then spinedit1.value:=findnextimage(-1,false);
  if key=vk_right then spinedit1.value:=findnextimage;
  if key=vk_up then if spinedit1.Value=high(packentries) then spinedit1.Value:=0 else spinedit1.Value:=spinedit1.Value+1;
  if key=vk_down then if spinedit1.Value=0 then spinedit1.Value:=high(packentries) else spinedit1.Value:=spinedit1.Value-1;
end;
end;

if (Key>=48) and (Key<=57) then begin
 if (ssctrl in shift) and (ssalt in shift) then begin
    showmessage('DON''T have both alt and ctrl pushed at once!');
    exit;
 end;

 slotfoldername:=ExtractFilePath(paramstr(0))+'SlotSaves/';
{$IFDEF Win32}
slotfoldername:=ExtractFilePath(paramstr(0))+'SlotSaves\';
{$ENDIF}

if not directoryexists(slotfoldername) then createdir(slotfoldername);

slotfilename:=slotfoldername+'Slot'+chr(Key)+'.LCP';

   if ssctrl in shift then begin
    if not(opened) then begin
     showmessage('No project is open');
     exit;
    end;
    fs:= TFilestream.Create(slotfilename,fmcreate);
    cs:= TCompressionStream.Create(cldefault,fs);
    packentriestostream(cs);
    cs.Destroy;
    fs.Free;
   end;
   if ssalt in shift then begin
    if not fileexists(slotfilename) then begin
    showmessage('file '+slotfilename+' doesn''t exist, cannot load slot-save');
    exit;
    end;
    if closeproject then begin
    fs:=TFilestream.Create(slotfilename,fmopenread);
    ds:=TDecompressionStream.Create(fs);
    streamtopackentries(ds);
    fs.free;
    end;
   end;
 end;
  if
  CheckBox1.Checked then begin
  analyzeentry;
  showimage;
  end;
end;



procedure TMainForm.IndexEditChange(Sender: TObject);
begin
  if Checkbox1.Checked then
  begin
  analyzeentry;
  showimage;
  end;
end;

procedure TMainForm.LeftPanelClick(Sender: TObject);
begin

end;

procedure TMainForm.MenuItem10Click(Sender: TObject);
var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  analyzeentry;
  if not istransimagetype(packentries[spinedit1.Value].Imagetype) then begin
  showmessage('Operation not allowed for this type of Image type (only works on spriraw,sprite and bricks)');
  exit;
  end;
    Val(InputBox('Input a valid byte (0..255)','What do you want the new width to be? Note that bytes are (0..255)', inttostr(packentries[spinedit1.Value].Image.Width) ), newvalue, Error);
  if Error then showmessage('not even valid integer')
  else
   if not((newvalue<=255) and (newvalue>0)) then
   begin
    showmessage('value is not between 1 and 255');
    exit
    end
   else
  packentries[spinedit1.Value].Image.newdimensions(newvalue,packentries[spinedit1.Value].Image.height);


     packentries[spinedit1.Value].modified:=true;
     fillwithcorrectdata(spinedit1.Value,spinedit1.Value);
  showimage;


end;

procedure TMainForm.MenuItem11Click(Sender: TObject);
begin
  BitBtn6Click(Sender);
end;

procedure TMainForm.MenuItem12Click(Sender: TObject);
var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  analyzeentry;
  if not istransimagetype(packentries[spinedit1.Value].Imagetype) then begin
  showmessage('Operation not allowed for this type of Image type (only works on spriraw,sprite and bricks)');
  exit;
  end;
    Val(InputBox('Input a valid byte', 'What do you want the new height to be? Note that bytes are (0..255)', inttostr(packentries[spinedit1.Value].Image.height) ), newvalue, Error);
  if Error then showmessage('not even valid integer')
  else
   if not((newvalue<=255) and (newvalue>0)) then
   begin
    showmessage('value is not between 1 and 255');
    exit
    end
   else
  packentries[spinedit1.Value].Image.newdimensions(packentries[spinedit1.Value].Image.Width,newvalue);


     packentries[spinedit1.Value].modified:=true;
     fillwithcorrectdata(spinedit1.Value,spinedit1.Value);
  showimage;


end;

procedure TMainForm.MenuItem13Click(Sender: TObject);
begin
  MainForm.OnDblClick(sender);
end;

procedure TMainForm.MenuItem15Click(Sender: TObject);
begin
  MainForm.width:=640+LeftPanel.Width;
  MainForm.height:=TopPanel.Height+500;
end;

procedure TMainForm.MenuItem16Click(Sender: TObject);
begin
  if Colordialog1.Execute then MainForm.Color:=Colordialog1.Color;
end;

procedure TMainForm.MenuItem17Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

analyzeentry;
  if findnextpal(Mainform.Spinedit1.Value)>=0 then
        packentries[spinedit1.Value].Image.laddapalett(unpacktostring(Packentries[findnextpal(Spinedit1.Value,false)]));

showimage;
end;

procedure TMainForm.MenuItem18Click(Sender: TObject);
begin

        MPImgEditUnit.MPImgEditForm.Show;
end;

procedure TMainForm.MenuItem19Click(Sender: TObject);
begin

        OPImgEditUnit.OPImgEditForm.Show;
end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

analyzeentry;
  if findnextpal(Mainform.Spinedit1.Value)>=0 then
        packentries[spinedit1.Value].Image.laddapalett(unpacktostring(Packentries[findnextpal(Spinedit1.Value)]));

showimage;
end;

procedure TMainForm.MenuItem20Click(Sender: TObject);

  var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
    Val(InputBox('Input a valid number','How many entries do you wanna remove? Starting from entry '+inttostr(spinedit1.value), '0'), newvalue, Error);
  if Error then showmessage('not valid integer')
  else
   if newvalue=0 then

    exit

   else
  removeentries(Spinedit1.Value,newvalue);

  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
try
  SaveDialog1.Filter:='Windows Bitmap Image|*';
if  SaveDialog1.Execute then
  Image1.Picture.SaveToFile(SaveDialog1.FileName);
except
  showmessage('Saving Bitmap Failed');
end;
end;

procedure TMainForm.MenuItem3Click(Sender: TObject);
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

  respectoffset:=not respectoffset;
  if MainForm.CheckBox1.Checked then begin
  analyzeentry;
  showimage;
  end;
end;

procedure TMainForm.MenuItem4Click(Sender: TObject);
begin
end;

procedure TMainForm.MenuItem5Click(Sender: TObject);
var
madeupobject:TObject;
begin
madeupobject:=TObject.create;
maximizethedimensionsbool:=true;
BitBtn6Click(madeupobject);
maximizethedimensionsbool:=false;
madeupobject.destroy;


end;

procedure TMainForm.MenuItem6Click(Sender: TObject);
var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
analyzeentry;
  if not istransimagetype(packentries[spinedit1.Value].Imagetype) then begin
  showmessage('Operation not allowed for this type of Image type (only works on spriraw,sprite and bricks)');
  exit;
  end;
    Val(InputBox('Input a valid byte (0..255)','What do you want the new widthoffset to be? Note that bytes are (0..255)', inttostr(packentries[spinedit1.Value].Image.Widthoffset) ), newvalue, Error);
  if Error then showmessage('not even valid integer')
  else
   if (newvalue>255) or (newvalue<0) then
   begin
    showmessage('value is not between 0 and 255');
    exit
    end
   else
  packentries[spinedit1.Value].Image.Widthoffset:=newvalue;


     packentries[spinedit1.Value].modified:=true;
     fillwithcorrectdata(spinedit1.Value,spinedit1.Value);
  showimage;

end;

procedure TMainForm.MenuItem8Click(Sender: TObject);
var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
analyzeentry;
  if not istransimagetype(packentries[spinedit1.Value].Imagetype) then begin
  showmessage('Operation not allowed for this type of Image type (only works on spriraw,sprite and bricks)');
  exit;
  end;
    Val(InputBox('Input a valid byte', 'What do you want the new heightoffset to be? Note that bytes are (0..255)', inttostr(packentries[spinedit1.Value].Image.heightoffset) ), newvalue, Error);
  if Error then showmessage('not even valid integer')
  else
   if (newvalue>255) or (newvalue<0) then
   begin
    showmessage('value is not between 0 and 255');
    exit
    end
   else
  packentries[spinedit1.Value].Image.heightoffset:=newvalue;


     packentries[spinedit1.Value].modified:=true;
     fillwithcorrectdata(spinedit1.Value,spinedit1.Value);
  showimage;

end;

procedure TMainForm.MenuItem9Click(Sender: TObject);
    var
forer:longword;
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  for forer:=0 to high(Packentries) do begin
    Packentries[forer].modsinceanalyze:=true;
    analyzeentry(forer);
  end;
showimage;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
var fs        :TFileStream;
begin
  If opened and Optionsform.CheckBox2.Checked
  then begin
       fs:=TFileStream.Create(ExtractFilePath(paramstr(0))+'Recoverysave.LUP',fmcreate);
       packentriestostream(fs);
       fs.Free;
  end;
end;

{
function filetopackage(plats:TFilename):TPackentry;
var
   F:     TFilestream;
begin
  F:=TFilestream.Create(plats,fmOpenRead);
  F.Read(result,F.Size);
  F.Free;
end;



procedure packagetofile(const Data:TPackentry;plats:TFilename);
var
   F:     TFilestream;
begin
  F:=TFilestream.Create(plats,fmOpenWrite);
  F.Write(data,sizeof(data));
end;
}

procedure TMainForm.BitBtn7Click(Sender: TObject);
var
packagelocation:string;
//forer:   integer;
begin
  OpenDialog1.Filter:='All supported formats|*.HQR;*.LUP;*.LCP|HQR archive|*.HQR|Uncompressed LIC-project|*.LUP|Compressed LIC-project|*.LCP';
if not(OpenDialog1.Execute) then
exit;
  packagelocation:=OpenDialog1.FileName;

Openproject(packagelocation);

end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
    if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  Paletteform.Show;

end;

procedure TMainForm.BitBtn10Click(Sender: TObject);
var
cs:TCompressionstream;
fs:TFilestream;
begin
    if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  SaveDialog1.DefaultExt:='';
  SaveDialog1.Filter:='High Quality Resource|*.HQR|LBA Image Creator Compressed Project|*LCP|LBA Image Creator Uncompressed Project|*LUP';

if  SaveDialog1.Execute then begin

if Savedialog1.FilterIndex=1 then  begin
showmessage('test');
    if not(uppercase(extractfileext(MainForm.SaveDialog1.FileName))='.HQR') then
       if fileexists(MainForm.SaveDialog1.FileName+'.HQR') then
          if MessageDlg('File '+MainForm.SaveDialog1.FileName+'.HQR'+' already exists, overwrite?',mtwarning,mbyesno,0)=mrno then
             exit
          else MainForm.SaveDialog1.FileName:=MainForm.SaveDialog1.FileName+'.HQR'
       else MainForm.SaveDialog1.FileName:=MainForm.SaveDialog1.FileName+'.HQR';
    Savepacktofile(packentries,SaveDialog1.FileName);
    end;

if Savedialog1.FilterIndex=2 then  begin
    if not(uppercase(extractfileext(MainForm.SaveDialog1.FileName))='.LCP') then
       if fileexists(MainForm.SaveDialog1.FileName+'.LCP') then
          if MessageDlg('File '+MainForm.SaveDialog1.FileName+'.LCP'+' already exists, overwrite?',mtwarning,mbyesno,0)=mrno then
             exit
          else MainForm.SaveDialog1.FileName:=MainForm.SaveDialog1.FileName+'.LCP'
       else MainForm.SaveDialog1.FileName:=MainForm.SaveDialog1.FileName+'.LCP';
    fs:= TFilestream.Create(MainForm.SaveDialog1.FileName,fmcreate);
    cs:= TCompressionStream.Create(clMax,fs);
    packentriestostream(cs);
    cs.Destroy;
    fs.Free;
    end;

if Savedialog1.FilterIndex=3 then  begin
    if not(uppercase(extractfileext(MainForm.SaveDialog1.FileName))='.LUP') then
       if fileexists(MainForm.SaveDialog1.FileName+'.LUP') then
          if MessageDlg('File '+MainForm.SaveDialog1.FileName+'.LUP'+' already exists, overwrite?',mtwarning,mbyesno,0)=mrno then
             exit
          else MainForm.SaveDialog1.FileName:=MainForm.SaveDialog1.FileName+'.LUP'
       else MainForm.SaveDialog1.FileName:=MainForm.SaveDialog1.FileName+'.LUP';
    fs:= TFilestream.Create(MainForm.SaveDialog1.FileName,fmcreate);
    packentriestostream(fs);
    fs.Free;
    end;
end;
end;

procedure TMainForm.BitBtn11Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
    Packentries[Spinedit1.Value].modsinceanalyze:=true;
    analyzeentry;
showimage;
end;

procedure TMainForm.BitBtn12Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  TypeEditForm.show;
end;

procedure TMainForm.BitBtn13Click(Sender: TObject);
begin
  Optionsform.Show;
end;

procedure TMainForm.BitBtn2Click(Sender: TObject);
var
tempimage2:TLBAImage;
begin
      if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
tempimage2:=TLBAImage.Create;
tempimage.SetLba1Palette;
tempimage2.SetLba2Palette;


  analyzeentry;
  if not isimage(Packentries[spinedit1.Value].Imagetype) then
     showmessage('Right click the button and choose what kind of image you wanna input')
  else
     if istransimagetype(Packentries[spinedit1.Value].Imagetype) or ((Packentries[spinedit1.Value].Image.palettetostring=tempimage.palettetostring) or (Packentries[spinedit1.Value].Image.palettetostring=tempimage2.palettetostring))
       then begin
       case Packentries[spinedit1.Value].Imagetype of
        rawS: MPImgEditUnit.MPImgEditForm.ComboBox1.ItemIndex:=3;
        rawL: MPImgEditUnit.MPImgEditForm.ComboBox1.ItemIndex:=4;
        depack.Sprite: MPImgEditUnit.MPImgEditForm.ComboBox1.ItemIndex:=1;
        depack.Brick: MPImgEditUnit.MPImgEditForm.ComboBox1.ItemIndex:=2;
        Spriraw: MPImgEditUnit.MPImgEditForm.ComboBox1.ItemIndex:=0;

       end;
        MPImgEditUnit.MPImgEditForm.Show;
       end
       else begin
       case Packentries[spinedit1.Value].Imagetype of
        rawS: OPImgEditUnit.OPImgEditForm.ComboBox1.ItemIndex:=0;
        rawL: OPImgEditUnit.OPImgEditForm.ComboBox1.ItemIndex:=1;
       end;
        OPImgEditUnit.OPImgEditForm.Show;
       end;

tempimage2.Destroy;

end;

procedure TMainForm.BitBtn3Click(Sender: TObject);
begin
    if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
analyzeentry;
  if isimage(packentries[spinedit1.Value].Imagetype) then
  try
  SaveDialog1.Filter:='Windows Bitmap Image|*';
if  SaveDialog1.Execute then
  Image1.Picture.SaveToFile(SaveDialog1.FileName);
except
  showmessage('Saving Bitmap Failed');
end
else
    showmessage('You can only download the image if it is a image...');
end;

procedure TMainForm.BitBtn4Click(Sender: TObject);
begin
    if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
try
OpenDialog1.Filter:='Raw data|*';
if  OpenDialog1.Execute then begin
depack.PackEntry(loadfile(OpenDialog1.FileName),packentries[spinedit1.Value]);
packentries[spinedit1.Value].modsinceanalyze:=true;
analyzeentry;
showimage;
end;
except
  showmessage('Reading Data Failed, or inserting data failed');
end;
end;

procedure TMainForm.BitBtn5Click(Sender: TObject);
var
fileext   :shortstring;
begin
    if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
analyzeentry;
try
case Packentries[spinedit1.Value].Imagetype of
rawS,rawM,rawL:fileext:='.lim';
depack.Sprite:fileext:='.lsp';
depack.Brick:fileext:='.brk';
Spriraw:fileext:='.lsr';
DePack.palette:fileext:='.pal';
rawdata:fileext:='';
end;



SaveDialog1.DefaultExt:='';
SaveDialog1.Filter:='Raw data|*';
SaveDialog1.FileName:=copy(ExtractFileName(path),1,length(ExtractFileName(path))-length(ExtractFileExt(path)))+inttostr(spinedit1.Value)+fileext;
if  SaveDialog1.Execute then
savefile(SaveDialog1.FileName,Unpacktostring(Packentries[spinedit1.Value]))
except
  showmessage('Saving Data Failed');
end;

end;

procedure TMainForm.BitBtn6Click(Sender: TObject);
var a, b: Integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

  if not isimage(packentries[spinedit1.Value].Imagetype) then begin
  showmessage('You can only edit images, duh :p');
  exit;
  end;

  spinedit1.Enabled:=false;

  if packentries[MainForm.spinedit1.Value].Imagetype=DePack.brick
then
brickmode:=true
else
brickmode:=false;

if sender.ClassNameIs('TMenuItem') then
brickmode:=false;


if not (brickmode)
and istransimagetype(packentries[spinedit1.Value].Imagetype)
and ((packentries[spinedit1.Value].Image.Height+packentries[spinedit1.Value].Image.Heightoffset>255)
or (packentries[spinedit1.Value].Image.Width+packentries[spinedit1.Value].Image.Widthoffset>255))
then showmessage('beware of width or height plus it''s offset makes sums up to a value above 255, make sure your drawing ends up fitting in 255*255 square, other areas should be blank');

  if Editor.EditForm.ShowModal=mrOK then begin
     packentries[spinedit1.Value].Image.data:='';
     packentries[spinedit1.Value].Image.Height:=Editor.bitImage.Height;
     packentries[spinedit1.Value].Image.Width:=Editor.bitImage.Width;
     setlength(packentries[spinedit1.Value].Image.data,packentries[spinedit1.Value].Image.width*packentries[spinedit1.Value].Image.height);
     for b:=0 to Editor.bitImage.Height-1 do
     for a:=0 to Editor.bitImage.Width-1 do
     packentries[spinedit1.Value].Image.data[1+a+packentries[spinedit1.Value].Image.width*b]:=chr(Editor.bitImage.Image[a,b]);
     packentries[spinedit1.Value].Image.Widthoffset:=0;
     packentries[spinedit1.Value].Image.heightoffset:=0;
     if istransimagetype(packentries[spinedit1.Value].Imagetype) then
     packentries[spinedit1.Value].Image.fixdimensions;
     packentries[spinedit1.Value].modified:=true;
     fillwithcorrectdata(spinedit1.Value,spinedit1.Value);
     showimage;
  end;

  spinedit1.Enabled:=true;
if istransimagetype(packentries[spinedit1.Value].ImageType) and ((packentries[spinedit1.Value].Image.Width>255) or (packentries[spinedit1.Value].Image.Height>255)) then
begin
 (MessageDlg('Invalid Image Dimensions','The Width or the Height has been poorly edited, because width or height is above 255. Do you want to go back and edit the Image? (lol sorry but I couldn''t resist :p)',mtwarning,[mbyes,mbok],0));
 Bitbtn6Click(Sender);
end;

end;

procedure TMainForm.BitBtn8Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

  SaveDialog1.DefaultExt:='.HQR';
  SaveDialog1.Filter:='High Quality Resource|*.HQR';
if  SaveDialog1.Execute then
  Savepacktofile(packentries,SaveDialog1.FileName);
end;

procedure TMainForm.BitBtn9Click(Sender: TObject);
begin
  OldSchoolForm.show;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
if MessageDlg('Remove Entry','Are you sure you want to delete the selected entry?',mtconfirmation,mbyesno,0)=mryes
then
removeentries(spinedit1.value);

  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
    Val(InputBox('Input a valid number','How many entries you wanna add after '+inttostr(spinedit1.value)+'?', '0'), newvalue, Error);
  if Error then showmessage('not valid integer')
  else
   if newvalue=0 then

    exit

   else
  addentries(Spinedit1.Value+1,newvalue);

  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
var Error: boolean;
    newvalue:integer;
begin

  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
    Val(InputBox('Input a valid number','How many entries you wanna add before '+inttostr(spinedit1.value)+'?', '0'), newvalue, Error);
  if Error then showmessage('not valid integer')
  else
   if newvalue=0 then

    exit

   else
  addentries(Spinedit1.Value,newvalue);

  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  var
  cs:TCompressionstream;
fs:TFilestream;
begin
if opened and Optionsform.CheckBox1.Checked then begin
    fs:= TFilestream.Create(ExtractFilePath(paramstr(0))+'afterclosesave.LCP',fmcreate);
    cs:= TCompressionStream.Create(clfastest,fs);
    packentriestostream(cs);
    cs.Destroy;
    fs.Free;
if fileexists(ExtractFilePath(paramstr(0))+'Recoverysave.LUP') then
if not sysutils.DeleteFile(ExtractFilePath(paramstr(0))+'Recoverysave.LUP')
then showmessage('deleting temproary file failed: '+ExtractFilePath(paramstr(0))+'Recoverysave.LUP');
end;

{
if fileexists(ExtractFilePath(paramstr(0))+'Recoverysave.LUP') then
if not(sysutils.DeleteFile(ExtractFilePath(paramstr(0))+'Recoverysave.LUP')) then
showmessage('Failed to remove '+ExtractFilePath(paramstr(0))+'Recoverysave.LUP'+'. Note that you are not supposed to run several LIC at once!');
}
end;



initialization
  {$I main.lrs}

end.

