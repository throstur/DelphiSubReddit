unit uSubReddit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  uFetchReddit,
  uSubRedditPost,
  uSubRedditComment;

type
  TSubReddit = class

  private
    LastName: string;
    procedure ParseJSONPost(JSONString: string);
    procedure ParseJSONPostComment(var CommentArray: TArray<TSubRedditComment>; JSONString: string);
    procedure ParseJSONComment(var CommentArray: TArray<TSubRedditComment>; JSONComments: TJSONObject);

    procedure PopulateComments(var Comments: TArray<TSubRedditComment>; PermaLink: string; NumComments: integer);

  public
    Posts: TArray<TSubRedditPost>;
    procedure Populate(Limit: integer);

end;

implementation

{ TSubReddit }

procedure TSubReddit.ParseJSONPost(JSONString: string);
var
  JSONRoot: TJSONObject;
  JSONPosts: TJSONArray;
  JSONPost: TJSONValue;
  SubRedditPost: TSubRedditPost;
  i: integer;
begin
  JSONRoot := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
  if Assigned(JSONRoot) then
    begin
      JSONPosts := JSONRoot.GetValue<TJSONArray>('data.children');
      for JSONPost in JSONPosts do
        begin
          SubRedditPost := Default(TSubRedditPost);
          SubRedditPost.Id := JSONPost.GetValue<string>('data.id');
          SubRedditPost.Name := JSONPost.GetValue<string>('data.name');
          SubRedditPost.Title := JSONPost.GetValue<string>('data.title');
          SubRedditPost.SelfText := JSONPost.GetValue<string>('data.selftext');
          SubRedditPost.Author := JSONPost.GetValue<string>('data.author');
          SubRedditPost.CreatedUtc := JSONPost.GetValue<double>('data.created_utc');
          SubRedditPost.PermaLink := JSONPost.GetValue<string>('data.permalink');
          SubRedditPost.NumComments := JSONPost.GetValue<integer>('data.num_comments');
          SubRedditPost.Score := JSONPost.GetValue<integer>('data.score');
          SubRedditPost.Ups := JSONPost.GetValue<integer>('data.ups');
          SubRedditPost.Downs := JSONPost.GetValue<integer>('data.downs');

          i := Length(Posts);
          SetLength(Posts, i + 1);
          Posts[i] := SubRedditPost;
        end;
    end
  else
    begin
      raise EConvertError.Create('Invalid JSON');
    end;
end;

procedure TSubReddit.ParseJSONPostComment(var CommentArray: TArray<TSubRedditComment>; JSONString: string);
var
  JSONCommentRoot: TJSONArray;
  JSONRoot: TJSONObject;
begin
  JSONCommentRoot := TJSONObject.ParseJSONValue(JSONString) as TJSONArray;
  JSONRoot := JSONCommentRoot.Items[1] as TJSONObject;
  if Assigned(JSONRoot) then
    ParseJSONComment(CommentArray, JSONRoot)
  else
    raise EConvertError.Create('Invalid JSON');

end;

procedure TSubReddit.ParseJSONComment(var CommentArray: TArray<TSubRedditComment>; JSONComments: TJSONObject);
var
  JSONPosts: TJSONArray;
  JSONPost: TJSONValue;

  JSONReplies: TJSONObject;

  SubRedditComment: TSubRedditComment;
  Body: string;
begin
  JSONPosts := JSONComments.GetValue<TJSONArray>('data.children');
  for JSONPost in JSONPosts do
  if JSONPost.TryGetValue<string>('data.body', Body) then
    begin
      SubRedditComment := Default(TSubRedditComment);
      SubRedditComment.Id := JSONPost.GetValue<string>('data.id');
      SubRedditComment.Name := JSONPost.GetValue<string>('data.name');
      SubRedditComment.Body := Body;
      SubRedditComment.Author := JSONPost.GetValue<string>('data.author');
      SubRedditComment.CreatedUtc := JSONPost.GetValue<double>('data.created_utc');
      SubRedditComment.PermaLink := JSONPost.GetValue<string>('data.permalink');
      SubRedditComment.Score := JSONPost.GetValue<integer>('data.score');
      SubRedditComment.Ups := JSONPost.GetValue<integer>('data.ups');
      SubRedditComment.Downs := JSONPost.GetValue<integer>('data.downs');

      SetLength(CommentArray, Length(CommentArray) + 1);
      CommentArray[Length(CommentArray) - 1] := SubRedditComment;

      if JSONPost.GetValue<TJSONValue>('data.replies') is TJSONObject then
        begin          
          JSONReplies := JSONPost.GetValue<TJSONObject>('data.replies');
          ParseJSONComment(SubRedditComment.Comments, JSONReplies)
        end;
          
    end;
end;



procedure TSubReddit.PopulateComments(var Comments: TArray<TSubRedditComment>; PermaLink: string; NumComments: integer);
begin
  if NumComments > 0 then
    begin
      with TFetchReddit.Create do
        begin
          ParseJSONPostComment(Comments, FetchComments(PermaLink, NumComments));
          Free;
        end;
    end;
end;


procedure TSubReddit.Populate(Limit: integer);
var
  i: integer;
begin
  with TFetchReddit.Create do
  begin
    ParseJSONPost(FetchPosts(LastName, Limit, 'delphi'));
    LastName := Posts[Length(Posts) - 1].Name;
    Free;
  end;
  
  for i := 0 to Length(Posts) - 1 do
    PopulateComments(Posts[i].Comments, Posts[i].PermaLink, Posts[i].NumComments);
end;

end.
