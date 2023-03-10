--PackBCSProd:
use DFCZ_OSLET
--PackBCSTest:
--use DFCZ_OSLET_TST
Select
count(distinct(loglist.UserName)) 'Successfully logged users'
from (
SELECT cast ([LogTime] as date) as LogDate
      ,[UserName]
      ,[Message]
  	  ,left(message,4) as logged

  FROM [dbo].[Log4Net] 
  
  where 
  cast (logtime as date) = cast (getdate() as date)
  and right(message,9) = 'logged in') loglist
  where loglist.logged = 'BCS '
  group by loglist.LogDate,loglist.logged


 