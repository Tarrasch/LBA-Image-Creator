unit Help;     //just window with text that is informative

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Memo1: TMemo;
    procedure Memo1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3; 

implementation

{ TForm3 }

procedure TForm3.Memo1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#27 then form3.Close;
end;

initialization
  {$I help.lrs}

end.

