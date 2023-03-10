use DFCZ_OSLET

declare @Year as int
declare @month as int

set @year = 2019
set @month = 5

SELECT cast (max([LogTime]) as date) as LogDate
           ,L.[UserName]
       	  --,left(message,4) as logged
	  FROM [dbo].[Log4Net] L
  inner join [User] U on L.UserName = U.[Login]
  inner join BusinessUnit  BU on U.LastBusinessUnitId = BU.Id
  
  where
  year (logtime) = @year and month (logtime ) = @month and
  right(message,9) = 'logged in' 
  group by UserName
  order by cast (max([LogTime]) as date) asc


use DFCZ_OSLET

Select
BUname,
logged,
count(distinct(loglist.UserName)) 'Successfully logged users',
count(loglist.id) 'Successfully loggins'
from (
SELECT cast ([LogTime] as date) as LogDate
      
      ,Bu.name as BUname
      ,L.[UserName]
      ,L.[Message]
  	  ,left(message,4) as logged
	  ,L.id

  FROM [dbo].[Log4Net] L
  inner join [User] U on L.UserName = U.[Login]
  inner join BusinessUnit  BU on U.LastBusinessUnitId = BU.Id
  
  where 
  cast (logtime as date) = cast (getdate() as date)
  and right(message,9) = 'logged in') loglist
  --where loglist.logged = 'USER'
  group by BUname,loglist.LogDate,loglist.logged
  order by BUname, logged


 