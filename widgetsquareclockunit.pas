unit widgetsquareclockunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  LoWidget, OsLevelUtils, LoWidgetsTimeUtils,
  ExtCtrls, StdCtrls, DWMUtils;

type

  { TWidgetSquareClockForm }

  TWidgetSquareClockForm = class(TForm, ILoWidget)
    LabelHourH: TLabel;
    LabelHourL: TLabel;
    LabelMinH: TLabel;
    LabelMinL: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    ShapeMin: TShape;
    ShapeHour: TShape;
    ShapeColorBar: TShape;
    TimerClock: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerClockTimer(Sender: TObject);
  private
    procedure UpdateColorBar;
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

  UpdateColorBar;
end;

procedure TWidgetSquareClockForm.UpdateColorBar;
var
  aPalette: TAccentPalette;
begin
  SetTranslucent(Self.Handle, clFuchsia, 0);

  aPalette:=GetAccentPaletteColors;

  Shape1.Brush.color:=aPalette[0].Value;
  Shape2.Brush.color:=aPalette[1].Value;
  Shape3.Brush.color:=aPalette[2].Value;
  Shape4.Brush.color:=aPalette[3].Value;
  Shape5.Brush.color:=aPalette[4].Value;
  Shape6.Brush.color:=aPalette[5].Value;
  Shape7.Brush.color:=aPalette[6].Value;
  Shape8.Brush.color:=aPalette[7].Value;

  ShapeColorBar.Brush.Color:=aPalette[3].Value;
  ShapeColorBar.Pen.Color:=aPalette[4].Value;
end;

procedure TWidgetSquareClockForm.Configure(AController: TLoWidgetController);
begin
  with AController do
  begin
    AssignEvents(ShapeMin);
    AssignEvents(ShapeHour);
    AssignEvents(ShapeColorBar);
    AssignEvents(LabelHourH);
    AssignEvents(LabelHourL);
    AssignEvents(LabelMinH);
    AssignEvents(LabelMinL);
  end;
end;

procedure TWidgetSquareClockForm.FormCreate(Sender: TObject);
begin
  SetTranslucent(Self.Handle, clFuchsia, 0);

  UpdateColorBar;
end;


end.

