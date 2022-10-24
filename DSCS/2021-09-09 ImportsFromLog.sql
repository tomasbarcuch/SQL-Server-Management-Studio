select
data.UserName,
Count(data.Id) imports,
--data.id,
 --data.LogTime,
DATEPART(MONTH,LogTime) 'month', 
DATEPART(Day,LogTime) 'day',
SUM(DATA.items) imported_looseparts from (
select *,
CAST(REPLACE(LEFT(REPLACE([Message],'IMPORT-END ',''),PATINDEX('% - %',REPLACE([Message],'IMPORT-END ',''))+1),' -','') as INT) as items
from log4Net 
where MESSAGE like 'IMPORT-END %' 
and [Message] like '%LoosePart%' and [Message] Like '%KRONES GLOBAL%'
and LogTime > '2021-08-01' --order by LogTime desc
) data

group by DATEPART(Day,LogTime),DATEPART(MONTH,LogTime)
,data.UserName--,data.Id,data.LogTime
having data.username = 'olga.gruener'

order by DATEPART(MONTH,LogTime),DATEPART(Day,LogTime)

