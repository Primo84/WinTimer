unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,shellapi, Menus;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    BitBtn2: TBitBtn;
    pp1: TPopupMenu;
    Zamknij1: TMenuItem;
    Przywroc1: TMenuItem;
    BitBtn3: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Zamknij1Click(Sender: TObject);
    procedure popup(var msg :tmessage);message wm_user+1;
    procedure BitBtn3Click(Sender: TObject);
    procedure Przywroc1Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure koniec(a:cardinal);
    { Public declarations }
  end;

var
  Form1: TForm1;
  g,min,sek:integer;
  start:boolean;
  czas:integer;
  tim,restart:boolean;
  ic:TNOTIFYICONDATA;
implementation

uses Unit2;
procedure tform1.popup(var msg :tmessage);
var
p:tpoint;
begin
if msg.LParam=WM_RBUTTONDOWN then
  begin
  getcursorpos(p);
  pp1.Popup(p.X,p.Y);
  end;
end;

procedure tform1.koniec(a:cardinal);
var
ver:tosversioninfo;
han:thandle;
pr,pr1:token_privileges;
s1,s2:dword;
begin
ver.dwOSVersionInfoSize:=sizeof(ver);
getversionex(ver);
if ver.dwPlatformId<>VER_PLATFORM_WIN32_NT then exitwindowsex(a or EWX_FORCE,0)
  else
  begin
  OpenProcessToken(getcurrentprocess(),TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,han);
  LookupPrivilegeValue(nil,'seshutdownprivilege',pr.Privileges[0].Luid);
  pr.PrivilegeCount:=1;
  pr.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  s1:=sizeof(pr1);
  s2:=0;
  windows.AdjustTokenPrivileges(han,false,pr,s1,pr1,s2);
  exitwindowsex(a or EWX_FORCE,0);
  end;
end;
{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
if tim then
  begin
  showmessage('Timer jest juz ustawiony');
  exit;
  end;
form2:=tform2.create(self);
if form2.ShowModal=mrok then
  begin
  if start then
    begin
    czas:=(g*3600)+(min*60)+sek;
    timer1.Enabled:=true;
    tim:=true;
    end;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
res,dz:integer;
begin
dz:=czas div 3600;
edit1.Text:=inttostr(dz);
res:=czas mod 3600;
dz:= res div 60;
edit2.Text:= inttostr(dz);
dz:=res- dz*60;
edit3.Text:=inttostr(dz);
czas:=czas-1;
if czas<0 then
begin
timer1.Enabled:=false;
tim:=false;
sendmessage(hwnd_broadcast,wm_quit,0,0);
if restart then koniec(EWX_REBOOT) else koniec(EWX_POWEROFF);
close;
end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
if application.MessageBox('Czy napewno chcesz wylaczyc timer','Stop',mb_yesNo)=idyes then
begin
timer1.Enabled:=false;
tim:=false;
edit1.Text:='';
edit2.Text:='';
edit3.Text:='';
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
tim:=false;
ic.cbSize:=sizeof(ic);
ic.Wnd:=handle;
ic.uID:=10;
ic.uFlags:=NIF_ICON+NIF_MESSAGE+NIF_TIP;
ic.uCallbackMessage:=wm_user+1;
ic.hIcon:=application.Icon.Handle;
ic.szTip:='WinTimer';
end;

procedure TForm1.Zamknij1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
Shell_NotifyIcon(NIM_ADD,@ic);
form1.Hide;
end;

procedure TForm1.Przywroc1Click(Sender: TObject);
begin
Shell_NotifyIcon(NIM_Delete,@ic);
form1.Show;
end;

end.
