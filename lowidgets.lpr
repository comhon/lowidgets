program lowidgets;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LoWidgetsCtrlUnit, widgetsquareclockunit, widgetresourcemonunit,
  OsLevelUtils, lowidget, LoWidgetsTimeUtils;

{$R *.res}

var
  aStartInTray: boolean;

begin
  RequireDerivedFormResource:=True;
  Application.Title:='LoWidgets';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TCtrlForm, CtrlForm);

  aStartInTray:=true;

  if aStartInTray then
  begin
    Application.ShowMainForm:=false;
    CtrlForm.TrayIcon.Visible:=true;
  end;
  Application.Run;
end.

