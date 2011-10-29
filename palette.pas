//This is now GNU Licensed due to entangling from DePack unit by Zink.     (2007-2007)
//By Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.

unit Palette;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,Main,DePack, LICEngine, Help,
  StdCtrls, Buttons, ExtCtrls, Spin;

type

  { TPaletteform }

  TPaletteform = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioGroup1: TRadioGroup;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  function findnextpal(startvalue:DWord;forwards:boolean =true):Integer;
  procedure loadtemppalette;
  procedure Modifyentries(first,last:DWORD);

var

  Paletteform: TPaletteform;
  Dealwith:DWORD;
  tempimage:TLBAImage;
  tempbmp:TBitmap;
  temppalette:TPalette;
  fromfilepalette:TPalette;
  askbeforedither:boolean;

implementation

{ TPaletteform }
procedure Modifyentries(first,last:DWORD);
var
forer,forer2:DWORD;
byteforer1,byteforer2:byte;
closest:byte;
tmpdistance,closestdistance:longint;
Palettevar:TPalette;
pointto:array [#0..#255] of char;
tmpbmp:TBitmap;
scanfrom:byte; //just 0 or 1
begin

  case Paletteform.RadioGroup1.ItemIndex of
  0: for forer:=first to last do begin
       if Packentries[forer].Imagetype<>DePack.palette then
       Packentries[forer].Image.Palette:=temppalette;
       if Main.istransimagetype(Packentries[forer].Imagetype)
       then
       Packentries[forer].Image.Palette[0].Red:=1;
     end;

  1: for forer:=first to last do begin
       if Packentries[forer].Imagetype=DePack.palette then begin
       Packentries[forer].Image.Palette:=temppalette;
       Packentries[forer].modified:=true;
       end;
     end;

  2: begin
     for forer:=first to last do begin
     if isimage(Packentries[forer].Imagetype) then begin

     if Main.istransimagetype(Packentries[forer].Imagetype)
     then
     temppalette[0].Red:=1
     else
     if (temppalette[0].Red=1) and (temppalette[0].Green=0) and (temppalette[0].Blue=0)
     then temppalette[0].Red:=0;

     tempimage.Palette:=palettevar;  // just so if-statement is valid for next line
     if tempimage.palettetostring<>Main.Packentries[forer].Image.palettetostring then begin
       Palettevar:=Main.Packentries[forer].Image.Palette;
       scanfrom:=0;
       if  Main.istransimagetype(Packentries[forer].Imagetype)
       then begin
       pointto[#0]:=#0;
       scanfrom:=1;
       end;
       for byteforer1:=scanfrom to 255 do begin
       closestdistance:=maxlongint;
         for byteforer2:=255 downto 0 do begin
           tmpdistance:=sqr(Palettevar[byteforer1].Red-temppalette[byteforer2].Red)+sqr(Palettevar[byteforer1].Green-temppalette[byteforer2].Green)+sqr(Palettevar[byteforer1].Blue-temppalette[byteforer2].Blue);
           if tmpdistance<closestdistance then begin
             closest:=byteforer2;
             closestdistance:=tmpdistance;
           end;
         end;
       pointto[char(byteforer1)]:=char(closest);
       end;
       end;
       for forer2:=1 to length(packentries[forer].Image.data) do
         packentries[forer].Image.Data[forer2]:=pointto[packentries[forer].Image.Data[forer2]];
       packentries[forer].Image.Palette:=temppalette;
       packentries[forer].modified:=true;
     end;
     end;
     end;

  3:begin

     if askbeforedither then
     case Dialogs.MessageDlg('Palette Editor','Dithering several images can take quite a long time, do you want to continue? (yestoall = don''t ask again this session)',mtconfirmation,[mbYesToAll,mbyes,mbno],0) of
     mrno: exit;
     mryestoall: askbeforedither:=false;
     end;

       tmpbmp:=TBitmap.Create;
     for forer:=first to last do begin
     if isimage(Packentries[forer].Imagetype) then begin
       packentries[forer].Image.Sparabitmap(tmpbmp);
       packentries[forer].Image.Palette:=temppalette;
       packentries[forer].Image.laddaBMP(tmpbmp,true);
       packentries[forer].modified:=true;
     end;
     end;

       tmpbmp.Destroy;
    end;

end;
Fillwithcorrectdata(first,last);
end;

procedure loadtemppalette;
begin
  if Paletteform.Radiobutton1.Checked then
     begin
     tempimage.SetLba1Palette;
     temppalette:=tempimage.Palette;
     end;

  if Paletteform.Radiobutton2.Checked then
     begin
     tempimage.SetLba2Palette;
     temppalette:=tempimage.Palette;
     end;

  if Paletteform.Radiobutton3.Checked then
     begin
     temppalette:=fromfilepalette;
     end;

  if Paletteform.Radiobutton4.Checked then
     begin
     if Packentries[Paletteform.Spinedit1.Value].Imagetype=DePack.palette then begin
        tempimage.laddapalett(unpacktostring(Packentries[Paletteform.Spinedit1.Value]));
        temppalette:=tempimage.Palette;
        end;
     end;

end;

Function findnextpal(startvalue:DWord;forwards:boolean =true):Integer;
var
atvalue:integer;
begin
  atvalue:=startvalue;
  repeat
  if forwards then
  inc(atvalue)
  else
  dec(atvalue);
  if atvalue=length(Packentries) then atvalue:=0;
  if atvalue=-1 then atvalue:=high(packentries);
  analyzeentry(atvalue);
  until (Packentries[atvalue].Imagetype=DePack.palette) or (atvalue=startvalue);
if atvalue=startvalue then result:=-1 else result:=atvalue;
if packentries[atvalue].Imagetype=DePack.palette then result:=atvalue;
end;

procedure TPaletteform.Button1Click(Sender: TObject);
begin
    MainForm.OpenDialog1.Filter:='Palette file=768B';
if not(MainForm.OpenDialog1.Execute) then
exit;
tempImage.laddapalett(Main.loadfile(MainForm.OpenDialog1.FileName));
tempImage.palettetoimage(Image3.Picture.Bitmap);
fromfilepalette:=tempImage.Palette;
Paletteform.RadioButton3.Checked:=true;
Image3.Refresh;
end;

procedure TPaletteform.Button2Click(Sender: TObject);
begin
if findnextpal(Paletteform.Spinedit1.Value)=-1 then exit
else Paletteform.Spinedit1.Value:=findnextpal(Paletteform.Spinedit1.Value);
 { tempImage.laddapalett(UnpackToString(Packentries[Paletteform.Spinedit1.Value]));
  tempImage.palettetoimage(Paletteform.Image4.Picture.Bitmap);
  Paletteform.RadioButton4.Checked:=true;
  Image4.Refresh;  }

  Paletteform.SpinEdit1Change(sender);
end;

procedure TPaletteform.Button3Click(Sender: TObject);
begin
  Loadtemppalette;
  Modifyentries(Dealwith,Dealwith);
  showimage;
end;

procedure TPaletteform.Button4Click(Sender: TObject);
begin
  Loadtemppalette;
  Modifyentries(0,Spinedit1.MaxValue);
  showimage;
end;

procedure TPaletteform.Button5Click(Sender: TObject);
begin
if Spinedit2.Value<=Spinedit3.Value then begin
  Loadtemppalette;
  Modifyentries(Spinedit2.Value,Spinedit3.Value);
  showimage;
  end
else
  showmessage('From should be less or equal to To -.-');
end;

procedure TPaletteform.Button6Click(Sender: TObject);
begin
if findnextpal(Paletteform.Spinedit1.Value,false)=-1 then exit     //it might as well be still but meh ~.~
else Paletteform.Spinedit1.Value:=findnextpal(Paletteform.Spinedit1.Value,false);
{  tempImage.laddapalett(UnpackToString(Packentries[Paletteform.Spinedit1.Value]));
  tempImage.palettetoimage(Paletteform.Image4.Picture.Bitmap);
  Paletteform.RadioButton4.Checked:=true;
  Image4.Refresh;  }

  Paletteform.SpinEdit1Change(sender);
end;

procedure TPaletteform.Button7Click(Sender: TObject);
begin
form3.Show;
end;

procedure TPaletteform.FormActivate(Sender: TObject);
begin
  if not opened then exit;  {$IFDEF Win32}
  Image4.Picture.Bitmap.FreeImage;
  Image5.Picture.Bitmap.FreeImage;    {$ENDIF}
  Dealwith:=MainForm.SpinEdit1.Value;
  Packentries[Dealwith].Image.palettetoimage(Image5.Picture.Bitmap) ;
  SpinEdit1.MaxValue:=high(Packentries);
  SpinEdit2.MaxValue:=high(Packentries);
  SpinEdit3.MaxValue:=high(Packentries);
  SpinEdit1.Value:=Dealwith;

  label1.Caption:='Palette for entry '+inttostr(Dealwith)+':';
  Button3.Caption:='To '+inttostr(Dealwith);
  if findnextpal(dealwith)>=0 then
  Paletteform.Spinedit1.Value:=findnextpal(Mainform.SpinEdit1.Value);
  Packentries[Spinedit1.Value].Image.palettetoimage(Image4.Picture.Bitmap);
  //Image4.Picture.Bitmap.FreeImage;
  Paletteform.SpinEdit1Change(sender);
  Image5.Refresh;
{
  Image1.Refresh;
  Image2.Refresh;
}

end;

procedure TPaletteform.FormChangeBounds(Sender: TObject);
begin

end;

procedure TPaletteform.FormCreate(Sender: TObject);
begin
  Tempimage:=TLBAImage.create;
  Tempimage.SetLba1Palette;
  Tempimage.palettetoimage(Image1.Picture.Bitmap);
  Tempimage.SetLba2Palette;
  Tempimage.palettetoimage(Image2.Picture.Bitmap);
  Askbeforedither:=true;
end;

procedure TPaletteform.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Main.MainForm.Keydown(Key,shift);
end;



procedure TPaletteform.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#27 then Paletteform.Close;
end;


procedure TPaletteform.SpinEdit1Change(Sender: TObject);
begin
  analyzeentry(Spinedit1.Value);
  if Packentries[Spinedit1.Value].Imagetype=DePack.palette then begin
  tempImage.laddapalett(UnpackToString(Packentries[Spinedit1.Value]));
  tempImage.palettetoimage(Image4.Picture.Bitmap);
  end
  else
  Image4.Picture.clear;
  
  if (sender.ClassType=TSpinedit) or (sender.ClassType=TButton) then
  Paletteform.RadioButton4.Checked:=true;;

  Image4.Refresh;
end;

initialization
  {$I palette.lrs}

end.

