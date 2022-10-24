declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Neutraubling')
select 
11 as Entity
,HUcode Code
,'REPROTECTION' as 'ServiceType'
,L.Code+' - Neukonservierung bis'+' '+Cast(cast(Deadline as date) as varchar) [Description]
,cast(Deadline as date) as 'CF_EXECUTION_DATE'
--,L.Code Location
 FROM(
 select --TOP(100) 
 HU.Code Hucode,
 HU.[Description] HUdesc,
 HU.ActualLocationId,
 CV.EntityId,
 CV.Content,
 Closed.FirstDate,
 Closed.LastDate,
 DATEADD(MONTH,cast(right(left( CV.Content,charindex(']', CV.Content)-2),len(left( CV.Content,charindex(']',CV.Content)-2))-1) as INT),Closed.FirstDate) Deadline,
cast(right(left( CV.Content,charindex(']', CV.Content)-2),len(left( CV.Content,charindex(']',CV.Content)-2))-1) as INT) as ProtectionMonths,
PlanDate.Content as Planed ,
Reconserved.LastDate Reconserved
 
 FROM CustomValue CV
 inner join HandlingUnit HU on CV.EntityId = HU.Id and CV.CustomFieldId in (Select id from CustomField where name = 'Foil') and LEN(CV.Content)>0 
 inner join BusinessUnitPermission BUP on CV.EntityId = BUP.HandlingUnitId --and BUP.BusinessUnitId = (Select Id from BusinessUnit where Name = 'KRONES GLOBAL')

and EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[HandlingUnitId] = HU.id) AND ([BUP].[BusinessUnitId] = @PackerBusinessUnitId)) --$P{PackerBusinessUnitId}))



 inner join (SELECT 
		wfe.[EntityId]
      ,min(wfe.[Updated]) as FirstDate
      ,max(wfe.[Updated]) as LastDate
  FROM dbo.WorkflowEntry WFE
  inner join dbo.status s on wfe.statusid = s.id
  where entity = 11 and wfe.statusid = (select S.id from [Status] S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = @ClientBusinessUnitId
where S.name = 'BOX_CLOSED')
  group by 
s.id, wfe.[Entity] ,wfe.[EntityId]) Closed on CV.EntityId = Closed.EntityId

left join ServiceLine SL on CV.EntityId = SL.EntityId
left join CustomValue PlanDate on SL.Id = PlanDate.EntityId and PlanDate.CustomFieldId in (Select id from CustomField where name = 'EXECUTION_DATE') 
 
left join (SELECT 
		wfe.[EntityId]
      ,min(wfe.[Updated]) as FirstDate
      ,max(wfe.[Updated]) as LastDate
  FROM dbo.WorkflowEntry WFE
  inner join dbo.status s on wfe.statusid = s.id
  where entity = 48 and wfe.statusid = (select S.id from [Status] S inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = @ClientBusinessUnitId


where S.name = 'FINISHED'
)
  group by 
s.id, wfe.[Entity] ,wfe.[EntityId]) Reconserved on SL.Id = Reconserved.EntityId

 where CV.Content in (
('[6M] Alu,schrumpfen,schweissen,abdecken'),
('[12M] Alu,schrumpfen,schweissen,abdecken'),
('[24M] Alu,schrumpfen,schweissen,abdecken')
 )

) DATA

inner join [Location] L on DATA.ActualLocationId = L.id

where DATEDIFF(DAY,GETDATE(),DATA.Deadline) between -100 and 30


