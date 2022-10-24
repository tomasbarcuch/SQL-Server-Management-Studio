/*
select code,cume_dist() over (order by clusteredid) from bin

select code,ntile(10) over (order by clusteredid) from bin
*/

Select * from (
select 
Count(DATA.Code) QTY,
DATA.[Status], 
Calendar.[Date] from (
select 
LP.Code,
S.Name Status, 
WFEstart.EntityId,
--WFEend.EntityId, 
WFEstart.Created FromDate, 
--WFEend.Created,  
case when WFEstart.entityid <> WFEend.EntityId and S.Name <> 'SHIPPED' then getdate() else 
Case when WFEstart.entityid <> WFEend.EntityId and S.Name = 'SHIPPED' then WFEstart.Created else
WFEend.Created end end ToDate
--,cast(DATEDIFF([minute],WFEstart.Created,case when WFEstart.entityid <> WFEend.EntityId then getdate() else WFEend.Created end) as decimal(20,4))/60 duration_hours
 
from
(select StatusId ,entityid, created, id sid,lead(id)  over (order by entityid, created) eid from WorkflowEntry with (NOLOCK)) WFEstart


left join WorkflowEntry  WFEend with (NOLOCK) on WFEstart.eid = WFEend.id
inner join Loosepart  LP with (NOLOCK) on WFEstart.EntityId = LP.Id
inner join BusinessUnitPermission BUP with (NOLOCK) on WFEstart.EntityId = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Mölnlycke Health Care')
inner join [Status] S with (NOLOCK) on WFEStart.StatusId = S.id and S.Name in ('NEW','ON_SHIPMENT','ON_STOCK','SHIPPED','ON_THE_WAY')

--and LP.code = '8990348'
) DATA
,[Calendar] with (NOLOCK)
 WHERE [Calendar].[Date] BETWEEN DATA.FromDate AND DATA.ToDate
 and Calendar.Date between '2021-08-01' and '2021-08-31'

 group by 

 DATA.[Status], 
Calendar.[Date]

) SRC
PIVOT (max(src.QTY) for src.Status  in ([NEW],[ON_SHIPMENT],[ON_STOCK],[SHIPPED],[ON_THE_WAY])
        ) as STOCK

        order by STOCK.[Date]
 


--=====================================================================================

Select * from (

select 

Count(DATA.Code) QTY,
DATA.[Status], 
Calendar.[Date] from (


select 
S.Name Status,
LP.Code,
WFE.Created DateFrom,
--CASE when S.NAME <> 'SHIPPED' then LEAD(WFE.Created)  over (order by WFE.entityid, WFE.created) else WFE.Created end DateTo,
case when LEAD(WFE.EntityId)  over (order by WFE.entityid, WFE.created) <> WFE.EntityId and S.Name <> 'SHIPPED' then getdate() else 
Case when LEAD(WFE.EntityId)  over (order by WFE.entityid, WFE.created) <> WFE.EntityId and S.Name = 'SHIPPED' then WFE.Created else
LEAD(WFE.Created)  over (order by WFE.entityid, WFE.created) end end DateTo,


WFE.EntityId,
LAG(WFE.EntityId)  over (order by WFE.entityid, WFE.created) LAGENTIT

from WorkflowEntry WFE
inner join Loosepart LP on WFE.EntityId = LP.Id
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Mölnlycke Health Care')
inner join [Status] S on WFE.StatusId = S.id and S.Name in ('NEW','ON_SHIPMENT','ON_STOCK','SHIPPED','ON_THE_WAY')
) DATA
,[Calendar] with (NOLOCK)
 WHERE [Calendar].[Date] BETWEEN DATA.DateFrom AND DATA.DateTo
 and Calendar.Date between '2021-01-01' and '2021-09-30'

 group by 

 DATA.[Status], 
Calendar.[Date]

) SRC
PIVOT (max(src.QTY) for src.Status  in ([NEW],[ON_SHIPMENT],[ON_STOCK],[SHIPPED],[ON_THE_WAY])
        ) as STOCK

        order by STOCK.[Date]


