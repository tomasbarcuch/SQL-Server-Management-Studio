
declare @TEMP table (ID UNIQUEIDENTIFIER,Entity varchar(20),EntityId UNIQUEIDENTIFIER,StatusID UNIQUEIDENTIFIER,Date DATETIME,row1 INT,row2 int, BusinessUnitId UNIQUEIDENTIFIER)
insert into @temp

select
newid(), 
'HandlingUnit' as Entity,
wfe.Entityid,
wfe.StatusId,
wfe.Updated, 
ROW_NUMBER()over(order by wfe.entityid, wfe.updated) as row1, 
ROW_NUMBER() over (order by wfe.entityid, wfe.updated)-1 as row2,
wfe.BusinessUnitId
from WorkflowEntry WFE 
where EntityId in
(
select HandlingUnitId from BusinessUnitPermission BUP
where BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
and BUP.HandlingUnitId is not null
)


SELECT T1.Entity, HU.code as Code,isnull(T.text,S.Name) as Status, T1.[Date] 'start', --T2.[Date] 'end', 
--case when T1.row1 = T2.Row2 and T1.EntityId <> T2.EntityId then getdate() else T2.date end as 'end',
cast(DATEDIFF([minute],T1.[Date],case when T1.row1 = T2.Row2 and T1.EntityId <> T2.EntityId then getdate() else T2.date end) as decimal(20,4))/60 duration_hours,
BU.name as BusinessUnit,
1 as 'count',
case when T1.row1 = T2.Row2 and T1.EntityId <> T2.EntityId then L.Code else NULL end as 'Last Location'


FROM @TEMP T1
inner join @TEMP T2 on T1.row1 = T2.Row2 --and T1.EntityId = T2.EntityId
inner join HandlingUnit HU on T1.EntityId = HU.Id
inner join [Status] S on T1.StatusID = S.id
left join Translation T on S.id = T.EntityId and T.[Language] = 'en'
left join BusinessUnit BU on T1.BusinessUnitId = Bu.Id
left join [Location] L on HU.ActualLocationId = L.Id

where S.name not in ('Canceled2','LpNew','Canceled','HuNew')
--and LP.code = 'LPKR-005454'
--order by T2.[Date] DESC


