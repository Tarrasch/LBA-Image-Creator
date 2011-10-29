unit Preview;

{$MODE Delphi}

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, LResources,Math;

type

  { TPreviewForm }

  TPreviewForm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PreviewForm: TPreviewForm;
  first: boolean;

implementation

uses OldSchool;


procedure TPreviewForm.FormResize(Sender: TObject);
begin   {
image1.Width:=PreviewForm.Width;
image1.height:=PreviewForm.height;
image1.refresh;  }
end;

procedure TPreviewForm.FormShow(Sender: TObject);
begin
Image1.Picture.Clear;
Image2.Picture.Clear;
  if OldSchoolform.PageControl2.PageIndex=0 then
  Image1.Picture.LoadFromFile(PicFilename)
  else
  Image1.Picture.LoadFromFile(PicFilename);
  Image1.Picture.Bitmap.TransparentColor:=1;
  
  Image1.Refresh;
  
  PreviewForm.Image1.Width:=Image1.Picture.Width;
  PreviewForm.Image1.Height:=Image1.Picture.Height ;
  
  Raw.Sparabitmap(Image2.Picture.Bitmap);
  Image2.Visible:=true;
  Image2.Left:=Image1.Width;
  Image2.Width:=Raw.Width;
  Image2.Height:=Raw.Height;
  
  PreviewForm.clientWidth:=Raw.Width+Image1.Picture.Width;
  PreviewForm.clientHeight:=max(Raw.Height,Image1.Picture.Height);
  Image2.Picture.Bitmap.TransparentColor:=1;
  Image2.Refresh;
  
  

end;

procedure TPreviewForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
Image1.Picture.Clear;
Image2.Picture.Clear;
if first = false then
PreviewForm.Close
else
begin
first:=false;
picture.Clear;
  PreviewForm.clientWidth:=Raw.Width;
  PreviewForm.clientHeight:=Raw.Height;
Raw.Sparabitmap(image1.Picture.Bitmap);

  Image2.Visible:=false;
Image1.Picture.Bitmap.TransparentColor:=1;
image1.Refresh;

end;
end;



initialization
  {$i Preview.lrs}

end.
