unit uFetchReddit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetEncoding;

type
  TFetchReddit = class
  private
    const Reddit_URI = 'https://www.reddit.com';
    const SubReddit_URI = Reddit_URI + '/r/%s/.json?limit=%d&after=%s';
  public
    function FetchPosts(After: string; Limit: integer; SubReddit: string): string;
    function FetchComments(PermaLink: string; NumComments: integer): string;
end;

implementation

function TFetchReddit.FetchPosts(After: string; Limit: integer; SubReddit: string): string;
var
  URI: string;
begin
  URI := Format(SubReddit_URI, [SubReddit, Limit, After]);

  with THTTPClient.Create do
    begin
      ResponseTimeout := 1500;
      Result := Get(URI).ContentAsString;
      Free
    end;
end;

function TFetchReddit.FetchComments(PermaLink: string; NumComments: integer): string;
begin
  with THTTPClient.Create do
    begin
      ResponseTimeout := 1500;
      Result := Get(Reddit_URI + PermaLink + '.json?limit=' + NumComments.ToString).ContentAsString;
      Free
    end;
end;

end.
