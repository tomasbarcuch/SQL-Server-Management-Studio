
select U.[Login], U.Email, cast(log.lastdate as date) as lastlogin, U.[Disabled] from [User] U
left join (
select max(lastdate) lastdate,username from(
select 
max(logtime) lastdate,
USERNAME
from Log4Net
group by UserName
union 
select max(BCSlog.updated) lastdate,U.[Login] from BCSLog 
inner join [User] U on BCSLog.UpdatedById = U.Id
group by U.[Login]
) data
group by data.UserName

) log on U.[Login] = log.UserName

where U.[Disabled] = 0

order by lastlogin desc

