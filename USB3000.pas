// *****************************************************************************
//     Всё необходимые объявления (константы, структуры, функции и т.д.)
//            для работы в среде Borland Delphi с модулем USB3000
// *****************************************************************************

const
	// адрес начала сегмента блока данных в памяти программ драйвера DSP
	VarsBaseAddress_USB3000 					= $30;

	// адреса переменных драйвера DSP для USB3000 (раполагаются в памяти программ DSP)
	D_PROGRAM_BASE_ADDRESS_USB3000		  	= 	(VarsBaseAddress_USB3000 + $0);
	D_TARGET_USB3000   							= 	(VarsBaseAddress_USB3000 + $1);
	D_LABEL_USB3000   							= 	(VarsBaseAddress_USB3000 + $6);
	D_VERSION_USB3000	   						= 	(VarsBaseAddress_USB3000 + $9);
	D_TEST_VAR1_USB3000	 						= 	(VarsBaseAddress_USB3000 + $A);
	D_TEST_VAR2_USB3000	 						= 	(VarsBaseAddress_USB3000 + $B);
	D_TEST_INTR_VAR_USB3000 					= 	(VarsBaseAddress_USB3000 + $C);
	D_MODULE_READY_USB3000 						= 	(VarsBaseAddress_USB3000 + $D);
	D_COMMAND_USB3000			 					= 	(VarsBaseAddress_USB3000 + $E);
	D_INPUT_CLOCK_SOURCE 						=	(VarsBaseAddress_USB3000 + $10);

	D_CONTROL_TABLE_LENGHT_USB3000			= 	(VarsBaseAddress_USB3000 + $20);
	D_INPUT_SAMPLE_USB3000						= 	(VarsBaseAddress_USB3000 + $21);
	D_INPUT_CHANNEL_USB3000						= 	(VarsBaseAddress_USB3000 + $22);
	D_INPUT_RATE_USB3000							= 	(VarsBaseAddress_USB3000 + $23);
	D_INTER_KADR_DELAY_USB3000					= 	(VarsBaseAddress_USB3000 + $24);
	D_FIRST_SAMPLE_DELAY_USB3000				= 	(VarsBaseAddress_USB3000 + $25);
	D_INPUT_ENABLED_USB3000						= 	(VarsBaseAddress_USB3000 + $26);
	D_INPUT_FIFO_BASE_ADDRESS_USB3000		= 	(VarsBaseAddress_USB3000 + $27);
	D_INPUT_FIFO_LENGTH_USB3000				= 	(VarsBaseAddress_USB3000 + $28);
	D_CUR_INPUT_FIFO_LENGTH_USB3000			= 	(VarsBaseAddress_USB3000 + $29);

	D_CORRECTION_ENABLED_USB3000				= 	(VarsBaseAddress_USB3000 + $2B);

	D_INPUT_TYPE_USB3000		  					= 	(VarsBaseAddress_USB3000 + $2C);
	D_SYNCHRO_TYPE_USB3000 						= 	(VarsBaseAddress_USB3000 + $2D);
	D_SYNCHRO_AD_TYPE_USB3000					= 	(VarsBaseAddress_USB3000 + $2E);
	D_SYNCHRO_AD_MODE_USB3000					= 	(VarsBaseAddress_USB3000 + $2F);
	D_SYNCHRO_AD_CHANNEL_USB3000				= 	(VarsBaseAddress_USB3000 + $30);
	D_SYNCHRO_AD_POROG_USB3000					= 	(VarsBaseAddress_USB3000 + $31);

	D_OUTPUT_SAMPLE_USB3000 					= 	(VarsBaseAddress_USB3000 + $40);
	D_OUTPUT_SCLK_DIV_USB3000					= 	(VarsBaseAddress_USB3000 + $41);
	D_OUTPUT_RATE_USB3000						= 	(VarsBaseAddress_USB3000 + $42);
	D_OUTPUT_ENABLED_USB3000					= 	(VarsBaseAddress_USB3000 + $43);
	D_OUTPUT_FIFO_BASE_ADDRESS_USB3000		= 	(VarsBaseAddress_USB3000 + $44);
	D_OUTPUT_FIFO_LENGTH_USB3000				= 	(VarsBaseAddress_USB3000 + $45);
	D_CUR_OUTPUT_FIFO_LENGTH_USB3000			= 	(VarsBaseAddress_USB3000 + $46);

	D_ENABLE_TTL_OUT_USB3000					= 	(VarsBaseAddress_USB3000 + $4D);
	D_TTL_OUT_USB3000								= 	(VarsBaseAddress_USB3000 + $4E);
	D_TTL_IN_USB3000								= 	(VarsBaseAddress_USB3000 + $4F);

	D_ADC_SCALE_USB3000 							= 	(VarsBaseAddress_USB3000 + $50);
	D_ADC_ZERO_USB3000							= 	(VarsBaseAddress_USB3000 + $58);
	D_CONTROL_TABLE_USB3000						= 	($100);

	// тактовая частота работы DSP в кГц
	DSP_CLOCK_OUT_USB3000 						= 	72000;

	// возможные источники тактовых импульсов для ввода данных
	INTERNAL_INPUT_CLOCK_USB3000			 	=	0;		// внутренние тактовые импульса ввода данных
	EXTERNAL_INPUT_CLOCK_USB3000	 			=	1;		// внешние тактовые импульса ввода данных
	INVALID_INPUT_CLOC_USB3000K	 			=	2;		// такого не бывает

	// возможные типы синхронизации ввода данных
	NO_SYNCHRO_USB3000						 	=	0;
	TTL_START_SYNCHRO_USB3000				 	=	1;
	TTL_KADR_SYNCHRO							 	=	2;
	ANALOG_SYNCHRO_USB3000					 	=	3;
	INVALID_SYNC_USB3000						 	=	4;

	// возможные типы вводимых с модуля даных
	EMPTY_DATA_USB3000						 	= 	0;
	ADC_DATA_USB3000						 		= 	1;
	TTL_DATA_USB3000						 		= 	2;
	MIXED_DATA_USB3000						 	= 	3;
	INVALID_INPUT_DATA_USB3000			  	 	= 	4;

	// возможные индексы скорости работы шины USB
	USB11_USB3000				 		 			= 	0;
	USB20_USB3000				 		 			= 	1;
	INVALID_USB_SPEED_USB3000			  		= 	2;


type

// структура, задающая режимы ввода данных для модуля USB-3000
INPUT_PARS_USB3000 = packed record
	size : WORD;
	InputEnabled : BOOL;			  						// флажок разрешение/запрещение ввода данных (только при чтении)
	CorrectionEnabled : BOOL; 							// управление корректировкой входных данных (с АЦП)
	InputClockSource : WORD;							// источник тактовых импульсов для ввода данных
	InputType : WORD;										// тип вводимых с модуля даных (АЦП или ТТЛ)
	SynchroType : WORD;									// тип синхронизации вводимых с модуля даных
	SynchroAdType : WORD;								// тип аналоговой синхронизации
	SynchroAdMode : WORD; 								// режим аналоговой сихронизации
	SynchroAdChannel : WORD;  							// канал АЦП при аналоговой синхронизации
	SynchroAdPorog : SHORT;								// порог срабатывания АЦП при аналоговой синхронизации
	ChannelsQuantity : WORD;							// число активных логических каналов
	ControlTable : array [0..127] of WORD;			// управляющая таблица с активными логическими каналами
	InputFifoBaseAddress : WORD;						// базовый адрес FIFO буфера ввода
	InputFifoLength : WORD;	  							// длина FIFO буфера ввода
	InputRate : double;	  			  					// тактовая частота ввода данных в кГц
	InterKadrDelay : double;		  					// межкадровая задержка в мс
	ChannelRate : double;								// частота ввода фиксированного логического канала
	AdcOffsetCoef : array [0..7] of double; 		// корректировочные коэф. смещение нуля для АЦП
	AdcScaleCoef : array [0..7] of double;	 		// корректировочные коэф. масштаба для АЦП
end;
pINPUT_PARS_USB3000 = ^INPUT_PARS_USB3000;

// структура, задающая режимы вывода данных для модуля USB-3000
OUTPUT_PARS_USB3000 = packed record
	size : WORD;
	OutputEnabled : BOOL;								// разрешение/запрещение вывода данных
	OutputRate : double;	  		  						// частота вывода данных в кГц
	OutputFifoBaseAddress : WORD;  					// базовый адрес FIFO буфера вывода
	OutputFifoLength : WORD;							// длина FIFO буфера вывода
end;
pOUTPUT_PARS_USB3000 = ^OUTPUT_PARS_USB3000;

// структура пользовательского ППЗУ
FLASH_USB3000 = packed record
	CRC16 : WORD;											// контрольная сумма
	size : WORD;											// размер структуры
	SerialNumber : array [0..8] of BYTE;		 	// серийный номер модуля
	Name : array [0..10] of BYTE;					 	// название модуля
	Revision : CHAR;										// ревизия модуля
	DspType : array [0..16] of BYTE;			 		// тип установленного DSP
	IsDacPresented : BYTE; 								// флажок наличия ЦАП
	DspClockout : DWORD; 								// тактовая частота DSP в Гц
	AdcOffsetCoef : array [0..7] of single; 		// корректировочные коэф. смещения нуля для АЦП
	AdcScaleCoef : array [0..7] of single;	 		// корректировочные коэф. масштаба для АЦП
	DacOffsetCoef : array [0..1] of single; 		// корректировочные коэф. смещения нуля для ЦАП
	DacScaleCoef : array [0..1] of single;	 		// корректировочные коэф. масштаба для ЦАП
	ReservedByte : array [0..128] of BYTE;	 		// зарезервировано
end;
pFLASH_USB3000 = ^FLASH_USB3000;

// структура, содержащая информацию о версии драйвера DSP
DSP_INFO_USB3000 = packed record
	Target : array [0..9] of BYTE;			 		//	модуль, для которого предназначен данный драйвер DSP
	DrvLabel : array [0..5] of BYTE;			 		// метка разработчика драйвера DSP
	DspMajor : BYTE;										// старшие число версии драйвера DSP
	DspMinor : BYTE;										// младшее число версии драйвера DSP
end;
pDSP_INFO_USB3000 = ^DSP_INFO_USB3000;

// интерфейс модуля USB3000                                       `
IRTUSB3000 = class
  public
	// USB интерфейс модуля
	Function OpenDevice(VirtualSlot : WORD) : boolean; virtual; stdcall; abstract;
	Function CloseDevice : boolean; virtual; stdcall; abstract;
	Function GetModuleHandle : THandle; virtual; stdcall; abstract;
	Function GetUsbSpeed(UsbSpeed : pByte) : boolean; virtual; stdcall; abstract;
	Function GetModuleName(ModuleName : pCHAR) : boolean; virtual; stdcall; abstract;
	Function GetModuleSerialNumber(SerialNumber : pCHAR) : boolean; virtual; stdcall; abstract;
	Function GetAvrVersion(AvrVersion : pCHAR) : boolean; virtual; stdcall; abstract;
	Function ReleaseInstance : boolean; virtual; stdcall; abstract;

	// функции для работы с DSP модуля
	Function RESET_DSP : boolean; virtual; stdcall; abstract;
	Function LOAD_DSP(FileName : pCHAR = nil) : boolean; virtual; stdcall; abstract;
	Function MODULE_TEST : boolean; virtual; stdcall; abstract;
	Function GET_DSP_INFO(DspInfo : pDSP_INFO_USB3000): boolean; virtual; stdcall; abstract;
	Function SEND_COMMAND(Command : WORD) : boolean; virtual; stdcall; abstract;

	// функции для работы с памятью DSP модуля
	Function PUT_VAR_WORD(Address : WORD; Data : SHORT) : boolean; virtual; stdcall; abstract;
	Function GET_VAR_WORD(Address : WORD; Data : pSHORT) : boolean; virtual; stdcall; abstract;
	Function PUT_DM_WORD(Address : WORD; Data : SHORT) : boolean; virtual; stdcall; abstract;
	Function GET_DM_WORD(Address : WORD; Data : pSHORT) : boolean; virtual; stdcall; abstract;
	Function PUT_PM_WORD(Address : WORD; Data : DWORD) : boolean; virtual; stdcall; abstract;
	Function GET_PM_WORD(Address : WORD; Data : pDWORD) : boolean; virtual; stdcall; abstract;
	Function PUT_DM_ARRAY(BaseAddress, NPoints : WORD; Data : pSHORT) : boolean; virtual; stdcall; abstract;
	Function GET_DM_ARRAY(BaseAddress, NPoints : WORD; Data : pSHORT) : boolean; virtual; stdcall; abstract;
	Function PUT_PM_ARRAY(BaseAddress, NPoints : WORD; Data : pDWORD) : boolean; virtual; stdcall; abstract;
	Function GET_PM_ARRAY(BaseAddress, NPoints : WORD; Data : pDWORD) : boolean; virtual; stdcall; abstract;

	// функции для работы в режиме ввода данных
	Function GET_INPUT_PARS(ap : pINPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function SET_INPUT_PARS(ap : pINPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function START_READ : boolean; virtual; stdcall; abstract;
	Function STOP_READ : boolean; virtual; stdcall; abstract;
	Function READ_KADR(Data : pSHORT) : boolean; virtual; stdcall; abstract;
	Function READ_SAMPLE(Channel : WORD; Sample : pSHORT) : boolean; virtual; stdcall; abstract;
	Function ReadData(lpBuffer : pSHORT; nNumberOfWordsToRead, lpNumberOfBytesRead : pDWORD; lpOverlapped : POverlapped) : boolean; virtual; stdcall; abstract;

	// функции для работы в режиме вывода данных
	Function GET_OUTPUT_PARS(dp : pOUTPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function SET_OUTPUT_PARS(dp : pOUTPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function START_WRITE : boolean; virtual; stdcall; abstract;
	Function STOP_WRITE : boolean; virtual; stdcall; abstract;
	Function WRITE_SAMPLE(Channel : WORD; Sample : pSHORT) : boolean; virtual; stdcall; abstract;
	Function WriteData(lpBuffer : pSHORT; nNumberOfWordsToWrite, lpNumberOfBytesWritten : pDWORD; lpOverlapped : POverlapped) : boolean; virtual; stdcall; abstract;

	// функции для работы с ТТЛ линиями
	Function ENABLE_TTL_OUT(EnabledTtlOut : boolean) : boolean; virtual; stdcall; abstract;
	Function TTL_OUT(TtlOut : WORD) : boolean; virtual; stdcall; abstract;
	Function TTL_IN(TtlIn : pWORD) : boolean; virtual; stdcall; abstract;

	// функции для работы ППЗУ
	Function ENABLE_FLASH_WRITE(EnableFlashWrite : boolean) : boolean; virtual; stdcall; abstract;
	Function PUT_FLASH(fi : pFLASH_USB3000) : boolean; virtual; stdcall; abstract;
	Function GET_FLASH(fi : pFLASH_USB3000) : boolean; virtual; stdcall; abstract;

	// функция выдачи строки с последней ошибкой
	Function GetLastErrorString(lpBuffer : pCHAR; nSize : DWORD) : Integer; virtual; stdcall; abstract;
end;
PIRTUSB3000 = ^IRTUSB3000;

