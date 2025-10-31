unit uSubRedditComment;

interface

type
  TSubRedditComment = record
    Id: string;
    Name: string;
    Body: string;
    Author: string;
    CreatedUtc: double;
    PermaLink: string;
    Score: integer;
    Ups: integer;
    Downs: integer;
    Comments: TArray<TSubRedditComment>;
  end;

implementation

end.
