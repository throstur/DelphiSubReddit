unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uFetchReddit, Vcl.ComCtrls, Vcl.Grids, uSubReddit, uSubRedditPost;

type
  TMainForm = class(TForm)
    Button_Load: TButton;
    TreeView_Posts: TTreeView;
    procedure Button_LoadClick(Sender: TObject);

  private
    procedure AddPostNode(ParentNode: TTreeNode; Post: TSubRedditPost);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;
  SubReddit: TSubReddit;

implementation

{$R *.dfm}

procedure TMainForm.AddPostNode(ParentNode: TTreeNode; Post: TSubRedditPost);
var
  i: Integer;
  NewNode: TTreeNode;
begin
  NewNode := TreeView_Posts.Items.AddChild(ParentNode, Format('%s  - %s  %d  (u:%d d:%d)', [Post.Title, Post.Author, Post.Score, Post.Ups, Post.Downs]));
end;

procedure TMainForm.Button_LoadClick(Sender: TObject);
var
  Post: TSubRedditPost;
begin
  SubReddit.Populate;
  TreeView_Posts.Items.Clear;
  TreeView_Posts.Items.AddFirst(TreeView_Posts.Items.GetFirstNode, Format('r/Delphi: %d posts', [Length(SubReddit.Posts)]));
  for Post in SubReddit.Posts do
    begin
      AddPostNode(TreeView_Posts.Items.GetFirstNode, Post);
    end;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // ReportMemoryLeaksOnShutdown := True;
  SubReddit := TSubReddit.Create;
end;

destructor TMainForm.Destroy;
begin
  SubReddit.Free;
  inherited;
end;

end.
