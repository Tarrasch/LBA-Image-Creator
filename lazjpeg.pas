{ Copyright (C) 2003 Mattias Gaertner

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}
unit LazJPEG;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, FPImage, IntfGraphics, Graphics, FPReadJPEG, FPWriteJPEG,
  ClipBrd;

type
  TJPEGQualityRange = TFPJPEGCompressionQuality;
  TJPEGPerformance = TJPEGReadPerformance;

  TJPEGImage = class(TFPImageBitmap)
  private
    FPerformance: TJPEGPerformance;
    FProgressiveEncoding: boolean;
    FQuality: TJPEGQualityRange;
  protected
    procedure InitFPImageReader(IntfImg: TLazIntfImage; ImgReader: TFPCustomImageReader); override;
    procedure FinalizeFPImageReader(ImgReader: TFPCustomImageReader); override;
    procedure InitFPImageWriter(IntfImg: TLazIntfImage; ImgWriter: TFPCustomImageWriter); override;
  public
    constructor Create; override;
    class function GetFileExtensions: string; override;
    class function GetDefaultFPReader: TFPCustomImageReaderClass; override;
    class function GetDefaultFPWriter: TFPCustomImageWriterClass; override;
  public
    property CompressionQuality: TJPEGQualityRange read FQuality write FQuality;
    property ProgressiveEncoding: boolean read FProgressiveEncoding;
    property Performance: TJPEGPerformance read FPerformance write FPerformance;
  end;

const
  DefaultJPEGMimeType = 'image/jpeg';


implementation


{ TJPEGImage }

procedure TJPEGImage.InitFPImageReader(IntfImg: TLazIntfImage; ImgReader: TFPCustomImageReader);
var
  JPEGReader: TFPReaderJPEG;
begin
  if ImgReader is TFPReaderJPEG then begin
    JPEGReader:=TFPReaderJPEG(ImgReader);
    JPEGReader.Performance:=Performance;
    JPEGReader.OnProgress:=@Progress;
  end;
  inherited InitFPImageReader(IntfImg, ImgReader);
end;

procedure TJPEGImage.FinalizeFPImageReader(ImgReader: TFPCustomImageReader);
var
  JPEGReader: TFPReaderJPEG;
begin
  if ImgReader is TFPReaderJPEG then begin
    JPEGReader:=TFPReaderJPEG(ImgReader);
    FProgressiveEncoding:=JPEGReader.ProgressiveEncoding;
  end;
  inherited FinalizeFPImageReader(ImgReader);
end;

procedure TJPEGImage.InitFPImageWriter(IntfImg: TLazIntfImage; ImgWriter: TFPCustomImageWriter);
var
  JPEGWriter: TFPWriterJPEG;
begin
  if ImgWriter is TFPWriterJPEG then begin
    JPEGWriter:=TFPWriterJPEG(ImgWriter);
    if JPEGWriter<>nil then ;
    JPEGWriter.ProgressiveEncoding:=ProgressiveEncoding;
    JPEGWriter.CompressionQuality:=CompressionQuality;
    JPEGWriter.OnProgress:=@Progress;
  end;
  inherited InitFPImageWriter(IntfImg, ImgWriter);
end;

class function TJPEGImage.GetDefaultFPReader: TFPCustomImageReaderClass;
begin
  Result:=TFPReaderJPEG;
end;

class function TJPEGImage.GetDefaultFPWriter: TFPCustomImageWriterClass;
begin
  Result:=TFPWriterJPEG;
end;

constructor TJPEGImage.Create;
begin
  inherited Create;
  FPerformance:=jpBestQuality;
  FProgressiveEncoding:=false;
  FQuality:=75;
end;

class function TJPEGImage.GetFileExtensions: string;
begin
  Result:='jpg;jpeg';
end;

initialization
  TPicture.RegisterFileFormat('jpg', 'JPEG Image File', TJPEGImage);
  TPicture.RegisterFileFormat('jpeg', 'JPEG Image File', TJPEGImage);
  TPicture.RegisterClipboardFormat(RegisterClipboardFormat(DefaultJPEGMimeType),
    TJPEGImage);

finalization
  TPicture.UnregisterGraphicClass(TJPEGImage);

end.

