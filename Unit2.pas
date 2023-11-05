unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    rb1: TRadioButton;
    rb2: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses unit1;
{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
try
if edit1.Text='' then g:=0 else g:=strtoint(edit1.Text);
if edit2.Text='' then min:=0 else min:=strtoint(edit2.Text);
if edit3.Text='' then sek:=0 else sek:=strtoint(edit3.Text);
except
showmessage('Musisz wprowadzic same liczby');
start:=false;
exit;
end;
if(g>=0)and(min>=0)and(min<60)and(sek>=0)and(sek<=60)then start:=true else
  begin
  showmessage('Podaj czas poprawnie');
  start:=false;
  exit;
  end;
  if rb1.Checked then
    begin
    restart:=true;
    form1.Label1.Caption:='Czas do restartu';
    end;
  if rb2.Checked then
  begin
  restart:=false;
  form1.Label1.Caption:='Czas do wylaczenia';
  end;
start:=true;
end;

procedure TForm2.rb1Click(Sender: TObject);
begin
rb2.Checked:=false;
label1.Caption:='Czas do restartu';
end;

procedure TForm2.rb2Click(Sender: TObject);
begin
rb1.Checked:=false;
label1.Caption:='Czas do wylaczenia';
end;

end.
