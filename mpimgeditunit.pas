unit MPImgEditUnit;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtDlgs, StdCtrls, Buttons,LICEngine,LazJPEG,
  ExtCtrls,Main,DePack;

type

  { TMPImgEditForm }

  TMPImgEditForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  MPImgEditForm: TMPImgEditForm;
  PicFilename   : TFilename;
  Picture           : TPicture;
  Raw           : TLBAImage;
  dealwith      :Dword;
implementation

{ TMPImgEditForm }

procedure TMPImgEditForm.Button1Click(Sender: TObject);
begin
  If OpenPictureDialog1.Execute
    then Edit1.Text:=OpenPictureDialog1.FileName;
end;

procedure TMPImgEditForm.Button2Click(Sender: TObject);
var
dimensionlimited:boolean;
begin
dimensionlimited:=false;
         case ComboBox1.ItemIndex of
          0:dimensionlimited:=true;
          1:dimensionlimited:=true;
          2:dimensionlimited:=true;
         end;
if (dimensionlimited) and ((raw.Width>255) or (raw.Height>255))
then begin
showmessage('Invalid dimensions...  width/height should be less than 256');
exit;
end;
         case ComboBox1.ItemIndex of
          0:Main.Packentries[Dealwith].Imagetype:=Depack.spriraw;
          1:Main.Packentries[Dealwith].Imagetype:=Depack.sprite;
          2:Main.Packentries[Dealwith].Imagetype:=Depack.brick;
          3:Main.Packentries[Dealwith].Imagetype:=Depack.RawS;
          4:Main.Packentries[Dealwith].Imagetype:=Depack.RawL;
         end;

  move(raw.Height,Main.Packentries[Dealwith].Image.Height,(16+768));
  Main.Packentries[Dealwith].Image.Data:=raw.Data;
  Main.Packentries[Dealwith].modified:=true;
  Main.FillWithCorrectData(Dealwith,Dealwith);
  
showimage;
end;

procedure TMPImgEditForm.CheckBox1Change(Sender: TObject);
begin
  MPImgEditForm.Edit1Change(Sender);
end;

procedure TMPImgEditForm.ComboBox1Change(Sender: TObject);
begin
  MPImgEditForm.Edit1Change(Sender);
end;

procedure TMPImgEditForm.Edit1Change(Sender: TObject);
begin
  try
//     Image1.Picture.Clear;
       if fileexists (Edit1.Text) then begin
         PicFilename:=Edit1.Text;
         Picture.LoadFromFile(PicFilename);
         
         case ComboBox1.ItemIndex of
          0: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,false, 255,0,0,CheckBox2.Checked);
          1: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,false, 255,0,0,CheckBox2.Checked);
          2: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,false, 255,0,0,CheckBox2.Checked);
          3: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,false, 255,256,256);
          4: Raw.laddaBMP(Picture.Bitmap,CheckBox1.Checked,false, 255,640,480);
         end;
         Raw.Sparabitmap(Image1.Picture.Bitmap);
           Image1.Picture.Bitmap.TransparentColor:=1;
       end;
  except
    showmessage(' some error occured, probably the image wasn''t a bmp,jpeg or png');
  end;
end;

procedure TMPImgEditForm.FormActivate(Sender: TObject);
begin
  Dealwith:=Mainform.SpinEdit1.Value;
  Button2.Caption:='Insert this image to entry '+inttostr(Dealwith);
  Button2.Refresh;
  Raw.Palette:=Main.Packentries[Dealwith].Image.Palette;
end;

procedure TMPImgEditForm.FormCreate(Sender: TObject);
begin
  Raw:=TLBAImage.create;
  Picture:=TPicture.Create;
end;

procedure TMPImgEditForm.FormKeyPress(Sender: TObject; var Key: char);
begin

  if key=#27 then Self.Close;
end;

procedure TMPImgEditForm.FormResize(Sender: TObject);
begin
  Edit1.Width:=Button1.Left-54;
end;

initialization
  {$I mpimgeditunit.lrs}

end.

