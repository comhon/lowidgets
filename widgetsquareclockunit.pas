unit widgetsquareclockunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  LoWidget, OsLevelUtils, LoWidgetsTimeUtils,
  ExtCtrls, StdCtrls;

type

  { TWidgetSquareClockForm }

  TWidgetSquareClockForm = class(TForm, ILoWidget)
    LabelHourH: TLabel;
    LabelHourL: TLabel;
    LabelMinH: TLabel;
    LabelMinL: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    ShapeHour: TShape;
    TimerClock: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerClockTimer(Sender: TObject);
  private
    procedure Configure(AController: TLoWidgetController);
  public

  end;

var
  WidgetSquareClockForm: TWidgetSquareClockForm;

implementation

{$R *.lfm}

{ TWidgetSquareClockForm }

procedure TWidgetSquareClockForm.TimerClockTimer(Sender: TObject);
var
  TimeRec: TLoWidgetTimeRec;
begin
  TimeRec:=DecodeLoWidgetTime(Now);

  LabelHourH.Caption:=timerec.Digits.HourH;
  LabelHourL.Caption:=timerec.Digits.HourL;
  LabelMinH.Caption :=timerec.Digits.MinH;
  LabelMinL.Caption :=timerec.Digits.MinL;
end;

procedure TWidgetSquareClockForm.Configure(AController: TLoWidgetController);
begin
  with AController do
  begin
    AssignEvents(Shape1);
    AssignEvents(Shape2);
    AssignEvents(ShapeHour);
    AssignEvents(LabelHourH);
    AssignEvents(LabelHourL);
    AssignEvents(LabelMinH);
    AssignEvents(LabelMinL);
  end;
end;

procedure TWidgetSquareClockForm.FormCreate(Sender: TObject);
begin
  SetTranslucent(Self.Handle, clFuchsia, 0);
end;


end.

