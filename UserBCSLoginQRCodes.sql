select 

case LastLanguage
when 'de' then 'BCS Anmeldungscode'+CHAR(13)+'['+DB_NAME()+']'
when 'en' then 'BCS Login code'+CHAR(13)+'['+DB_NAME()+']'
when 'cs' then 'BCS přihlašovací kód'+CHAR(13)+'['+DB_NAME()+']'
end as LabelDescription,
U.Id, 
U.[Login], 
lower(U.BCSLoginCode) as BCSLoginCode, 
U.FirstName+' '+LastName as Name 
from [USER] U 
where login in ('tomas.barcuch','test.test','it.support')


