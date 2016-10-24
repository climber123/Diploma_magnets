// *****************************************************************************
//     �� ����������� ���������� (���������, ���������, ������� � �.�.)
//            ��� ������ � ����� Borland Delphi � ������� USB2185
// *****************************************************************************

const
	// ����� ������ �������� ����� ������ � ������ �������� �������� DSP
	VarsBaseAddress_USB2185						= $30;

	// ������ ���������� �������� DSP ��� USB2185 (������������ � ������ �������� DSP)
	D_PROGRAM_BASE_ADDRESS_USB2185		  	= 	(VarsBaseAddress_USB2185 + $0);
	D_TARGET_USB2185   							= 	(VarsBaseAddress_USB2185 + $1);
	D_LABEL_USB2185	  							= 	(VarsBaseAddress_USB2185 + $6);
	D_VERSION_USB2185	   						= 	(VarsBaseAddress_USB2185 + $9);
	D_TEST_VAR1_USB2185	 						= 	(VarsBaseAddress_USB2185 + $A);
	D_TEST_VAR2_USB2185	 						= 	(VarsBaseAddress_USB2185 + $B);
	D_TEST_INTR_VAR_USB2185 					= 	(VarsBaseAddress_USB2185 + $C);
	D_MODULE_READY_USB2185 						= 	(VarsBaseAddress_USB2185 + $D);
	D_COMMAND_USB2185			 					= 	(VarsBaseAddress_USB2185 + $E);

	D_READ_RATE_USB2185							= 	(VarsBaseAddress_USB2185 + $10);
	D_READ_ENABLED_USB2185						= 	(VarsBaseAddress_USB2185 + $11);
	D_READ_FIFO_BASE_ADDRESS_USB2185			= 	(VarsBaseAddress_USB2185 + $12);
	D_READ_FIFO_LENGTH_USB2185					= 	(VarsBaseAddress_USB2185 + $13);

	D_WRITE_RATE_USB2185							= 	(VarsBaseAddress_USB2185 + $20);
	D_WRITE_ENABLED_USB2185						= 	(VarsBaseAddress_USB2185 + $21);
	D_WRITE_FIFO_BASE_ADDRESS_USB2185		= 	(VarsBaseAddress_USB2185 + $22);
	D_WRITE_FIFO_LENGTH_USB2185				= 	(VarsBaseAddress_USB2185 + $23);

	// �������� ������� ������ DSP � ���
	DSP_CLOCK_OUT_USB2185 						= 	72000;

	// ��������� ������� �������� ������ ���� USB
	USB11_USB2185				 		 			= 	0;
	USB20_USB2185				 		 			= 	1;
   INVALID_USB_SPEED_USB2185			  		= 	2;


type

// ��������� ����������������� ����
FLASH_USB2185 = packed record
	FlashBytes : array [0..255] of BYTE;
end;
pFLASH_USB2185 = ^FLASH_USB2185;

// ���������, ���������� ���������� � ������ �������� DSP
DSP_INFO_USB2185 = packed record
	Target : array [0..9] of BYTE;			 		//	������, ��� �������� ������������ ������ ������� DSP
	DrvLabel : array [0..5] of BYTE;			 		// ����� ������������ �������� DSP
	DspMajor : BYTE;										// ������� ����� ������ �������� DSP
	DspMinor : BYTE;										// ������� ����� ������ �������� DSP
end;
pDSP_INFO_USB2185 = ^DSP_INFO_USB2185;

// ��������� ������ USB2185
IRTUSB2185 = class
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
	Function GET_DSP_INFO(DspInfo : pDSP_INFO_USB2185): boolean; virtual; stdcall; abstract;
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

	// ������� ��� ����������� ������ ������ �� ������
	Function START_READ : boolean; virtual; stdcall; abstract;
	Function STOP_READ : boolean; virtual; stdcall; abstract;
	Function ReadData(lpBuffer : pSHORT; nNumberOfWordsToRead, lpNumberOfBytesRead : pDWORD; lpOverlapped : POverlapped) : boolean; virtual; stdcall; abstract;

	// ������� ��� ����������� �������� ������ � ������
	Function START_WRITE : boolean; virtual; stdcall; abstract;
	Function STOP_WRITE : boolean; virtual; stdcall; abstract;
	Function WriteData(lpBuffer : pSHORT; nNumberOfWordsToWrite, lpNumberOfBytesWritten : pDWORD; lpOverlapped : POverlapped) : boolean; virtual; stdcall; abstract;

	// ������� ��� ������ � ���������������� ����
	Function GET_FLASH(fi : pFLASH_USB2185) : boolean; virtual; stdcall; abstract;
	Function PUT_FLASH(fi : pFLASH_USB2185) : boolean; virtual; stdcall; abstract;

	// ������� ������ ������ � ��������� �������
	Function GetLastErrorString(lpBuffer : pCHAR; nSize : DWORD) : Integer; virtual; stdcall; abstract;
end;
PIRTUSB2185 = ^IRTUSB2185;

