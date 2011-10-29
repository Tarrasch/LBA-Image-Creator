

//I just use this to easly make image conversions... Not optimal method but it works :).
Unit ImageConverter;

{$mode objfpc}{$H+}
interface
uses SysUtils, magick_wand, ImageMagick;

procedure ThrowWandException(wand: PMagickWand);
procedure Convert(inimage,outimage:TFilename);


implementation
procedure ThrowWandException(wand: PMagickWand);
var
  description: PChar;
  severity: ExceptionType;
begin
  description := MagickGetException(wand, @severity);
  WriteLn(Format('An error ocurred. Description: %s', [description]));
  description := MagickRelinquishMemory(description);
  Abort;
end;

procedure Convert(inimage,outimage:TFilename);
var
  status: MagickBooleanType;
  wand: PMagickWand;
begin
  { Read an image. }

  MagickWandGenesis;

  wand := NewMagickWand;

  try
    status := MagickReadImage(wand, @inimage[1]);
    if (status = MagickFalse) then ThrowWandException(wand);

    { Turn the images into a thumbnail sequence. }

    MagickResetIterator(wand);

    {while (MagickNextImage(wand) <> MagickFalse) do
     MagickResizeImage(wand, 106, 80, LanczosFilter, 1.0);
    }
    { Write the image as MIFF and destroy it. }

    status := MagickWriteImages(wand,@outimage[1], MagickTrue);
    if (status = MagickFalse) then ThrowWandException(wand);

  finally
    wand := DestroyMagickWand(wand);

    MagickWandTerminus;
  end;
end;
end.
