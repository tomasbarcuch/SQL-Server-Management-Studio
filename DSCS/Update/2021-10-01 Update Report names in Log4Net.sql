/*

begin TRANSACTION 
update Log4Net set [Message] = REPLACE([Message],'REP','DST')
--select *,(substring([Message],20,8))
from Log4Net
where message like 'Document Template%' and  (substring([Message],20,8)) in (
select REPLACE(NAME,'DST','REP') from DocumentTemplate where NAME like 'DST%')
commit
*/
/*
begin TRANSACTION
UPDATE DocumentTemplate set name = case Name

when 'REP-0058' then 'DST-0030'
when 'REP-0059' then 'DST-0031'

end
from DocumentTemplate where NAME like 'DST%'
COMMIT


begin TRANSACTION 
update Log4Net set [Message] = 
--select [Message],
REPLACE(Message,(substring([Message],20,8)),
case (substring([Message],20,8))

when 'REP-0058' then 'DST-0030'
when 'REP-0059' then 'DST-0031'

else (substring([Message],20,8)) end)
from Log4Net

where message like 'Document Template%' and  (substring([Message],20,8)) like 'DST%'
ROLLBACK
*/

begin TRANSACTION
update Log4Net set [Message] = REPLACE([Message],'REP-0059','DST-0031') from Log4Net where [Message] like '%REP-0058%'
COMMIT