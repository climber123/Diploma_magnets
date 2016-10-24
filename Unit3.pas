unit Unit3;
{Большинство из этого кода - готовый пример от производителей модуля АЦП.
Переписан цикл сбора данных, установки параметров, условия выхода,
дописаны правила сбора и вывода информации}
interface

uses
  Classes, unit4, unit5, rtusbapi, SysUtils, Messages, Variants, Graphics, Controls, Forms,
  Dialogs, Windows;

type
    saving = class(TThread)
    public
    procedure Execute; override;
    end;

type
    memWork = class(TThread)
    public
    procedure Execute; override;
    procedure Draw;
    end;

type
  unit3000 = class(TThread)

  private
    { Private declarations }
  protected
  public
  procedure TerminateApplication(ErrorString: string);
  procedure Execute; override;
  function WaitingForRequestCompleted(var ReadOv : OVERLAPPED) : boolean;
  function ReadThread(var param : pointer): DWORD;
  function Terminated: boolean;
	procedure INItU3000;
	Procedure PropInstall;
  procedure rabota;
  procedure KonecSbora;
  procedure WriteToLog(s:string);
  procedure ShowThreadErrorMessage;
  procedure VariablesInit;
end;
  procedure PID(stpN, currtemp, UstTemp, NextStT, dtstepint, dtstepdif: integer);
  
//  procedure Saveall;   нигде не используется

const
	// кол-во отсчетов в запросе (кратное 256) для ф. ReadData
	DataStep : DWORD = 40*512;
	// частота ввода данных
  ReadRate : double  = 400*512;
  VpromejBuferah: integer = 6144;
  VBolshomBuffer: integer = 21474837;
 {k1:real=1;       //Коеффициенты ПИД
 k2:real=1;
 k3:real=1; }

var
   k1,k2,k3:real;       //Коеффициенты ПИД

   DotTempKoeff,DotSignKoeff, SignSmesch, SignKoeff, TempSmesch, TempKoeff,
   T4oSmesch, T4oKoeff, DotT4oKoeff:real;

   tt1, stepval, maxtemp, PacketNum, LboxItNum, shag, dTI, dTD, IncapsTemp:integer;
   j,k,absindex, f4LB2II:longword;
   //ResArray: array of Shortint;
   memproc: memWork;
   saveproc:saving;
   stringtoWrite:string;
   curSign,curTemp:short;
   temperature4output, SampleTemp4Cal:short;

	// идентификатор потока ввода
	hReadThread : THANDLE;
	ReadTid : DWORD;
	// файл для записи собранных данных
	FileHandle, FileHandle1: Integer;
	// интерфейс модуля USB3000
	pModule : IRTUSB3000;
	// версия библиотеки Rtusbapi.dll
	DllVersion : DWORD;
	// идентификатор устройства
	ModuleHandle : THandle;
	// структура, содержащая информацию о версии драйвера DSP
	DspInfo : DSP_INFO_USB3000;
	// структура информации в ППЗУ модуля
	fi : FLASH_USB3000;
	// структура параметров работы АЦП
	ip : INPUT_PARS_USB3000;
	// название модуля
	ModuleName: String;
	// версия драйвера AVR
	AvrVersion : array [0..4] of CHAR;
	// серийный номер модуля
	ModuleSerialNumber : array [0..8] of CHAR;
	// экранный счетчик-индикатор
	Counter, OldCounter : WORD;               //!!!!!!!!!!!!!!!!

  //указатель на буфер для данных
	buffer1, buffer2 : array of SHORT;
 { ResultSign, resultTemp:array[0..6143] of real;
  LogArray: array[0..6143] of string;
  logarray1: array[0..21474836] of string; }
  ResultSign, resultTemp:array of real;
  LogArray: array of string;
  logarray1: array of string;
	// номер ошибки при выполнения потока сбора данных
	ThreadErrorNumber : WORD;
	// флажок завершения потоков ввода данных
	IsThreadComplete : boolean;

	// вспомогаикльные переменные
 //	i : WORD;
	hConIn : THandle;
	ErrorString : string;
	Escape, OddCheck, ws4calibr, SampR4calibr, PIDGrAllow, LastOneWasTheError,
  PID4skorostiNagreva, start:boolean;
  LIndex,jkl: integer;
  bI:word;
  Tp,ts: TTimeStamp;
  tryvar:integer;

implementation
      uses unit1, unit2;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure unit3000.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ unit3000 }

procedure unit3000.Execute;
begin
  { Place thread code here }
  INItU3000;    //работа в отдельном процессе
  PropInstall;
  rabota;
end;

procedure unit3000.WriteToLog(s: string);
//эту функцию нужно синхронизировать при вызове, но тогда строку нужно
//делать как внешнюю переменную, либо сделать эту функцию вне отдельного процесса
begin
//--
  form4.ListBox1.Items[LboxItNum]:=s;
  LboxItNum:=LboxItNum+1;
end;

procedure unit3000.INItU3000;   //Инициализация, запись лога в лог
var i:WORD;
begin
absindex:=0;
	// проверим версию используемой DLL библиотеки
	DllVersion := RtGetDllVersion;
	if DllVersion <> CURRENT_VERSION_RTUSBAPI then
		begin
			ErrorString := 'Неверная версия DLL библиотеки Rtusbapi.dll! ' + #10#13 +
						'           Текущая: ' + IntToStr(DllVersion shr 16) +  '.' + IntToStr(DllVersion and $FFFF) + '.' +
						' Требуется: ' + IntToStr(CURRENT_VERSION_RTUSBAPI shr 16) + '.' + IntToStr(CURRENT_VERSION_RTUSBAPI and $FFFF) + '.';
			TerminateApplication(ErrorString);
		end
	else

WriteToLog(' DLL Version --> OK');
	// попробуем получить указатель на интерфейс для модуля USB3000
	pModule := RtCreateInstance(pCHAR('usb3000'));
	if pModule = nil then TerminateApplication('Не могу найти интерфейс модуля USB3000!')
	else WriteToLog(' Module Interface --> OK');
  	// попробуем обнаружить модуль USB3000 в первых 127 виртуальных слотах
	for i := 0 to 126 do
   	if pModule.OpenDevice(i) then break;
  	// что-нибудь обнаружили?ШОВМЕССАДЖ
	if i > 126 then TerminateApplication('Не удалось обнаружить модуль USB3000 в первых 256 виртуальных слотах!')
	else WriteToLog(' OpenDevice(%u) --> OK');
  	// получим идентификатор устройства
	ModuleHandle := pModule.GetModuleHandle();
  	// прочитаем название модуля в текущем виртуальном слоте
	ModuleName := '0123456789';
	if not pModule.GetModuleName(pCHAR(ModuleName)) then TerminateApplication('Не могу прочитать название модуля!')
	else WriteToLog(' GetModuleName() --> OK');
  	// проверим, что это модуль USB3000
	if Boolean(AnsiCompareStr(ModuleName, 'USB3000')) then TerminateApplication('К открытому виртуальному слоту подключён не модуль USB3000!')
	else WriteToLog(' The module is ''USB3000''');
  	// прочитаем серийный номер модуля
	if not pModule.GetModuleSerialNumber(@ModuleSerialNumber) then TerminateApplication('Не могу прочитать серийный номер модуля!')
	else WriteToLog(' GetModuleSerialNumber() --> OK');
  	// выведем на экран серийный номер обнаруженного модуля
	WriteToLog(' The Serial Number is ' + String(ModuleSerialNumber));
  	// прочитаем версию драйвера AVR
	if not pModule.GetAvrVersion(@AvrVersion) then TerminateApplication('Не могу прочитать версию драйвера AVR модуля!')
	else WriteToLog(' GetAvrVersion() --> OK');
  	// выведем на экран версию драйвера AVR
	WriteToLog(' The AVR Driver Version is ' + String(AvrVersion));
  // Код драйвера DSP возьмём из соответствующего ресурса DLL библиотеки Rtusbapi.dll
	if not pModule.LOAD_DSP(nil) then TerminateApplication('Не могу загрузить модуль USB3000!')
	else WriteToLog(' LOAD_DSP() --> OK');
  	// проверим загрузку модуля
 	if not pModule.MODULE_TEST() then TerminateApplication('Ошибка в загрузке модуля USB3000!')
	else WriteToLog(' MODULE_TEST() --> OK');
  	// теперь получим номер версии загруженного драйвера DSP
	if not pModule.GET_DSP_INFO(@DspInfo) then TerminateApplication('Не могу прочитать версию драйвера DSP!')
	else WriteToLog(' GET_DSP_INFO() --> OK');
  	// выведем на экран версию драйвера DSP
	WriteToLog(' The DSP Driver Version is ' + IntToStr(DspInfo.DspMajor) + '.' + IntToStr(DspInfo.DspMinor));
  	// обязательно проинициализируем поле size структуры FLASH_USB3000
	fi.size := sizeof(FLASH_USB3000);
  	// получим информацию из ППЗУ модуля
	if not pModule.GET_FLASH(@fi) then TerminateApplication('Не могу прочитать ППЗУ модуля USB3000!')
	else WriteToLog(' GET_MODULE_DESCR() --> OK');
   	// обязательно проинициализируем поле size структуры INPUT_PARS_USB3000
	ip.size := sizeof(INPUT_PARS_USB3000);
  	// получим текущие параметры работы ввода данных
	if not pModule.GET_INPUT_PARS(@ip) then TerminateApplication('Не могу получить текущие параметры ввода данных!')
	else WriteToLog(' GET_INPUT_PARS --> OK');

    FileHandle := FileCreate('Test'+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat');
		if FileHandle = -1 then showmessage('Не могу открыть файл'+ 'Test '+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat'+' для записи собранных данных!');
    FileHandle1 := FileCreate('Test1'+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat');
		if FileHandle1 = -1 then showmessage('Не могу открыть файл '+'Test1'+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat'+' для записи собранных данных!');

end;

function unit3000.Terminated : boolean;
begin
if escape=true then begin    //Внешняя вункция - флаг окончания сбора вcледствие ошибки
result:=true                 //или остановки, дописывание в файл недосохранного хвоста информации
end
else result:=false;
end;

procedure unit3000.VariablesInit;
begin
OddCheck:=false;
ws4calibr:=false;
SampR4calibr:=false;
Escape:=false;
PID4skorostiNagreva:=false;
DotTempKoeff:=4;
start:=false;
end;

procedure unit3000.PropInstall;  //Установка параметров сбора
var i:Byte;
Begin

//-------------------Установки измерительного процесса---------------------------------------------------------------------
	// установим желаемые параметры ввода данных с модуля USB3000
	ip.CorrectionEnabled := true;				// разрешим корректировку данных
	ip.InputClockSource := INTERNAL_INPUT_CLOCK_USB3000;	// будем использовать внутренние тактовые испульсы для ввода данных         720000000
	ip.ChannelsQuantity := 2;					// четыре активных канала
	//for i:=0 to (ip.ChannelsQuantity-1) do ip.ControlTable[i] := i;
	ip.InputRate := ReadRate/1000;// частота ввода данных в кГц (3МГц...InputRate=Fclockout/(2*(N+1)), fclockout=720000кгц)
  ip.InterKadrDelay := 0.0;					// межкадровая задержка - пока всегда устанавливать в 0.0
	ip.InputFifoBaseAddress := $0;  			// базовый адрес FIFO буфера ввода
	ip.InputFifoLength := $3000;	 			// длина FIFO буфера ввода
	// будем использовать фирменные калибровочные коэффициенты, которые храняться в ППЗУ модуля USB3000
	for i:=0 to 7 do
		begin
			ip.AdcOffsetCoef[i] := fi.AdcOffsetCoef[i];
			ip.AdcScaleCoef[i] := fi.AdcScaleCoef[i];
		end;
//--------------------------------------------------------------------------------------------------
	// передадим в модуль требуемые параметры по вводу данных
	if not pModule.SET_INPUT_PARS(@ip) then TerminateApplication('Не могу установить параметры ввода данных!')
	else WriteToLog(' SET_INPUT_PARS --> OK');

	// отобразим параметры работы модуля по вводу данных на экране монитора
	//WriteLn('');
	WriteToLog(' Module USB3000 (S/N '+'_'+ StrPas(@fi.SerialNumber)+ 'is ready ... ');
	WriteToLog(' Input parameters:');
	if ip.InputClockSource = INTERNAL_INPUT_CLOCK_USB3000 then WriteToLog('  InputClockSource is INTERNAL')
	else WriteToLog('InputClockSource is EXTERNAL');
	WriteToLog('ChannelsQuantity = '+ floattostr(ip.ChannelsQuantity));

	WriteToLog(Format('   InputRate = %5.3f kHz', [ip.InputRate]));
	WriteToLog(Format('   InterKadrDelay = %2.4f ms', [ip.InterKadrDelay]));
	WriteToLog(Format('   ChannelRate =  %5.3f kHz', [ip.ChannelRate]));
end;

procedure unit3000.TerminateApplication(ErrorString: string);
begin

 {Пожалуй, так правильно выходить из процесса, ТРЕБУЕТСЯ ПЕРЕПИСАТЬ или
 ИСПРАВИТЬ ФУКЦИИ ВЫХОДА из сбора информации!!!!}

 	// сообщение с ошибкой
	MessageBox(HWND(nil), pCHAR(ErrorString), 'ОШИБКА!!!', MB_OK + MB_ICONINFORMATION);
	// освободим идентификатор потока сбора данных
	if hReadThread = THANDLE(nil) then
  CloseHandle(hReadThread);
	// освободим интерфейс модуля
  if pModule <> nil then
  pModule.ReleaseInstance();
	// освободим память буфера данных
	if Buffer1 <> nil then Buffer1 := nil;
  if Buffer2 <> nil then Buffer2 := nil;
  if LogArray <> nil then LogArray := nil;
  if LogArray1 <> nil then LogArray1 := nil;
  FileClose(FileHandle);
  FileClose(FileHandle1);

    	halt;
end;

function unit3000.WaitingForRequestCompleted(var ReadOv : OVERLAPPED) : boolean;
var 	BytesTransferred : DWORD;
begin
	Result := true;
	while true do
	   begin
			if GetOverlappedResult(ModuleHandle, ReadOv, BytesTransferred, FALSE) then break
			else if (GetLastError() <>  ERROR_IO_INCOMPLETE) then
				begin
					// ошибка ожидания ввода очередной порции данных
					ThreadErrorNumber := 3; Result := false; break;
				end
			else if Terminated() then
				begin
					// программа прервана (нажата клавиша ESC)
					ThreadErrorNumber := 4; Result := false; break;
				end
			else Sleep(20);
		end;
end;

function unit3000.ReadThread(var param : pointer): DWORD;
var
	RequestNumber : WORD;
	//i : WORD ; непонятно зачем нужно
	// идентификатор массива их двух событий
	ReadEvent : array[0..1] of THANDLE;
	// массив OVERLAPPED структур из двух элементов
	ReadOv : array[0..1] of OVERLAPPED;
	BytesTransferred : array[0..1] of DWORD;

begin            //--------НЕЧЕТНО
Result := 0;
	// остановим ввод данных и одновременно прочистим соответствующий канал bulk USB
	if not pModule.STOP_READ() then
  begin
  ThreadErrorNumber := 1;
  IsThreadComplete := true; exit;
  end;

	// создадим два события
	ReadEvent[0] := CreateEvent(nil, FALSE , FALSE, nil);
	FillMemory(@ReadOv[0], sizeof(OVERLAPPED), 0);
	ReadOv[0].hEvent := ReadEvent[0];
	ReadEvent[1] := CreateEvent(nil, FALSE , FALSE, nil);
	FillMemory(@ReadOv[1], sizeof(OVERLAPPED), 0);
	ReadOv[1].hEvent := ReadEvent[1];

 	// заранее закажем первый асинхронный сбор данных в Buffer!!!!!!!!!!!!!!!!!!!
	RequestNumber := 0;
	if not pModule.ReadData(@buffer1[0], @DataStep, @BytesTransferred[RequestNumber], @ReadOv[RequestNumber]) then
		begin
        //Tp:=DateTimeToTimeStamp(now);
			if (GetLastError() <> ERROR_IO_PENDING) then
				begin
					CloseHandle(ReadEvent[0]); CloseHandle(ReadEvent[1]); ThreadErrorNumber := 2; IsThreadComplete := true; exit;
				end
		end;
    OddCheck:=false;
    memproc:=memWork.Create(false);
   // СБОР ДАННЫХ
	// а теперь можно запускать сбор данных

//=====================================
if pModule.START_READ() then
   	begin
		// цикл сбора данных
      while Terminated<>true do //Бесконечноый цикл сбора информации по DataStep
				begin                   //опросов в 2 буфера, меняюзихся по-очереди
        RequestNumber := RequestNumber xor $1;
					//сделаем запрос на очередную порции вводимых данных
     if OddCheck=True then  begin
//Создается процесс обработки буффера, после окончания которого, процесс разрушается сам
//система вызова функции этого класса, после инициализации пустого процессса
//неработоспособна!
       memproc:=memWork.Create(false);
					if not pModule.ReadData(@buffer1[0], @DataStep, @BytesTransferred[RequestNumber], @ReadOv[RequestNumber]) then
						begin
 							if (GetLastError() <> ERROR_IO_PENDING) then
								begin
									ThreadErrorNumber := 2;
                  Escape:=true;
                  break;
								end
						end;
            					// ожидание выполнение очередного запроса на сбор данных
					if not WaitingForRequestCompleted(ReadOv[RequestNumber xor $1]) then break;
					// были ли ошибки или пользователь прервал ввод данных
					if ThreadErrorNumber <> 0 then break
					else if Terminated() then
						begin
							// программа прервана (нажата клавиша ESC)
							ThreadErrorNumber := 4; break;
						end
					else Sleep(20);
					// увеличиваем счётчик
					  Inc(Counter);
            OddCheck:=False;
           end else  //if OddCheck=false then
          begin
        memproc:=memWork.Create(false);
					if not pModule.ReadData(@buffer2[0], @DataStep, @BytesTransferred[RequestNumber], @ReadOv[RequestNumber]) then
						begin
  							if (GetLastError() <> ERROR_IO_PENDING) then
								begin
									ThreadErrorNumber := 2;
                  Escape:=true;
                  break;
								end
						end;
            					// ожидание выполнение очередного запроса на сбор данных
					if not WaitingForRequestCompleted(ReadOv[RequestNumber xor $1]) then break;
					// были ли ошибки или пользователь прервал ввод данных
					if ThreadErrorNumber <> 0 then break
					else if Terminated() then
						begin
							// программа прервана (нажата клавиша ESC)
							ThreadErrorNumber := 4; break;
						end
					else Sleep(20);
				// увеличиваем счётчик
					Inc(Counter);
          OddCheck:=true;
 //         if counter=11 then break;

           end;
				end
		end
	else ThreadErrorNumber := 5;
	// ждём окончания операции сбора последней порции данных
	if ThreadErrorNumber = 0 then
		begin
			if WaitingForRequestCompleted(ReadOv[RequestNumber]) then Inc(Counter);
		end;

 {Вот это надо сделать более понятным}

	// остановим сбор данных
	if not pModule.STOP_READ() then ThreadErrorNumber := 1;
	// если надо, то прервём незавершённый асинхронный запрос
	if not CancelIo(ModuleHandle) then ThreadErrorNumber := 6;
	// освободим идентификаторы событий
	CloseHandle(ReadEvent[0]); CloseHandle(ReadEvent[1]);
	// установим флажок окончания потока сбора данных
 IsThreadComplete := true;
	// ждём окончания работы потока ввода данных
  //WaitForSingleObject(hReadThread, INFINITE);
  konecsbora;
end;

procedure unit3000.rabota;
//Собственно запуск всей работы циклического сбора в отдельном процессе
begin
	// попробуем выделить нужное кол-во памяти под буферя
  SetLength(Buffer1, DataStep);
  SetLength(Buffer2, DataStep);
  Setlength(ResultSign, VpromejBuferah);
  SetLength(resultTemp, VpromejBuferah);
  SetLength(LogArray, VpromejBuferah);
  SetLength(LogArray1, VBolshomBuffer);

	// запустим поток сбора данных
	hReadThread := CreateThread(nil, $2000, @unit3000.ReadThread, nil, 0, ReadTid);
	if hReadThread = THANDLE(nil) then TerminateApplication('Не могу запустить поток сбора данных!');
  { !!!  Основной цикл программы ожидания конца сбора данных !!!													}
	// сбросим флаги ошибки потока ввода
	ThreadErrorNumber := 0;
	// сбросим флажок завершённости потока сбора данных
end;

procedure unit3000.KonecSbora;
var obnulenietemperaturi:integer;
begin
obnulenietemperaturi:=0;
 pModule.WRITE_SAMPLE(0,@obnulenietemperaturi);
{НУЖНО ОСВОБОДИТЬ из unit3 ВСЕ ПОДЧИСТУЮ!!!!!
Чтобы было как при первой инициализации!!!!!}
// ждём окончания работы потока ввода данных
  Escape:=true;
 //IsThreadComplete;
	// если не было ошибок при вводе - попробуем сохранить собранные данные

	// освободим идентификатор потока сбора данных

	if hReadThread = THANDLE(nil) then CloseHandle(hReadThread);
    try
    TerminateThread(memproc.Handle,0);
    TerminateThread(saveproc.Handle,0);
    except
    end;
if unit1.heatertest=false then
begin
    //попробуем открыть файл для записи собранных данных
		if FileWrite(FileHandle,logarray[(packetnum+1)*6144],f4lb2ii) = -1 then  showmessage('Не могу записать собранные данные в файл Test.dat!');
    // закроем файл данных
    FileClose(FileHandle);
	  //освободим память буфера данных
  	if FileWrite(FileHandle1,logarray1[0],PacketNum*6144+f4LB2II) = -1 then  showmessage('Не могу записать собранные данные в файл Test.dat!');
    FileClose(FileHandle1);
end;
	buffer1:=nil;
  buffer2:=nil;
  logarray1:=nil;
  LogArray:=nil;
	// освободим интерфейс модуля
	if not pModule.ReleaseInstance() then
  TerminateApplication('Не могу освободить интерфейс модуля USB3000!')
	else WriteToLog(' ReleaseInstance() --> OK');

	// посмотрим были ли ошибки при сборе данных
	WriteToLog('');
	if ThreadErrorNumber <> 0 then ShowThreadErrorMessage()
	else WriteToLog(' The program was completed successfully!!!');
end;

procedure unit3000.ShowThreadErrorMessage;
begin
	case ThreadErrorNumber of
		$0 : ;
		$1 : WriteToLog(' READ Thread: STOP_READ() --> Bad! :(((');
		$2 : WriteToLog(' READ Thread: ReadData() --> Bad :(((');
		$3 : WriteToLog(' READ Thread: Waiting data Error! :(((');
		// если программа была злобно прервана, предъявим ноту протеста
		$4 : WriteToLog(' READ Thread: The program was terminated! :(((');
		$5 : WriteToLog(' READ Thread: START_READ() --> Bad :(((');
		else WriteToLog(' READ Thread: Unknown error! :(((');
	end;
end;


procedure PID(stpN, currtemp, UstTemp, NextStT, dtstepint, dtstepdif: integer);
var promej, dliaDiffer,dd:real;
zero:integer;
begin
zero:=0;
//условие первого выполнения пропорциональной части ПИД, чтобы она не была меньше 0
if PID4skorostiNagreva=false then NextStT:=UstTemp;
if start=false then
begin
start:=true;
dliaDiffer:=NextStT-currtemp;
//temperature4output:=currtemp;
promej:=0;
end;

  promej:=promej+((NextStT-currtemp)*DTstepint);
  //if dliadiffer-(NextStT-currtemp)<=0 then dliadiffer:=NextStT-currtemp;
  temperature4output:=temperature4output+round((k1*(NextStT-currtemp)+k2*promej+k3*((dliadiffer-(NextStT-currtemp))/DTstepdif))/4);
  dd:=(dliadiffer-(NextStT-currtemp));
  form5.Caption:={inttostr(temperature4output)+'>_<'+}floattostr(dd);
  dliaDiffer:=(NextStT-currtemp);


//переменная - интеграл по определению

//вычисление выходной температуры для ПИД. деление на 4 потому что ЦАП всего 2000 поддерживает
//Условие выхода, если температура больше того, что может вывести ЦАП
//для рабочего цикла
if temperature4output>680 then temperature4output:=680;
//потому что больше ЦАП не выдаст и усилитель тоже больше не выдаст!
//Вывод на ЦАП
if ws4calibr=true then temperature4output:=SampleTemp4Cal;

    if pModule.WRITE_SAMPLE(0,@temperature4output)<>true then showmessage('ошибка ПИД');  //==Код на АЦП!
    if temperature4output<0 then pModule.WRITE_SAMPLE(0,@zero);

end;

{ memWork }

procedure memWork.Draw;
begin
//тут температура в градусах от 0 до максимальной с чточностью в 0,5 градуса !!!!!!!!!!!!

if unit1.heatertest=false then
begin//рисуется в чарт, пищется в 2 массива, один из которых постоянно
form1.Chart1.Series[0].AddXY(round(curTemp/DotTempKoeff),curSign/DotSignKoeff,'',clRed);
//дописывается в файл, а другой просто накапливает информацию, чтобы
//сохранить в самом конце по нажатию кнопки
LogArray[f4LB2II]:=floattostr(round(curTemp/DotTempKoeff))+'_'+floattostr(curSign/DotSignKoeff);
LogArray1[f4LB2II+6144*PacketNum]:=floattostr(round(curTemp/DotTempKoeff))+'_'+floattostr(curSign/DotSignKoeff);
end else
begin
     //Для формы тестирования, показывает уровень сигнала
 // form5.Chart1.Series[0].AddXY(f4LB2II+6144*PacketNum, SignKoeff*curSign,'',clRed);
  form5.Chart2.Series[0].AddXY(f4LB2II+6144*PacketNum, curTemp/DotTempKoeff,'',clRed);
if PIDGrAllow=true then
  form5.Chart2.series[1].AddXY(f4LB2II+6144*PacketNum, temperature4output,'',clGreen);
end;
if f4LB2II+6144*PacketNum=2147400 then
begin
R3000var.WriteToLog('измерение несколько затянулось'); //непонятно как будет работать
escape:=true;   //Возможно выход из процесса неправильный!!!!
end;
{if f4lb2ii=6143 then
begin                                           //В режиме теста не работает!!!
 if unit1.heatertest=false then                   Или работает?
  saveproc:=saving.create(false);
  //непонятно, будет ли успевать перед увеличением packetnum
  //возможно нужно будет сделать sleep
  //sleep(20);
end;  }

end;

procedure memWork.Execute;
var i,averDifSign,AverTemp:integer;
begin
  inherited;
averDifSign:=0;
AverTemp:=0;
      if OddCheck=true then
          begin
          for i := 0 to DataStep - 1 do
          begin
            if i mod 2 =0 then
              begin
              averDifSign:=averDifSign+buffer2[i];
              AverTemp:=AverTemp+buffer2[i+1];
              end;
          end;
          end;
      if OddCheck=false then
          begin
          for i := 0 to DataStep - 1 do
          begin
            if i mod 2 =0 then
              begin
              averDifSign:=averDifSign+buffer1[i];
              AverTemp:=AverTemp+buffer1[i+1];
              end;
          end;
          end;
curSign:=round(averDifSign*2/DataStep);
curTemp:=round(AverTemp*2/DataStep);

{if curTemp div 4 >= maxtemp then
begin
 unit1.R3000var.WriteToLog('Достигнута максимальная температура по условию');
 form1.Button2.Click;
end else   }
   //возможно необходимо сначала увеличить f4LB2II и проверить на 6143, а после уже рисовать
f4LB2II:=f4LB2II+1;
IncapsTemp:=incapstemp+stepval;
if f4LB2II mod 10 =0 then
//--Исправить шаг, сделать его инкапсулируюшимся!!!!!
//--поправить составляющие ПИЛ компоненты, сделать П И Д отдельными перменными!!!!
PID(f4LB2II, round(curTemp/4), maxtemp, IncapsTemp div 10 { stepval*((packetNum*6144+f4lb2ii) div 10)}, 1, 1);
{if f4lb2ii=6143 then
begin
f4lb2ii:=0;
if unit1.heatertest=false then
  saveproc:=saving.create(false);
  //непонятно, будет ли успевать перед увеличением packetnum
  //возможно нужно будет сделать sleep
sleep(20);
PacketNum:=PacketNum+1;
end; }
Synchronize(Draw);
TerminateThread(memproc.Handle,0);
end;

{ saving }

procedure saving.Execute;
begin
  inherited;
    //попробуем открыть файл для записи собранных данных
    //с пакетномерами, можно бфыло и по-другому сделать -
    //просто
if FileWrite(FileHandle,logarray[packetnum*6144],6144) = -1 then  showmessage('Не могу записать собранные данные в файл Test.dat!');
TerminateThread(saveproc.Handle,0);
end;

end.
