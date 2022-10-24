
SET NOCOUNT ON

declare @TEMP table (ID UNIQUEIDENTIFIER,Entity varchar(20),EntityId UNIQUEIDENTIFIER,StatusID UNIQUEIDENTIFIER,Date DATETIME,row1 VARCHAR(MAX),row2 VARCHAR(MAX),  BusinessUnitId UNIQUEIDENTIFIER, Project varchar (30), [Order] varchar (30))
insert into @temp



select
newid(), 
'Loosepart' as Entity,
wfe.Entityid,
wfe.StatusId,
wfe.Updated, 
'LP'+cast(ROW_NUMBER()over(order by wfe.entityid, wfe.updated) as VARCHAR) as row1, 
'LP'+cast(ROW_NUMBER() over (order by wfe.entityid, wfe.updated)-1 as VARCHAR) as row2,
wfe.BusinessUnitId,
Dimensions.Project,
[Dimensions].[Order]
from WorkflowEntry WFE 
inner join (
select D.name, DV.Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order])
        ) as Dimensions on wfe.EntityId = Dimensions.EntityId
where wfe.EntityId in
(
select LoosePartID from BusinessUnitPermission BUP
where BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
and BUP.LoosePartID is not null
) and Dimensions.Project = 'VT00078220'
and wfe.Updated BETWEEN '2020-03-01' and '2020-03-31'
;
insert into @temp

select
newid(), 
'HandlingUnit' as Entity,
wfe.Entityid,
wfe.StatusId,
wfe.Updated, 
'HU'+cast(ROW_NUMBER()over(order by wfe.entityid, wfe.updated) as varchar) as row1, 
'HU'+cast(ROW_NUMBER() over (order by wfe.entityid, wfe.updated)-1 as varchar) as row2,
wfe.BusinessUnitId,
Dimensions.Project,
[Dimensions].[Order]
from WorkflowEntry WFE
inner join (
select D.name, DV.Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order])
        ) as Dimensions on wfe.EntityId = Dimensions.EntityId
where Wfe.EntityId in
(
select HandlingUnitId from BusinessUnitPermission BUP
where BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG')
and BUP.HandlingUnitId is not null
)  and Dimensions.Project = 'VT00078220'
and wfe.Updated BETWEEN '2020-03-01' and '2020-03-31'

SELECT T1.Entity, isnull(LP.Code,HU.code) as Code,isnull(T.text,S.Name) as Status, 
T1.[Date] 'start', --T2.[Date] 'end', 
cast(year(T1.date) as [varchar])+'-'+left(convert(char(11),T1.date,110),2)as 'YearMonth',
--case when T1.row1 = T2.Row2 and T1.EntityId <> T2.EntityId then getdate() else T2.date end as 'end',
cast(DATEDIFF([minute],T1.[Date],case when T1.row1 = T2.Row2 and T1.EntityId <> T2.EntityId then getdate() else T2.date end) as decimal(20,4))/60 duration_hours,
BU.name as BusinessUnit,
1 as 'count',
case when T1.row1 = T2.Row2 and T1.EntityId <> T2.EntityId then isnull(Llp.Code,Lhu.code) else NULL end as 'Last Location',
T1.Project,
T1.[Order]



FROM @TEMP T1
inner join @TEMP T2 on T1.row1 = T2.Row2 --and T1.EntityId = T2.EntityId


left join LoosePart LP on T1.EntityId = LP.Id
left join HandlingUnit HU on T1.EntityId = HU.Id
inner join [Status] S on T1.StatusID = S.id
left join Translation T on S.id = T.EntityId and T.[Language] = 'en'
left join BusinessUnit BU on T1.BusinessUnitId = Bu.Id
left join [Location] Llp on lp.ActualLocationId = Llp.Id
left join [Location] Lhu on hu.ActualLocationId = lhu.Id

where S.name not in ('Canceled2','LpNew','Canceled','HuNew')




