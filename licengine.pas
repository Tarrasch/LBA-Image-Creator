//This is now GNU Licensed due to entangling from DePack unit by Zink.    (2007-2008)
//By Arash Rouhani-Kalleh, in MBN forums known as LBAWinOwns.

//This unit is for dealing with the images in LBA1 and 2, this unit supports all kinds of raw, SPRIRAW's, Bricks, and Sprites.
//Use the TLBAImage (formerly Mainpalettearaw) dealing with images, it hold's the data rawly with 8-bit indexing to a 24-bit palette.
//This unit was formerly known as MostStuff

{$DEFINE ED}     //Euclidean Distance
//{$DEFINE YUV}    //YUV colorspace Distance     //YUV didnt work, megivesup

         //dont have both activated at once (I think)
{$R-}

unit LICEngine;



interface


uses ExtCtrls , StdCtrls, SysUtils, Dialogs, Graphics, Classes, Variants,IntfGraphics,Graphtype,LCLType,LCLIntf,math,FPImage;

{
  str:='';
  for forer:=0 to 255 do begin
  if (forer mod 16)=0 then str:=str+#13;
  str:=str+'$'+inttohex(forer,2)+', ';
  end;
  savefile('/home/arash/Desktop/blah.txt',str);      }
const
numbers12234567etc: array[0..255] of byte =(
$00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,
$10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F,
$20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F,
$30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F,
$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,
$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,
$60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F,
$70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $7C, $7D, $7E, $7F,
$80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F,
$90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F,
$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF,
$B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF,
$C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF,
$D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF,
$E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF,
$F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF
);

const
LBA1PalByteArray: array[0..767] of byte = (
	$00, $00, $00, $FF, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
	$2B, $1F, $1B, $37, $27, $23, $43, $33, $2B, $4F, $3F, $37, $FF, $8B, $00, $FF,
	$C3, $00, $FF, $FF, $00, $FF, $C7, $00, $FF, $93, $00, $FF, $5F, $00, $FF, $FF,
	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00,
	$00, $17, $17, $00, $1F, $1F, $00, $27, $27, $00, $33, $2F, $07, $3B, $37, $07,
	$43, $43, $0B, $4F, $4B, $13, $5B, $53, $1B, $6B, $5F, $27, $77, $67, $37, $87,
	$73, $4B, $9B, $7B, $63, $AF, $87, $7B, $C3, $97, $97, $D7, $AB, $BB, $EB, $C3,
	$9F, $67, $4B, $A3, $6B, $4F, $AB, $73, $57, $AF, $7B, $5B, $B7, $83, $63, $BB,
	$8B, $67, $C3, $93, $6F, $CB, $9B, $77, $CF, $A3, $7F, $D3, $AF, $87, $DB, $BF,
	$93, $E3, $CB, $9F, $E7, $D7, $AB, $EF, $E3, $B3, $F7, $EF, $C3, $FF, $FB, $CF,
	$07, $0B, $17, $0B, $13, $27, $0F, $23, $37, $17, $33, $4B, $1B, $3F, $57, $1B,
	$4B, $67, $1F, $57, $77, $23, $67, $87, $23, $77, $97, $27, $87, $A7, $3B, $8F,
	$B3, $4F, $9B, $BF, $67, $A7, $CB, $83, $B7, $D7, $9F, $C7, $E3, $BF, $DB, $EF,
	$2F, $00, $0B, $3F, $00, $13, $53, $00, $17, $6B, $07, $1B, $7B, $07, $23, $83,
	$17, $1F, $93, $07, $27, $B3, $00, $33, $CB, $00, $37, $E3, $00, $3F, $EF, $27,
	$3F, $FF, $1F, $43, $FF, $3F, $63, $E7, $6F, $7F, $E7, $93, $97, $E7, $B7, $B7,
	$3F, $0F, $0F, $57, $17, $13, $73, $27, $17, $87, $2F, $1F, $97, $3B, $27, $A7,
	$3B, $2B, $B3, $47, $2B, $C7, $4B, $2F, $DB, $63, $3F, $EF, $7B, $53, $FF, $93,
	$67, $F3, $AB, $7F, $EB, $BB, $93, $F7, $CF, $97, $F7, $DB, $B7, $FB, $EB, $D7,
	$07, $1B, $0B, $0B, $27, $0F, $13, $37, $17, $1B, $47, $1F, $23, $53, $2B, $2B,
	$63, $33, $37, $73, $3F, $43, $7F, $4B, $4F, $8F, $57, $5B, $9F, $63, $67, $AB,
	$6F, $77, $BB, $7F, $87, $CB, $8F, $9B, $D7, $9F, $AB, $E7, $AF, $BF, $F7, $C3,
	$2B, $17, $07, $37, $1F, $0B, $43, $27, $0F, $53, $2F, $13, $5F, $37, $17, $6F,
	$43, $1F, $7B, $4B, $27, $8B, $57, $2F, $93, $5F, $37, $9B, $6B, $43, $A3, $77,
	$53, $AB, $83, $5F, $B3, $8F, $6F, $BF, $97, $77, $CB, $9F, $7F, $D7, $AB, $8B,
	$4F, $37, $1B, $5B, $43, $1F, $6F, $4B, $1B, $7F, $5B, $23, $93, $6B, $33, $AB,
	$7B, $37, $C3, $8B, $3F, $D3, $97, $4B, $E3, $A3, $4F, $F3, $AF, $53, $F7, $BB,
	$57, $FB, $CF, $63, $FF, $E3, $77, $FB, $EF, $8F, $FB, $F7, $AB, $FB, $F7, $CB,
	$07, $1F, $27, $0B, $2B, $37, $13, $3B, $47, $1F, $4B, $57, $2B, $5B, $6B, $33,
	$67, $73, $27, $73, $7B, $1B, $83, $7F, $0F, $8F, $8F, $0F, $9F, $9B, $13, $AB,
	$AB, $37, $B3, $B3, $4F, $C3, $C3, $6F, $D7, $D7, $93, $EB, $EB, $AB, $FF, $FF,
	$17, $2F, $2B, $23, $2F, $33, $1F, $37, $37, $27, $37, $3B, $2B, $3F, $43, $2F,
	$43, $47, $37, $4B, $4B, $3B, $4F, $53, $47, $5F, $63, $53, $6F, $73, $63, $7F,
	$87, $67, $8B, $8F, $77, $9F, $A3, $8B, $B3, $B7, $A3, $C7, $CB, $BB, $DF, $E3,
	$0F, $13, $0F, $17, $1F, $17, $23, $2F, $23, $2F, $3B, $2B, $3B, $4B, $33, $4B,
	$57, $3B, $57, $67, $43, $67, $73, $4B, $77, $83, $53, $87, $8F, $5F, $97, $9B,
	$6B, $A7, $A7, $7B, $B7, $B7, $8B, $CB, $CB, $97, $DB, $DB, $A7, $D7, $E7, $AF,
	$3B, $2B, $37, $4B, $37, $43, $5B, $47, $53, $6B, $5B, $63, $77, $6B, $73, $87,
	$7F, $83, $93, $87, $8B, $9F, $8F, $97, $AB, $97, $A7, $B7, $A3, $AF, $C3, $B3,
	$BF, $CB, $BB, $C3, $D3, $BF, $C7, $DB, $C7, $C7, $E3, $D3, $CF, $EB, $DF, $D7,
	$57, $07, $13, $6F, $0B, $1F, $8B, $13, $2F, $A7, $1F, $43, $AB, $33, $4F, $BB,
	$4B, $67, $D3, $53, $77, $DF, $57, $83, $EB, $5F, $87, $FB, $67, $97, $FF, $77,
	$AB, $FF, $87, $B7, $FF, $93, $CF, $FF, $9F, $E3, $FF, $AB, $F3, $FF, $BF, $E7,
	$2F, $2F, $2B, $3B, $3B, $37, $4B, $4B, $43, $57, $57, $53, $63, $63, $5F, $73,
	$73, $6B, $7F, $7F, $7B, $8F, $8F, $87, $9B, $9B, $97, $AB, $AB, $A3, $B7, $B7,
	$B3, $C7, $C7, $C3, $D3, $D3, $CF, $E3, $E3, $DF, $EF, $EF, $EF, $FF, $FF, $FF
);
const
LBA2PalByteArray: array[0..767] of byte = (
	$00, $00, $00, $7F, $00, $DF, $7F, $00, $DF, $7F, $00, $DF, $7F, $00, $DF, $7F,
	$00, $DF, $7F, $00, $DF, $7F, $00, $DF, $7F, $00, $DF, $7F, $00, $DF, $7F, $00,
	$DF, $7F, $00, $DF, $7F, $00, $DF, $7F, $00, $DF, $7F, $00, $DF, $FF, $FF, $FF,
	$23, $17, $07, $2B, $1B, $07, $33, $1F, $0B, $3B, $27, $0F, $43, $2B, $13, $4B,
	$33, $17, $53, $37, $1B, $5B, $3F, $23, $63, $43, $27, $6B, $47, $2B, $77, $4F,
	$33, $7F, $57, $3B, $83, $5B, $3F, $8B, $5F, $47, $8F, $63, $4B, $93, $6B, $4F,
	$9B, $6F, $57, $9F, $73, $5B, $A7, $7B, $5F, $AF, $7F, $67, $B3, $87, $6B, $BB,
	$8B, $6F, $C3, $93, $73, $CB, $9B, $7B, $CF, $A7, $83, $D7, $B3, $8B, $DF, $C3,
	$97, $E3, $CB, $A3, $EB, $DB, $AB, $EF, $E3, $B7, $F7, $EF, $C3, $FF, $FB, $CF,
	$17, $17, $13, $1F, $1F, $1B, $2B, $2B, $27, $37, $37, $2F, $43, $43, $3B, $4F,
	$4F, $43, $57, $57, $4F, $63, $63, $5B, $6F, $6F, $67, $7B, $7B, $73, $8F, $8F,
	$87, $A7, $A7, $9F, $BB, $BB, $B7, $D3, $D3, $CB, $E7, $E7, $E3, $FF, $FF, $FF,
	$2F, $00, $00, $3F, $00, $00, $4F, $00, $00, $5F, $00, $00, $6F, $00, $00, $7F,
	$00, $00, $8B, $07, $07, $97, $13, $0F, $A7, $1B, $1B, $B3, $2B, $27, $BF, $3B,
	$37, $CB, $4F, $4B, $D7, $67, $63, $E3, $7B, $77, $EF, $97, $93, $FF, $B3, $AF,
	$2B, $07, $07, $3F, $0B, $0B, $53, $17, $13, $6B, $1F, $17, $7F, $2B, $1F, $93,
	$3B, $2B, $AB, $47, $33, $BF, $57, $3F, $D3, $6B, $4B, $EB, $7F, $57, $FF, $93,
	$67, $FB, $A7, $7B, $FB, $BB, $93, $FB, $CF, $AB, $FB, $DF, $BF, $FB, $EB, $D7,
	$27, $1F, $13, $33, $2B, $17, $43, $37, $1F, $53, $43, $27, $63, $4F, $2B, $73,
	$5B, $2F, $83, $67, $37, $9B, $77, $3F, $B3, $8B, $47, $CB, $9B, $4B, $E3, $AF,
	$53, $F7, $BB, $57, $F7, $C7, $6F, $F7, $D3, $8B, $F7, $DB, $A3, $F7, $E7, $BF,
	$17, $23, $17, $1B, $2B, $1B, $23, $33, $23, $2B, $3B, $27, $33, $47, $2F, $3B,
	$4F, $33, $47, $57, $37, $4F, $5F, $3F, $5B, $67, $43, $67, $73, $4B, $77, $83,
	$57, $8B, $97, $67, $9B, $AB, $7B, $AF, $BF, $8B, $C3, $D3, $9B, $D7, $E7, $AF,
	$07, $1F, $0B, $07, $23, $0F, $0B, $2B, $13, $0F, $33, $17, $13, $3B, $1B, $17,
	$43, $1F, $1B, $4B, $23, $23, $57, $2B, $2F, $67, $37, $3F, $7B, $47, $4F, $8F,
	$57, $63, $A3, $6B, $77, $B7, $7F, $8B, $CB, $93, $A3, $E3, $AB, $BF, $F7, $C3,
	$00, $1B, $1B, $00, $23, $23, $00, $2B, $2B, $00, $33, $2F, $07, $3B, $37, $07,
	$43, $3F, $0B, $4F, $4B, $13, $5B, $53, $1B, $6B, $5F, $27, $77, $67, $37, $87,
	$73, $3B, $93, $7B, $43, $A7, $8B, $4B, $BB, $9B, $53, $CF, $AB, $5B, $E3, $BB,
	$00, $13, $1B, $00, $17, $23, $00, $1F, $2B, $00, $2B, $33, $00, $33, $3F, $07,
	$3B, $47, $07, $47, $53, $0B, $53, $5F, $0F, $5F, $6B, $13, $6B, $77, $1B, $7B,
	$83, $2F, $93, $9B, $47, $AF, $B3, $63, $CB, $CB, $83, $E3, $E3, $AB, $FF, $FF,
	$13, $1B, $1F, $17, $23, $27, $1B, $2B, $2F, $23, $33, $37, $27, $3B, $3F, $2F,
	$47, $4B, $37, $4F, $53, $43, $5B, $5F, $4B, $67, $6B, $53, $73, $77, $5B, $7F,
	$83, $67, $8B, $8F, $77, $9F, $A3, $8B, $B3, $B7, $A3, $C7, $CB, $BB, $DF, $E3,
	$07, $13, $27, $0F, $17, $33, $0F, $27, $3F, $17, $33, $4B, $1B, $3F, $57, $1B,
	$4B, $67, $1F, $57, $77, $23, $67, $87, $23, $77, $97, $27, $87, $A7, $3B, $8F,
	$B3, $4F, $9B, $BF, $67, $A7, $CB, $83, $B7, $D7, $9F, $C7, $E3, $BF, $DB, $EF,
	$1B, $17, $1B, $23, $1F, $23, $2B, $27, $2F, $37, $2F, $37, $3F, $37, $43, $47,
	$3F, $4B, $53, $47, $57, $5B, $53, $63, $67, $5F, $6F, $73, $6B, $7B, $7F, $77,
	$87, $8B, $83, $97, $A3, $9B, $AF, $BB, $B3, $C7, $D3, $CF, $DF, $EF, $EB, $FB,
	$0F, $0B, $0B, $1B, $13, $13, $27, $1B, $1B, $33, $27, $27, $3F, $2F, $2F, $4B,
	$3B, $3B, $57, $47, $43, $63, $53, $4F, $73, $63, $5F, $83, $73, $6F, $93, $83,
	$7F, $A3, $93, $8F, $B3, $A7, $A3, $C3, $B7, $B3, $D7, $CB, $C3, $EB, $DF, $D7,
	$00, $00, $00, $E7, $5F, $00, $EF, $7F, $00, $F7, $A7, $00, $FF, $CF, $00, $FF,
	$FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
);
type

Tpixelmode= (transparent,colorfollow,colordifferent);// used for sublines in the sprite-handling

//Readingmethod= (euclidean,dithering);//used for reading bmps

spriteformat= (brick,sprite);//To decide wheater brick or sprite

RLE = record
  pixelmode :Tpixelmode;
  start, length,subline : byte;
  first : boolean;
end;

RGB = record
 Red: byte;
 Green: byte;
 Blue: byte;
end;

BRGB = record //BigRGB, for dithering, "needs" negative values
 Red: smallint;
 Green: smallint;
 Blue: smallint;
end;

HRGB = record //HugeRGB
 Red: DWord;
 Green: DWord;
 Blue: DWord;
end;

NnHRGB = record //NivÃ¥ and HugeRGB
 HRGB :HRGB;
 Niva: byte;
end;

SNode = record //spatial-method node
 n1,n2:dword;
 Sr,Sg,Sb:dword;
 E:dword;
end;

BRGBImage = array of array of BRGB;

TPalette = array [0..255] of RGB;
{
  TGeneralRaw = class
  Private
    procedure failimage;
  Public
    Height,Width:Word;
    procedure newdimensions(newwidth,newheight:word);
    Data    : Ansistring;                 //varje byte pekar på en färg, antal = Width*height
    function palettetostring: ansistring; //RGB+RGB+RGB+RGB etc.
    procedure Sparabitmap(bmp: TBitmap);
    Palette : TPalette;
    procedure palettetoimage(bmp: TBitmap;imgheight:word =50);
  end;
}
  TLBAImage = class
  Private
    procedure failimage;
  Public

  //Vars

    Height,Width:Word;
    Heightoffset,Widthoffset:byte;
    Palette : TPalette;
    Data    : Ansistring;                 //varje byte pekar på en färg, antal = Width*height

    procedure newdimensions(newwidth,newheight:word);
    function palettetostring: ansistring; //RGB+RGB+RGB+RGB etc.
    procedure Sparabitmap(bmp: TBitmap);
    procedure palettetoimage(bmp: TBitmap;imgheight:word =50);
    
    function sparaRAW:ansistring; // should maybe really lie in GeneralRaw but meh ~.~
    function sparaSPRITE(format:spriteformat = sprite;customoffset:boolean=false; Xoffset: byte=0; Yoffset: byte=0):ansistring;
    function sparaSPRIRAW:ansistring;
    procedure laddapalett(theData :ansistring);
    procedure SetLba1Palette;
    procedure SetLba2Palette;
    function laddaBMP(Bitmap :TBitmap;dither:boolean;createpalette:boolean=false;palettenumberofcolorsminus1:byte=255;forcewidth:word = 0; forceheight:word = 0;whitetotrans :boolean =false):boolean;   //Most important function, probably 85% of engin writing has gone to this
    function laddaRAW(theData:ansistring):byte; // 0= fail, 1= Small, 2= Medium, 3= Large      (there actually is no medium in the lba games!)
    function laddaSPRIRAW(theData:ansistring):boolean;
    function laddaSPRITE(theData :ansistring;format:spriteformat = sprite):boolean;
    procedure fixdimensions;
end;


var
LBA1pal:^TPalette;
LBA2pal:^TPalette;

implementation

procedure TLBAImage.newdimensions(newwidth,newheight:word);
var
newdata:ansistring;
forer1,forer2:word;
begin
setlength(newdata,newwidth*newheight);
if (newwidth>width) or (newheight>width) then
for forer1:=1 to newwidth do
    for forer2:=0 to newheight-1 do
newdata[forer1+forer2*newwidth]:=#0;


for forer1:=1 to Min(newwidth,width) do
    for forer2:=0 to min(newheight-1,height-1) do
newdata[forer1+forer2*newwidth]:=data[forer1+forer2*width];

data:=newdata;
width:=newwidth;
height:=newheight;

end;


function TLBAImage.palettetostring: ansistring; //RGB+RGB+RGB+RGB etc.
var
forer :byte;
allt  :ansistring;
begin
  try

    allt:='';
      for forer:= 0 to 255 do
      allt:=allt+chr(self.Palette[forer].Red)+chr(self.Palette[forer].Green)+chr(self.Palette[forer].Blue);
  except
    showmessage('Whoups!!, Some error occured when trying to create the palette to string (TGenerallRaw.palettetostring)');

end;
result:=allt;
end;

procedure TLBAImage.Sparabitmap(bmp: TBitmap);  //always Timage.refresh if you gonna show it! (for windows only I think)

var
forer1:word;
forer2:word;
zerosperline:byte;
memstream : TMemoryStream;
begin

memstream:=TMemoryStream.Create;
memstream.Position:=0;
memstream.WriteByte(byte('B'));
memstream.WriteByte(byte('M'));
memstream.Write(0,4); //size get written later
memstream.WriteDWord(0);
memstream.WriteDWord(1078);
memstream.WriteDWord(40);
memstream.WriteDWord(self.Width);
memstream.WriteDWord(self.Height);
memstream.WriteWord(1);
memstream.WriteWord(8);
memstream.WriteDWord(0);memstream.WriteDWord(self.Width*self.Height);memstream.WriteDWord(0);memstream.WriteDWord(0);memstream.WriteDWord($100);memstream.WriteDWord(0);//compression and other shit...

//Palette
for forer1:=0 to 255 do begin
    memstream.WriteByte(self.Palette[forer1].Blue);
    memstream.WriteByte(self.Palette[forer1].Green);
    memstream.WriteByte(self.Palette[forer1].Red);
    memstream.WriteByte(0);
end;

//Data
//zerosperline:=-self.Width mod 4; dunno why but this seems to be calculated wrong :(
zerosperline:=((-self.Width mod 4) and 3);
for forer1:=self.Height-1 downto 0 do begin
    memstream.Write(self.Data[1+self.Width*forer1],self.Width);
    memstream.Write(0,zerosperline);
end;

memstream.Position:=2;
memstream.WriteDWord(memstream.Size);

memstream.Position:=0;
//memstream.SaveToFile('/home/arash/Desktop/blabla');
bmp.LoadFromStream(memstream);
end;

{
bmp.Destroy;
bmp:=tbitmap.create;
bmp.PixelFormat:=pf24bit;
bmp.Height:=self.Height;
bmp.Width:=self.Width;
bmp.Transparent:=true;
bmp.TransparentColor:=1;
}{

bmp.Destroy;
bmp:=tbitmap.create;
bmp.PixelFormat:=pf24bit;
bmp.Height:=self.Height;
bmp.Width:=self.Width;
bmp.Transparent:=true;
bmp.TransparentColor:=1;
try
      for Forer1 := 0 to self.Height-1 do
        for Forer2 := 0 to self.Width-1 do
          bmp.Canvas.Pixels[forer2,forer1]:=self.palette[byte(self.data[forer1*self.width+(forer2+1)])].Red or self.palette[byte(self.data[forer1*self.width+(forer2+1)])].Green shl 8 or self.palette[byte(self.data[forer1*self.width+(forer2+1)])].Blue shl 16 ;

    except
      bmp.Height:=12;
      bmp.Width:=220;
      bmp.Canvas.Color:=$FFFFFF;
      bmp.Canvas.FillRect(0,0,11,219);
      bmp.Canvas.Color:=0;
      bmp.Canvas.TextOut(0,0,'Bitmapcreation failed (Sparabitmap)');
    end;

    //bmp.PixelFormat:=pf8bit;

if (self.Palette[0].Red=1) and (self.Palette[0].green=0) and (self.Palette[0].blue=0) then begin  // else trans wont work and eliminates errors
bmp.PixelFormat:=pf8bit;
memstream := TMemoryStream.create;
try
bmp.SaveToStream(memstream);
memstream.position := 0;
bmp.LoadFromStream(memstream);
finally
memstream.free;
end;
end;

end;   }

  {
  TRawImage = record
    Description: TRawImageDescription;
    Data: PByte;
    DataSize: PtrUInt;
    Mask: PByte;
    MaskSize: PtrUInt;
    Palette: PByte;
    PaletteSize: PtrUInt;


      TRawImageDescription = record
    Format: TRawImageColorFormat;
    HasPalette: boolean; // if true, each pixel is an index in the palette
    Depth: cardinal; // used bits per pixel
    Width: cardinal;
    Height: cardinal;
    PaletteColorCount: integer;
    BitOrder: TRawImageBitOrder;
    ByteOrder: TRawImageByteOrder;
    LineOrder: TRawImageLineOrder;
    ColorCount: cardinal; // entries in color palette. Ignore when no palette.
    BitsPerPixel: cardinal; // bits per pixel. can be greater than Depth.
    LineEnd: TRawImageLineEnd;
    RedPrec: cardinal; // red precision. bits for red
    RedShift: cardinal;
    GreenPrec: cardinal;
    GreenShift: cardinal; // bitshift. Direction: from least to most significant
    BluePrec: cardinal;
    BlueShift: cardinal;
    AlphaPrec: cardinal;
    AlphaShift: cardinal;
    AlphaSeparate: boolean; // the alpha is stored as separate Mask
    // The next values are only valid, if there is a separate alpha mask
    AlphaBitsPerPixel: cardinal; // bits per alpha mask pixel.
    AlphaLineEnd: TRawImageLineEnd;
    AlphaBitOrder: TRawImageBitOrder;
    AlphaByteOrder: TRawImageByteOrder;
    // ToDo: add attributes for palette
  end;
} {
var
RawImage:TRawImage;
BMPHandle,BMPMaskHandle:LongWord;
tempstr:string;
forer:byte;
begin




RawImage.Data:=@Self.Data[1];
RawImage.DataSize:=length(self.Data);

//RawImage.Mask:=@Self.Data[1];
//RawImage.MaskSize:=length(self.Data);

RawImage.Palette:=@Self.Palette;
RawImage.PaletteSize:=$300;

RawImage.Description.Format:=ricfRGBA;
RawImage.Description.HasPalette:=false;
RawImage.Description.Depth:=8;
RawImage.Description.Width:=Self.Width;
RawImage.Description.Height:=self.Height;
RawImage.Description.PaletteColorCount:=$100;

RawImage.Description.BitOrder:=riboBitsInOrder;
RawImage.Description.ByteOrder:=riboMSBFirst;
RawImage.Description.LineOrder:=riloTopToBottom;
RawImage.Description.ColorCount:=3;
RawImage.Description.BitsPerPixel:=8;
RawImage.Description.LineEnd:=rileTight;

RawImage.Description.RedPrec:=8;
RawImage.Description.RedShift:=0;
RawImage.Description.GreenPrec:=8;
RawImage.Description.GreenShift:=0;
RawImage.Description.BluePrec:=8;
RawImage.Description.BlueShift:=0;
RawImage.Description.AlphaPrec:=0;
RawImage.Description.AlphaShift:=0;
RawImage.Description.AlphaSeparate:=false;


LCLINTF.CreateBitmapFromRawImage(RawImage,BMPHandle,BMPMaskHandle,true);

bmp.CreateFromBitmapHandles(BMPHandle,BMPMaskHandle,rect(0,0,self.Width-1,self.Height-1));

end;  }


procedure TLBAImage.palettetoimage(bmp: TBitmap;imgheight:word =50); //always Timage.refresh if you gonna show it! (If the user has Microsuck) only I think)
var
forer1:word;
forer2:word;
memstream : TMemoryStream;
begin

memstream:=TMemoryStream.Create;
memstream.Position:=0;
memstream.WriteByte(byte('B'));
memstream.WriteByte(byte('M'));
memstream.Write(0,4); //size get written later
memstream.WriteDWord(0);
memstream.WriteDWord(1078);
memstream.WriteDWord(40);
memstream.WriteDWord(256);
memstream.WriteDWord(imgheight);
memstream.WriteWord(1);
memstream.WriteWord(8);
memstream.WriteDWord(0);memstream.WriteDWord(self.Width*self.Height);memstream.WriteDWord(0);memstream.WriteDWord(0);memstream.WriteDWord($100);memstream.WriteDWord(0);//compression and other shit...

//Palette
for forer1:=0 to 255 do begin
    memstream.WriteByte(self.Palette[forer1].Blue);
    memstream.WriteByte(self.Palette[forer1].Green);
    memstream.WriteByte(self.Palette[forer1].Red);
    memstream.WriteByte(0);
end;

//Data
for forer1:=1 to imgheight do
    memstream.Write(numbers12234567etc,256);

memstream.Position:=2;
memstream.WriteDWord(memstream.Size);

memstream.Position:=0;
//memstream.SaveToFile('/home/arash/Desktop/blabla');
bmp.LoadFromStream(memstream);
end;

{
bmp.Destroy;
bmp:=tbitmap.create;
bmp.PixelFormat:=pf24bit;
bmp.Height:=self.Height;
bmp.Width:=self.Width;
bmp.Transparent:=true;
bmp.TransparentColor:=1;
}

procedure TLBAImage.failimage;
begin
Width:=1;
Height:=1;
Data:=#0;
Heightoffset:=0;
Widthoffset:=0;
end;

procedure TLBAImage.fixdimensions;
var
forer1,forer2:Word;
lowestwidth,lowestheight,lowestwidthoffset,lowestheightoffset:Word;
whiler:Word;
newdata:ansistring;
newwidth,newheight:word;
begin
lowestwidth:=999;
lowestwidthoffset:=999;
lowestheight:=999;
lowestheightoffset:=999;
newwidth:=0;
newheight:=0;

for forer1:=0 to self.Height-1 do begin
    whiler:=1;
    while (self.Data[forer1*self.Width+whiler]=#0) and (whiler<(self.Width)) do
    inc(whiler);

    if lowestwidthoffset>(whiler-1)
    then lowestwidthoffset:=(whiler-1);


end;

for forer1:=0 to self.Width-1 do begin
    whiler:=1;
    while (self.Data[forer1+self.Width*(whiler-1)+1]=#0) and (whiler<(self.Height)) do
    inc(whiler);

    if lowestHeightoffset>(whiler-1)
    then lowestHeightoffset:=(whiler-1);


end;


for forer1:=0 to self.Height-1 do begin
    whiler:=self.Width;
    while (self.Data[forer1*self.Width+whiler]=#0) and (whiler>0) do
    dec(whiler);

    if lowestwidth>self.Width-whiler
    then lowestwidth:=self.Width-whiler;
end;

if self.Width=lowestwidth then lowestwidth:=self.Width-1;

for forer1:=0 to self.Width-1 do begin
    whiler:=self.Height;
    while (self.Data[forer1+self.Width*(whiler-1)+1]=#0) and (whiler>0) do
    dec(whiler);

    if lowestHeight>self.Height-whiler
    then lowestHeight:=self.Height-whiler;
end;

if self.Height=lowestHeight then lowestHeight:=self.Height-1;



if (lowestHeight=0) and  (lowestwidth=0) and (lowestHeightoffset=0) and (lowestwidthoffset=0)
then
exit;

if lowestHeightoffset+self.Heightoffset>255 then begin
lowestheightoffset:=255;
self.Heightoffset:=255;
end
else
self.Heightoffset:=self.Heightoffset+lowestHeightoffset;

if lowestwidthoffset+self.widthoffset>255 then begin
lowestwidthoffset:=255;
self.widthoffset:=255;
end
else
self.Widthoffset:=self.widthoffset+lowestwidthoffset;

newwidth:=(self.width-lowestwidthoffset-lowestwidth)+newwidth;
newheight:=(self.Height-lowestHeightoffset-lowestHeight)+newheight;
setlength(newdata,newwidth*newheight);

//showmessage(inttostr(lowestwidthoffset)+inttostr(lowestwidth)+inttostr(lowestHeightoffset)+inttostr(lowestHeight));

for forer1:=lowestHeightoffset to self.Height-lowestHeight-1 do
    for forer2:=lowestwidthoffset to self.width-lowestwidth-1 do
    Newdata[(forer1-lowestheightoffset)*newwidth+forer2-lowestwidthoffset+1]:=Self.Data[forer1*self.Width+forer2+1];

self.Data:=Newdata;
self.Height:=newheight;
self.Width:=newwidth;


end;







function TLBAImage.laddaBMP(Bitmap :TBitmap;dither:boolean;createpalette:boolean=false;palettenumberofcolorsminus1:byte=255;forcewidth:word = 0; forceheight:word = 0;whitetotrans :boolean =false):boolean;
const
//Palette Optimzation
          //Spatial
                   TreeDepth=8;

var
forer1,forer2,forer3,forer4:Dword;
tmpRGB  : RGB;
closest : byte;
trans   : boolean;
closestdistance:integer;
tmpdistance : integer;
TheImage :BRGBImage;

//Dither-vars;
BRGBerror                    :BRGB;
transes                      :array of set of byte; //sets aint dynamic :-/

//Resize-vars
widthrelation:real;
heightrelation:real;
tempr1,tempr2,tempr3,tempr4,tempr5,tempr6,tempr7,tempr8,tempr9,tempr10,tempr11:real;
Lazintfimage:TLazIntfImage;
resizetobiggerpicture:boolean;


//Palette Optimzation
          //SSqArRGBImage:array of array of RGB;

          tempv1,tempv2,tempv3,tempv4,tempv5,tempv6,tempv7,tempv8,tempv9,tempv10:integer;   //anvÃ¤nds till allt
          tempw1,tempw2,tempw3,tempw4,tempw5,tempw6,tempw7,tempw8,tempw9,tempw10:Dword;
          //numSq:Dword;
          
          //Spatial
                   Tree:array of array of ^snode;
                   Prunemore:boolean;
                   atsnode,absnode:^snode;
                   N:dword;
          //Clustering
                       {amountentriesarray: array[0..255] of DWord;
                        RedSumOfArray:array[0..255] of QWord;
                        GreenSumOfArray:array[0..255] of QWord;
                        BlueSumOfArray:array[0..255] of QWord;
                       }

                       {$IFDEF YUV}
                       Y,U,V:byte;
                       {$ENDIF}
begin

try

{Resize (or just convert to another array format if no resizing was requested)


88888888ba                         88
88      "8b                        ""
88      ,8P
88aaaaaa8P'  ,adPPYba,  ,adPPYba,  88  888888888   ,adPPYba,
88""""88'   a8P_____88  I8[    ""  88       a8P"  a8P_____88
88    `8b   8PP"""""""   `"Y8ba,   88    ,d8P'    8PP"""""""
88     `8b  "8b,   ,aa  aa    ]8I  88  ,d8"       "8b,   ,aa
88      `8b  `"Ybbd8"'  `"YbbdP"'  88  888888888   `"Ybbd8"'

 
}

Lazintfimage:=TLazintfimage.Create(bitmap.Width,bitmap.Height);
bitmap.CreateIntfImage(Lazintfimage);




{$IFDEF YUV}//Y->G, U->B, V->R
        {$MACRO ON}
        {$DEFINE bcp:=$FF and Lazintfimage.Colors}
begin
for forer1:=0 to Lazintfimage.Width-1 do
for forer2:=0 to Lazintfimage.Height-1 do begin
Y:=round((0.299*(bcp[forer1,forer2].red))+(0.587*(bcp[forer1,forer2].Green))+(0.114*(bcp[forer1,forer2].Blue)));
U:=round(0.436*((bcp[forer1,forer2].Blue)-Y)/(1 - 0.114));
V:=round(0.615*((bcp[forer1,forer2].Red)-Y)/(1 - 0.299));

Lazintfimage.TColors[forer1,forer2]:=V shl 16 + U + Y shl 8;
end;

for forer1:=0 to 255 do begin
Y:=round((0.299*(self.palette[forer1].red))+(0.587*(self.palette[forer1].Green))+(0.114*(self.palette[forer1].Blue)));
U:=round(0.436*(self.palette[forer1].Blue-Y)/(1 - 0.114));
V:=round(0.615*(self.palette[forer1].Red-Y)/(1 - 0.299));
self.palette[forer1].red:=V;
self.palette[forer1].green:=Y;
self.palette[forer1].blue:=U;

end;

end;
{$ENDIF}

if (self.Palette[0].Red=1) and (self.Palette[0].green=0) and (self.Palette[0].blue=0)
then
self.Palette[0].Red:=0;

if not((forcewidth=0) and (forceheight=0)) and not((bitmap.Width=forcewidth) and (forceheight=bitmap.Height))  then begin
self.Width:=forceWidth;
self.Height:=forceHeight;
widthrelation:=width/(bitmap.Width);
heightrelation:=height/(bitmap.height);
trans:=false;
resizetobiggerpicture:=((widthrelation>0.8) and (heightrelation>0.8)) or (widthrelation>1) or (heightrelation>1);
//resizetobiggerpicture:=true;
setlength(TheImage,width+byte(dither)*2,height+byte(dither));
//resizetobiggerpicture:=true;
//Here is the actual Resizeing


{
 _______         ______ __
|_     _|.-----.|   __ \__|.-----.-----.-----.----.
  |   |  |  _  ||   __ <  ||  _  |  _  |  -__|   _|
  |___|  |_____||______/__||___  |___  |_____|__|
                           |_____|_____|
}
if resizetobiggerpicture then begin
for forer1:=0 to height-1 do begin
    tempr1:=(forer1+0.4999999)/heightrelation;
    tempv1:=trunc(tempr1)-byte((tempr1-trunc(tempr1))<0.5);
    tempr5:=0.5+tempr1-trunc(tempr1)-byte(tempr1-trunc(tempr1)>0.5);
    tempr3:=1-tempr5;
    
    tempv3:=min(tempv1+1,Lazintfimage.height-1);
    tempv4:=min(tempv1+2,Lazintfimage.Height-1);
    tempv7:=min(Lazintfimage.height-1,max(tempv1-1,0));

    for forer2:=byte(dither) to width-1+byte(dither) do begin
        tempr2:=(forer2+0.4999999-byte(dither))/widthrelation;
        tempv2:=trunc(tempr2)-byte((tempr2-trunc(tempr2))<0.5);
        tempr6:=0.5+tempr2-trunc(tempr2)-byte(tempr2-trunc(tempr2)>0.5);
        tempr4:=1-tempr6;

        
        {$MACRO ON}
        {$DEFINE bcp:=$FF and Lazintfimage.Colors}
        if  not((tempr3=0.5) and (tempr4=0.5)) then
        begin
             tempv5:=min(tempv2+1,Lazintfimage.width-1);
             tempv6:=min(tempv2+2,Lazintfimage.width-1);
             //tempv8:=max(tempv1-2,0);
             tempv9:=min(Lazintfimage.width-1,max(tempv2-1,0));
             //tempv10:=max(tempv2-2,0);

             tempv1:=max(tempv1,0);
             tempv2:=max(tempv2,0);
             
             theimage[forer2,forer1].Red:=
             (round((tempr3*tempr4*(bcp[tempv2,tempv1].red) + tempr3*tempr6*(bcp[tempv5,tempv1].red) + tempr5*tempr4*(bcp[tempv2,tempv3].red) + tempr5*tempr6*(bcp[tempv5,tempv3].red)))){ + //3/4 of all nearby colors plus
             (bcp[tempv9,tempv1].red + bcp[tempv9,tempv3].red + bcp[tempv2,tempv4].red + bcp[tempv5,tempv4].red +bcp[tempv6,tempv1].red + bcp[tempv6,tempv3].red + bcp[tempv2,tempv7].red + bcp[tempv5,tempv7].red)shr 3 ) shr 4}; //1/4 of all quite nearby colors

             theimage[forer2,forer1].Green:=
             (round((tempr3*tempr4*(bcp[tempv2,tempv1].green) + tempr3*tempr6*(bcp[tempv5,tempv1].green) + tempr5*tempr4*(bcp[tempv2,tempv3].green) + tempr5*tempr6*(bcp[tempv5,tempv3].green)))){ + //3/4 of all nearby colors plus
             (bcp[tempv9,tempv1].green + bcp[tempv9,tempv3].green + bcp[tempv2,tempv4].green + bcp[tempv5,tempv4].green +bcp[tempv6,tempv1].green + bcp[tempv6,tempv3].green + bcp[tempv2,tempv7].green + bcp[tempv5,tempv7].green)shr 3 ) shr 4}; //1/4 of all quite nearby colors

             theimage[forer2,forer1].blue:=
             (round((tempr3*tempr4*(bcp[tempv2,tempv1].blue) + tempr3*tempr6*(bcp[tempv5,tempv1].blue) + tempr5*tempr4*(bcp[tempv2,tempv3].blue) + tempr5*tempr6*(bcp[tempv5,tempv3].blue)))){ + //3/4 of all nearby colo5rs plus
             (bcp[tempv9,tempv1].blue + bcp[tempv9,tempv3].blue + bcp[tempv2,tempv4].blue + bcp[tempv5,tempv4].blue +bcp[tempv6,tempv1].blue + bcp[tempv6,tempv3].blue + bcp[tempv2,tempv7].blue + bcp[tempv5,tempv7].blue)shr 3 ) shr 4}; //1/4 of all quite nearby colors

        
        end
        else
            begin

             tempv1:=max(min(tempv1,Lazintfimage.height-1),0);
             tempv2:=max(min(tempv2,Lazintfimage.width-1),0);
         theimage[forer2,forer1].Red:=bcp[tempv2,tempv1].red ;
         theimage[forer2,forer1].Green:=bcp[tempv2,tempv1].green;
         theimage[forer2,forer1].blue:=bcp[tempv2,tempv1].blue;
            end;
    end;
end;//showmessage(inttostr(tempv10));showmessage(inttostr(tempv8));
{
 _______         _______                  __ __
|_     _|.-----.|     __|.--------.---.-.|  |  |.-----.----.
  |   |  |  _  ||__     ||        |  _  ||  |  ||  -__|   _|
  |___|  |_____||_______||__|__|__|___._||__|__||_____|__|

}
end
else
for forer1:=0 to height-1 do begin
    if forer1<>0 then begin     //kinda unccessary
    tempr1:=tempr3;
    tempr5:=1-tempr7;
    end
    else begin
    tempr1:=(forer1)/heightrelation;
    tempr5:=1-(tempr1-trunc(tempr1));
    end;
    
    if forer1<>height-1 then
    tempr3:=(forer1+1)/heightrelation
    else
    tempr3:=(forer1+0.99999)/heightrelation;
    tempr7:=tempr3-trunc(tempr3);
    
    tempv1:=trunc(tempr1);
    tempv3:=trunc(tempr3);
    
    for forer2:=byte(dither) to width-1+byte(dither) do begin

        if forer2<>byte(dither) then begin     //kinda unccessary
        tempr2:=tempr4;
        tempr6:=1-tempr8;
        end
        else begin
        tempr2:=(forer2-byte(dither))/widthrelation;
        tempr6:=1-(tempr2-trunc(tempr2));
        end;

            if forer2<>width-1+byte(dither) then
              tempr4:=(forer2+1-byte(dither))/widthrelation
              else
              tempr4:=(forer2+0.99999-byte(dither))/widthrelation;
        tempr8:=tempr4-trunc(tempr4);

        tempv2:=trunc(tempr2);
        tempv4:=trunc(tempr4);



        {$MACRO ON}
        {$DEFINE bcp:=$FF and Lazintfimage.Colors}
             //The three color channels
             tempr9:=(bcp[tempv2,tempv1].red)*tempr5*tempr6+(bcp[tempv2,tempv3].red)*tempr7*tempr6+(bcp[tempv4,tempv1].red)*tempr5*tempr8+(bcp[tempv4,tempv3].red)*tempr7*tempr8;
             tempr10:=(bcp[tempv2,tempv1].green)*tempr5*tempr6+(bcp[tempv2,tempv3].green)*tempr7*tempr6+(bcp[tempv4,tempv1].green)*tempr5*tempr8+(bcp[tempv4,tempv3].green)*tempr7*tempr8;
             tempr11:=(bcp[tempv2,tempv1].blue)*tempr5*tempr6+(bcp[tempv2,tempv3].blue)*tempr7*tempr6+(bcp[tempv4,tempv1].blue)*tempr5*tempr8+(bcp[tempv4,tempv3].blue)*tempr7*tempr8;

             if tempv3-tempv1>1 then begin
                for forer3:=tempv1+1 to tempv3-1 do begin
                    tempr9+=(bcp[tempv2,forer3].red)*tempr6+(bcp[tempv4,forer3].red)*tempr8;
                    tempr10+=(bcp[tempv2,forer3].green)*tempr6+(bcp[tempv4,forer3].green)*tempr8;
                    tempr11+=(bcp[tempv2,forer3].blue)*tempr6+(bcp[tempv4,forer3].blue)*tempr8;
                end;
             end;
             if tempv4-tempv2>1 then begin
                for forer4:=tempv2+1 to tempv4-1 do begin //it might aswell be forer3
                    tempr9+=(bcp[forer4,tempv1].red)*tempr5+(bcp[forer4,tempv3].red)*tempr7;
                    tempr10+=(bcp[forer4,tempv1].green)*tempr5+(bcp[forer4,tempv3].green)*tempr7;
                    tempr11+=(bcp[forer4,tempv1].blue)*tempr5+(bcp[forer4,tempv3].blue)*tempr7;
                end;
             end;
             if (tempv3-tempv1>1) and (tempv4-tempv2>1) then begin
                for forer3:=tempv1+1 to tempv3-1 do begin
                  for forer4:=tempv2+1 to tempv4-1 do begin
                    tempr9+=(bcp[forer4,forer3].red);
                    tempr10+=(bcp[forer4,forer3].green);
                    tempr11+=(bcp[forer4,forer3].blue);
                  end;
                end;
             end;


             
             theimage[forer2,forer1].Red:=round(tempr9*heightrelation*widthrelation);

             theimage[forer2,forer1].Green:=round(tempr10*heightrelation*widthrelation);

             theimage[forer2,forer1].blue:=round(tempr11*heightrelation*widthrelation);

    end;
end;


end //end for resizing


else
begin                 //start of converting to another format   (if no resize is neccesary)
trans:=true;
if (self.Palette[0].Red=0) and (self.Palette[0].green=0) and (self.Palette[0].blue=0)
then
self.Palette[0].Red:=1;

setlength(TheImage,bitmap.width+byte(dither)*2,bitmap.height+byte(dither));

for forer1:=0 to bitmap.height-1 do begin
    for forer2:=0+byte(dither) to bitmap.width-1+byte(dither) do begin

         theimage[forer2,forer1].Red:=bcp[forer2-byte(dither),forer1].red ;
         theimage[forer2,forer1].Green:=bcp[forer2-byte(dither),forer1].green;
         theimage[forer2,forer1].blue:=bcp[forer2-byte(dither),forer1].blue;
    end;
end;

self.Width:=bitmap.Width;
self.Height:=bitmap.Height;
end;

{Palette Optimzation (Or do nothing if palette is predefined)


88888888ba               88                                                ,ad8888ba,                         88                      88                                  88
88      "8b              88                ,d       ,d                    d8"'    `"8b                 ,d     ""                      ""                           ,d     ""
88      ,8P              88                88       88                   d8'        `8b                88                                                          88
88aaaaaa8P'  ,adPPYYba,  88   ,adPPYba,  MM88MMM  MM88MMM  ,adPPYba,     88          88  8b,dPPYba,  MM88MMM  88  88,dPYba,,adPYba,   88  888888888  ,adPPYYba,  MM88MMM  88   ,adPPYba,   8b,dPPYba,
88""""""'    ""     `Y8  88  a8P_____88    88       88    a8P_____88     88          88  88P'    "8a   88     88  88P'   "88"    "8a  88       a8P"  ""     `Y8    88     88  a8"     "8a  88P'   `"8a
88           ,adPPPPP88  88  8PP"""""""    88       88    8PP"""""""     Y8,        ,8P  88       d8   88     88  88      88      88  88    ,d8P'    ,adPPPPP88    88     88  8b       d8  88       88
88           88,    ,88  88  "8b,   ,aa    88,      88,   "8b,   ,aa      Y8a.    .a8P   88b,   ,a8"   88,    88  88      88      88  88  ,d8"       88,    ,88    88,    88  "8a,   ,a8"  88       88
88           `"8bbdP"Y8  88   `"Ybbd8"'    "Y888    "Y888  `"Ybbd8"'       `"Y8888Y"'    88`YbbdP"'    "Y888  88  88      88      88  88  888888888  `"8bbdP"Y8    "Y888  88   `"YbbdP"'   88       88
                                                                                         88
                                                                                         88
}

if createpalette then begin

//I tried to understand this alghoritm http://www.imagemagick.org/script/quantize.php
//The defintion of E was unclear for me, but I took what seemed logical to me

//later, after the spatial clustering has been performed, I use a K-meanClustering for the extra quality

N:=0;
setlength(Tree,TreeDepth+1);
for forer3:=0 to TreeDepth do begin
setlength(Tree[forer3],8**forer3);
fillDword(Tree[forer3,0],(8**forer3),0);
end;

for forer1:=0 to self.Height-1 do begin
    for forer2:=byte(dither) to self.Width-1+byte(dither) do begin
        for forer3:=0 to TreeDepth do begin

            //if forer2= self.Width-1+byte(dither) then showmessage(inttostr(theimage[forer2,forer1].Red));
            tempw1:=theimage[forer2,forer1].Red shr (8-forer3) shl (forer3*2)+
            theimage[forer2,forer1].Green shr (8-forer3) shl (forer3{*1})+
            theimage[forer2,forer1].Blue shr (8-forer3) {shl (forer3*0)};
            

            if Tree[forer3,tempw1]=nil
            then begin
            new(Tree[forer3,tempw1]);
            fillDword(Tree[forer3,tempw1]^,6,0);
            if forer3=TreeDepth then inc(N);
            end;
            inc(Tree[forer3,tempw1]^.n1);
            
        end;
            tempw3:=theImage[forer2,forer1].red and (256-(1 shl (8-treedepth)))+ (1 shl (8-treedepth))shr 1;//R-mid
            tempw4:=theImage[forer2,forer1].green and (256-(1 shl (8-treedepth)))+ (1 shl (8-treedepth)) shr 1;//G-mid
            tempw5:=theImage[forer2,forer1].blue and (256-(1 shl (8-treedepth)))+ (1 shl (8-treedepth)) shr 1;//B-mid
            with Tree[TreeDepth,tempw1]^
            do begin
            inc(n2);
            sr+=theimage[forer2,forer1].red;
            sg+=theimage[forer2,forer1].green;
            sb+=theimage[forer2,forer1].blue;
            E+={$IFDEF ED}round(sqrt( sqr( {$ELSE} abs( {$ENDIF}theImage[forer2,forer1].red-tempw3)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}theImage[forer2,forer1].green-tempw4)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}theImage[forer2,forer1].Blue-tempw5){$IFDEF ED})){$ENDIF};
            end;

    end;
end;

//Pruneing...
{           Ep = 0
  while number of nodes with (n2 > 0) > required maximum number of colors
     prune all nodes such that E <= Ep
     Set Ep  to minimum E in remaining nodes
}
tempw7:=0;
tempw1:=0;//Ep
//tempw3  ;//Lowestfound yet
Prunemore:=N>palettenumberofcolorsminus1+1;
tempw2:=1;//Depth, it should not be able to prune the biggest root
tempw3:=0;//R
tempw4:=0;//G
tempw5:=0;//B
tempw6:=9999999;
while Prunemore do begin
atsnode:=Tree[tempw2,tempw3 shr (8-tempw2) shl (tempw2*2)+tempw4 shr (8-tempw2) shl tempw2+tempw5 shr (8-tempw2)];
if atsnode<>nil
then begin

     //When the node exist
     if atsnode^.n2<>0 then begin

        if atsnode^.E<=tempw1 then begin

                    //The actual pruneing
           absnode:=Tree[(tempw2-1),tempw3 shr (8-(tempw2-1)) shl ((tempw2-1)*2)+tempw4 shr (8-(tempw2-1)) shl (tempw2-1)+tempw5 shr (8-(tempw2-1))];
           if absnode^.n2<>0 then
              dec(N);
           absnode^.n2+=atsnode^.n2;
           absnode^.Sr+=atsnode^.Sr;
           absnode^.Sg+=atsnode^.Sg;
           absnode^.Sb+=atsnode^.Sb;
           absnode^.E+={$IFDEF ED}round(sqrt( sqr( {$ELSE} abs( {$ENDIF}atsnode^.Sr-(tempw3 and (256-(1 shl (8-(tempw2-1))))+ (1 shl (8-(tempw2-1))) shr 1 )*atsnode^.n2)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}atsnode^.Sg-(tempw4 and (256-(1 shl (8-(tempw2-1))))+ (1 shl (8-(tempw2-1)))shr 1)*atsnode^.n2)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}atsnode^.Sb-(tempw5 and (256-(1 shl (8-(tempw2-1))))+ (1 shl (8-(tempw2-1)))shr 1)*atsnode^.n2){$IFDEF ED})){$ENDIF};
           atsnode^.n1-=atsnode^.n2;
           atsnode^.Sr:=0;
           atsnode^.Sg:=0;
           atsnode^.Sb:=0;
           atsnode^.n2:=0;
           atsnode^.E:=0;
           if atsnode^.n1=0 then begin
              dispose(atsnode);//disposea noden
              Tree[tempw2,tempw3 shr (8-tempw2) shl (tempw2*2)+tempw4 shr (8-tempw2) shl tempw2+tempw5 shr (8-tempw2)]:=nil;
              atsnode:=nil; // just for those later lines
            end;
           if tempw6>absnode^.E then
              tempw6:=absnode^.E;
        end
        else begin
               if tempw6>atsnode^.E then
           tempw6:=atsnode^.E;
        end;
     end;

Prunemore:=N>palettenumberofcolorsminus1+1;
end;
tempw10:=dword(true);
if atsnode<>nil then
if (atsnode^.n1<>atsnode^.n2) and (tempw2<treedepth) and ((tempw3 mod (1 shl (8-tempw2)))=0) and ((tempw4 mod (1 shl (8-tempw2)))=0) and ((tempw5 mod (1 shl (8-tempw2)))=0)
then begin
inc(tempw2); //in case of go one step further down in tree
tempw10:=dword(false);
end;
    if boolean(tempw10) then
    begin
    while (((tempw3 shr (8-tempw2))  and 1) = 1) and ((tempw4 shr (8-tempw2))  and 1 = 1) and ((tempw5 shr (8-tempw2))  and 1 = 1) do
    begin
    dec(tempw2);
    tempw10:=dword(false);
    end;
    if not boolean(tempw10) then begin
    tempw5:=tempw5 and (256-1 shl (8-tempw2));
    tempw4:=tempw4 and (256-1 shl (8-tempw2));
    tempw3:=tempw3 and (256-1 shl (8-tempw2));
    end;

    if ((tempw5 shr (8-tempw2))  and 1 = 1) then
    if ((tempw4 shr (8-tempw2))  and 1 = 1) then begin
       tempw3+=1 shl (8-tempw2);
       tempw4:=tempw4 - (1 shl (8-tempw2));
       tempw5:=tempw5 - (1 shl (8-tempw2))
       end else begin
       tempw4+=1 shl (8-tempw2);
       tempw5:=tempw5 - (1 shl (8-tempw2));
       end
       else
       tempw5+=1 shl (8-tempw2);
       

       
    if tempw2=0 then begin     //if finished
tempw2:=1;//Depth, it should not be able to prune the biggest root
tempw3:=0;//R
tempw4:=0;//G
tempw5:=0;//B
tempw1:=tempw6;
tempw6:=9999999;
    end;
end;
end;
//showmessage(inttostr(tempw7));

tempw7:=0;

tempw2:=1;//Depth, it should not be able to prune the biggest root
tempw3:=0;//R
tempw4:=0;//G
tempw5:=0;//B
tempw6:=1;

while tempw6<>N do begin
atsnode:=Tree[tempw2,tempw3 shr (8-tempw2) shl (tempw2*2)+tempw4 shr (8-tempw2) shl tempw2+tempw5 shr (8-tempw2)];
if atsnode<>nil
then
    if atsnode^.n2<>0 then begin
     //When the node exist
     self.Palette[tempw6-1].Red:=round(atsnode^.Sr/atsnode^.n2);
     self.Palette[tempw6-1].Green:=round(atsnode^.Sg/atsnode^.n2);
     self.Palette[tempw6-1].Blue:=round(atsnode^.Sb/atsnode^.n2);
     inc(tempw6);
     end;

if (atsnode<>nil) and (tempw2<treedepth) and ((tempw3 mod (1 shl (8-tempw2)))=0) and ((tempw4 mod (1 shl (8-tempw2)))=0) and ((tempw5 mod (1 shl (8-tempw2)))=0)
then
inc(tempw2) //in case of go one step further down in tree
else
    begin
    while (((tempw3 shr (8-tempw2))  and 1) = 1) and ((tempw4 shr (8-tempw2))  and 1 = 1) and ((tempw5 shr (8-tempw2))  and 1 = 1) do
    dec(tempw2);

    tempw5:=tempw5 and (256-1 shl (8-tempw2));
    tempw4:=tempw4 and (256-1 shl (8-tempw2));
    tempw3:=tempw3 and (256-1 shl (8-tempw2));


    if ((tempw5 shr (8-tempw2))  and 1 = 1) then
    if ((tempw4 shr (8-tempw2))  and 1 = 1) then begin
       tempw3+=1 shl (8-tempw2);
       tempw4:=tempw4 - (1 shl (8-tempw2));
       tempw5:=tempw5 - (1 shl (8-tempw2))
       end else begin
       tempw4+=1 shl (8-tempw2);
       tempw5:=tempw5 - (1 shl (8-tempw2));
       end
       else
       tempw5+=1 shl (8-tempw2);

    end;

end;

//Eventual 1 lap of K-Mean Clustering
//See Junkcode.txt
end;//end of IF createpalette then etc...



{Dithering (or convert without dithering)

88888888ba,    88           88                                   88
88      `"8b   ""    ,d     88                                   ""
88        `8b        88     88
88         88  88  MM88MMM  88,dPPYba,    ,adPPYba,  8b,dPPYba,  88  8b,dPPYba,    ,adPPYb,d8
88         88  88    88     88P'    "8a  a8P_____88  88P'   "Y8  88  88P'   `"8a  a8"    `Y88
88         8P  88    88     88       88  8PP"""""""  88          88  88       88  8b       88
88      .a8P   88    88,    88       88  "8b,   ,aa  88          88  88       88  "8a,   ,d88
88888888Y"'    88    "Y888  88       88   `"Ybbd8"'  88          88  88       88   `"YbbdP"Y8
                                                                                   aa,    ,88
                                                                                    "Y8bbdP"
}


//bitmap.SaveToFile('L:\tmpbmp.bmp');

if not dither then begin
try
  //self.Data:='';
  setlength(self.Data,self.width*self.height);
  for forer1:=0 to self.Height-1 do begin        //determines row
  for forer2:=0 to self.Width-1 do begin             //determines column
  if trans and ((((bcp[forer2,forer1].red)=$01) and ((bcp[forer2,forer1].green)=$0) and ((bcp[forer2,forer1].blue)=$0)) or (whitetotrans and ((bcp[forer2,forer1].red)=$FF) and ((bcp[forer2,forer1].green)=$FF) and ((bcp[forer2,forer1].blue)=$FF)))
  then self.Data[1+forer1*self.Width+forer2]:=#0
  else begin
  tmpRGB.Red:=TheImage[forer2,forer1].red ;
  tmpRGB.Green:=TheImage[forer2,forer1].green ;
  tmpRGB.blue:=TheImage[forer2,forer1].blue ;
  closestdistance:=maxlongint;
  for forer3:=255 downto byte(trans) do begin
  tmpdistance := {$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}tmpRGB.Red-self.palette[forer3].Red)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}tmpRGB.Green-self.palette[forer3].Green)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}tmpRGB.Blue-self.palette[forer3].Blue);
  if tmpdistance < closestdistance then begin
  closest:=forer3;
  closestdistance:=tmpdistance;
  end;
  end;
  self.Data[1+forer1*self.Width+forer2]:=chr(closest);
  end;
  end;
  end;
except
  showmessage('Reading the bitmap-data failed! Please report problem');
end;
end;





if dither then begin
try

begin
if (self.Palette[0].Red=1) and (self.Palette[0].green=0) and (self.Palette[0].blue=0)
then
trans:=true
else
trans:=false;

if trans then begin

setlength(transes,self.Width+1);

for forer1:=0 to self.Height-1 do
    for forer2:=1 to self.Width-1 do
        if (((TheImage[forer2,forer1].Red=1) and (theImage[forer2,forer1].green=0) and (theImage[forer2,forer1].blue=0)) or (whitetotrans and ((theImage[forer2,forer1].Red=255) and (theImage[forer2,forer1].green=255) and (theImage[forer2,forer1].blue=255)))) then
        transes[forer2]:= transes[forer2]+[forer1]
     //   else
     //   transes[forer2]:= transes[forer2]-[forer1];
end;

self.Data:='';
setlength(Data,Height*Width);
for forer1:=0 to self.Height-1 do begin
    for forer2:=1 to self.Width do begin
  if not(trans and (forer1 in transes[forer2]) )
  then begin
        closestdistance:=maxlongint;
        for forer3:=255 downto byte(trans) do begin
            tmpdistance:= {$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}theImage[forer2,forer1].red-self.Palette[forer3].Red)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}theImage[forer2,forer1].green-self.Palette[forer3].green)+{$IFDEF ED} sqr( {$ELSE} abs( {$ENDIF}theImage[forer2,forer1].Blue-self.Palette[forer3].Blue);
            if closestdistance > tmpdistance then begin
               closest:=forer3;
               closestdistance:=tmpdistance;
            end;
        end;
    self.Data[forer2+forer1*width]:=chr(closest);
    // to prevent colorbleeding...
   if not((theImage[forer2,forer1].red>255) or (theImage[forer2,forer1].red<-0)) then
    BRGBerror.Red:=(theImage[forer2,forer1].red-self.Palette[closest].Red)
    else BRGBerror.Red:=0;
    if not((theImage[forer2,forer1].Green>255) or (theImage[forer2,forer1].Green<-0)) then
    BRGBerror.Green:=(theImage[forer2,forer1].Green-self.Palette[closest].Green)
    else BRGBerror.Green:=0;
    if not((theImage[forer2,forer1].Blue>255) or (theImage[forer2,forer1].Blue<-0)) then
    BRGBerror.Blue:=(theImage[forer2,forer1].Blue-self.Palette[closest].Blue)
    else BRGBerror.Blue:=0;

         //changed the constants a little

       theImage[forer2+1,forer1].red:=theImage[forer2+1,forer1].red+BRGBerror.Red*3 shr 4       ;
       theImage[forer2+1,forer1].Green:=theImage[forer2+1,forer1].Green+BRGBerror.Green*3 shr 4  ;
       theImage[forer2+1,forer1].Blue:=theImage[forer2+1,forer1].Blue+BRGBerror.Blue*3 shr 4      ;

       theImage[forer2,forer1+1].red:=theImage[forer2,forer1+1].red+BRGBerror.Red*5 shr 4          ;
       theImage[forer2,forer1+1].Green:=theImage[forer2,forer1+1].Green+BRGBerror.Green*5 shr 4     ;
       theImage[forer2,forer1+1].Blue:=theImage[forer2,forer1+1].Blue+BRGBerror.Blue*5 shr 4         ;

       theImage[forer2+1,forer1+1].red:=theImage[forer2+1,forer1+1].red+BRGBerror.Red shr 4           ;
       theImage[forer2+1,forer1+1].Green:=theImage[forer2+1,forer1+1].Green+BRGBerror.Green shr 4      ;
       theImage[forer2+1,forer1+1].Blue:=theImage[forer2+1,forer1+1].Blue+BRGBerror.Blue shr 4          ;

       theImage[forer2-1,forer1+1].red:=theImage[forer2-1,forer1+1].red+BRGBerror.Red*3 shr 4            ;
       theImage[forer2-1,forer1+1].Green:=theImage[forer2-1,forer1+1].Green+BRGBerror.Green*3 shr 4       ;
       theImage[forer2-1,forer1+1].Blue:=theImage[forer2-1,forer1+1].Blue+BRGBerror.Blue*3 shr 4
    end
    else self.Data[forer2+forer1*width]:=#0;
    end;
end;
end;

except
  showmessage('Reading the data failed! Please report problem(dither)');
end;
end;

{$IFDEF YUV}//Y->G, U->B, V->R
for forer1:=0 to 255 do begin
Y:=self.palette[forer1].green;
U:=self.palette[forer1].blue;
V:=self.palette[forer1].red;
self.palette[forer1].red:=round(1.164*(Y - 16) + 1.596*(V - 128));
self.palette[forer1].green:=round(1.164*(Y - 16) - 0.813*(V - 128) - 0.391*(U - 128));
self.palette[forer1].blue:=round(1.164*(Y - 16)                   + 2.018*(U - 128));
end;
{$ENDIF}



except
result:=false;
exit;
end;
result:=true;
end;


function TLBAImage.sparaSPRIRAW:ansistring;
begin
result:=chr(08)+chr(0)+chr(0)+chr(0)+chr((length(data)+4) and $FF )+chr((length(data)+4)and $FF00 shr 8 )+chr((length(data)+4) shr 16 )+chr(0)+chr(self.Width)+chr(self.Height)+chr(0)+chr(0)+self.Data;
end;


procedure TLBAImage.laddapalett(theData :ansistring);
//var
type
PPalette=^TPalette;
begin
if (length(theData) <> 768)
then begin
showmessage('The palette size was not 768 bytes -.-');
exit;
end;
self.Palette:=PPalette(@thedata[1])^;
//PPalette:=@thedata[1];
//self.Palette:=PPalette^;
end;




function TLBAImage.sparaRAW:ansistring;
begin
result:=self.Data;
end;


procedure TLBAImage.SetLba1Palette;
begin
self.Palette:=LBA1Pal^;
end;

procedure TLBAImage.SetLba2Palette;
begin
self.Palette:=LBA2Pal^;
end;

function TLBAImage.sparaSPRITE(format:spriteformat = sprite;customoffset:boolean=false; Xoffset: byte=0; Yoffset: byte=0):ansistring;

var
Arrayen  :Array of Array of RLE;
strfil  :ansistring;
closesttowhite  :byte;   // Which to assume must be transparent
byteforer1  :byte;
byteforer2  :byte;
byteforer3  :byte;
tmpRGB  :RGB;
closestdistance:  integer;
tmpdistance:  integer;
tmpbyte1:  byte;
forer : integer;
begin
strfil:='';
if customoffset then begin
widthoffset:=Xoffset;
heightoffset:=Yoffset;
end;
closesttowhite:=0;

setlength(arrayen,height,width);

for byteforer1 := 0 to self.Height-1 do begin


for byteforer2:= 0 to self.Width-1 do begin
arrayen[byteforer1,byteforer2].pixelmode:=colordifferent;
end;

if self.Width>=3 then
 for byteforer2:= 0 to self.Width-3 do
 if (self.Data[byteforer1*self.Width+byteforer2+1]=self.Data[byteforer1*self.Width+byteforer2+2]) and (self.Data[byteforer1*self.Width+byteforer2+1]=self.Data[byteforer1*self.Width+byteforer2+3]) and (self.Data[byteforer2+byteforer1*self.Width+1]<>char(closesttowhite))
 // if data[byteforer2+1..3] are the same and not transcolor
 then
 begin
 arrayen[byteforer1,byteforer2].pixelmode:=colorfollow;
 arrayen[byteforer1,byteforer2+1].pixelmode:=colorfollow;
 arrayen[byteforer1,byteforer2+2].pixelmode:=colorfollow;
end;
    // For maximal compression
if self.Width>=2 then begin
   if (self.Data[byteforer1*self.Width+1]=self.Data[byteforer1*self.Width+2]) and (self.Data[byteforer1*self.Width+1]<>char(closesttowhite))
   then begin
         arrayen[byteforer1,0].pixelmode:=colorfollow;
         arrayen[byteforer1,1].pixelmode:=colorfollow;
   end;

   if (self.Data[byteforer1*self.Width+self.Width]=self.Data[byteforer1*self.Width+self.Width-1])
   then begin
         arrayen[byteforer1,self.Width-1].pixelmode:=colorfollow;
         arrayen[byteforer1,self.Width-2].pixelmode:=colorfollow;
   end;


end;

    //\\ For maximal compression

for byteforer2:= 0 to self.Width-1 do
 if (byte(self.Data[byteforer1*self.Width+byteforer2+1])=closesttowhite)
 // if data[byteforer2+1] are the same and NOT trans-color
 then
 arrayen[byteforer1,byteforer2].pixelmode:=transparent;



arrayen[byteforer1,0].first:=true;
arrayen[byteforer1,0].start:=1;
arrayen[byteforer1,0].length:=1;
arrayen[byteforer1,0].subline:=1;

if self.Width>=2 then
for byteforer2:= 1 to self.Width-1 do begin
if arrayen[byteforer1,byteforer2].pixelmode = arrayen[byteforer1,byteforer2-1].pixelmode then
//If same pixelmode as previous
  if ((arrayen[byteforer1,byteforer2].pixelmode=colorfollow) and  (self.Data[byteforer1*self.Width+byteforer2+1]<>self.Data[byteforer1*self.Width+byteforer2])) or (byteforer2-arrayen[byteforer1,byteforer2-1].start=63)

  then begin //if two different sublines are pixelmode=colorfollow yet having different colors !OR! if the very same subline has reached a size of 63 pixels (note that the  format's index byte only has 6 bits for length :)
    arrayen[byteforer1,byteforer2].subline:=arrayen[byteforer1,byteforer2-1].subline+1;
    arrayen[byteforer1,byteforer2].first:=true;
    arrayen[byteforer1,byteforer2].start:=byteforer2+1;
    for byteforer3:=arrayen[byteforer1,byteforer2-1].start to byteforer2 do
      arrayen[byteforer1,byteforer3-1].length:=1+byteforer2-arrayen[byteforer1,byteforer2-1].start;
    end

  else begin //in case of the subline continues
    arrayen[byteforer1,byteforer2].subline:=arrayen[byteforer1,byteforer2-1].subline;
    arrayen[byteforer1,byteforer2].first:=false;
    arrayen[byteforer1,byteforer2].start:=arrayen[byteforer1,byteforer2-1].start;
  end

else begin //If not same pixelmode as previous
  arrayen[byteforer1,byteforer2].subline:=arrayen[byteforer1,byteforer2-1].subline+1;
  arrayen[byteforer1,byteforer2].first:=true;
  arrayen[byteforer1,byteforer2].start:=byteforer2+1;
    for byteforer3:=arrayen[byteforer1,byteforer2-1].start to byteforer2 do
    arrayen[byteforer1,byteforer3-1].length:=1+byteforer2-arrayen[byteforer1,byteforer2-1].start;
end;


end;

    for byteforer3:=arrayen[byteforer1,self.Width-1].start-1 to self.Width-1 do
    arrayen[byteforer1,byteforer3].length:=1+self.Width-arrayen[byteforer1,self.Width-1].start;

//now begin fill in data  tmpbyte1 means next sublines location
strfil:=strfil+chr(arrayen[byteforer1,self.Width-1].subline);
tmpbyte1:=1;
for byteforer2:= 1 to arrayen[byteforer1,self.Width-1].subline do begin
if  arrayen[byteforer1,tmpbyte1-1].pixelmode=transparent then
strfil:=strfil+chr(arrayen[byteforer1,tmpbyte1-1].length-1);
if  arrayen[byteforer1,tmpbyte1-1].pixelmode=colordifferent then
strfil:=strfil+chr(64+arrayen[byteforer1,tmpbyte1-1].length-1)+copy(self.Data,byteforer1*self.Width+arrayen[byteforer1,tmpbyte1-1].start,arrayen[byteforer1,tmpbyte1-1].length);
if  arrayen[byteforer1,tmpbyte1-1].pixelmode=colorfollow then
strfil:=strfil+chr(128+arrayen[byteforer1,tmpbyte1-1].length-1)+self.Data[byteforer1*self.Width+tmpbyte1];
tmpbyte1:=arrayen[byteforer1,tmpbyte1-1].start+arrayen[byteforer1,tmpbyte1-1].length;
end;





end; //end for the heightloop



if format=sprite then
result:=chr(08)+chr(00)+chr(00)+chr(00)+chr(length(strfil)+4 )+chr((length(strfil)+4) shr 8)+chr((length(strfil)+4) shr 16)+chr(0)+chr(self.Width)+chr(self.Height)+chr(widthoffset)+chr(heightoffset)+strfil
else
result:=chr(self.Width)+chr(self.Height)+chr(widthoffset)+chr(heightoffset)+strfil;

end;

function TLBAImage.laddaRAW(theData:ansistring):byte;   // 0= fail, 1= Small, 2= Medium, 3= Large
begin

if (self.Palette[0].Red=1) and (self.Palette[0].green=0) and (self.Palette[0].blue=0)
then
self.Palette[0].Red:=0;

if not((length(thedata)=$10000) or (length(thedata)=$20000) or (length(thedata)=307200)) then
begin
failimage;
result:=0;
exit;
end;
Heightoffset:=0;
Widthoffset:=0;

case length(thedata) mod 3 of
0: begin height:=480; width:=640; result:=3 end;
1: begin height:=256; width:=256; result:=1 end;
2: begin height:=256; width:=512; result:=2 end;
end;
self.Data:=thedata;
end;

function TLBAImage.laddaSPRIRAW(theData:ansistring):boolean;
begin
try
if (self.Palette[0].Red=0) and (self.Palette[0].green=0) and (self.Palette[0].blue=0)
then
self.Palette[0].Red:=1;

if (thedata[1]=#8)// and ((byte(thedata[9])*byte(thedata[10])+12)=length(thedata)) and ((byte(thedata[5])+byte(thedata[6])shl 8+byte(thedata[7])shl 16)=length(thedata))
then begin
self.Data:=copy(theData,13,length(thedata)-12);
width:=byte(thedata[9]);
height:=byte(thedata[10]);
Widthoffset:=byte(thedata[11]);
Heightoffset:=byte(thedata[12]);
result:=true;
end
else
begin
failimage;
result:=false;
end;
except
failimage;
result:=false;
end;
end;

function TLBAImage.laddaSPRITE(theData :ansistring;format:spriteformat = sprite):boolean;     //This is a rip off from Zinks code to match my system
var a, b, c, PixCount, cX, cY, dPos: Integer;
    Flags, SubLines: Byte;
    Bit       :array of array of byte;
    intercept        :byte; // has the purpose of "m"-value in y=m+kx
    illegal:         boolean;
begin

{$R+}
if (self.Palette[0].Red=0) and (self.Palette[0].green=0) and (self.Palette[0].blue=0)
then
self.Palette[0].Red:=1;

try
if format = sprite
then intercept:=8
else
intercept:=0;

illegal:=false;
if format = sprite then begin
if not(thedata[1]=#8)
then illegal:=true;
if not((byte(thedata[5])+byte(thedata[6])shl 8+byte(thedata[7])shl 16)=length(thedata)-8)
then illegal:=true;
end;

if (byte(thedata[1+intercept])*byte(thedata[2+intercept])*3+5+intercept)<length(thedata)
then illegal:=true;


if illegal then begin
failimage;
result:=false;
exit;
end;

result:=true;

self.data:='';
 Width:=Byte(theData[1+intercept]); Height:=Byte(theData[2+intercept]);
 WidthOffset:=Byte(theData[3+intercept]); HeightOffset:=Byte(theData[4+intercept]);


 setlength(bit,width,height);

 for b:=0 to height-1 do
  for a:=0 to width-1 do
   Bit[a,b]:=0;

 cY:=0;
 dPos:=5+intercept;
 for a:=0 to Height-1 do begin
    SubLines:=byte(theData[dpos]);
  cX:=0;
  Inc(dPos);
  for b:=0 to SubLines-1 do begin
   Flags:=Byte(theData[dPos]);
   Inc(dPos);
   PixCount:=(Flags and $3F)+1;
   If (Flags and $40)<>0 then
    for c:=0 to PixCount-1 do begin
     Bit[cX,cY]:=Byte(theData[dPos]);
     Inc(dPos);
     Inc(cX);
    end
   else if (Flags and $80)<>0 then begin
    for c:=0 to PixCount-1 do begin
     Bit[cX,cY]:=Byte(theData[dPos]);
     Inc(cX);
    end;
    Inc(dPos);
   end
   else
    Inc(cX,PixCount);
  end;
  Inc(cY);
 end;


self.Data:='';
setlength(self.Data,height*width);
  for b:=0 to height-1 do
  for a:=0 to width-1 do
  self.data[a+b*width+1]:=chr(Bit[a,b]);

except
failimage;
result:=false;
exit;
end;

{$R-}
end;


initialization
LBA1pal:=@LBA1PalByteArray;
LBA2pal:=@LBA2PalByteArray;

end.
