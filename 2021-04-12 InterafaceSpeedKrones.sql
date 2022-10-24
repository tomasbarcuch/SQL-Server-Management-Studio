select count (data.id) Parts_updated, data.[day], data.[interval]
from (
select 

LP.ID,
cast(LP.updated as date) day,
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '0:00:00.0000001' and '3:00:00.0000000' then '00:00'
else 
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '3:00:00.0000001' and '6:00:00.0000000' then '03:00'
else  
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '6:00:00.0000001' and '9:00:00.0000000' then '06:00'
else  
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '9:00:00.0000001' and '12:00:00.0000000' then '09:00'
else  
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '12:00:00.0000001' and '15:00:00.0000000' then '12:00'
else  
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '15:00:00.0000001' and '18:00:00.0000000' then '15:00'
else  
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '18:00:00.0000001' and '21:00:00.0000000' then '18:00'
else  
case when cast (CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    LP.Updated), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as time) between '21:00:00.0000001' and '23:59:59.9999999' then '21:00'
else '07:00' end end end end end end end end as interval

from LoosePart LP


inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')

where lp.updated > '2021-04-26 12:00'
) data
group by data.[day],data.[interval]
order by data.[day], data.[interval]