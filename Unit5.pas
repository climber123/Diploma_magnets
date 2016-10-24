unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, Series;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter2: TSplitter;
    Timer1: TTimer;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Edit6: TEdit;
    Button8: TButton;
    Button3: TButton;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Label7: TLabel;
    Label1: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit9: TEdit;
    Edit5: TEdit;
    Button5: TButton;
    Button7: TButton;
    Button6: TButton;
    CheckBox2: TCheckBox;
    Edit4: TEdit;
    Chart1: TChart;
    Series2: TPointSeries;
    Splitter1: TSplitter;
    Chart2: TChart;
    Series1: TPointSeries;
    Series3: TLineSeries;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit18: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Label18: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  sr,spd,ssnd:Boolean;
  
implementation

uses Unit1, Unit3, Unit2;

{$R *.dfm}

procedure TForm5.Button3Click(Sender: TObject);
begin
unit3.SampleTemp4Cal:=strtoint(edit3.text);
end;

procedure TForm5.Button5Click(Sender: TObject);
begin
edit5.Color:=clred;
button5.enabled:=false;

if (edit11.text='') {or (strtoint(edit11.text)<0)} then edit11.text:=inttostr(unit3.stepval div 2);
if (edit10.text='') or (strtoint(edit10.text)<0) then edit10.text:=inttostr(unit3.maxtemp div 8);
if (edit7.text='') or (strtofloat(Edit7.text)<0) then edit7.text:=floattostr(unit3.k1);
if (edit8.text='') or (strtofloat(Edit8.text)<0) then edit8.text:=floattostr(unit3.k2);
if (edit9.text='') or (strtofloat(Edit9.text)<0) then edit9.text:=floattostr(unit3.k3);
if (edit4.text='') or (strtoint(Edit4.text)<0) then edit4.text:=inttostr(unit3.dTI);
if (edit21.text='') or (strtoint(Edit4.text)<0) then edit4.text:=inttostr(unit3.dTD);
//unit3.stepval:=strtoint(edit11.text)*2;
//умножено на 2, потому что температура рассчитана до 1000,
//но ЦАП может выдавать только 2000 значений в 5В диапазоне
//unit3.maxtemp:=strtoint(Edit10.text)*8;
unit3.stepval:=strtoint(edit11.text);
unit3.maxtemp:=strtoint(Edit10.text);
unit3.dTi:=strtoint(edit4.Text);
unit3.dTd:=strtoint(edit21.Text);
//Умножено на 8 потому что температура рассчитана на 1000
//Но АЦП выдает 8000 значений в 5В диапазоне
unit3.k1:=strtofloat(Edit7.text);
unit3.k2:=strtofloat(Edit8.text);
unit3.k3:=strtofloat(Edit9.text);
end;

procedure TForm5.Button6Click(Sender: TObject);
begin
if online=false then
begin
unit1.heatertest:=true;
button6.Caption:='Stop Test';
button5.Click;
button7.click;
online:=true;
R3000var:=unit3000.Create(false);
end else
begin
unit3.escape:=true;
unit1.online:=false;
unit1.heatertest:=false;
button6.Caption:='Start Test';
button5.Enabled:=true;
edit5.Color:=clblue;
end;
end;

procedure TForm5.Button7Click(Sender: TObject);
begin
 unit3.SignSmesch:=strtofloat(edit13.text);
 unit3.SignKoeff:=strtofloat(edit14.text);
 unit3.DotTempKoeff:=strtofloat(edit15.text);
 unit3.TempSmesch:=strtofloat(edit16.text);
 unit3.T4oSmesch:=strtofloat(edit18.text);
 unit3.T4oKoeff:=strtofloat(edit19.text);
 unit3.DotT4oKoeff:=strtofloat(edit20.text);
end;

procedure TForm5.Button8Click(Sender: TObject);
begin
if ssnd=false then
begin
  unit2.PlayStart(strtoint(Edit1.Text),strtoint(Edit2.Text));
  ssnd:=true;
  edit6.Color:=clred;
  button8.Caption:='StopSound';
end else
begin
  unit2.PlayStop;
  ssnd:=false;
  edit6.Color:=clBlue;
  button8.Caption:='StartSound';
end;
end;

procedure TForm5.CheckBox1Click(Sender: TObject);
begin
if unit3.PIDGrAllow=false then
unit3.PIDGrAllow:=true else
unit3.PIDGrAllow:=false;
end;

procedure TForm5.CheckBox2Click(Sender: TObject);
begin
if Unit3.ws4calibr=false then
Unit3.ws4calibr:=true else
Unit3.ws4calibr:=false;
end;

procedure TForm5.CheckBox3Click(Sender: TObject);
begin
if unit3.PID4skorostiNagreva=false then
unit3.PID4skorostiNagreva:=true else
unit3.PID4skorostiNagreva:=false;
end;

procedure TForm5.Edit10Change(Sender: TObject);
begin
button5.Enabled:=true;
edit5.Color:=clBlue;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
form1.enabled:=true;
unit3.escape:=true;
unit1.heatertest:=false;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
sr:=false;
spd:=false;
ssnd:=false;
//edit4.Color:=clblue;
edit5.Color:=clblue;
edit6.Color:=clblue;
end;

procedure TForm5.Panel2Resize(Sender: TObject);
begin
panel2.Width:=173;

end;

end.
