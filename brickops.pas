//This is now GNU Licensed due to entangling from DePack unit by Zink.     (2007-2007)
//By Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.


unit Brickops;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ColorBox;

type

  { TForm4 }

  TForm4 = class(TForm)
    cbAddF: TCheckBox;
    cbBackF: TCheckBox;
    cbCoverBack: TCheckBox;
    cbFrontF: TCheckBox;
    cbGrid: TCheckBox;
    cbFrontC: TColorBox;
    cbBackC: TColorBox;
    Label4: TLabel;
    Label5: TLabel;
    procedure cbAddFChange(Sender: TObject);
    procedure cbBackCChange(Sender: TObject);
    procedure cbBackFChange(Sender: TObject);
    procedure cbCoverBackChange(Sender: TObject);
    procedure cbFrontCChange(Sender: TObject);
    procedure cbFrontFChange(Sender: TObject);
    procedure cbGridChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form4: TForm4; 

implementation
 uses editor;
{ TForm4 }



procedure TForm4.cbFrontCChange(Sender: TObject);
var IdentMapEntry:TIdentMapEntry;
begin
IdentEntry(cbFrontC.ItemIndex,IdentMapEntry);
  cbFrontC.Color:=IdentMapEntry.Value;

 Editor.RepaintImage;
end;

procedure TForm4.cbFrontFChange(Sender: TObject);
begin

 RepaintImage;
end;

procedure TForm4.cbGridChange(Sender: TObject);
begin

 RepaintImage;
end;

procedure TForm4.cbBackCChange(Sender: TObject);
var IdentMapEntry:TIdentMapEntry;
begin
IdentEntry(cbBackC.ItemIndex,IdentMapEntry);
  cbBackC.Color:=IdentMapEntry.Value;
  
  Editor.RepaintImage;
end;

procedure TForm4.cbAddFChange(Sender: TObject);
begin

 RepaintImage;
end;

procedure TForm4.cbBackFChange(Sender: TObject);
begin

 RepaintImage;
end;

procedure TForm4.cbCoverBackChange(Sender: TObject);
begin

 RepaintImage;
end;



procedure TForm4.FormKeyPress(Sender: TObject; var Key: char);
begin

    if key=#27 then Self.Close;
end;

initialization
  {$I brickops.lrs}

end.

