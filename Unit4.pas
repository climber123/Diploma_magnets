unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm4 = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Button1: TButton;
    Button2: TButton;
    ListBox2: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation
    uses unit1, unit2, unit3;
{$R *.dfm}

end.
