unit ds1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RXShell, Menus, RxMenus;

var
  wClass:   TWndClass;  // class struct for main window
  hFont,                // handle of font
  hInst,                // handle of program (hinstance)
  hMemo,
  Handle:   HWND;       // handle of main window
  Msg:      TMSG;       // message struct
  hm: HMenu;
  CPos: TPoint;
  sWidth,
  sHeight: SmallInt;
  Interv: Integer;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    RxTrayIcon1: TRxTrayIcon;
    RxPopupMenu1: TRxPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Label4: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function CheckIddleTime: DWord;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure RxTrayIcon1DblClick(Sender: TObject);
    procedure ApplicationMinimize(Sender : TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
  sch: integer;
  first: boolean;
  znak : integer; // переменная кол-ва срабатываний таймера
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.CheckIddleTime: DWord;
var
   LastInput: TLastInputInfo;
begin
   LastInput.cbSize := SizeOf(TLastInputInfo);
   GetLastInputInfo(LastInput);
   Result := GetTickCount - LastInput.dwTime;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
{var
  t: TPoint;
  changex, changey: integer;
begin
  Label1.Caption:= 'Время простоя: ' + vartostr(CheckIddleTime/1000)+' секунд(ы)';
  GetCursorPos(t);
  sch:=sch+1;
  SetCursorPos(t.X+25,t.Y+25);
  If sch=10 then begin SetCursorPos(1,1); sch:=0; end;}

var dx,dy,i:integer;
    OldX,OldY:integer;
    t : TPoint;
begin
  if first then
   begin
       RxTrayIcon1.Active:=true;
       ShowWindow(Application.Handle, SW_HIDE);
     end;
  first:=false;
  if (Round(CheckIddleTime/1000))>Strtoint(edit1.text) then begin
  Label1.Caption:= 'Время простоя: ' + vartostr(Round(CheckIddleTime/1000))+' секунд(ы)';
  GetCursorPos(t);
  OldX:=t.X;
  OldY:=t.Y;
  dx:= 25;
  dy:= 25;
  if znak mod 2 = 0 then
   SetCursorPos(OldX - dx, OldY-dy) //Число четное - сдвигаем курсор влево вверх
   else
   SetCursorPos(OldX + dx, OldY+dy); //Число не четное - сдвигаем курсор вправо вниз
   znak:=znak+1;

  sleep(100);
 //Пять нажатий (нажатие + отпускание) клавиши F7
//  for i := 1 to 2 do begin
//    keybd_event(VK_F7, 0, 0, 0); //Нажатие F7.
    keybd_event(VK_F7, 0, KEYEVENTF_KEYUP, 0); //Отпускание F7.
    keybd_event(VK_F7, 0, KEYEVENTF_KEYUP, 0); //Отпускание F7.
    keybd_event(VK_F7, 0, KEYEVENTF_KEYUP, 0); //Отпускание F7.
//  end;

{  keybd_event(VK_LCONTROL, 0, 0, 0); //Нажатие левого Ctrl.
  keybd_event(VK_LSHIFT, 0, 0, 0); //Нажатие левого Shift.
  keybd_event(Ord('Z'), 0, 0, 0); //Нажатие 'z'.

  keybd_event(Ord('Z'), 0, KEYEVENTF_KEYUP, 0); //Отпускание 'z'.
  keybd_event(VK_LSHIFT, 0, KEYEVENTF_KEYUP, 0); //Отпускание левого Shift.
  keybd_event(VK_LCONTROL, 0, KEYEVENTF_KEYUP, 0); //Отпускание левого Ctrl.
}
  end;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  sch:=0;
  znak:=1;
  Application.Minimize;
end;

procedure TForm1.FormCreate(Sender: TObject);
var F:textfile;
    s:string;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  Application.OnMinimize:=ApplicationMinimize;
  first:=true;
  if fileage('set.ini')>0 then begin
    AssignFile(f,'set.ini');
    reset(f);
    readln(f,s);
    form1.Edit1.Text:=s;
    closefile(F);
  end;
end;

procedure TForm1.ApplicationMinimize(Sender : TObject);
begin
       RxTrayIcon1.Active:=true;
       ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var f:textfile;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  rewrite(f,'set.ini');
  writeln(f,edit1.text);
  closefile(F);
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
     Application.Restore; Application.BringToFront;
     ShowWindow(Application.Handle, SW_SHOWNORMAL);
     ShowWindow(Application.Handle, SW_RESTORE);
     RxTrayIcon1.Active:=false;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
 close;
end;

procedure TForm1.RxTrayIcon1DblClick(Sender: TObject);
begin
     Application.Restore; Application.BringToFront;
     ShowWindow(Application.Handle, SW_SHOWNORMAL);
     ShowWindow(Application.Handle, SW_RESTORE);
     RxTrayIcon1.Active:=false;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
// If ord(key)=13 then Application.Minimize;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 If ord(key)=13 then Application.Minimize;
end;

end.
