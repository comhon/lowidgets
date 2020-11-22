unit widgetresourcemonunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, OsLevelUtils, LoWidget;

type

  { TWidgetResourceMonForm }

  TWidgetResourceMonForm = class(TForm, ILoWidget)
    CheckBoxDebugBar: TCheckBox;
    ImageArrow: TImage;
    ImageRamChip: TImage;
    ShapeBar1Green: TShape;
    ShapeBar2Yellow: TShape;
    ShapeBar3Red: TShape;
    ShapeBar4Percent: TShape;
    ShapeBg: TShape;
    ShapeProgressHelper: TShape;
    TimerResMon: TTimer;
    TrackBarDebug: TTrackBar;
    procedure CheckBoxDebugBarChange(Sender: TObject);
    procedure TimerResMonTimer(Sender: TObject);
  private
    procedure Configure(AController: TLoWidgetController);
  public

  end;

var
  WidgetResourceMonForm: TWidgetResourceMonForm;

implementation

{$R *.lfm}

{ TWidgetResourceMonForm }

procedure TWidgetResourceMonForm.TimerResMonTimer(Sender: TObject);
var
  percent: cardinal;
begin
  if not TrackbarDebug.Enabled then
  begin
    percent := GetRamUssage;
  end
  else
  begin
    percent := TrackBarDebug.Position;
  end;

  ShapeBar4Percent.Width:=Trunc(percent/100 * ShapeProgressHelper.Width);

  ImageArrow.Left:=ShapeProgressHelper.Left+ShapeBar4Percent.Width-ImageArrow.Width div 2;
end;

procedure TWidgetResourceMonForm.Configure(AController: TLoWidgetController);
begin
  with AController do
  begin
    AssignEvents(ShapeBg);
    AssignEvents(ShapeBar1Green);
    AssignEvents(ShapeBar2Yellow);
    AssignEvents(ShapeBar3Red);
    AssignEvents(ShapeBar4Percent);
  end;
end;

procedure TWidgetResourceMonForm.CheckBoxDebugBarChange(Sender: TObject);
begin
  TrackBarDebug.Enabled:=CheckBoxDebugBar.Checked;
end;

end.

