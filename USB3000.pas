// *****************************************************************************
//     �� ����������� ���������� (���������, ���������, ������� � �.�.)
//            ��� ������ � ����� Borland Delphi � ������� USB3000
// *****************************************************************************

const
	// ����� ������ �������� ����� ������ � ������ �������� �������� DSP
	VarsBaseAddress_USB3000 					= $30;

	// ������ ���������� �������� DSP ��� USB3000 (������������ � ������ �������� DSP)
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

	// �������� ������� ������ DSP � ���
	DSP_CLOCK_OUT_USB3000 						= 	72000;

	// ��������� ��������� �������� ��������� ��� ����� ������
	INTERNAL_INPUT_CLOCK_USB3000			 	=	0;		// ���������� �������� �������� ����� ������
	EXTERNAL_INPUT_CLOCK_USB3000	 			=	1;		// ������� �������� �������� ����� ������
	INVALID_INPUT_CLOC_USB3000K	 			=	2;		// ������ �� ������

	// ��������� ���� ������������� ����� ������
	NO_SYNCHRO_USB3000						 	=	0;
	TTL_START_SYNCHRO_USB3000				 	=	1;
	TTL_KADR_SYNCHRO							 	=	2;
	ANALOG_SYNCHRO_USB3000					 	=	3;
	INVALID_SYNC_USB3000						 	=	4;

	// ��������� ���� �������� � ������ �����
	EMPTY_DATA_USB3000						 	= 	0;
	ADC_DATA_USB3000						 		= 	1;
	TTL_DATA_USB3000						 		= 	2;
	MIXED_DATA_USB3000						 	= 	3;
	INVALID_INPUT_DATA_USB3000			  	 	= 	4;

	// ��������� ������� �������� ������ ���� USB
	USB11_USB3000				 		 			= 	0;
	USB20_USB3000				 		 			= 	1;
	INVALID_USB_SPEED_USB3000			  		= 	2;


type

// ���������, �������� ������ ����� ������ ��� ������ USB-3000
INPUT_PARS_USB3000 = packed record
	size : WORD;
	InputEnabled : BOOL;			  						// ������ ����������/���������� ����� ������ (������ ��� ������)
	CorrectionEnabled : BOOL; 							// ���������� �������������� ������� ������ (� ���)
	InputClockSource : WORD;							// �������� �������� ��������� ��� ����� ������
	InputType : WORD;										// ��� �������� � ������ ����� (��� ��� ���)
	SynchroType : WORD;									// ��� ������������� �������� � ������ �����
	SynchroAdType : WORD;								// ��� ���������� �������������
	SynchroAdMode : WORD; 								// ����� ���������� ������������
	SynchroAdChannel : WORD;  							// ����� ��� ��� ���������� �������������
	SynchroAdPorog : SHORT;								// ����� ������������ ��� ��� ���������� �������������
	ChannelsQuantity : WORD;							// ����� �������� ���������� �������
	ControlTable : array [0..127] of WORD;			// ����������� ������� � ��������� ����������� ��������
	InputFifoBaseAddress : WORD;						// ������� ����� FIFO ������ �����
	InputFifoLength : WORD;	  							// ����� FIFO ������ �����
	InputRate : double;	  			  					// �������� ������� ����� ������ � ���
	InterKadrDelay : double;		  					// ����������� �������� � ��
	ChannelRate : double;								// ������� ����� �������������� ����������� ������
	AdcOffsetCoef : array [0..7] of double; 		// ���������������� ����. �������� ���� ��� ���
	AdcScaleCoef : array [0..7] of double;	 		// ���������������� ����. �������� ��� ���
end;
pINPUT_PARS_USB3000 = ^INPUT_PARS_USB3000;

// ���������, �������� ������ ������ ������ ��� ������ USB-3000
OUTPUT_PARS_USB3000 = packed record
	size : WORD;
	OutputEnabled : BOOL;								// ����������/���������� ������ ������
	OutputRate : double;	  		  						// ������� ������ ������ � ���
	OutputFifoBaseAddress : WORD;  					// ������� ����� FIFO ������ ������
	OutputFifoLength : WORD;							// ����� FIFO ������ ������
end;
pOUTPUT_PARS_USB3000 = ^OUTPUT_PARS_USB3000;

// ��������� ����������������� ����
FLASH_USB3000 = packed record
	CRC16 : WORD;											// ����������� �����
	size : WORD;											// ������ ���������
	SerialNumber : array [0..8] of BYTE;		 	// �������� ����� ������
	Name : array [0..10] of BYTE;					 	// �������� ������
	Revision : CHAR;										// ������� ������
	DspType : array [0..16] of BYTE;			 		// ��� �������������� DSP
	IsDacPresented : BYTE; 								// ������ ������� ���
	DspClockout : DWORD; 								// �������� ������� DSP � ��
	AdcOffsetCoef : array [0..7] of single; 		// ���������������� ����. �������� ���� ��� ���
	AdcScaleCoef : array [0..7] of single;	 		// ���������������� ����. �������� ��� ���
	DacOffsetCoef : array [0..1] of single; 		// ���������������� ����. �������� ���� ��� ���
	DacScaleCoef : array [0..1] of single;	 		// ���������������� ����. �������� ��� ���
	ReservedByte : array [0..128] of BYTE;	 		// ���������������
end;
pFLASH_USB3000 = ^FLASH_USB3000;

// ���������, ���������� ���������� � ������ �������� DSP
DSP_INFO_USB3000 = packed record
	Target : array [0..9] of BYTE;			 		//	������, ��� �������� ������������ ������ ������� DSP
	DrvLabel : array [0..5] of BYTE;			 		// ����� ������������ �������� DSP
	DspMajor : BYTE;										// ������� ����� ������ �������� DSP
	DspMinor : BYTE;										// ������� ����� ������ �������� DSP
end;
pDSP_INFO_USB3000 = ^DSP_INFO_USB3000;

// ��������� ������ USB3000                                       `
IRTUSB3000 = class
  public
	// USB ��������� ������
	Function OpenDevice(VirtualSlot : WORD) : boolean; virtual; stdcall; abstract;
	Function CloseDevice : boolean; virtual; stdcall; abstract;
	Function GetModuleHandle : THandle; virtual; stdcall; abstract;
	Function GetUsbSpeed(UsbSpeed : pByte) : boolean; virtual; stdcall; abstract;
	Function GetModuleName(ModuleName : pCHAR) : boolean; virtual; stdcall; abstract;
	Function GetModuleSerialNumber(SerialNumber : pCHAR) : boolean; virtual; stdcall; abstract;
	Function GetAvrVersion(AvrVersion : pCHAR) : boolean; virtual; stdcall; abstract;
	Function ReleaseInstance : boolean; virtual; stdcall; abstract;

	// ������� ��� ������ � DSP ������
	Function RESET_DSP : boolean; virtual; stdcall; abstract;
	Function LOAD_DSP(FileName : pCHAR = nil) : boolean; virtual; stdcall; abstract;
	Function MODULE_TEST : boolean; virtual; stdcall; abstract;
	Function GET_DSP_INFO(DspInfo : pDSP_INFO_USB3000): boolean; virtual; stdcall; abstract;
	Function SEND_COMMAND(Command : WORD) : boolean; virtual; stdcall; abstract;

	// ������� ��� ������ � ������� DSP ������
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

	// ������� ��� ������ � ������ ����� ������
	Function GET_INPUT_PARS(ap : pINPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function SET_INPUT_PARS(ap : pINPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function START_READ : boolean; virtual; stdcall; abstract;
	Function STOP_READ : boolean; virtual; stdcall; abstract;
	Function READ_KADR(Data : pSHORT) : boolean; virtual; stdcall; abstract;
	Function READ_SAMPLE(Channel : WORD; Sample : pSHORT) : boolean; virtual; stdcall; abstract;
	Function ReadData(lpBuffer : pSHORT; nNumberOfWordsToRead, lpNumberOfBytesRead : pDWORD; lpOverlapped : POverlapped) : boolean; virtual; stdcall; abstract;

	// ������� ��� ������ � ������ ������ ������
	Function GET_OUTPUT_PARS(dp : pOUTPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function SET_OUTPUT_PARS(dp : pOUTPUT_PARS_USB3000) : boolean; virtual; stdcall; abstract;
	Function START_WRITE : boolean; virtual; stdcall; abstract;
	Function STOP_WRITE : boolean; virtual; stdcall; abstract;
	Function WRITE_SAMPLE(Channel : WORD; Sample : pSHORT) : boolean; virtual; stdcall; abstract;
	Function WriteData(lpBuffer : pSHORT; nNumberOfWordsToWrite, lpNumberOfBytesWritten : pDWORD; lpOverlapped : POverlapped) : boolean; virtual; stdcall; abstract;

	// ������� ��� ������ � ��� �������
	Function ENABLE_TTL_OUT(EnabledTtlOut : boolean) : boolean; virtual; stdcall; abstract;
	Function TTL_OUT(TtlOut : WORD) : boolean; virtual; stdcall; abstract;
	Function TTL_IN(TtlIn : pWORD) : boolean; virtual; stdcall; abstract;

	// ������� ��� ������ ����
	Function ENABLE_FLASH_WRITE(EnableFlashWrite : boolean) : boolean; virtual; stdcall; abstract;
	Function PUT_FLASH(fi : pFLASH_USB3000) : boolean; virtual; stdcall; abstract;
	Function GET_FLASH(fi : pFLASH_USB3000) : boolean; virtual; stdcall; abstract;

	// ������� ������ ������ � ��������� �������
	Function GetLastErrorString(lpBuffer : pCHAR; nSize : DWORD) : Integer; virtual; stdcall; abstract;
end;
PIRTUSB3000 = ^IRTUSB3000;

