unit OPImgEditUnit;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
   Spin, StdCtrls, Buttons,LICEngine,Main,Depack,LazJPEG,
   ExtDlgs,Palette;


type

  { TOPImgEditForm }

  TOPImgEditForm = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    ColorDialog1: TColorDialog;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpinEdit1: TSpinEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  Function StrToHex(s: String): String;
  Function HexToStr(s: String): String;


     const
LBA1paletteend: array[0..47] of byte = (
    $00, $00, $00, $0F, $0F, $0F, $1F, $1F, $1F, $33, $33, $33, $43, $43, $43, $53, $53, $53, $63, $63, $63, $77, $77, $77, $87, $87, $87, $97, $97, $97, $A7, $A7, $A7, $BB, $BB, $BB, $CB, $CB, $CB, $DB, $DB, $DB, $EB, $EB, $EB, $FF, $FF, $FF);
var
  OPImgEditForm: TOPImgEditForm;
  PicFilename   : TFilename;
  Picture       : TPicture;
  Raw,tempimage : TLBAImage;
  dealwith      :Dword;


implementation

{ TOPImgEditForm }

Function StrToHex(s: String): String;
Var i: Integer;
Begin
  Result:='';
  If Length(s)>0 Then
    For i:=1 To Length(s) Do
      Result:=Result+IntToHex(Ord(s[i]),2);
End;

Function HexToStr(s: String): String;
Var i: Integer;
Begin
  Result:=''; i:=1;
  While i<Length(s) Do Begin
    Result:=Result+Chr(StrToIntDef('$'+Copy(s,i,2),0));
    Inc(i,2);
  End;
End;

procedure TOPImgEditForm.SpinEdit1Change(Sender: TObject);
begin
  analyzeentry(Spinedit1.Value);
  if Packentries[Spinedit1.Value].Imagetype=DePack.palette then begin
  tempImage.laddapalett(UnpackToString(Packentries[Spinedit1.Value]));
  tempImage.palettetoimage(Image2.Picture.Bitmap);
  RadioButton2.Checked:=true;
  end
  {$IFDEF Win32}
  else

  Image2.Picture.Bitmap.FreeImage;


  {$ELSE}
  ;
    {$ENDIF}
  Image2.Refresh;
end;

procedure TOPImgEditForm.Edit1Change(Sender: TObject);
var forer:integer;
pointto:array [#0..#255] of char;
temp:char;

begin
  try
  Image1.Picture.Clear;  {
  {$IFDEF Win32}
     Image1.Picture.Bitmap.FreeImage;
  {$ENDIF}                }
       if fileexists (Edit1.Text) and (Combobox1.ItemIndex<>-1) then begin
         PicFilename:=Edit1.Text;
         Picture.LoadFromFile(PicFilename);


         if (length(Edit3.Text) div 6)>0 then begin
         //Fix the palette, initially put in the end
         for forer:=0 to length(Edit3.Text) div 6-1 do
             move(hextostr(copy(Edit3.Text,forer*6+1,6))[1],raw.Palette[255-length(Edit3.Text) div 6+1+forer],3);
         end;
         case ComboBox1.ItemIndex of
          0: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,true,255-length(Edit3.Text) div 6,256,256);
          1: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,true,255-length(Edit3.Text) div 6,640,480);
         end;
         //Put palette entries back in order...

         if (length(Edit3.Text) div 6)>0 then begin

         for forer:=0 to 255 do begin
         pointto[char(forer)]:=char(forer);
         if forer in [255-length(Edit3.Text) div 6+1..255]
         then begin
         temp:=pointto[char(strtoint(edit4.Text)+forer-(255-length(Edit3.Text) div 6+1))];
         pointto[char(strtoint(edit4.Text)+forer-(255-length(Edit3.Text) div 6+1))]:=pointto[char(forer)];
         pointto[char(forer)]:=temp;
         end;
         end;

         For forer:=0 to length(raw.Data)-1 do
         raw.Data[forer]:=pointto[raw.Data[forer]];

         move(raw.Palette[strtoint(Edit4.Text)],raw.Palette[255-length(Edit3.Text) div 6+1],length(Edit3.Text) div 2);
         
         for forer:=0 to length(Edit3.Text) div 6-1 do
             move(hextostr(copy(Edit3.Text,forer*6+1,6))[1],raw.Palette[strtoint(edit4.Text)+forer],3);


         end;
         

         
         Raw.Sparabitmap(Image1.Picture.Bitmap);
           Image1.Picture.Bitmap.TransparentColor:=1;
       end;
  except
    showmessage('some error occured, check all indata');
  end;
end;

procedure TOPImgEditForm.Button3Click(Sender: TObject);
begin
if (dealwith=spinedit1.Value) and (RadioButton2.Checked) then begin
showmessage('You seem to want entry '+inttostr(dealwith)+' for the image AND the palette. Nauhgty! (no change has been done)');
exit;
end;
           case ComboBox1.ItemIndex of
          0:Main.Packentries[Dealwith].Imagetype:=Depack.RawS;
          1:Main.Packentries[Dealwith].Imagetype:=Depack.RawL;
         end;

  move(raw.Height,Main.Packentries[Dealwith].Image.Height,(16+768));
  Main.Packentries[Dealwith].Image.Data:=raw.Data;
  Main.Packentries[Dealwith].modified:=true;
  Main.FillWithCorrectData(Dealwith,Dealwith);

//palette part:

if RadioButton1.Checked then SaveFile(Edit2.Text,Raw.palettetostring);
if RadioButton2.Checked then begin
  Main.Packentries[SpinEdit1.Value].ImageType:=DePack.palette;
  Main.Packentries[SpinEdit1.Value].Image.Palette:=Raw.Palette;
  Main.Packentries[SpinEdit1.Value].modified:=true;
  Main.FillWithCorrectData(SpinEdit1.Value,SpinEdit1.Value);
end;
showimage;
end;

procedure TOPImgEditForm.Button4Click(Sender: TObject);
begin
Main.MainForm.SaveDialog1.DefaultExt:='.pal';
Main.MainForm.SaveDialog1.Filter:='768B Palette file|*';
Main.MainForm.SaveDialog1.FileName:=copy(ExtractFileName(path),1,length(ExtractFileName(path))-length(ExtractFileExt(path)))+inttostr(Mainform.spinedit1.Value)+'''s.pal';
if  Main.MainForm.SaveDialog1.Execute then;
Edit2.Text:=Main.MainForm.SaveDialog1.FileName;
end;

procedure TOPImgEditForm.Button5Click(Sender: TObject);
begin
  Edit4.Text:=inttostr(0);
  Edit3.Text:='';

  OPImgEditForm.Edit1Change(Sender);
end;


procedure TOPImgEditForm.Button6Click(Sender: TObject);
begin
  if findnextpal(Spinedit1.Value,false)=-1 then exit
else Spinedit1.Value:=findnextpal(Spinedit1.Value,false);
SpinEdit1Change(sender);
 { tempImage.laddapalett(UnpackToString(Packentries[Spinedit1.Value]));
  tempImage.palettetoimage(Image2.Picture.Bitmap);
  RadioButton2.Checked:=true;
  Image2.Refresh;   }
end;

procedure TOPImgEditForm.Button7Click(Sender: TObject);
var
tempstr:string;
begin
  Edit4.Text:='239';
  tempstr:='';
  setlength(tempstr,48);
  move(LBA1paletteend[0],tempstr[1],48);
  Edit3.Text:=strtohex(tempstr);

  OPImgEditForm.Edit1Change(Sender);
end;

procedure TOPImgEditForm.Button8Click(Sender: TObject);
var final:string;
    forer:dword;
    r0,r,g0,g,b0,b:byte;
begin
  Colordialog1.Title:='Select darkest gradient';
     if not
  Colordialog1.Execute then
  exit;
  r0:=Colordialog1.Color and $FF;
  g0:=Colordialog1.Color shr 8 and $FF;
  b0:=Colordialog1.Color shr 16 and $FF;

  Colordialog1.Title:='Select lightest gradient';
        if not
  Colordialog1.Execute then
  exit;
  r:=Colordialog1.Color and $FF;
  g:=Colordialog1.Color shr 8 and $FF;
  b:=Colordialog1.Color shr 16 and $FF;
  
  setlength(final,39);
  for forer:=0 to 12 do begin
      final[3*forer+1]:=char(r0+round((r-r0)/12*forer));
      final[3*forer+2]:=char(g0+round((g-g0)/12*forer));
      final[3*forer+3]:=char(b0+round((b-b0)/12*forer));
  end;

  Edit3.Text:=strtohex(final);
  Edit4.Text:='192';

  OPImgEditForm.Edit1Change(Sender);
end;

procedure TOPImgEditForm.Button9Click(Sender: TObject);
var
   forer:dword;
   ms:Tmemorystream;
   
begin
try
showmessage(inttostr(Image3.Picture.Bitmap.Canvas.TextHeight('testttttttt')));
showmessage(inttostr(Image3.Picture.Bitmap.Canvas.TextWidth('testttttttt')));
  Image3.Picture.Clear;
  
  for forer:=0 to length(Edit3.Text) div 6-1 do
      begin
  Image3.Picture.Bitmap.Canvas.Font.Color:=0;
  Image3.Picture.Bitmap.Canvas.Font.Color:=
  byte(HexToStr(Copy(Edit3.Text,forer*6+1,2))[1])
  +byte(HexToStr(Copy(Edit3.Text,forer*6+3,2))[1]) shl 8
  +byte(HexToStr(Copy(Edit3.Text,forer*6+5,2))[1]) shl 16;

  
  Image3.Picture.Bitmap.Canvas.TextOut(10+forer*10,1,'X');

  Image3.Picture.Bitmap.Canvas.Changed;

  ms:=TMemoryStream.Create;
  Image3.Picture.Bitmap.SaveToStream(ms);
  Image3.Picture.Bitmap.LoadFromStream(ms);
  ms.Free;

  self.Refresh;
  Image3.Refresh;
  end;
except
showmessage('sumthing went wrong...');
end;
end;

procedure TOPImgEditForm.CheckBox1Change(Sender: TObject);
begin

  OPImgEditForm.Edit1Change(Sender);
end;

procedure TOPImgEditForm.ComboBox1Change(Sender: TObject);
begin

  OPImgEditForm.Edit1Change(Sender);
end;

procedure TOPImgEditForm.Button2Click(Sender: TObject);
begin
  if findnextpal(Spinedit1.Value)=-1 then exit
else Spinedit1.Value:=findnextpal(Spinedit1.Value);
SpinEdit1Change(sender);
 { tempImage.laddapalett(UnpackToString(Packentries[Spinedit1.Value]));
  tempImage.palettetoimage(Image2.Picture.Bitmap);
  RadioButton2.Checked:=true;
  Image2.Refresh;                 }
end;

procedure TOPImgEditForm.Button1Click(Sender: TObject);
begin
  If OpenPictureDialog1.Execute
    then Edit1.Text:=OpenPictureDialog1.FileName;
end;

procedure TOPImgEditForm.BitBtn1Click(Sender: TObject);
begin
  Edit4.ReadOnly:=not Edit3.ReadOnly;
  Edit3.ReadOnly:=not Edit3.ReadOnly;
end;

procedure TOPImgEditForm.FormActivate(Sender: TObject);
var
start, stop:DWORD;
begin
  Dealwith:=Mainform.SpinEdit1.Value;
  Button3.Caption:='Insert this image to entry '+inttostr(Dealwith);
  SpinEdit1.MaxValue:=high(Packentries);
  if findnextpal(0)>-1 then begin
  start:=findnextpal(dealwith);
  stop:=start;
  repeat
  stop:=findnextpal(stop);
  until (Packentries[stop].Image.palettetostring=Packentries[dealwith].Image.palettetostring) or (start=stop)
  end
  else
  stop:=dealwith;

  SpinEdit1.Value:=stop;
  SpinEdit1Change(sender);

end;

procedure TOPImgEditForm.FormCreate(Sender: TObject);
begin
Raw:=TLBAImage.create;
Picture:=TPicture.Create;
tempimage:=TLBAImage.create;
end;

procedure TOPImgEditForm.FormKeyPress(Sender: TObject; var Key: char);
begin

  if key=#27 then self.Close;
end;

procedure TOPImgEditForm.FormResize(Sender: TObject);
begin

  Edit1.Width:=Button1.Left-54;
  Edit2.Width:=Button4.Left-54;
  Edit3.Width:=self.Width-edit3.Left-20;
end;

initialization
  {$I opimgeditunit.lrs}

end.

