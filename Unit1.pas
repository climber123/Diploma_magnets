unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeeProcs, TeEngine, Chart, ExtCtrls, ToolWin, ComCtrls, Series,
  StdCtrls, unit2, unit3, unit4;

type
  TForm1 = class(TForm)
    coo: TStatusBar;
    ToolBar1: TToolBar;
    Panel1: TPanel;
    Chart1: TChart;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button1: TButton;
    Button2: TButton;
    Series1: TPointSeries;
    Series2: TPointSeries;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Series3: TPointSeries;
    Button3: TButton;
    CheckBox2: TCheckBox;
    Label7: TLabel;
    Label9: TLabel;
    Timer1: TTimer;
    ToolButton7: TToolButton;
    procedure Panel2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure unenabling;
    procedure enabling;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PanVisib, online:Boolean;
  heatertest, chartVisib:boolean;
  R3000var:unit3000;
  NameOfAlloy:string;
  Ft,St:TTimeStamp;
  Koefarr1:array [0..2] of real;
  m:cardinal;
implementation

uses Unit5;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//флаг работы сбора данных, нужен для корректного закрытия программы в процессе работы сбора
{Необходимо выводить на ЦАП нулевой сигнал сразу при загрузке.
т.к. усилитель мощности должен работать постоянно, а ЦАП по умолчанию
выводит 5В. Поэтому, нагреватель постоянно нагревается.
Значит, необходимо инициализировать АЦП сразу при загрузке, т.к.
только после этого можно задать выходную температуру.}
online:=true;
nameofalloy:=edit5.text;
ToolButton2.Enabled:=false;

//создаем файлы для записи собранной информации
//в 1й в конце измерения записывается весь массив
//во второй дописывается информация в процессе измерений
{RFhandle:=FileOpen('KoefStUp.dat',fmOpenReadWrite);
    if RFhandle = -1 then showmessage('Не могу открыть файл '+'KoefStUp.dat'+' для записи собранных данных!');
}

{ хотел сделать передачу коэффициентов после тестирования через файл
НЕ ПОЛУЧИЛОСЬ
if FileRead(RFhandle,Koefarr1,1) =-1 then showmessage('!!!!!');
 CloseHandle(RFhandle);
showmessage(floattostr(koefarr1[0]));
showmessage(floattostr(koefarr1[1]));
showmessage(floattostr(koefarr1[2]));  }
unit3.k1:=1.0;
unit3.k2:=1.0;
unit3.k3:=1.0;
unit3.stepval:=strtoint(edit3.text)*2;
unit3.maxtemp:=strtoint(Edit4.text)*8;
//для отображения времени измерения
Ft:=DateTimeToTimeStamp(now);
//timer1.Enabled:=true;
//Запуск звуковых колебаний, работы по сбору данных
//unit2.PlayStart(strtoint(Edit1.Text),strtoint(Edit2.Text));

R3000var:=unit3000.Create(false);
enabling; //закрытие доступа к органам управления установками процесса
end;

procedure TForm1.Button2Click(Sender: TObject);
begin                        
  online:=false;        //остановка процесса сбора данных
//  timer1.Enabled:=false;
  unit3.Escape:=true;
// sleep(150);  //дает возможность в цикле сбора данных перейти на break
//unit2.PlayStop; //Остановка звука
if R3000var.Terminated=false then showmessage('какая-то фигня!!!');
//Кажется дублирование
//TerminateThread(R3000var.Handle,0);//высвобожение процесса
button3.click;
unenabling; //разрешение доступа к edit'ам
end;

procedure TForm1.Button3Click(Sender: TObject);
//var j:integer;
begin
//принудительное сохранения данных чарта, лостбокса для лога прибора
//и запись в файл информации из конечного буфера программы
//а также закрытие файла для дописывания информации из буфера

  form4.ListBox1.Items.SaveToFile('Logfile'+'_'+NameOfAlloy+'_'+datetostr(now)+'.txt');
  form1.Chart1.SaveToBitmapFile('TestBtm'+'_'+NameOfAlloy+'_'+datetostr(now)+'.bmp');
  form1.Chart1.SaveToBitmapFile('TestMeta'+'_'+NameOfAlloy+'_'+datetostr(now)+'.meta');

{for j := 0 to 100000 do
begin
form4.ListBox2.Items[j]:=unit3.logarray[j];
end;
form4.ListBox2.Items.SaveToFile('DATAfale'+'_'+NameOfAlloy+'_'+datetostr(now)+'.txt');
}
end;

procedure TForm1.Button4Click(Sender: TObject);
 var ttt:integer;
begin
ttt:=strtoint(edit6.text);
if pModule.WRITE_SAMPLE(0,@ttt)<>true then showmessage('ошибка ПИД');  //==Код на АЦП!

end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
if chartVisib=true then  //Убираем Чарт с формы, чтобы меньше грузить систему
begin
chart1.Visible:=False;
chartVisib:=false;
CheckBox2.Caption:='Показать график';
end else
begin
chart1.Visible:=true;
chartVisib:=true;
CheckBox2.Caption:='Скрыть график';
end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//r3000var.TerminateApplication('1');
//r3000var.FreeInstance;
if online=true then  //закрытие формы, если процессы запущены или не запущены
begin
button2.click;
end;
 // CloseHandle(R3000var.Handle);
// R3000var.CleanupInstance;
//  R3000var.Terminate;
try
Application.Terminate;
except
  exit;
  halt;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
PanVisib:=true;       //установка начальных значений
chartVisib:=true;
button2.Enabled:=false;
online:=false;
R3000var.VariablesInit;
end;

procedure TForm1.Panel2Click(Sender: TObject);
begin
if PanVisib=true then   //видимость панельки
    begin
    PanVisib:=false;
    Panel1.Width:=0;
    end else
    begin
    PanVisib:=true;
    Panel1.Width:=185;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var currTemp4show:integer;
begin
St:=DateTimeToTimeStamp(now); //для счетчика времени и прогресс бара
coo.Panels[0].Text:=inttostr((st.Time-ft.Time) div 1000)+' сек' ;
coo.Panels[1].text:=floattostr(100*round(unit3.curTemp/maxtemp));

if unit3.Escape=true then //Условие высвобождения памяти, процеесов
  begin             //при остановке сбоа иформации
    sleep(150);
    button2.Click;
  end;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
form5.visible:=true;
form1.enabled:=false;
heatertest:=true;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
unit2.PlayStart(strtoint(Edit1.Text),strtoint(Edit2.Text));

end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
ShowMessage(inttostr(PacketNum));
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
form4.Visible:=true;
form1.Enabled:=true;
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
var eeee:integer;
wwww:array[0..2] of real;
begin
{ Вспомогательная функция для передачи коэффициентов ПИД через
внешний файл, это НЕ ПОЛУЧИЛОСЬ!
eeee := FileCreate('KoefStUp.dat');
		if eeee = -1 then showmessage('Не могу');
    wwww[0]:=1.067;
    wwww[1]:=22.99;
    wwww[2]:=333.13;
 if FileWrite(eeee,wwww[0],3) = -1 then  showmessage('Не могу записать');
FileClose(eeee);}
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
begin
r3000var.TerminateApplication('1');
end;

procedure TForm1.unenabling;
begin
edit1.Enabled:=true;
edit2.Enabled:=true;
edit3.Enabled:=true;
edit4.Enabled:=true;
edit5.Enabled:=true;
edit6.Enabled:=true;
button1.enabled:=true;
button2.Enabled:=false;
end;


procedure TForm1.enabling;
begin
edit1.Enabled:=false;
edit2.Enabled:=false;
edit3.Enabled:=false;
edit4.Enabled:=false;
edit5.Enabled:=false;
edit6.Enabled:=false;
button1.enabled:=False;
button2.Enabled:=true;
end;

end.
