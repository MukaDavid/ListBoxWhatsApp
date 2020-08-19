unit FListBoxWhatsApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Header, FMX.ListBox, FMX.Layouts, Generics.Collections,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, RTTI;

type
  TListBoxHelper = class helper for TListBox
    function CheckedCount: Integer;
  end;

  TRegistro = class
  private
    FId: Integer;
    FTitulo: string;
    FDetalhe: string;
    FIniciais: string;
  public
    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Detalhe: string read FDetalhe write FDetalhe;
    property Iniciais: string read FIniciais write FIniciais;
  end;

  TfrmListboxWhatsApp = class(TForm)
    tbcPrincipal: TTabControl;
    tbiContatos: TTabItem;
    tbiDetalhe: TTabItem;
    lbxWhatsapp: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblId: TLabel;
    lblTitulo: TLabel;
    lblDetalhe: TLabel;
    lblIniciais: TLabel;
    Layout1: TLayout;
    btnVoltar: TButton;
    ListBoxItem1: TListBoxItem;
    StyleBook1: TStyleBook;
    btnExcluir: TButton;
    btnDesmarcar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbxWhatsappItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnVoltarClick(Sender: TObject);
    procedure lbxWhatsappGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btnDesmarcarClick(Sender: TObject);
  private
    FLongTap: boolean;
    FListaRegistro: TObjectList<TRegistro>;
    procedure SelecionarItem(pListBoxItem: TListBoxItem);
    procedure MostrarDetalhesDoContato(pItem: TListBoxItem);
    procedure Vibrar(pTempo: cardinal);
    { Private declarations }
  public
    procedure PopularListbox;
    {procedure stlWhatsAppItemGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean); }
    { Public declarations }
  end;

var
  frmListboxWhatsApp: TfrmListboxWhatsApp;

implementation


{$IF DEFINED(ANDROID)}
uses Androidapi.Jni.JavaTypes,
  Androidapi.Jni.Os,
  Androidapi.Helpers,
  Androidapi.JNI.App, Androidapi.JNIBridge;
  //FMX.Platform.Android, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net;
{$ENDIF}


{$R *.fmx}

procedure TfrmListboxWhatsApp.btnDesmarcarClick(Sender: TObject);
begin
  for var li := 0 to  lbxWhatsapp.Items.Count - 1 do
  begin
    if lbxWhatsapp.ListItems[li].IsChecked then
      SelecionarItem(lbxWhatsapp.ListItems[li]);
  end;
end;

procedure TfrmListboxWhatsApp.btnVoltarClick(Sender: TObject);
begin
  tbcPrincipal.GotoVisibleTab(tbiContatos.Index);
end;

procedure TfrmListboxWhatsApp.FormCreate(Sender: TObject);
var
  lRegistro: TRegistro;
begin
  FListaRegistro := TObjectList<TRegistro>.Create;

  lRegistro := TRegistro.Create;
  lRegistro.Id := 1;
  lRegistro.Iniciais := 'BW';
  lRegistro.Titulo := 'Bruce Wayne';
  lRegistro.Detalhe := 'Batman - Cavaleiro das Trevas';
  FListaRegistro.Add(lRegistro);

  lRegistro := TRegistro.Create;
  lRegistro.Id := 2;
  lRegistro.Iniciais := 'CK';
  lRegistro.Titulo := 'Clark Kent';
  lRegistro.Detalhe := 'Superman - Homem de Aço';
  FListaRegistro.Add(lRegistro);

  lRegistro := TRegistro.Create;
  lRegistro.Id := 3;
  lRegistro.Iniciais := 'DP';
  lRegistro.Titulo := 'Diana Prince';
  lRegistro.Detalhe := 'Mulher Maravilha - Princesa de Themysira';
  FListaRegistro.Add(lRegistro);

  lRegistro := TRegistro.Create;
  lRegistro.Id := 4;
  lRegistro.Iniciais := 'HJ';
  lRegistro.Titulo := 'Hal Jordan';
  lRegistro.Detalhe := 'Lanterna Verde - Cavaleiro Esmeralda';
  FListaRegistro.Add(lRegistro);

  lRegistro := TRegistro.Create;
  lRegistro.Id := 5;
  lRegistro.Iniciais := 'BA';
  lRegistro.Titulo := 'Barry Allen';
  lRegistro.Detalhe := 'Flash - Velocista Escarlate';
  FListaRegistro.Add(lRegistro);
end;

procedure TfrmListboxWhatsApp.FormShow(Sender: TObject);
begin
  PopularListbox;
end;

procedure TfrmListboxWhatsApp.lbxWhatsappGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if EventInfo.GestureID = igiLongTap then
  begin
    SelecionarItem(lbxWhatsapp.Selected);
    FLongTap := True;
    Vibrar(30);
  end;
end;


procedure TfrmListboxWhatsApp.lbxWhatsappItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if not FLongTap then
  begin
    if lbxWhatsapp.CheckedCount > 0 then
      SelecionarItem(Item)
    else
      MostrarDetalhesDoContato(Item);
  end;
  Item.IsSelected := False;
  FLongTap := False;
end;

procedure TfrmListboxWhatsApp.MostrarDetalhesDoContato(pItem: TListBoxItem);
begin
  if (pItem.Tag <> 0) then
  begin
    var lRegistro := TRegistro(pItem.Tag);
    lblId.Text := lRegistro.Id.ToString;
    lblIniciais.Text := lRegistro.Iniciais;
    lblTitulo.Text := lRegistro.Titulo;
    lblDetalhe.Text := lRegistro.Detalhe;
    tbcPrincipal.GotoVisibleTab(tbiDetalhe.Index);
  end;
end;

procedure TfrmListboxWhatsApp.PopularListbox;
begin
  lbxWhatsapp.BeginUpdate;
  try
    lbxWhatsapp.Clear;
    for var lRegistro in FListaRegistro do
    begin
      var lListBoxItem := TListBoxItem.Create(lbxWhatsapp);
      lListBoxItem.Height := 65;
      lListBoxItem.Parent := lbxWhatsapp;
      lListBoxItem.StyleLookup := 'stlWhatsApp';
      lListBoxItem.StylesData['txtTitulo'] := lRegistro.Titulo;
      lListBoxItem.StylesData['txtDetalhe'] := lRegistro.Detalhe;
      lListBoxItem.StylesData['txtIniciais'] := lRegistro.Iniciais;
      lListBoxItem.StylesData['imgSelecionado.visible'] := False;
      lListBoxItem.Tag := integer(lRegistro);
    end;
  finally
    lbxWhatsapp.EndUpdate;
  end;
end;

procedure TfrmListboxWhatsApp.SelecionarItem(pListBoxItem : TListBoxItem);
begin
  if pListBoxItem.IsChecked then
    pListBoxItem.StylesData['recFundo.Fill.Color'] := TValue.From<TAlphaColor>(TAlphaColorRec.White)
  else
    pListBoxItem.StylesData['recFundo.Fill.Color'] := TValue.From<TAlphaColor>(TAlphaColorRec.Papayawhip);

  pListBoxItem.StylesData['imgSelecionado.Visible'] := TValue.From<Boolean>(not pListBoxItem.IsChecked);
  pListBoxItem.IsChecked := not pListBoxItem.IsChecked;
  pListBoxItem.IsSelected := False;

  btnDesmarcar.Visible := lbxWhatsapp.CheckedCount > 0;
  btnExcluir.Visible := lbxWhatsapp.CheckedCount > 0;
end;


procedure TfrmListboxWhatsApp.Vibrar(pTempo: cardinal);
{$IF DEFINED(ANDROID)}
var
  VibratorObj: JObject;
  Vibrator: JVibrator;
{$ENDIF}
begin
{$IF DEFINED(ANDROID)}
  VibratorObj := TAndroidHelper.Activity.getSystemService(TJActivity.JavaClass.VIBRATOR_SERVICE);
  Vibrator    := TJVibrator.Wrap((VibratorObj as ILocalObject).GetObjectID);
  Vibrator.vibrate(pTempo);
{$ENDIF}
end;

{ TListBoxHelper }

function TListBoxHelper.CheckedCount: Integer;
begin
  Result := 0;
  for var li := 0 to Items.Count - 1 do
  begin
    if ListItems[li].IsChecked then
      inc(Result);
  end;
end;

end.
