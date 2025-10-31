unit uSubReddit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  uFetchReddit,
  uSubRedditPost;

type
  TSubReddit = class

  private
    LastName: string;
    procedure Fetch(After: string; Limit: integer; SubReddit: string = 'delphi');
    procedure ParseJSON(JSONString: string);

  public
    Posts : TArray<TSubRedditPost>;
    procedure Populate;

end;

implementation

{ TSubReddit }

procedure TSubReddit.Fetch(After: string; Limit: integer; SubReddit: string);
begin
  with TFetchReddit.Create do
  begin
    ParseJSON(FetchPosts(After, Limit, SubReddit));
    Free;
  end;
end;

procedure TSubReddit.ParseJSON(JSONString: string);
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
          SubRedditPost.Title := JSONPost.GetValue<string>('data.title');
          SubRedditPost.SelfText := JSONPost.GetValue<string>('data.selftext');
          SubRedditPost.Author := JSONPost.GetValue<string>('data.author');
          SubRedditPost.CreatedUtc := JSONPost.GetValue<double>('data.created_utc');
          SubRedditPost.Url := JSONPost.GetValue<string>('data.url');
          SubRedditPost.NumComments := JSONPost.GetValue<integer>('data.num_comments');
          SubRedditPost.Score := JSONPost.GetValue<integer>('data.score');
          SubRedditPost.Ups := JSONPost.GetValue<integer>('data.ups');
          SubRedditPost.Downs := JSONPost.GetValue<integer>('data.downs');
          LastName := JSONPost.GetValue<string>('data.name');

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

procedure TSubReddit.Populate;
begin
  Fetch(LastName, 10);
end;

end.
