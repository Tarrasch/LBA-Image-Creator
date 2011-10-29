unit OldSchool;

{$MODE Delphi}

//{$Define UserHasImageMagick}
interface

uses
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, LICEngine, StdCtrls, ComCtrls,  ExtDlgs, ExtCtrls,
  LResources,Buttons
  {$IFDEF UserHasImageMagick} ,ImageConverter{$ENDIF},LazJPEG ;

type

  { TOldSchoolForm }

  TOldSchoolForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    EditLoadEgenImage: TEdit;
    EditLoadMainImage: TEdit;
    EditLoadMainPalette: TEdit;
    EditSaveEgenImage: TEdit;
    EditSaveEgenPalette: TEdit;
    EditSaveMainImage: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    PageControl2: TPageControl;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    OpenPictureDialog1: TOpenPictureDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;







var
  OldSchoolForm: TOldSchoolForm;
  bmp:TBitmap;    //for the preview,partially
  Picture :TPicture;  //for the preview
  Raw  :TLBAImage;
  PicFilename:TFileName;

implementation

uses Preview,Main;







procedure TOldSchoolForm.Button4Click(Sender: TObject);
begin
if not SaveDialog1.Execute then exit;
EditSaveEgenImage.Text:=SaveDialog1.Filename;
end;

procedure TOldSchoolForm.FormCreate(Sender: TObject);
begin
  bmp:=TBitmap.Create;
  Picture:=TPicture.Create;
  Raw:=TLBAImage.create;
end;

procedure TOldSchoolForm.Button5Click(Sender: TObject);
begin
if not SaveDialog1.Execute then exit;
EditSaveEgenPalette.Text:=SaveDialog1.Filename;
end;

procedure TOldSchoolForm.Button7Click(Sender: TObject);
begin
if not OpenDialog1.Execute then exit;
EditLoadMainPalette.Text:=OpenDialog1.FileName;
end;

procedure TOldSchoolForm.Button6Click(Sender: TObject);
begin
if not OpenPictureDialog1.Execute then exit;
EditLoadMainImage.Text:=OpenPictureDialog1.FileName;
end;

procedure TOldSchoolForm.Button8Click(Sender: TObject);
begin
if not SaveDialog1.Execute then exit;
EditSaveMainImage.Text:=Savedialog1.FileName;
end;

procedure TOldSchoolForm.Button3Click(Sender: TObject);
begin
try
  case Radiogroup2.ItemIndex of
  0: Raw.SetLba1Palette;
  1: Raw.SetLba2Palette;
  2: Raw.laddapalett(Loadfile(EditLoadMainPalette.Text));
  end;
  {$IFDEF UserHasImageMagick}
  ImageConverter.Convert(EditLoadMainImage.Text,'tmpimage.bmp');
  PicFilename:='tmpimage.bmp';
  {$ELSE}
  PicFilename:=EditLoadMainImage.Text;
  {$ENDIF}
  Picture.LoadFromFile(PicFilename);
  
  case Radiogroup1.ItemIndex of
  0: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked);
  1: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked);
  2: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked,false,640,480);
  3: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked,false,512,256);
  4: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked,false,256,256);
  end;
  case Radiogroup1.ItemIndex of
  0:Main.SaveFile(EditSaveMainImage.Text,Raw.sparaSPRITE);
  1:Main.SaveFile(EditSaveMainImage.Text,Raw.sparaSPRIRAW);
  else
  Main.SaveFile(EditSaveMainImage.Text,Raw.sparaRAW);
  end;

Picture.LoadFromFile(PicFilename);

PreviewForm.image1.picture:=Picture;
preview.first:=true;

PreviewForm.show;

except
  showmessage('Some error occured');
end;

//raw.Sparabitmap(bmp);



end;

procedure TOldSchoolForm.Button2Click(Sender: TObject);
begin
try

  {$IFDEF UserHasImageMagick}
  ImageConverter.Convert(EditLoadEgenImage.Text,'tmpimage.bmp');
  PicFilename:='tmpimage.bmp';
  {$ELSE}
  PicFilename:=EditLoadEgenImage.Text;
  {$ENDIF}

  Picture.LoadFromFile(PicFilename);

  case Radiogroup3.ItemIndex of
  0: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked,true,255,640,480);
  1: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked,true,255,512,256);
  2: Raw.laddaBMP(Picture.Bitmap,OldSchoolForm.CheckBox1.Checked,true,255,256,256);
  end;
  
   Main.SaveFile(EditSaveEgenImage.Text,Raw.sparaRAW);
   Main.SaveFile(EditSaveEgenPalette.Text,Raw.palettetostring);
  

Picture.LoadFromFile(PicFilename);

PreviewForm.image1.picture:=Picture;
preview.first:=true;

PreviewForm.show;
  
except
  showmessage('Some error occured');
end;

//raw.Sparabitmap(bmp);





end;

procedure TOldSchoolForm.Button9Click(Sender: TObject);
begin
OpenDialog1.Execute;
EditLoadMainImage.Text:=OpenDialog1.FileName;
end;

procedure TOldSchoolForm.Button1Click(Sender: TObject);
begin
if not OpenpictureDialog1.Execute  then exit;
EditloadEgenimage.Text:=openpicturedialog1.FileName;
end;

procedure TOldSchoolForm.Button10Click(Sender: TObject);
begin

OpenDialog1.Execute;
EditloadEgenimage.Text:=opendialog1.FileName;
end;


initialization
  {$i OldSchool.lrs}

end.
