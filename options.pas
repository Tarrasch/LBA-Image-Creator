unit Options;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls, Main;

type

  { TOptionsForm }

  TOptionsForm = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    ToggleBox1: TToggleBox;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  OptionsForm: TOptionsForm;

implementation

{ TOptionsForm }

procedure TOptionsForm.Button1Click(Sender: TObject);
var Error: boolean;
    seconds:integer;
begin
    Val(InputBox('Input a valid integer', 'How often in seconds do you want the auto save to occur?', Edit1.Text ), seconds, Error);
  if Error then StatusBar1.SimpleText:='only numbers ...mmmkay?'
  else
  begin
  if seconds<61 then
  if MessageDlg('perhaps less than a minute is a bit too low, please take in account that when you deal with large packages the the autosaves can take much disk space, do you want to continue anyway?', mtwarning, mbyesno,0)=mrno
  then begin
  StatusBar1.SimpleText:='Assigning aborted';
  exit;
  end;
  Edit1.Text:=inttostr(seconds);
  StatusBar1.SimpleText:='Value Succesfully assigned to '+Edit1.Text;
  Mainform.Timer1.Interval:=seconds*1000;
  end;

end;

initialization
  {$I options.lrs}

end.

