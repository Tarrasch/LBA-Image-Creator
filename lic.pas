//This is now GNU Licensed due to entangling from DePack unit by Zink.
//By Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.

unit LIC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, DePack, MostStuff
  , Buttons, StdCtrls, ExtCtrls, ComCtrls, Spin, ActnList, Menus,virtualkeys , Editor;

type


  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Image1: TImage;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    StatusBar1: TStatusBar;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure IndexEditChange(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox1Click(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }
  end;
{    function filetostr(plats:TFilename):ansistring;
    procedure strtofile(const Data:ansistring;plats:TFilename;autooverwrite:boolean = true); } //this slow shit has been vanished...
    procedure loadpackage(plats:TFilename);  //Never use, instead use Openpackage
    procedure analyzeentry(entry:integer=-1);//nothing visual is done
    procedure showimage(entry:integer=-1);   //visual actions
    procedure Openpackage(plats:TFilename);
    function filetopackage(plats:TFilename):TPackentry;
    procedure packagetofile(const Data:TPackentry;plats:TFilename);
    function GetCorrectData(Entry:TPackentry):ansistring;
    procedure FillWithCorrectData(first,last:DWORD);
    function isimage(Imagetype:TImagetype):boolean;
    function istransimagetype(Imagetype:TImagetype):boolean;
    function isNottransimagetype(Imagetype:TImagetype):boolean;
    procedure SaveFile(const FileName: TFileName;const content: string);
    function LoadFile(const FileName: TFileName): string;
    procedure findnextimage(forwards:boolean =true);
    
var
  Form1: TForm1;
  Opened:boolean;
  Packentries:TPackentries;
  lastindex:integer;
  tempImage:TMainpaletteraw;

implementation

uses Palette;

procedure findnextimage(forwards:boolean =true);
var
startvalue,atvalue:integer;
begin
  startvalue:=Form2.SpinEdit1.Value;
  atvalue:=Form2.Spinedit1.Value;
  repeat
  if forwards then
  inc(atvalue)
  else
  dec(atvalue);
  if atvalue=length(Packentries) then atvalue:=0;
  if atvalue=-1 then atvalue:=high(packentries);
  analyzeentry(atvalue);
  until (isimage(Packentries[atvalue].Imagetype)) or (atvalue=startvalue);
Form2.Spinedit1.Value:=atvalue;
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
  if packentries[forer].modified then packentry(GetCorrectData(packentries[forer]),packentries[forer],-1,0);
  packentries[forer].modified:=false;
  analyzeentry(forer);
  end;
end;

function GetCorrectData(Entry:TPackentry):ansistring;
begin
case entry.Imagetype of
depack.brick:result:=entry.Image.sparaSPRITE(MostStuff.brick);
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
index:=form1.spinedit1.Value
else
index:=entry;


if packentries[index].modsinceanalyze=true then begin

if packentries[index].Imagetype=raw then begin
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
loadedproperly:=packentries[index].Image.laddaSPRITE(UnpackToString(packentries[index]),moststuff.brick);

if not(loadedproperly) then
  if length(UnpackToString(packentries[index]))=768 then
  begin
    packentries[index].Imagetype:=Depack.palette;
    packentries[index].Image.laddapalett(UnpackToString(packentries[index]));
  end
  else
  begin
    packentries[index].Imagetype:=raw;
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
index:=form1.spinedit1.Value
else
index:=entry;

if (packentries[index].Imagetype=spriraw) or (packentries[index].Imagetype=depack.sprite) or (packentries[index].Imagetype=depack.brick) or (packentries[index].Imagetype=depack.rawS) or (packentries[index].Imagetype=depack.rawM) or (packentries[index].Imagetype=depack.rawL) then begin
Form1.Image1.Picture.Bitmap.FreeImage;
packentries[index].Image.Sparabitmap(Form1.Image1.Picture.Bitmap);
Form1.StatusBar1.Panels.Items[5].Text:=inttostr(packentries[index].Image.Width)+'*'+inttostr(packentries[index].Image.Height);
end;

if (packentries[index].Imagetype=Depack.palette) then begin
Form1.Image1.Picture.Bitmap.FreeImage;
packentries[index].Image.palettetoimage(Form1.Image1.Picture.Bitmap);
Form1.StatusBar1.Panels.Items[4].Text:='Palette';
Form1.StatusBar1.Panels.Items[5].Text:='';
end;

if (packentries[index].Imagetype=Depack.raw) then begin
Form1.Image1.Picture.Bitmap.FreeImage;
Form1.StatusBar1.Panels.Items[4].Text:='Other';
Form1.StatusBar1.Panels.Items[5].Text:='';
end;

Form1.StatusBar1.Panels.Items[1].Text:='s: '+inttostr(packentries[index].RlSize);

Form1.StatusBar1.Panels.Items[2].Text:='cs: '+inttostr(packentries[index].CpSize);

case packentries[index].FType of {-3=hidden, -2=blank, -1=normal, >-1=repeated}
-3:Form1.StatusBar1.Panels.Items[3].Text:='hidden';
-2:Form1.StatusBar1.Panels.Items[3].Text:='blank';
-1:Form1.StatusBar1.Panels.Items[3].Text:='normal';
else
Form1.StatusBar1.Panels.Items[3].Text:='rep. '+inttostr(packentries[index].FType);
end;

case packentries[index].Imagetype of
rawS:Form1.StatusBar1.Panels.Items[4].Text:='Small Raw';
rawM:Form1.StatusBar1.Panels.Items[4].Text:='Medium Raw';
rawL:Form1.StatusBar1.Panels.Items[4].Text:='Large Raw';
depack.Sprite:Form1.StatusBar1.Panels.Items[4].Text:='Sprite';
depack.Brick:Form1.StatusBar1.Panels.Items[4].Text:='Brick';
Spriraw:Form1.StatusBar1.Panels.Items[4].Text:='Spriraw';
end;

Form1.StatusBar1.Panels.Items[6].Text:=inttostr(packentries[index].Image.Widthoffset)+'*'+inttostr(packentries[index].Image.Heightoffset);

lastindex:=index;

end;

procedure Openpackage(plats:TFilename);
var
forer:integer;
begin
if opened then
if  MessageDlg('Close current project? All progress will be removed. (unless you saved output HQR)',mtconfirmation,mbyesno,0)=7 then
exit
else begin
for forer:=0 to high(packentries) do
   packentries[forer].Image.destroy;
//dispose(Project);
end;
loadpackage(plats);
end;


procedure loadpackage(plats:TFilename);
var forer   :integer;
lba1pal:boolean;
types:TImagetype;
begin
lba1pal:=true;
types:=raw;
opened:=true;
Packentries:=Openpackfile(plats);
if uppercase(extractfilename(plats))='SPRIRAW.HQR' then
begin
 types:=spriraw;
 lba1pal:=false;
end;
if uppercase(extractfilename(plats))='SCREEN.HQR' then
begin
 types:=raw;
 lba1pal:=false;
end;
if uppercase(extractfilename(plats))='RESS.HQR' then
begin
 types:=raw;
 if Packentries[3].Ftype=-2 then     //nr 4 entry in lba2 is blank
 lba1pal:=false
 else
 lba1pal:=true;
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
 types:=raw;
 lba1pal:=false;
end;


for forer:=0 to length(Packentries)-1 do
begin
  Packentries[forer].Imagetype:=types;
  Packentries[forer].modified:=false;
  packentries[forer].modsinceanalyze:=true;
  
  Packentries[forer].Image :=TMainPaletteRaw.create;
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

{ TForm1 }

procedure TForm1.Panel2Click(Sender: TObject);
begin

end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;
  
end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin

end;

procedure TForm1.ToggleBox1Click(Sender: TObject);
begin
  if opened then begin
  analyzeentry;
  showimage;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  opened:=false;
  tempimage:=TMainpaletteraw.create;
  Palette.tempimage:=TMainpaletteraw.create;
  Palette.tempbmp:=TBitmap.Create;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if key=VK_LEFT then findnextimage(false);
  if key=vk_right then findnextimage;
  if key=vk_up then findnextimage(false);
  if key=vk_down then findnextimage;

end;



procedure TForm1.FormResize(Sender: TObject);
begin
end;

procedure TForm1.IndexEditChange(Sender: TObject);
begin
  if Checkbox1.Checked then
  begin
  analyzeentry;
  showimage;
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
try
  SaveDialog1.Filter:='Windows Bitmap Image|*';
if  SaveDialog1.Execute then
  Image1.Picture.SaveToFile(SaveDialog1.FileName);
except
  showmessage('Saving Bitmap Failed');
end;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  try
SaveDialog1.Filter:='Raw data|*';
if  SaveDialog1.Execute then
savefile(SaveDialog1.FileName,Packentries[spinedit1.Value].Data)
except
  showmessage('Saving Data Failed');
end;
end;


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


procedure TForm1.BitBtn7Click(Sender: TObject);
var
packagelocation:string;
//forer:   integer;
begin
  OpenDialog1.Filter:='High Quality Resource|*.HQR';
if not(OpenDialog1.Execute) then
exit;
  packagelocation:=OpenDialog1.FileName;
  Openpackage(packagelocation);
  spinedit1.Value:=0;
  spinedit1.MaxValue:=high(packentries);
  
  if not(directoryexists(GetCurrentDir+'/tempbyLIC')) then
  mkdir(GetCurrentDir+'/tempbyLIC');

{for forer:=0 to high(packentries) do
begin
    packagetofile(Packentries[forer],GetCurrentDir+'/tempbyLIC/'+inttostr(forer));

end; }
  If Checkbox1.Checked then begin
  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
    if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  Form2.Show;

end;

procedure TForm1.BitBtn10Click(Sender: TObject);    //atm just bullshit
var fs:TFilestream;
    a:^ansistring;
begin
  SaveDialog1.Filter:='Raw data|*';
if  SaveDialog1.Execute then begin
a:=@Packentries;
savefile(Savedialog1.FileName,a^);
end;
end;

procedure TForm1.BitBtn11Click(Sender: TObject);
  var
forer:longword;
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  for forer:=0 to high(Packentries) do
    analyzeentry(forer);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin

end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  try
  SaveDialog1.Filter:='Windows Bitmap Image|*';
if  SaveDialog1.Execute then
  Image1.Picture.SaveToFile(SaveDialog1.FileName);
except
  showmessage('Saving Bitmap Failed');
end;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
try

OpenDialog1.Filter:='Raw data|*';
if  SaveDialog1.Execute then
depack.PackEntry(loadfile(OpenDialog1.FileName),packentries[spinedit1.Value]);
except
  showmessage('Reading Data Failed, or inserting data failes');
end;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
try
SaveDialog1.Filter:='Raw data|*';
if  SaveDialog1.Execute then
savefile(SaveDialog1.FileName,Unpacktostring(Packentries[spinedit1.Value]))
except
  showmessage('Saving Data Failed');
end;

end;

procedure TForm1.BitBtn6Click(Sender: TObject);
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
  
  if Editor.EditForm.ShowModal=mrOK then begin
     packentries[spinedit1.Value].Image.data:='';
     for b:=0 to Editor.bitImage.Height-1 do
     for a:=0 to Editor.bitImage.Width-1 do
     packentries[spinedit1.Value].Image.data:=packentries[spinedit1.Value].Image.data+chr(Editor.bitImage.Image[a,b]);
     packentries[spinedit1.Value].modsinceanalyze:=true;
     fillwithcorrectdata(spinedit1.Value,spinedit1.Value);
     showimage;
  end;
  
  spinedit1.Enabled:=true;

end;

procedure TForm1.BitBtn8Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;
  
  SaveDialog1.Filter:='High Quality Resource|*.HQR';
if  SaveDialog1.Execute then
  Savepacktofile(packentries,SaveDialog1.FileName);
end;

procedure TForm1.BitBtn9Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

  if  MessageDlg('Close current project? All progress will be removed. (unless you saved output HQR)',mtconfirmation,mbyesno,0)=7 then
  exit
  else begin
  opened:=false;

  end;


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not(opened) then begin
  showmessage('No project is open');
  exit;
  end;

  analyzeentry;
  showimage;
  lastindex:=SpinEdit1.Value;
end;



initialization
  {$I lic.lrs}

end.

