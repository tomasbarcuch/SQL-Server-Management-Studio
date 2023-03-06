select U.[Login], LOGGEDIN.LastLog from [User] U
LEFT JOIN (select L.UserName, MAX(LogTime) LastLog from Log4Net L where [Message] like '%Logged In%' and L.LogTime > '2020-12-31' group by UserName) LOGGEDIN on U.[Login] = LOGGEDIN.UserName
where U.[Disabled] = 0
And U.IsAdmin = 0
AND U.AuthType = 0


