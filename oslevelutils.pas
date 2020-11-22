unit OsLevelUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows;

function GetRamUssage: cardinal;
procedure SetTranslucent(ThehWnd: longint; Color: longint; nTrans: integer);

implementation

type
  DWORDLONG = UInt64;

  PMemoryStatusEx = ^TMemoryStatusEx;
  TMemoryStatusEx = packed record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: DWORDLONG;
    ullAvailPhys: DWORDLONG;
    ullTotalPageFile: DWORDLONG;
    ullAvailPageFile: DWORDLONG;
    ullTotalVirtual: DWORDLONG;
    ullAvailVirtual: DWORDLONG;
    ullAvailExtendedVirtual: DWORDLONG;
  end;

function GlobalMemoryStatusEx(var lpBuffer: TMemoryStatusEx): BOOL; stdcall; external kernel32;

function GetRamUssage: cardinal;
var
  MemStatus: TMemoryStatusEx;
begin
  FillChar(MemStatus, SizeOf(MemStatus), 0);
  MemStatus.dwLength := SizeOf(MemStatus);

  Win32Check(GlobalMemoryStatusEx(MemStatus));

  result:= 100-((MemStatus.ullAvailPhys * 100) div MemStatus.ullTotalPhys);
end;

//Make your forms transparent!
//Adnan Shameem
//http://lazplanet.blogspot.com/2013/04/make-your-forms-transparent.html

const
  LWA_COLORKEY = 1;
  LWA_ALPHA = 2;
  LWA_BOTH = 3;
  WS_EX_LAYERED = $80000;
  GWL_EXSTYLE = -20;

{Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal Color As Long, ByVal X As Byte, ByVal alpha As Long) As Boolean }
function SetLayeredWindowAttributes(hWnd: longint; Color: longint;
  X: byte; alpha: longint): bool stdcall; external 'USER32';

{not sure how to alias these functions here ????   alias setwindowlonga!!}
{Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long }
function SetWindowLongA(hWnd: longint; nIndex: longint;
  dwNewLong: longint): longint stdcall; external 'USER32';

{Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long }
function GetWindowLongA(hWnd: longint; nIndex: longint): longint stdcall;
  external 'user32';

procedure SetTranslucent(ThehWnd: longint; Color: longint; nTrans: integer);
var
  Attrib: longint;
begin
  {SetWindowLong and SetLayeredWindowAttributes are API functions, see MSDN for details }
  Attrib := GetWindowLongA(ThehWnd, GWL_EXSTYLE);
  SetWindowLongA(ThehWnd, GWL_EXSTYLE, attrib or WS_EX_LAYERED);
  {anything with color value color will completely disappear if flag = 1 or flag = 3  }
  SetLayeredWindowAttributes(ThehWnd, Color, nTrans, 1);
end;

end.

