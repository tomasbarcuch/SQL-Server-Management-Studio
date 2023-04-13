DECLARE @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Duisburg')
DECLARE @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Mülheim')
DECLARE @WARNING_DAYS as TINYINT = 10

SELECT --distinct
HU.ID
,HU.Code
,HU.Protection
,ISNULL(SLClosed.SLClosed,HU.BoxClosedDate) LAST_PROTECTION_DATE
--,HU.BoxClosedDate
--,SLStatus.Name
,DATEADD(Month,HU.Protection,ISNULL(SLClosed.SLClosed,HU.BoxClosedDate)) as PRODUCTION_DATE
,DATEADD(Day,-@WARNING_DAYS,(DATEADD(Month,HU.Protection,ISNULL(SLClosed.SLClosed,HU.BoxClosedDate)))) as WarningDate
 from HandlingUnit HU
--LEFT JOIN ServiceLine SL on HU.id = SL.EntityId AND SL.ServiceTypeId IN (Select id from ServiceType where Code in ('PROTECTION','REPROTECTION'))
--LEFT JOIN STATUS SLStatus on SL.StatusId = SLStatus.Id
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = @ClientBusinessUnitId --AND WFE.WorkflowAction = 22
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.Id) AND ([BUP].[BusinessUnitId] = @BusinessUnitID))
LEFT JOIN (select Distinct SL.EntityId,MAX(WFE.Created) over (Partition by SL.EntityId) SLClosed from WorkflowEntry WFE 
INNER JOIN ServiceLine SL on WFE.EntityId = SL.Id
where WFE.Entity = 48 and WFE.StatusId in (select id from status where name in ('CLOSED'))


) SLCLOSED on HU.Id = SLCLOSED.EntityId
WHERE HU.Protection > 0 and HU.BoxClosedDate IS NOT NULL

--AND HU.Code = '2012002911220095'
