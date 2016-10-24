unit Unit3;
{����������� �� ����� ���� - ������� ������ �� �������������� ������ ���.
��������� ���� ����� ������, ��������� ����������, ������� ������,
�������� ������� ����� � ������ ����������}
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
  
//  procedure Saveall;   ����� �� ������������

const
	// ���-�� �������� � ������� (������� 256) ��� �. ReadData
	DataStep : DWORD = 40*512;
	// ������� ����� ������
  ReadRate : double  = 400*512;
  VpromejBuferah: integer = 6144;
  VBolshomBuffer: integer = 21474837;
 {k1:real=1;       //������������ ���
 k2:real=1;
 k3:real=1; }

var
   k1,k2,k3:real;       //������������ ���

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

	// ������������� ������ �����
	hReadThread : THANDLE;
	ReadTid : DWORD;
	// ���� ��� ������ ��������� ������
	FileHandle, FileHandle1: Integer;
	// ��������� ������ USB3000
	pModule : IRTUSB3000;
	// ������ ���������� Rtusbapi.dll
	DllVersion : DWORD;
	// ������������� ����������
	ModuleHandle : THandle;
	// ���������, ���������� ���������� � ������ �������� DSP
	DspInfo : DSP_INFO_USB3000;
	// ��������� ���������� � ���� ������
	fi : FLASH_USB3000;
	// ��������� ���������� ������ ���
	ip : INPUT_PARS_USB3000;
	// �������� ������
	ModuleName: String;
	// ������ �������� AVR
	AvrVersion : array [0..4] of CHAR;
	// �������� ����� ������
	ModuleSerialNumber : array [0..8] of CHAR;
	// �������� �������-���������
	Counter, OldCounter : WORD;               //!!!!!!!!!!!!!!!!

  //��������� �� ����� ��� ������
	buffer1, buffer2 : array of SHORT;
 { ResultSign, resultTemp:array[0..6143] of real;
  LogArray: array[0..6143] of string;
  logarray1: array[0..21474836] of string; }
  ResultSign, resultTemp:array of real;
  LogArray: array of string;
  logarray1: array of string;
	// ����� ������ ��� ���������� ������ ����� ������
	ThreadErrorNumber : WORD;
	// ������ ���������� ������� ����� ������
	IsThreadComplete : boolean;

	// ��������������� ����������
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
  INItU3000;    //������ � ��������� ��������
  PropInstall;
  rabota;
end;

procedure unit3000.WriteToLog(s: string);
//��� ������� ����� ���������������� ��� ������, �� ����� ������ �����
//������ ��� ������� ����������, ���� ������� ��� ������� ��� ���������� ��������
begin
//--
  form4.ListBox1.Items[LboxItNum]:=s;
  LboxItNum:=LboxItNum+1;
end;

procedure unit3000.INItU3000;   //�������������, ������ ���� � ���
var i:WORD;
begin
absindex:=0;
	// �������� ������ ������������ DLL ����������
	DllVersion := RtGetDllVersion;
	if DllVersion <> CURRENT_VERSION_RTUSBAPI then
		begin
			ErrorString := '�������� ������ DLL ���������� Rtusbapi.dll! ' + #10#13 +
						'           �������: ' + IntToStr(DllVersion shr 16) +  '.' + IntToStr(DllVersion and $FFFF) + '.' +
						' ���������: ' + IntToStr(CURRENT_VERSION_RTUSBAPI shr 16) + '.' + IntToStr(CURRENT_VERSION_RTUSBAPI and $FFFF) + '.';
			TerminateApplication(ErrorString);
		end
	else

WriteToLog(' DLL Version --> OK');
	// ��������� �������� ��������� �� ��������� ��� ������ USB3000
	pModule := RtCreateInstance(pCHAR('usb3000'));
	if pModule = nil then TerminateApplication('�� ���� ����� ��������� ������ USB3000!')
	else WriteToLog(' Module Interface --> OK');
  	// ��������� ���������� ������ USB3000 � ������ 127 ����������� ������
	for i := 0 to 126 do
   	if pModule.OpenDevice(i) then break;
  	// ���-������ ����������?����������
	if i > 126 then TerminateApplication('�� ������� ���������� ������ USB3000 � ������ 256 ����������� ������!')
	else WriteToLog(' OpenDevice(%u) --> OK');
  	// ������� ������������� ����������
	ModuleHandle := pModule.GetModuleHandle();
  	// ��������� �������� ������ � ������� ����������� �����
	ModuleName := '0123456789';
	if not pModule.GetModuleName(pCHAR(ModuleName)) then TerminateApplication('�� ���� ��������� �������� ������!')
	else WriteToLog(' GetModuleName() --> OK');
  	// ��������, ��� ��� ������ USB3000
	if Boolean(AnsiCompareStr(ModuleName, 'USB3000')) then TerminateApplication('� ��������� ������������ ����� ��������� �� ������ USB3000!')
	else WriteToLog(' The module is ''USB3000''');
  	// ��������� �������� ����� ������
	if not pModule.GetModuleSerialNumber(@ModuleSerialNumber) then TerminateApplication('�� ���� ��������� �������� ����� ������!')
	else WriteToLog(' GetModuleSerialNumber() --> OK');
  	// ������� �� ����� �������� ����� ������������� ������
	WriteToLog(' The Serial Number is ' + String(ModuleSerialNumber));
  	// ��������� ������ �������� AVR
	if not pModule.GetAvrVersion(@AvrVersion) then TerminateApplication('�� ���� ��������� ������ �������� AVR ������!')
	else WriteToLog(' GetAvrVersion() --> OK');
  	// ������� �� ����� ������ �������� AVR
	WriteToLog(' The AVR Driver Version is ' + String(AvrVersion));
  // ��� �������� DSP ������ �� ���������������� ������� DLL ���������� Rtusbapi.dll
	if not pModule.LOAD_DSP(nil) then TerminateApplication('�� ���� ��������� ������ USB3000!')
	else WriteToLog(' LOAD_DSP() --> OK');
  	// �������� �������� ������
 	if not pModule.MODULE_TEST() then TerminateApplication('������ � �������� ������ USB3000!')
	else WriteToLog(' MODULE_TEST() --> OK');
  	// ������ ������� ����� ������ ������������ �������� DSP
	if not pModule.GET_DSP_INFO(@DspInfo) then TerminateApplication('�� ���� ��������� ������ �������� DSP!')
	else WriteToLog(' GET_DSP_INFO() --> OK');
  	// ������� �� ����� ������ �������� DSP
	WriteToLog(' The DSP Driver Version is ' + IntToStr(DspInfo.DspMajor) + '.' + IntToStr(DspInfo.DspMinor));
  	// ����������� ����������������� ���� size ��������� FLASH_USB3000
	fi.size := sizeof(FLASH_USB3000);
  	// ������� ���������� �� ���� ������
	if not pModule.GET_FLASH(@fi) then TerminateApplication('�� ���� ��������� ���� ������ USB3000!')
	else WriteToLog(' GET_MODULE_DESCR() --> OK');
   	// ����������� ����������������� ���� size ��������� INPUT_PARS_USB3000
	ip.size := sizeof(INPUT_PARS_USB3000);
  	// ������� ������� ��������� ������ ����� ������
	if not pModule.GET_INPUT_PARS(@ip) then TerminateApplication('�� ���� �������� ������� ��������� ����� ������!')
	else WriteToLog(' GET_INPUT_PARS --> OK');

    FileHandle := FileCreate('Test'+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat');
		if FileHandle = -1 then showmessage('�� ���� ������� ����'+ 'Test '+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat'+' ��� ������ ��������� ������!');
    FileHandle1 := FileCreate('Test1'+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat');
		if FileHandle1 = -1 then showmessage('�� ���� ������� ���� '+'Test1'+'_'+NameOfAlloy+'_'+datetostr(now)+'.dat'+' ��� ������ ��������� ������!');

end;

function unit3000.Terminated : boolean;
begin
if escape=true then begin    //������� ������� - ���� ��������� ����� �c�������� ������
result:=true                 //��� ���������, ����������� � ���� �������������� ������ ����������
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

procedure unit3000.PropInstall;  //��������� ���������� �����
var i:Byte;
Begin

//-------------------��������� �������������� ��������---------------------------------------------------------------------
	// ��������� �������� ��������� ����� ������ � ������ USB3000
	ip.CorrectionEnabled := true;				// �������� ������������� ������
	ip.InputClockSource := INTERNAL_INPUT_CLOCK_USB3000;	// ����� ������������ ���������� �������� �������� ��� ����� ������         720000000
	ip.ChannelsQuantity := 2;					// ������ �������� ������
	//for i:=0 to (ip.ChannelsQuantity-1) do ip.ControlTable[i] := i;
	ip.InputRate := ReadRate/1000;// ������� ����� ������ � ��� (3���...InputRate=Fclockout/(2*(N+1)), fclockout=720000���)
  ip.InterKadrDelay := 0.0;					// ����������� �������� - ���� ������ ������������� � 0.0
	ip.InputFifoBaseAddress := $0;  			// ������� ����� FIFO ������ �����
	ip.InputFifoLength := $3000;	 			// ����� FIFO ������ �����
	// ����� ������������ ��������� ������������� ������������, ������� ��������� � ���� ������ USB3000
	for i:=0 to 7 do
		begin
			ip.AdcOffsetCoef[i] := fi.AdcOffsetCoef[i];
			ip.AdcScaleCoef[i] := fi.AdcScaleCoef[i];
		end;
//--------------------------------------------------------------------------------------------------
	// ��������� � ������ ��������� ��������� �� ����� ������
	if not pModule.SET_INPUT_PARS(@ip) then TerminateApplication('�� ���� ���������� ��������� ����� ������!')
	else WriteToLog(' SET_INPUT_PARS --> OK');

	// ��������� ��������� ������ ������ �� ����� ������ �� ������ ��������
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

 {�������, ��� ��������� �������� �� ��������, ��������� ���������� ���
 ��������� ������ ������ �� ����� ����������!!!!}

 	// ��������� � �������
	MessageBox(HWND(nil), pCHAR(ErrorString), '������!!!', MB_OK + MB_ICONINFORMATION);
	// ��������� ������������� ������ ����� ������
	if hReadThread = THANDLE(nil) then
  CloseHandle(hReadThread);
	// ��������� ��������� ������
  if pModule <> nil then
  pModule.ReleaseInstance();
	// ��������� ������ ������ ������
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
					// ������ �������� ����� ��������� ������ ������
					ThreadErrorNumber := 3; Result := false; break;
				end
			else if Terminated() then
				begin
					// ��������� �������� (������ ������� ESC)
					ThreadErrorNumber := 4; Result := false; break;
				end
			else Sleep(20);
		end;
end;

function unit3000.ReadThread(var param : pointer): DWORD;
var
	RequestNumber : WORD;
	//i : WORD ; ��������� ����� �����
	// ������������� ������� �� ���� �������
	ReadEvent : array[0..1] of THANDLE;
	// ������ OVERLAPPED �������� �� ���� ���������
	ReadOv : array[0..1] of OVERLAPPED;
	BytesTransferred : array[0..1] of DWORD;

begin            //--------�������
Result := 0;
	// ��������� ���� ������ � ������������ ��������� ��������������� ����� bulk USB
	if not pModule.STOP_READ() then
  begin
  ThreadErrorNumber := 1;
  IsThreadComplete := true; exit;
  end;

	// �������� ��� �������
	ReadEvent[0] := CreateEvent(nil, FALSE , FALSE, nil);
	FillMemory(@ReadOv[0], sizeof(OVERLAPPED), 0);
	ReadOv[0].hEvent := ReadEvent[0];
	ReadEvent[1] := CreateEvent(nil, FALSE , FALSE, nil);
	FillMemory(@ReadOv[1], sizeof(OVERLAPPED), 0);
	ReadOv[1].hEvent := ReadEvent[1];

 	// ������� ������� ������ ����������� ���� ������ � Buffer!!!!!!!!!!!!!!!!!!!
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
   // ���� ������
	// � ������ ����� ��������� ���� ������

//=====================================
if pModule.START_READ() then
   	begin
		// ���� ����� ������
      while Terminated<>true do //������������ ���� ����� ���������� �� DataStep
				begin                   //������� � 2 ������, ���������� ��-�������
        RequestNumber := RequestNumber xor $1;
					//������� ������ �� ��������� ������ �������� ������
     if OddCheck=True then  begin
//��������� ������� ��������� �������, ����� ��������� ��������, ������� ����������� ���
//������� ������ ������� ����� ������, ����� ������������� ������� ���������
//����������������!
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
            					// �������� ���������� ���������� ������� �� ���� ������
					if not WaitingForRequestCompleted(ReadOv[RequestNumber xor $1]) then break;
					// ���� �� ������ ��� ������������ ������� ���� ������
					if ThreadErrorNumber <> 0 then break
					else if Terminated() then
						begin
							// ��������� �������� (������ ������� ESC)
							ThreadErrorNumber := 4; break;
						end
					else Sleep(20);
					// ����������� �������
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
            					// �������� ���������� ���������� ������� �� ���� ������
					if not WaitingForRequestCompleted(ReadOv[RequestNumber xor $1]) then break;
					// ���� �� ������ ��� ������������ ������� ���� ������
					if ThreadErrorNumber <> 0 then break
					else if Terminated() then
						begin
							// ��������� �������� (������ ������� ESC)
							ThreadErrorNumber := 4; break;
						end
					else Sleep(20);
				// ����������� �������
					Inc(Counter);
          OddCheck:=true;
 //         if counter=11 then break;

           end;
				end
		end
	else ThreadErrorNumber := 5;
	// ��� ��������� �������� ����� ��������� ������ ������
	if ThreadErrorNumber = 0 then
		begin
			if WaitingForRequestCompleted(ReadOv[RequestNumber]) then Inc(Counter);
		end;

 {��� ��� ���� ������� ����� ��������}

	// ��������� ���� ������
	if not pModule.STOP_READ() then ThreadErrorNumber := 1;
	// ���� ����, �� ������ ������������� ����������� ������
	if not CancelIo(ModuleHandle) then ThreadErrorNumber := 6;
	// ��������� �������������� �������
	CloseHandle(ReadEvent[0]); CloseHandle(ReadEvent[1]);
	// ��������� ������ ��������� ������ ����� ������
 IsThreadComplete := true;
	// ��� ��������� ������ ������ ����� ������
  //WaitForSingleObject(hReadThread, INFINITE);
  konecsbora;
end;

procedure unit3000.rabota;
//���������� ������ ���� ������ ������������ ����� � ��������� ��������
begin
	// ��������� �������� ������ ���-�� ������ ��� ������
  SetLength(Buffer1, DataStep);
  SetLength(Buffer2, DataStep);
  Setlength(ResultSign, VpromejBuferah);
  SetLength(resultTemp, VpromejBuferah);
  SetLength(LogArray, VpromejBuferah);
  SetLength(LogArray1, VBolshomBuffer);

	// �������� ����� ����� ������
	hReadThread := CreateThread(nil, $2000, @unit3000.ReadThread, nil, 0, ReadTid);
	if hReadThread = THANDLE(nil) then TerminateApplication('�� ���� ��������� ����� ����� ������!');
  { !!!  �������� ���� ��������� �������� ����� ����� ������ !!!													}
	// ������� ����� ������ ������ �����
	ThreadErrorNumber := 0;
	// ������� ������ ������������� ������ ����� ������
end;

procedure unit3000.KonecSbora;
var obnulenietemperaturi:integer;
begin
obnulenietemperaturi:=0;
 pModule.WRITE_SAMPLE(0,@obnulenietemperaturi);
{����� ���������� �� unit3 ��� ���������!!!!!
����� ���� ��� ��� ������ �������������!!!!!}
// ��� ��������� ������ ������ ����� ������
  Escape:=true;
 //IsThreadComplete;
	// ���� �� ���� ������ ��� ����� - ��������� ��������� ��������� ������

	// ��������� ������������� ������ ����� ������

	if hReadThread = THANDLE(nil) then CloseHandle(hReadThread);
    try
    TerminateThread(memproc.Handle,0);
    TerminateThread(saveproc.Handle,0);
    except
    end;
if unit1.heatertest=false then
begin
    //��������� ������� ���� ��� ������ ��������� ������
		if FileWrite(FileHandle,logarray[(packetnum+1)*6144],f4lb2ii) = -1 then  showmessage('�� ���� �������� ��������� ������ � ���� Test.dat!');
    // ������� ���� ������
    FileClose(FileHandle);
	  //��������� ������ ������ ������
  	if FileWrite(FileHandle1,logarray1[0],PacketNum*6144+f4LB2II) = -1 then  showmessage('�� ���� �������� ��������� ������ � ���� Test.dat!');
    FileClose(FileHandle1);
end;
	buffer1:=nil;
  buffer2:=nil;
  logarray1:=nil;
  LogArray:=nil;
	// ��������� ��������� ������
	if not pModule.ReleaseInstance() then
  TerminateApplication('�� ���� ���������� ��������� ������ USB3000!')
	else WriteToLog(' ReleaseInstance() --> OK');

	// ��������� ���� �� ������ ��� ����� ������
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
		// ���� ��������� ���� ������ ��������, ��������� ���� ��������
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
//������� ������� ���������� ���������������� ����� ���, ����� ��� �� ���� ������ 0
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


//���������� - �������� �� �����������

//���������� �������� ����������� ��� ���. ������� �� 4 ������ ��� ��� ����� 2000 ������������
//������� ������, ���� ����������� ������ ����, ��� ����� ������� ���
//��� �������� �����
if temperature4output>680 then temperature4output:=680;
//������ ��� ������ ��� �� ������ � ��������� ���� ������ �� ������!
//����� �� ���
if ws4calibr=true then temperature4output:=SampleTemp4Cal;

    if pModule.WRITE_SAMPLE(0,@temperature4output)<>true then showmessage('������ ���');  //==��� �� ���!
    if temperature4output<0 then pModule.WRITE_SAMPLE(0,@zero);

end;

{ memWork }

procedure memWork.Draw;
begin
//��� ����������� � �������� �� 0 �� ������������ � ���������� � 0,5 ������� !!!!!!!!!!!!

if unit1.heatertest=false then
begin//�������� � ����, ������� � 2 �������, ���� �� ������� ���������
form1.Chart1.Series[0].AddXY(round(curTemp/DotTempKoeff),curSign/DotSignKoeff,'',clRed);
//������������ � ����, � ������ ������ ����������� ����������, �����
//��������� � ����� ����� �� ������� ������
LogArray[f4LB2II]:=floattostr(round(curTemp/DotTempKoeff))+'_'+floattostr(curSign/DotSignKoeff);
LogArray1[f4LB2II+6144*PacketNum]:=floattostr(round(curTemp/DotTempKoeff))+'_'+floattostr(curSign/DotSignKoeff);
end else
begin
     //��� ����� ������������, ���������� ������� �������
 // form5.Chart1.Series[0].AddXY(f4LB2II+6144*PacketNum, SignKoeff*curSign,'',clRed);
  form5.Chart2.Series[0].AddXY(f4LB2II+6144*PacketNum, curTemp/DotTempKoeff,'',clRed);
if PIDGrAllow=true then
  form5.Chart2.series[1].AddXY(f4LB2II+6144*PacketNum, temperature4output,'',clGreen);
end;
if f4LB2II+6144*PacketNum=2147400 then
begin
R3000var.WriteToLog('��������� ��������� ����������'); //��������� ��� ����� ��������
escape:=true;   //�������� ����� �� �������� ������������!!!!
end;
{if f4lb2ii=6143 then
begin                                           //� ������ ����� �� ��������!!!
 if unit1.heatertest=false then                   ��� ��������?
  saveproc:=saving.create(false);
  //���������, ����� �� �������� ����� ����������� packetnum
  //�������� ����� ����� ������� sleep
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
 unit1.R3000var.WriteToLog('���������� ������������ ����������� �� �������');
 form1.Button2.Click;
end else   }
   //�������� ���������� ������� ��������� f4LB2II � ��������� �� 6143, � ����� ��� ��������
f4LB2II:=f4LB2II+1;
IncapsTemp:=incapstemp+stepval;
if f4LB2II mod 10 =0 then
//--��������� ���, ������� ��� �����������������!!!!!
//--��������� ������������ ��� ����������, ������� � � � ���������� ����������!!!!
PID(f4LB2II, round(curTemp/4), maxtemp, IncapsTemp div 10 { stepval*((packetNum*6144+f4lb2ii) div 10)}, 1, 1);
{if f4lb2ii=6143 then
begin
f4lb2ii:=0;
if unit1.heatertest=false then
  saveproc:=saving.create(false);
  //���������, ����� �� �������� ����� ����������� packetnum
  //�������� ����� ����� ������� sleep
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
    //��������� ������� ���� ��� ������ ��������� ������
    //� �������������, ����� ����� � ��-������� ������� -
    //������
if FileWrite(FileHandle,logarray[packetnum*6144],6144) = -1 then  showmessage('�� ���� �������� ��������� ������ � ���� Test.dat!');
TerminateThread(saveproc.Handle,0);
end;

end.
