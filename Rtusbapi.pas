// *****************************************************************************
//     Всё необходимые объявления (константы, структуры, функции и т.д.)
//       для работы в среде Borland Delphi с модулями от R-Technology
//              Поддерживаемые модули: USB2185 и USB3000
// *****************************************************************************

unit Rtusbapi;

interface

uses
	windows;

type
pSHORT = ^SHORT;
pBYTE = ^BYTE;

// объявления интерфейса для модуля USB2185
{$I 'USB2185.pas'}
// объявления интерфейса для модуля USB3000
{$I 'USB3000.pas'}

const
// текущая версия библиотеки Rtusbapi.dll
	VERMAJOR_RTUSBAPI 			=	$0001;
	VERMINOR_RTUSBAPI 			=	$0005;
	CURRENT_VERSION_RTUSBAPI	=	((VERMAJOR_RTUSBAPI shl 16) or VERMINOR_RTUSBAPI);

// объявление экспортируемых из Rtusbapi.dll функций
Function RtGetDllVersion : DWORD; stdcall;
Function RtCreateInstance(DeviceName : PChar) : Pointer; stdcall;

implementation
	Function RtGetDllVersion : DWORD; External 'Rtusbapi.dll'
	Function RtCreateInstance(DeviceName : PChar) : Pointer; External 'Rtusbapi.dll'
end.

