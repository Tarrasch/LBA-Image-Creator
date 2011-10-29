unit MPImgEditUnit;

{$mode objfpc}{$H+}

interface

{$Define UserHasImageMagick}
uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtDlgs
  {$IFDEF UserHasImageMagick} ,ImageConverter{$ENDIF}, StdCtrls, Buttons,
  ExtCtrls;

type

  { TMPImgEditForm }

  TMPImgEditForm = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  MPImgEditForm: TMPImgEditForm;
  PicFilename   : TFilename;
implementation

{ TMPImgEditForm }

procedure TMPImgEditForm.Button1Click(Sender: TObject);
begin
  If OpenPictureDialog1.Execute
    then Edit1.Text:=OpenPictureDialog1.FileName;
end;

initialization
  {$I transimageunit.lrs}

end.

