unit uSubRedditPost;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  uFetchReddit;

type
  TSubRedditPost = record
    Id: string;
    Title: string;
    SelfText: string;
    Author: string;
    CreatedUtc: double;
    Url: string;
    NumComments: integer;
    Score: integer;
    Ups: integer;
    Downs: integer;
  end;
implementation

end.
