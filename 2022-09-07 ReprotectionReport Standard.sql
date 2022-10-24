DECLARE @DeadLine as DATE = GETDATE()+3000
DECLARE @DateFrom as DATE = GETDATE()-3000

SELECT 
HU.Code,
HU.Protection
,DATA.FirstDate as Date_Packed
,DATEADD(MONTH,HU.Protection, DATA.FirstDate) as Date_Reprotection
,HU.BoxClosedDate
,SERVICELINES.*

from (

SELECT 
		wfe.[EntityId]
      ,CAST(min(wfe.[Updated]) as DATE) as FirstDate
      ,CAST(max(wfe.[Updated]) as DATE) as LastDate
      
  FROM dbo.WorkflowEntry WFE
  
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.HandlingUnitId and BUP.BusinessUnitID = (Select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')

where entity = 11 and wfe.WorkflowAction = 22

group by wfe.EntityId
)DATA
inner join HandlingUnit HU on DATA.EntityId = HU.Id
left join PackingOrderHeader POH on HU.id = POH.HandlingUnitId

INNER JOIN (
select 
ISNULL(T.Text,ST.Code) as Code
,SL.EntityId
,CAST(CAST(CV.Content as DATE) as VARCHAR) +' '+ S.Name Content
from ServiceLine SL 
inner join ServiceType ST on SL.ServiceTypeId = ST.Id
inner join BusinessUnitPermission BUP on ST.id = BUP.ServiceTypeId and BUP.BusinessUnitId = (Select id from BusinessUnit where Name = 'DEUFOL CUSTOMERS')
inner join [Status] S on SL.StatusId = S.Id-- and S.Name = 'PLANNED'
LEFT JOIN Translation T on ST.id = T.EntityId and T.[Language] = 'de' AND T.[Column] = 'Description'
inner join CustomValue CV on SL.Id = CV.EntityId and CV.CustomFieldId = 'f7e63e45-014e-46a6-90c0-a5c999e664de'
) SRC
PIVOT (max(src.Content) for src.Code  in ([Austausch des Trockenmittels],[Folienwechsel],[Trockenmittel- und Folienwechsel])
) SERVICELINES ON HU.Id = SERVICELINES.EntityId


where HU.Protection > 0 and HU.ActualLocationId is not NULL
and DATEADD(MONTH,HU.Protection, DATA.FirstDate) BETWEEN @DateFrom AND @DeadLine

