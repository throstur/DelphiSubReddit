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
    const SubReddit_API_URI = 'https://www.reddit.com/r/%s/.json?limit=%d&after=%s';
  public
    function FetchPosts(After: string; Limit: integer; SubReddit: string): string;
end;

implementation

function TFetchReddit.FetchPosts(After: string; Limit: integer; SubReddit: string): string;
var
  URI: string;
begin
  URI := Format(SubReddit_API_URI, [SubReddit, Limit, After]);

  with THTTPClient.Create do
    begin
      ResponseTimeout := 1500;
      Result := Get(URI).ContentAsString;
      Free
    end;
end;

end.
