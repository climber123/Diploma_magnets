unit Unit2;

interface

uses
  Classes, unit3, unit4, SysUtils, extctrls, mmsystem, spin, Windows, Variants,
  Dialogs, Controls, StdCtrls, Messages, Graphics, Forms;


type
  sound = class(TThread)
  private
    { Private declarations }
  protected 
    procedure Execute; override;
  end;
  procedure PlayStart(FRQ,Volume : integer);
  procedure PlayStop;
  procedure GenCreate;
  procedure GenDestroy;

const
  BlockSize = 1024*32; // размер буфера вывода -- с какого-то min размера звучит без пауз

var
   ServiceThread : sound;
   Freq  : array [0..1] of LongInt;
   Typ   : array [0..1] of LongInt;
   Lev   : array [0..1] of LongInt;
   tPred : array [0..1] of Double;
   Fr0, Fr1, SoundType0, SoundType1, Vol0, Vol1: integer;

implementation
      uses unit1;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure sound.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ sound }

procedure Mix(Buffer,First,Second : PChar; Count : LongInt); assembler;
{       процедура смешивает два массива данных First и Second и помещает}
{       результат в Buffer. Элементы массивов имеют размер WORD         }
{       Count -- Число элеменов в ОДНОМ массиве, т.е. Buffer имеет длину}
{       2*Count элементов}
{       EAX - Buffer       }
{       EDX - First        }
{       ECX - Second       }
{       Count -- в стеке   }
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX     // Buffer помещен в EDI -- индексный регистр приемника
        MOV     ESI,ECX     // Second помещен в ESI -- индексный регистр источника
        MOV     ECX,Count   // Count помещен в ECX
        XCHG    ESI,EDX     // смена источника -- теперь First
@@Loop:
        MOVSW              // пересылка слова из First/Second в Buffer и инкремент индексов
        XCHG    ESI,EDX    // смена источника
        LOOP    @@Loop     // декремент ECX и проверка условия выхода ECX = 0

        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure GenCreate;
begin
  Fr0:=1000;
  Fr1:=1000;
  SoundType0:=1;
  SoundType1:=1;
  Vol0:=20000;
  Vol1:=20000;
end;

procedure Generator(buf : PChar;  Typ, Freq,  Lev, Size : LongInt; var tPred : Double);
var
  I : LongInt;
  OmegaC,t : Double;
begin
//showmessage(inttostr(typ));
  case Typ of
   0:  // тишина
       begin
       for I := 0 to Size-2 do begin
         PSmallInt(buf)^ := 0;
         Inc(PSmallInt(buf));
       end;
       tPred := 0;
       end;
   1: // синус
      begin
        OmegaC := 2*PI*Freq;
        for I := 0 to Size div 2 do begin
          t := I/44100 + tPred;
          PSmallInt(buf)^ := Round(Lev*sin(OmegaC*t));
          Inc(PSmallInt(buf));
        end;
        tPred := t;
      end;
   2: // меандр
      begin
        OmegaC := 2*PI*Freq;
        for I := 0 to Size div 2 do begin
          t := I/44100 + tPred;
          if sin(OmegaC*t) >= 0 then
            PSmallInt(buf)^ := Lev
          else
            PSmallInt(buf)^ := -Lev;
          Inc(PSmallInt(buf));
        end;
        tPred := t;
      end;
   end;
end;

procedure PlayStart(FRQ, volume:integer);
var
  WOutCaps : TWAVEOUTCAPS;
begin
  // проверка наличия устройства вывода
  FillChar(WOutCaps,SizeOf(TWAVEOUTCAPS),#0);
  if MMSYSERR_NOERROR <> WaveOutGetDevCaps(0,@WOutCaps,SizeOf(TWAVEOUTCAPS)) then
  begin
    ShowMessage('Ошибка аудиоустройства');
    exit;
  end;
  // подготовка параметров сигнала
   GenCreate;
  //--
  Freq[0] := FRQ;
  Freq[1] := FRQ;
  Typ[0] :=  SoundType0;
  Typ[1] :=  SoundType1;
  Lev[0] :=  volume;
  Lev[1] :=  volume;
  tPred[0] := 0;
  tPred[1] := 0;
  // запуск потока вывода на выполнение
  ServiceThread := sound.Create(False);
end;

procedure PlayStop;
begin
  ServiceThread.Terminate;
end;

procedure GenDestroy;
begin
   ServiceThread.Free;
end;

procedure sound.Execute;
var
  I : Integer;
  hEvent : THandle;
  wfx : TWAVEFORMATEX;
  hwo : HWAVEOUT;
  si : TSYSTEMINFO;
  wh : array [0..1] of TWAVEHDR;
  Buf : array [0..1] of PChar;
  CnlBuf  : array [0..1] of PChar;
begin
     { Place thread code here }
  // заполнение структуры формата
  FillChar(wfx,Sizeof(TWAVEFORMATEX),#0);
  with wfx do begin
    wFormatTag := WAVE_FORMAT_PCM;      // используется PCM формат
    nChannels := 2;                     // это стереосигнал
    nSamplesPerSec := 44100;            // частота дискретизации 44,1 Кгц
    wBitsPerSample := 16;               // выборка 16 бит
    nBlockAlign := wBitsPerSample div 8 * nChannels; // число байт в выбоке для стересигнала -- 4 байта
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign; // число байт в секундном интервале для стереосигнала
    cbSize := 0;     // не используется
  end;

  // открытие устройства
  hEvent := CreateEvent(nil,false,false,nil);
  if WaveOutOpen(@hwo,0,@wfx,hEvent,0,CALLBACK_EVENT) <> MMSYSERR_NOERROR then begin
    CloseHandle(hEvent);
    Exit;
  end;

  // выделение памяти под буферы, выравниваются под страницу памяти Windows
  GetSystemInfo(si);
  buf[0] := VirtualAlloc(nil,(BlockSize*4+si.dwPageSize-1) div si.dwPagesize * si.dwPageSize,
                             MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);
  buf[1] := PChar(LongInt(buf[0]) + BlockSize);
  // отдельно буферы для генераторов под каждый канал
  CnlBuf[0] := PChar(LongInt(Buf[1])  + BlockSize);
  CnlBuf[1] := PChar(LongInt(CnlBuf[0]) + BlockSize div 2);

  // подготовка 2-х буферов вывода
  for I:=0 to 1 do begin
    FillChar(wh[I],sizeof(TWAVEHDR),#0);
    wh[I].lpData := buf[I];      // указатель на буфер
    wh[I].dwBufferLength := BlockSize;  // длина буфера
    waveOutPrepareHeader(hwo, @wh[I], sizeof(TWAVEHDR));  // подготовка буферов драйвером
  end;

  // генерация буферов каналов
  Generator(CnlBuf[0], Typ[0], Freq[0], Lev[0], BlockSize div 2, tPred[0]);
{  showmessage(cnlbuf[0]+'_'+inttostr(typ[0])+'_'+
  inttostr(freq[0])+'_'+inttostr(lev[0]) +
  '_'+inttostr(Blocksize div 2)+'_'+floattostr(tPred[0]));  }
  Generator(CnlBuf[1], Typ[1], Freq[1], Lev[1], BlockSize div 2, tPred[1]);
  // смешивание буферов каналов в первый буфер вывода
  Mix(buf[0],CnlBuf[0],CnlBuf[1], BlockSize div 2);
  I:=0;
  while not Terminated do begin
    // передача очередного буфера драйверу для проигрывания
    waveOutWrite(hwo, @wh[I], sizeof(WAVEHDR));
    WaitForSingleObject(hEvent, INFINITE);
    I:= I xor 1;
    // генерация буферов каналов
    Generator(CnlBuf[0],Typ[0], Freq[0], Lev[0], BlockSize div 2, tPred[0]);
    Generator(CnlBuf[1],Typ[1], Freq[1], Lev[1], BlockSize div 2, tPred[1]);
    // смешивание буферов каналов в очередной буфер вывода
    Mix(buf[I],CnlBuf[0],CnlBuf[1], BlockSize div 2);
    // ожидание конца проигрывания и освобождения предыдущего буфера

  end;

  // завершение работы с аудиоустройством
  waveOutReset(hwo);
  waveOutUnprepareHeader(hwo, @wh[0], sizeof(WAVEHDR));
  waveOutUnprepareHeader(hwo, @wh[1], sizeof(WAVEHDR));
  // освобождение памяти
  VirtualFree(buf[0],0,MEM_RELEASE);
  WaveOutClose(hwo);
  CloseHandle(hEvent);
end;

end.
