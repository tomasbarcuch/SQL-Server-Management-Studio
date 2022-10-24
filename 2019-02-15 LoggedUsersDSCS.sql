select max(LogDate) logged_in,UserName as DSCS_user, BUname from
(SELECT cast ([LogTime] as date) as LogDate
      
      ,Bu.name as BUname
      ,L.[UserName]
      ,L.[Message]
  	  ,left(message,4) as logged
	

  FROM [dbo].[Log4Net] L
  inner join [User] U on L.UserName = U.[Login] and U.IsAdmin = 0 and u.[Disabled] = 0
  inner join BusinessUnit  BU on U.LastBusinessUnitId = BU.Id
  
  where 
  cast (logtime as date) between '2021-09-01' and getdate() and
  (username not like '%test%' and lower(username) not like '%demo%')
  and right(message,9) = 'logged in')loglist

  group by UserName,BUname