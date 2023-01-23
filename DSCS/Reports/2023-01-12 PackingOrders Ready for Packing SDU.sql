Select distinct DATA.CODE, DATA.Created, DATA.[PRINT] from (
select 
POH.Code
,SPOH.Name 
,POH.CountLines
,ON_STOCK.QTY
,WFE.Created
,CASE WHEN SPOH.Name = 'MEASUREMENT_STARTED' and WFE.Created < GETDATE() THEN 0 ELSE 1 END as 'PRINT'
from
 PackingOrderLine POL
inner join PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id
inner join [Status] SPOH on POH.StatusId = SPOH.Id-- and SPOH.Name not in ('MEASUREMENT_STARTED')
inner join WorkflowEntry WFE on POH.StatusId = WFE.StatusId and POH.Id = WFE.EntityId
inner join BusinessUnitPermission BUP on POL.id = BUP.PackingOrderLineId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')
LEFT JOIN(select POL.PackingOrderHeaderId, COUNT(LP.id) QTY from LoosePart LP
INNER join [Status] S on LP.StatusId = S.id and S.Name = 'ON_STOCK'
inner join PackingOrderLine POL on LP.id = POL.LoosePartId
 group by POL.PackingOrderHeaderId) ON_STOCK on POH.Id = ON_STOCK.PackingOrderHeaderId


WHERE POH.CountLines = ON_STOCK.QTY

) DATA WHERE [PRINT] = 1

ORDER BY DATA.CREATED ASC