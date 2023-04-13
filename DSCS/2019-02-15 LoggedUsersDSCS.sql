
/*
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
  cast (logtime as date) between '2022-01-01' and getdate() and
  (username not like '%test%' and lower(username) not like '%demo%')
  and right(message,9) = 'logged in')loglist

  group by UserName,BUname
*/
--========================================================================== log in duration
 select 
 DATA.UserName, 
 YEAR(DATA.LogTime) Year, 
 MONTH(DATA.LogTime) Month,
 DATA.LogTime,
 DATEDIFF(MINUTE,DATA.LogTime,DATA.LOGOUT) as Duration
 
  from (
 
  select 
DATA.UserName
,DATA.Log
,DATA.LogTime
,CASE WHEN DATA.LOG = 'in' AND 
LEAD(DATA.Log) OVER (ORDER BY DATA.UserName, DATA.logTime) = 'off' AND 
LEAD(DATA.UserName) OVER (ORDER BY DATA.UserName, DATA.logTime) = DATA.UserName 
THEN LEAD(DATA.LogTime) OVER (ORDER BY DATA.UserName, DATA.logTime) 
ELSE DATEADD(HOUR,8,DATA.LogTime) END AS LOGOUT
,LEAD(DATA.UserName) OVER (ORDER BY DATA.UserName, DATA.logTime) UserName2
  
  
   from (
  
  select
  L.UserName,
  CASE WHEN right(L.message,9) = 'logged in' THEN 'in' ELSE  CASE WHEN right(L.message,10) = 'logged off' THEN 'off' END END LOG,
    L.LogTime
   from Log4Net L

  where L.LogTime > '2021-12-31' and   message like '%logged%'
 -- order by L.UserName,L.LogTime
  ) DATA


  
 ) DATA

WHERE DATA.[LOG] = 'in' AND Data.UserName2 = DATA.UserName and DATEDIFF(MINUTE,DATA.LogTime,DATA.LOGOUT)>5 
ORDER BY DATA.UserName, DATA.logTime