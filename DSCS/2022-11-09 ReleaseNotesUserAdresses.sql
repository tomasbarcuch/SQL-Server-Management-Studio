--send release notes

select email 'send release notes', U.LastName from (select userid from userrole 
where roleid in (
select id from role where Name in ('KeyUser','Administrator','Consultant','User'))
group by userid) role inner join [USER] U on role.userid = U.id
where U.DISABLED = 0 and email not in ('novalid@deufol.com')and u.login not like '%test%' and u.Email not like '%novalid%'
UNION
select email,U.LastName from [USER] U
where 
U.disabled = 0 and U.IsAdmin = 1 and u.login not like '%test%' and email not in ('novalid@deufol.com','Deufol321@deufol.com')
order by U.LastName


