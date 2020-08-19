program ListBoxWhatsApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  FListBoxWhatsApp in 'FListBoxWhatsApp.pas' {frmListboxWhatsApp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmListboxWhatsApp, frmListboxWhatsApp);
  Application.Run;
end.
