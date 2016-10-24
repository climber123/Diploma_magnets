// *****************************************************************************
//     �� ����������� ���������� (���������, ���������, ������� � �.�.)
//       ��� ������ � ����� Borland Delphi � �������� �� R-Technology
//              �������������� ������: USB2185 � USB3000
// *****************************************************************************

unit Rtusbapi;

interface

uses
	windows;

type
pSHORT = ^SHORT;
pBYTE = ^BYTE;

// ���������� ���������� ��� ������ USB2185
{$I 'USB2185.pas'}
// ���������� ���������� ��� ������ USB3000
{$I 'USB3000.pas'}

const
// ������� ������ ���������� Rtusbapi.dll
	VERMAJOR_RTUSBAPI 			=	$0001;
	VERMINOR_RTUSBAPI 			=	$0005;
	CURRENT_VERSION_RTUSBAPI	=	((VERMAJOR_RTUSBAPI shl 16) or VERMINOR_RTUSBAPI);

// ���������� �������������� �� Rtusbapi.dll �������
Function RtGetDllVersion : DWORD; stdcall;
Function RtCreateInstance(DeviceName : PChar) : Pointer; stdcall;

implementation
	Function RtGetDllVersion : DWORD; External 'Rtusbapi.dll'
	Function RtCreateInstance(DeviceName : PChar) : Pointer; External 'Rtusbapi.dll'
end.

