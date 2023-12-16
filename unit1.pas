unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes
  , SysUtils
  , Forms
  , Controls
  , Graphics
  , Dialogs
  , ActnList
  , StdCtrls
  , LCL
  , LCLIntf
  , LMessages
  //, TLMessage
  ;

const
  WM_KILLHIMSELF_MSG = WM_USER + $101;//прибиваем самих себя
type

  { TForm1 }

  TForm1 = class(TForm)
    ActCompCreate: TAction;
    ActCompKill: TAction;
    ActionList1: TActionList;
    procedure ActCompCreateExecute(Sender: TObject);
    procedure ActCompKillExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Fcnt: Integer;
  public
    procedure WMKillHimself(var Msg: TLMessage); message WM_KILLHIMSELF_MSG;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ActCompCreateExecute(Sender: TObject);
var
  btn: TButton = nil;
  myPoint: TPoint;
begin
  btn:= TButton.Create(Self);

  myPoint:= ScreenToClient(Mouse.CursorPos);

  with btn do
  begin
    Left:= myPoint.X;
    Top:= myPoint.Y;
    Width:= 75;
    Height:= 25;
    Inc(Fcnt);
    Name:= Format('button_%d',[Fcnt]);
    Caption:= Name;
    OnClick:= @ActCompKillExecute;
    Parent:= Self;
  end;
end;

procedure TForm1.ActCompKillExecute(Sender: TObject);
var
  msg: TLMessage;
begin
  if not TObject(Sender).InheritsFrom(TButton) then Exit;
  msg.wParam:= PtrInt(TButton(Sender));
  PostMessage(Self.Handle,WM_KILLHIMSELF_MSG,msg.wParam,0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Fcnt:= 0;
  Self.OnClick:= @ActCompCreateExecute;
end;

procedure TForm1.WMKillHimself(var Msg: TLMessage);
var
  btn: TButton = nil;
begin
  btn:= TButton(Msg.wParam);
  if Assigned(btn) then btn.Free;
end;

end.

