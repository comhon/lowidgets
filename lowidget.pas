unit lowidget;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, ExtCtrls, Dialogs, IniFiles;

type

{ TLoWidgetController }

TLoWidgetController = class
private
  FControlledForm: TForm;
  FMouseIsDown: boolean;
  FMouseCursorOrigin: TPoint;

  procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  procedure LoadPosition;
  procedure SavePosition;
public
  procedure AssignEvents(AControl: TControl);
  constructor Create(AForm: TForm);
  destructor Destroy; override;

  property ControlledForm: TForm read FControlledForm;
end;



ILoWidget = interface
  procedure Configure(AController: TLoWidgetController);
end;

const
  c_config_file = 'lowidgets.ini';


implementation

{ TLoWidgetController }

procedure TLoWidgetController.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FMouseIsDown then
  begin
    if (FControlledForm = nil) then Exit;

    FControlledForm.Left:=FControlledForm.Left + (X - FMouseCursorOrigin.X);
    FControlledForm.Top :=FControlledForm.Top  + (Y - FMouseCursorOrigin.Y);
  end;
end;

procedure TLoWidgetController.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseIsDown:=false;
end;

procedure TLoWidgetController.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseIsDown:=true;
  FMouseCursorOrigin.X:=X;
  FMouseCursorOrigin.Y:=Y;
end;

procedure TLoWidgetController.LoadPosition;
var
  aIni: TIniFile;
  aSection: string;
begin
  aIni:=TIniFile.Create(c_config_file);
  aSection:=FControlledForm.ClassName;
  try
    FControlledForm.Left    := aIni.ReadInteger(aSection,'Left',    FControlledForm.Left   );
    FControlledForm.Top     := aIni.ReadInteger(aSection,'Top',     FControlledForm.Top    );
    FControlledForm.Visible := aIni.ReadBool(   aSection,'Visible', True );
  finally
    aIni.Free;
  end;
end;

procedure TLoWidgetController.SavePosition;
var
  aIni: TIniFile;
  aSection: string;
begin
  aIni:=TIniFile.Create(c_config_file);
  aSection:=FControlledForm.ClassName;
  try
    aIni.WriteInteger(aSection,'Left',    FControlledForm.Left   );
    aIni.WriteInteger(aSection,'Top',     FControlledForm.Top    );
    aIni.WriteBool   (aSection,'Visible', FControlledForm.Visible);
  finally
    aIni.Free;
  end;

end;

procedure TLoWidgetController.AssignEvents(AControl: TControl);
begin
  if not Assigned(AControl) then
  begin
    Exit;
  end;

  if (AControl is TForm) then with TForm(AControl) do
  begin
    OnMouseDown:=@MouseDown;
    OnMouseMove:=@MouseMove;
    OnMouseUp  :=@MouseUp;
  end;

  if (AControl is TShape) then with TShape(AControl) do
  begin
    OnMouseDown:=@MouseDown;
    OnMouseMove:=@MouseMove;
    OnMouseUp  :=@MouseUp;
  end;

  if (AControl is TLabel) then with TLabel(AControl) do
  begin
    OnMouseDown:=@MouseDown;
    OnMouseMove:=@MouseMove;
    OnMouseUp  :=@MouseUp;
  end;

end;


constructor TLoWidgetController.Create(AForm: TForm);
begin
  FControlledForm:=AForm;
  FMouseCursorOrigin.X:=0;
  FMouseCursorOrigin.Y:=0;
  FMouseIsDown:=false;

  AssignEvents(AForm);
  LoadPosition;
end;

destructor TLoWidgetController.Destroy;
begin
  SavePosition;
  inherited Destroy;
end;

end.

