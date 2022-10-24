--notice about outage of D-SCS
select
-- '('+U.LastName+', '+U.FirstName+')', 
lower(Email)+';' as 'send notice about outage of D-SCS'
from [USER] U where U.[Disabled]= 0
and U.email <> 'novalid@deufol.com' and AuthType = 0
and u.Email not like '%test%'
--and LastBusinessUnitId is not null
group by email,left(LastName,1)
--,'('+U.LastName+', '+U.FirstName+')'
order by left(LastName,1)

--send release notes

select email 'send release notes' from (select userid from userrole 
where roleid in (
select id from role where Name in ('KeyUser','Administrator','Consultant','User'))
group by userid) role inner join [USER] U on role.userid = U.id
where U.DISABLED = 0 and email not in ('novalid@deufol.com')and u.login not like '%test%'
UNION
select email from [USER] U
where 
U.disabled = 0 and U.IsAdmin = 1 and u.login not like '%test%' and email not in ('novalid@deufol.com','Deufol321@deufol.com')



