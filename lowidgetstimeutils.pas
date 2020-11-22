unit LoWidgetsTimeUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TLoWidgetTimeRec = record
    hh,mm,ss,ms: Word;
    Digits: record
      HourH: string;
      HourL: string;
      MinH: string;
      MinL: string;
    end;
    TimeStr: string;
  end;

  function DecodeLoWidgetTime(ADateTime: TDateTime): TLoWidgetTimeRec;

implementation

function DecodeLoWidgetTime(ADateTime: TDateTime): TLoWidgetTimeRec;
begin
  with result do
  begin
    DecodeTime(ADateTime,hh,mm,ss,ms);
    TimeStr:=Format('%.*d',[2, hh])+':'+Format('%.*d',[2, mm]);
    Digits.HourH:=timestr[1];
    Digits.HourL:=timestr[2];
    Digits.MinH :=timestr[4];
    Digits.MinL :=timestr[5];
  end;
end;

end.

