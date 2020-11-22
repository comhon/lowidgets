unit LoWidgetsCtrlUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  StdCtrls, widgetsquareclockunit, widgetresourcemonunit, lowidget, FileInfo;

type

  { TCtrlForm }

  TCtrlForm = class(TForm)
    CheckBoxResourceMon: TCheckBox;
    CheckBoxSquareClock: TCheckBox;
    MainMenuBar: TMainMenu;
    ItemFile: TMenuItem;
    ItemFileHide: TMenuItem;
    ItemFileClose: TMenuItem;
    ItemPopupShow: TMenuItem;
    ItemPopupClose: TMenuItem;
    ItemHelp: TMenuItem;
    ItemHelpAbout: TMenuItem;
    PopupMenuTray: TPopupMenu;
    TrayIcon: TTrayIcon;
    procedure CheckBoxResourceMonChange(Sender: TObject);
    procedure CheckBoxSquareClockChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ItemFileCloseClick(Sender: TObject);
    procedure ItemFileHideClick(Sender: TObject);
    procedure ItemPopupCloseClick(Sender: TObject);
    procedure ItemPopupShowClick(Sender: TObject);
    procedure ItemHelpAboutClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
  private
    FResMon:TWidgetResourceMonForm;
    FResMonCtrl:TLoWidgetController;

    FSquareClock:TWidgetSquareClockForm;
    FSquareClockCtrl:TLoWidgetController;
  public
    procedure SendToTray;
    procedure RestoreFromTray;
  end;

var
  CtrlForm: TCtrlForm;

implementation

type
  { TVersion }
  TVersion = class (TPersistent)
  private
    FBuild: Integer;
    FMajor: Integer;
    FMinor: Integer;
    FVersion: Integer;
  published
    property Version: Integer read FVersion write FVersion;
    property Major: Integer read FMajor write FMajor;
    property Minor: Integer read FMinor write FMinor;
    property Build: Integer read FBuild write FBuild;
  end;

{$R *.lfm}

{ TCtrlForm }

procedure TCtrlForm.FormCreate(Sender: TObject);
begin
  FSquareClock:=TWidgetSquareClockForm.Create(Self);
  FSquareClockCtrl:=TLoWidgetController.Create(FSquareClock);
  ILoWidget(FSquareClock).Configure(FSquareClockCtrl);

  FResMon:=TWidgetResourceMonForm.Create(Self);
  FResMonCtrl:=TLoWidgetController.Create(FResMon);
  ILoWidget(FResMon).Configure(FResMonCtrl);

  CheckBoxSquareClock.Checked:=FSquareClock.Visible;
  CheckBoxResourceMon.Checked:=FResMon.Visible;
end;

procedure TCtrlForm.FormDestroy(Sender: TObject);
begin
  //close the controller first
  FSquareClockCtrl.Free;
  FResMonCtrl.Free;

  inherited Destroy;
end;

procedure TCtrlForm.CheckBoxSquareClockChange(Sender: TObject);
begin
  if CheckBoxSquareClock.Checked then
  begin
    FSquareClock.Show;
  end
  else
  begin
    FSquareClock.Hide;
  end;
end;

procedure TCtrlForm.CheckBoxResourceMonChange(Sender: TObject);
begin
  if CheckBoxResourceMon.Checked then
  begin
    FResMon.Show;
  end
  else
  begin
    FResMon.Hide;
  end;
end;

procedure TCtrlForm.FormShow(Sender: TObject);
begin

end;

procedure TCtrlForm.ItemFileCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TCtrlForm.ItemFileHideClick(Sender: TObject);
begin
  SendToTray;
end;

procedure TCtrlForm.ItemPopupCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TCtrlForm.ItemPopupShowClick(Sender: TObject);
begin
  RestoreFromTray;
end;

procedure TCtrlForm.ItemHelpAboutClick(Sender: TObject);
var
  aVersionInfo:TVersionInfo;
  VersionInfo:TVersion;
begin
  aVersionInfo:=TVersionInfo.Create;
  VersionInfo:=TVersion.Create;
  try
    aVersionInfo.Load(HINSTANCE);
    VersionInfo.Version:=aVersionInfo.FixedInfo.FileVersion[0];
    VersionInfo.Major:=aVersionInfo.FixedInfo.FileVersion[1];
    VersionInfo.Minor:=aVersionInfo.FixedInfo.FileVersion[2];
    VersionInfo.Build:=aVersionInfo.FixedInfo.FileVersion[3];
  finally
    if assigned(aVersionInfo) then aVersionInfo.Free;
  end;

  ShowMessage('LoWidgets'+' '+Format('%d.%d.%d',[VersionInfo.Version,VersionInfo.Major,VersionInfo.Minor])
  +sLineBreak
  +sLineBreak+'(c) Jan Štěpán 2020'
  +sLineBreak+'comhon.software@gmail.com'
  +sLinebreak
  +sLineBreak+'Inspired by:'
  +sLineBreak+'Square Clock and Resource Monitor from "Widgets Launcher"'
  +sLineBreak+'Chan Software Solutions, Windows Store App'
  +sLinebreak
  +sLineBreak+'Credits:'
  +sLineBreak+'Icons8 - Square Clock icon'
  +sLineBreak+'https://icons8.com/icons/set/square-clock'
  +sLinebreak
  );

end;

procedure TCtrlForm.TrayIconClick(Sender: TObject);
begin
  RestoreFromTray;
end;

procedure TCtrlForm.SendToTray;
begin
  TrayIcon.Visible:=true;
  Self.Visible:=false;
end;

procedure TCtrlForm.RestoreFromTray;
begin
  Self.Visible:=true;
  TrayIcon.Visible:=false;
end;

end.

