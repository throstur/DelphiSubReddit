unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uFetchReddit, Vcl.ComCtrls, Vcl.Grids, uSubReddit, uSubRedditPost, uSubRedditComment;

type
  TMainForm = class(TForm)
    Button_Load: TButton;
    TreeView_Posts: TTreeView;
    ComboBox_Limit: TComboBox;
    procedure Button_LoadClick(Sender: TObject);

  private
    procedure AddCommentNode(ParentNode: TTreeNode; Comments: TArray<TSubRedditComment>);
    function AddPostNode(ParentNode: TTreeNode; Post: TSubRedditPost): TTreeNode;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;
  SubReddit: TSubReddit;

implementation

{$R *.dfm}

procedure TMainForm.AddCommentNode(ParentNode: TTreeNode; Comments: TArray<TSubRedditComment>);
var
  Comment: TSubRedditComment;
  CommentNode: TTreeNode;
begin
  for Comment in Comments do
    begin
      CommentNode := TreeView_Posts.Items.AddChild(ParentNode, Format('%s  - %s  Score %d (u:%d d:%d)', [Comment.Body, Comment.Author, Comment.Score, Comment.Ups, Comment.Downs]));
      AddCommentNode(CommentNode, Comment.Comments);
    end;
end;

function TMainForm.AddPostNode(ParentNode: TTreeNode; Post: TSubRedditPost): TTreeNode;
var
  i: Integer;
  NewNode: TTreeNode;
begin
  Result := TreeView_Posts.Items.AddChild(ParentNode, Format('%s  - %s  Score %d (u:%d d:%d) Comments %d', [Post.Title, Post.Author, Post.Score, Post.Ups, Post.Downs, Post.NumComments]));
end;

procedure TMainForm.Button_LoadClick(Sender: TObject);
var
  Post: TSubRedditPost;
  PostNode: TTreeNode;
begin
  SubReddit.Populate(ComboBox_Limit.Items[ComboBox_Limit.ItemIndex].ToInteger());
  TreeView_Posts.Items.Clear;
  TreeView_Posts.Items.AddFirst(TreeView_Posts.Items.GetFirstNode, Format('r/Delphi: %d posts', [Length(SubReddit.Posts)]));
  for Post in SubReddit.Posts do
    begin
      PostNode := AddPostNode(TreeView_Posts.Items.GetFirstNode, Post);
      AddCommentNode(PostNode, Post.Comments);
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
