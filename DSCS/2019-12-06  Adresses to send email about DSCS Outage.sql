--notice about outage of D-SCS
select
-- '('+U.LastName+', '+U.FirstName+')', 
lower(Email)+';' as 'send notice about outage of D-SCS'
from [USER] U where U.[Disabled]= 0
and U.email <> 'novalid@deufol.com' and AuthType = 0
and u.Email not like '%test%'
and u.Email not like '%novalid%'
--and LastBusinessUnitId is not null
group by email,left(LastName,1)
--,'('+U.LastName+', '+U.FirstName+')'
order by left(LastName,1)





