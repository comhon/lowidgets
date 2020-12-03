unit DWMUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Registry, SPGetSid, Graphics;

type
  TAccentPaletteBinary = array [0..31] of Byte;

  TColorRegistrySetting = record
    ColorizationColor: Integer;
    ColorizationAfterglow: Integer;
    ColorizationAccentColor: Integer;
    AccentPalette: TAccentPaletteBinary;
    StartColorMenu: Integer;
    AccentColorMenu: Integer;
  end;

  TMyColor = packed record
    case Integer of
      0: (Value: TColor);
      1: (Bytes: array [0..3] of Byte);
  end;

  TRegColor = packed record
    case Integer of
      0: (Value: integer);
      1: (R: Byte; G: Byte; B: Byte; A: Byte);
  end;

  TAccentPalette = array [0..7] of TMyColor;

function GetAccentPaletteColors: TAccentPalette;
function AccentPaletteToString(aPalette: TAccentPaletteBinary): String;

procedure SaveColorRegistrySetting(aSetting:TColorRegistrySetting);
function LoadColorRegistrySetting: TColorRegistrySetting;

function RegDword2Color(aRegDword: integer): TColor;

implementation

function GetAccentPaletteColors: TAccentPalette;
var
  aPalette: TAccentPalette;
  aPaletteBinary: TAccentPaletteBinary;
  aMyColor: TMyColor;
  i,j: integer;
begin
  aPaletteBinary:=LoadColorRegistrySetting.AccentPalette;

  for i:= 0 to 7 do
  begin
    j:=i*4;
    aMyColor.Bytes[0]:=aPaletteBinary[j+0];
    aMyColor.Bytes[1]:=aPaletteBinary[j+1];
    aMyColor.Bytes[2]:=aPaletteBinary[j+2];
    aMyColor.Bytes[3]:=aPaletteBinary[j+3];
    aPalette[i]:=aMyColor;
  end;

  result:=aPalette;
end;

function AccentPaletteToString(aPalette: TAccentPaletteBinary): String;
var
  i: integer;
begin
  result:='';
  for i:= Low(TAccentPaletteBinary) to High(TAccentPaletteBinary) do
  begin
    result:=result+Format('%.2x',[aPalette[i]])+' ';
  end;
end;

procedure SaveColorRegistrySetting(aSetting:TColorRegistrySetting);
var
  reg: TRegistry;
begin
  reg:=TRegistry.Create(KEY_WRITE);
  try
    reg.RootKey:=HKEY_CURRENT_USER;
    if not reg.OpenKey('Software\Microsoft\Windows\DWM\',false) then
    begin
      Exit;
    end;
    reg.WriteInteger('ColorizationColor',      aSetting.ColorizationColor);
    reg.WriteInteger('ColorizationAfterglow',  aSetting.ColorizationAfterGlow);
    reg.WriteInteger('ColorizationAccentColor',aSetting.ColorizationAccentColor);

    reg.CloseKey;

    reg.RootKey:=HKEY_USERS;
    if not reg.OpenKey(GetCurrentUserSid+'\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent',false) then
    begin
      Exit;
    end;

    reg.WriteBinaryData('AccentPalette', aSetting.AccentPalette, Length(aSetting.AccentPalette) * SizeOf(Byte) );
    reg.WriteInteger('StartColorMenu', aSetting.StartColorMenu);
    reg.WriteInteger('AccentColorMenu',aSetting.AccentColorMenu);

    reg.CloseKey;

  finally
    reg.Free;
  end;

end;

function LoadColorRegistrySetting: TColorRegistrySetting;
var
  reg: TRegistry;
begin
  reg:=TRegistry.Create(KEY_READ);
  try
    reg.RootKey:=HKEY_CURRENT_USER;
    if not reg.OpenKey('Software\Microsoft\Windows\DWM\',false) then
    begin
      Exit;
    end;

    result.ColorizationColor      :=reg.ReadInteger('ColorizationColor');
    result.ColorizationAfterGlow  :=reg.ReadInteger('ColorizationAfterglow');
    //result.ColorizationAccentColor:=reg.ReadInteger('ColorizationAccentColor');

    reg.CloseKey;

    reg.RootKey:=HKEY_USERS;
    if not reg.OpenKey(GetCurrentUserSid+'\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent',false) then
    begin
      Exit;
    end;

    reg.ReadBinaryData('AccentPalette', result.AccentPalette, Length(result.AccentPalette) * SizeOf(Byte) );

    result.StartColorMenu:=reg.ReadInteger('StartColorMenu');
    result.AccentColorMenu:=reg.ReadInteger('AccentColorMenu');

    reg.CloseKey;

  finally
    reg.Free;
  end;

end;

function RegDword2Color(aRegDword: integer): TColor;
var
  ARegColor:TRegColor;
begin
  ARegColor.Value:=aRegDword;
  result:=RGBToColor(aRegColor.R,aRegColor.G,aRegColor.B);
end;


end.

