unit fOpenCLSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TfrmOpenCLSettings = class(TForm)
    pnlSystem: TPanel;
    lblPlatforms: TLabel;
    lblDevices: TLabel;
    cbPlatforms: TComboBox;
    cbDevices: TComboBox;
    btnOk: TButton;
    imgSolR: TImage;
    procedure FormCreate(Sender: TObject);
    procedure cbPlatformsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOpenCLSettings: TfrmOpenCLSettings;

implementation

{$R *.dfm}

uses
  RayTracingEngineStub;

procedure TfrmOpenCLSettings.cbPlatformsChange(Sender: TObject);
{$ifndef CUDA}
var
  devices  : integer;
  value    : PAnsiChar;
  p,d      : Integer;
{$endif}
begin
{$ifndef CUDA}
  p := cbPlatforms.ItemIndex;
  cbDevices.Items.Clear;
  value := AllocMem(100);
  RayTracer_GetOpenCLPlatformDescription(p,value,100);
  devices := RayTracer_GetOpenCLDeviceCount(p);
  for d := 0 to devices-1 do
  begin
    RayTracer_GetOpenCLDeviceDescription(p,d,value,100);
    cbDevices.Items.Add(TrimLeft(string(value)));
  end;
  FreeMem(value);
  cbDevices.ItemIndex := 0;
{$endif}
end;

procedure TfrmOpenCLSettings.FormCreate(Sender: TObject);
{$ifndef CUDA}
var
  platforms: integer;
  devices  : integer;
  v        : PAnsiChar;
  p,d      : Integer;
{$endif}
begin
{$ifndef CUDA}
  RayTracer_PopulateOpenCLInformation;
  cbPlatforms.Items.Clear;
  cbDevices.Items.Clear;
  v := AllocMem(100);
  platforms := RayTracer_GetOpenCLPlaformCount;
  for p := 0 to platforms-1 do
  begin
    RayTracer_GetOpenCLPlatformDescription(p,v,100);
    cbPlatforms.Items.add(string(v));
    if p=0 then
    begin
      devices := RayTracer_GetOpenCLDeviceCount(p);
      for d := 0 to devices-1 do
      begin
        RayTracer_GetOpenCLDeviceDescription(p,d,v,100);
        cbDevices.Items.Add(TrimLeft(string(v)));
      end;
    end;
  end;
  FreeMem(v);
  cbPlatforms.ItemIndex := 0;
  cbDevices.ItemIndex := 0;
{$endif}
end;

end.
