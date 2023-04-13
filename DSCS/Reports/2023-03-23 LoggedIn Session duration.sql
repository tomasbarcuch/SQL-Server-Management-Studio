
 select 
 loggin.UserName
 ,loggin.logInTime
 ,CASE WHEN (ISNULL(loggoff.logOffTime,loggin.logInTimeMax)) = loggin.logInTime THEN DATEADD(HOUR,8,loggin.logInTime) ELSE  ISNULL(loggoff.logOffTime,loggin.logInTimeMax) end loggoftime
 
 from (
   select
  L.UserName,
--  CASE WHEN right(L.message,9) = 'logged in' THEN 'in' ELSE  CASE WHEN right(L.message,10) = 'logged off' THEN 'off' END END LOG,
 --CASE WHEN Left(L.message,3) = 'BCS' THEN 'BCS' ELSE 'D-SCS' END APP,
    MIN(L.LogTime) logInTime
    ,MAX(L.LogTime) logInTimeMax
   from Log4Net L
inner join [User] U on L.UserName = U.[Login] AND U.IsAdmin = 0 AND U.AuthType = 0
  where 
  L.LogTime > '2021-12-31' and 
  message like '%logged%' and 
  Left(L.message,4) = 'User' and
  right(L.message,9) = 'logged in'

  group by L.UserName, CAST(L.LogTime as DATE)
 ) loggin left join (

     select
  L.UserName,
    MIN(L.LogTime) logOffTimeMin
    ,MAX(L.LogTime) logOffTime
   from Log4Net L

  where 
  L.LogTime > '2021-12-31' and 
  message like '%logged%' and 
  Left(L.message,4) = 'User' and
  right(L.message,10) = 'logged off'

  group by L.UserName, CAST(L.LogTime as DATE)
 ) loggoff on loggin.UserName = loggoff.UserName and CAST(loggin.logInTime as DATE) = CAST(loggoff.logOffTime as DATE)

 order by loggin.UserName, loggin.logInTime


--=======================================BCS
 
 select 
 loggin.UserName
 ,loggin.logInTime
 ,CASE WHEN (ISNULL(loggoff.logOffTime,loggin.logInTimeMax)) = loggin.logInTime THEN DATEADD(HOUR,8,loggin.logInTime) ELSE  ISNULL(loggoff.logOffTime,loggin.logInTimeMax) end loggoftime
 
 from (
   select
  L.UserName,
--  CASE WHEN right(L.message,9) = 'logged in' THEN 'in' ELSE  CASE WHEN right(L.message,10) = 'logged off' THEN 'off' END END LOG,
 --CASE WHEN Left(L.message,3) = 'BCS' THEN 'BCS' ELSE 'D-SCS' END APP,
    MIN(L.LogTime) logInTime
    ,MAX(L.LogTime) logInTimeMax
   from Log4Net L
inner join [User] U on L.UserName = U.[Login] AND U.IsAdmin = 0 AND U.AuthType = 0
  where 
  L.LogTime > '2021-12-31' and 
  message like '%logged%' and 
  Left(L.message,3) = 'BCS' and
  right(L.message,9) = 'logged in'

  group by L.UserName, CAST(L.LogTime as DATE)
 ) loggin left join (

     select
  L.UserName,
    MIN(L.LogTime) logOffTimeMin
    ,MAX(L.LogTime) logOffTime
   from Log4Net L

  where 
  L.LogTime > '2021-12-31' and 
  message like '%logged%' and 
  Left(L.message,3) = 'BCS' and
  right(L.message,10) = 'logged off'

  group by L.UserName, CAST(L.LogTime as DATE)
 ) loggoff on loggin.UserName = loggoff.UserName and CAST(loggin.logInTime as DATE) = CAST(loggoff.logOffTime as DATE)

 order by loggin.UserName, loggin.logInTime