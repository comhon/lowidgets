unit widgetstatusbarunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  LoWidget, OSLevelUtils;

type

  { TWidgetStatusBarForm }

  TWidgetStatusBarForm = class(TForm, ILoWidget)
    LabelMemText: TLabel;
    LabelMem: TLabel;
    TimerResources: TTimer;
    procedure TimerResourcesTimer(Sender: TObject);
  private

  public
    procedure Configure(AController: TLoWidgetController);
  end;

var
  WidgetStatusBarForm: TWidgetStatusBarForm;

implementation

{$R *.lfm}

{ TWidgetStatusBarForm }

procedure TWidgetStatusBarForm.TimerResourcesTimer(Sender: TObject);
var
  percent : integer;
begin
  percent := GetRamUssage;
  LabelMem.Caption:=percent.ToString + '%';
end;

procedure TWidgetStatusBarForm.Configure(AController: TLoWidgetController);
begin
  with AController do
  begin
    AssignEvents(LabelMem);
    AssignEvents(LabelMemText);
  end;
end;

end.

