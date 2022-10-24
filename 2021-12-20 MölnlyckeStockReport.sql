
select 
STOCK.Date
,TOTALS.QTY 'ON_STOCK_TOTAL'
,STOCK.NEW
,STOCK.ON_STOCK
,STOCK.ON_SHIPMENTE
,STOCK.SHIPPED
,STOCK.DAMAGED

from (
select 
Calendar.[Date]
,Count(distinct DATA.EntityId) as QTY 
,DATA.[Status]
  from 
(
select 
S.Name as Status ,
 WFE.entityid, 
WFE.created sdate,
ISNULL(case when lead(entityId)  over (order by WFE.entityid, WFE.created) <> EntityId then WFE.Created ELSE lead(WFE.Created)  over (order by WFE.entityid, WFE.created) end,WFE.Created) as edate
from WorkflowEntry WFE with (NOLOCK) 

inner join [Status] S on WFE.StatusId = S.id
--inner join Loosepart  LP with (NOLOCK) on WFE.EntityId = LP.Id
inner join BusinessUnitPermission BUP with (NOLOCK) on WFE.EntityId = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Mölnlycke Health Care')

union 

select 'DAMAGED', WE.LoosepartId, Created, Created from WarehouseEntry WE where WE.BinId = 'becdff93-9945-4523-b790-b0c53cc06301' and QuantityBase > 0

--where EntityId in ('a7e0c1b1-9418-4123-bee9-9e38cd40a789','dfff1bee-e9cf-4046-9617-0031b476df45')
)DATA
right join [Calendar] with (NOLOCK) on CAST(DATA.sdate as DATE) = Calendar.[Date]

where Calendar.Date BETWEEN  DATEADD(hh, -24, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) AND EOMONTH(GETDATE(),0)

group by [Status], Calendar.[Date] --order by Calendar.Date

) SRC
PIVOT (max(src.QTY) for src.Status  in ([NEW],[ON_STOCK],[ON_SHIPMENT],[SHIPPED],[DAMAGED])
        ) as STOCK

       
 
INNER join (

select 
Count(DATA.EntityId) QTY,
Calendar.[Date] from (
select 

'ON_STOCK_TOTAL' Status, 
WFEstart.EntityId,
WFEstart.Created FromDate, 

case when WFEstart.entityid <> WFEend.EntityId then getdate() else WFEend.Created end ToDate
 
from
(select StatusId ,entityid, created, id sid,lead(id)  over (order by entityid, created) eid from WorkflowEntry with (NOLOCK)) WFEstart


left join WorkflowEntry  WFEend with (NOLOCK) on WFEstart.eid = WFEend.id

inner join BusinessUnitPermission BUP with (NOLOCK) on WFEstart.EntityId = BUP.LoosePartId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Mölnlycke Health Care')
inner join [Status] S with (NOLOCK) on WFEStart.StatusId = S.id and S.Name = ('ON_STOCK')


) DATA
,[Calendar] with (NOLOCK)
  Where Calendar.Date BETWEEN  DATEADD(hh, -24, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) AND EOMONTH(GETDATE(),0)
  and [Calendar].[Date] BETWEEN DATA.FromDate AND DATA.ToDate

 group by 

Calendar.[Date]) TOTALS on STOCK.Date = TOTALS.Date

 order by STOCK.[Date]



 
 --select DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0) as FirtDayPreviousMonthWithTimeStamp,
 -- select DATEADD(hh, -24, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)) as LastDayPreviousMonthWithTimeStamp

 