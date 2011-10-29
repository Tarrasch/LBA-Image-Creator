//This is now GNU Licensed due to entangling from DePack unit by Zink.  (2007-2007)
//By Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.

unit Typeeditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Main,
  StdCtrls, Buttons, Spin,DePack, ExtCtrls;

type

  { TTypeEditForm }

  TTypeEditForm = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end; 
  procedure Modifyentries(first,last:DWORD);


var
  TypeEditForm : TTypeEditForm;
  dealwith     : Word;
  TempImagetype: TImagetype;
implementation

{ TTypeEditForm }
procedure Modifyentries(first,last:DWORD);
var
forer :DWORD;
begin
  if TypeEditForm.Radiobutton2.Checked then
    for forer:=first to last do begin
        analyzeentry(forer);
        if packentries[forer].Imagetype=RawData then begin packentries[forer].Imagetype:=depack.spriraw  ;
        packentries[forer].modsinceanalyze:=true;
        analyzeentry(forer);
        if packentries[forer].Imagetype=RawData then begin packentries[forer].Imagetype:=depack.sprite   ;
        packentries[forer].modsinceanalyze:=true;
        analyzeentry(forer);
        if packentries[forer].Imagetype=RawData then begin packentries[forer].Imagetype:=depack.raw   ;
        packentries[forer].modsinceanalyze:=true;
        analyzeentry(forer);
        if packentries[forer].Imagetype=RawData then begin packentries[forer].Imagetype:=depack.brick   ;
        packentries[forer].modsinceanalyze:=true;
        analyzeentry(forer);; end;end;end;end;
    end;
    
   if TypeEditForm.Radiobutton1.Checked then begin
      case TypeEditForm.ComboBox1.ItemIndex of
           0:TempImagetype:=DePack.spriraw;
           1:TempImagetype:=DePack.sprite;
           2:TempImagetype:=DePack.raw;
           3:TempImagetype:=DePack.brick;
           4:TempImagetype:=DePack.rawdata;
      end;
      for forer:=first to last do begin
          packentries[forer].modsinceanalyze:=true;
          if not TypeEditForm.CheckBox1.Checked then
             packentries[forer].Imagetype:=TempImagetype
          else
             if packentries[forer].Imagetype=RawData then
                packentries[forer].Imagetype:=TempImagetype;
          analyzeentry(forer);
          if TempImagetype=DePack.rawdata
             then packentries[forer].Imagetype:=DePack.rawdata;
      end;
   end;
        
        
end;

procedure TTypeEditForm.FormActivate(Sender: TObject);
begin
    if not opened then exit;
  Dealwith:=MainForm.SpinEdit1.Value;
  SpinEdit2.MaxValue:=high(Packentries);
  SpinEdit3.MaxValue:=high(Packentries);
  analyzeentry;
  label1.Caption:='Type for entry '+inttostr(Dealwith)+': '+Imagetypetostring(packentries[Dealwith].Imagetype);
  Button3.Caption:='To '+inttostr(Dealwith);
end;

procedure TTypeEditForm.FormKeyPress(Sender: TObject; var Key: char);
begin
      if key=#27 then Self.Close;
end;

procedure TTypeEditForm.Button3Click(Sender: TObject);
begin
  Modifyentries(Dealwith,Dealwith);
  showimage;
end;

procedure TTypeEditForm.Button1Click(Sender: TObject);
var
forer:DWord;
statistics: array[DePack.TImagetype] of DWord;
begin
for forer:=0 to 8 do
 statistics[TImagetype(forer)]:=0;

  for forer:=0 to high(Packentries) do
  inc(statistics[packentries[forer].Imagetype]);
  
Label13.Caption:=ImageTypetostring(RawData)+': '+inttostr(statistics[RawData]);
Label5.Caption:=ImageTypetostring(spriraw)+': '+inttostr(statistics[spriraw]);
Label6.Caption:=ImageTypetostring(sprite)+': '+inttostr(statistics[sprite]);
Label7.Caption:=ImageTypetostring(raw)+': '+inttostr(statistics[raw]);
Label8.Caption:=ImageTypetostring(brick)+': '+inttostr(statistics[brick]);
Label9.Caption:=ImageTypetostring(palette)+': '+inttostr(statistics[palette]);
Label10.Caption:=ImageTypetostring(rawS)+': '+inttostr(statistics[rawS]);
Label11.Caption:=ImageTypetostring(rawM)+': '+inttostr(statistics[rawM]);
Label12.Caption:=ImageTypetostring(rawL)+': '+inttostr(statistics[rawL]);
  
end;

procedure TTypeEditForm.Button4Click(Sender: TObject);
begin
  Modifyentries(0,high(packentries));
  showimage;
end;

procedure TTypeEditForm.Button5Click(Sender: TObject);
begin
if Spinedit2.Value<=Spinedit3.Value then begin
  Modifyentries(Spinedit2.Value,Spinedit3.Value);
  showimage;
  end
else
  showmessage('From should be less or equal to To -.-');
end;

initialization
  {$I typeeditor.lrs}

end.

