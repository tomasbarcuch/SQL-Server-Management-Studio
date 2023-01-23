BEGIN TRANSACTION

UPDATE WFE SET WFE.Created = DATA.DATEFIX from WorkflowEntry WFE 

INNER JOIN (


SELECT
DATA.Id,
CASE WHEN DATA.Created between ISNULL(DATA.LG,Created) and ISNULL(DATA.LD,Created) THEN 0 ELSE 1 END AS FIX,
CASE WHEN (CASE WHEN DATA.Created between ISNULL(DATA.LG,Created) and ISNULL(DATA.LD,Created) THEN 0 ELSE 1 END) = 1 THEN 
DATEADD(MINUTE,DATEDIFF(MINUTE,LG,LD)/2,LG) ELSE NULL END DATEFIX

FROM (

select
WFE.Id,
WFE.EntityId,
WFE.Created,
LAG(WFE.Created) OVER (ORDER BY WFE.EntityId, WFE.Updated) LG,
LEAD(WFE.Created) OVER (ORDER BY WFE.EntityId, WFE.Updated) LD,
CASE WHEN LAG(WFE.EntityId) OVER (ORDER BY WFE.EntityId, WFE.Updated) = WFE.EntityId THEN
LAG(WFE.Created) OVER (ORDER BY WFE.EntityId, WFE.Updated)
ELSE NULL END
NEXTCreated,


WFE.Updated

from WorkflowEntry WFE


where WFE.updated <> WFE.Created and
 WFE.ClientBusinessUnitId = (select id from BusinessUnit where name = 'Siemens Duisburg')
--AND WFE.EntityId = 'fe27d8e8-3ed3-4f6e-8cdc-0acec1458cd6'
--order by WFE.EntityId, WFE.Updated


) DATA 

WHERE CREATED <> Updated

--AND CASE WHEN DATA.Created between ISNULL(DATA.LG,Created) and ISNULL(DATA.LD,Created) THEN 0 ELSE 1 END = 1


--ORDER BY EntityId,Updated

) DATA on WFE.ID = DATA.ID and FIX = 1 AND DATEFIX IS NOT NULL

ROLLBACK