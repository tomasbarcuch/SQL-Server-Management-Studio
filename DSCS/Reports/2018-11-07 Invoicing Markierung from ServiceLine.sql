declare @CF as varchar (max)
declare @datefrom as DATE
declare @dateto as DATE
declare @status as varchar(max)

set @CF = 'Markierungsvorschrift / Sondermarkierung'
set @datefrom = '2018-10-01'
set @dateto = '2018-10-31'
set @status = 'SlDone'

select
St.code,
SL.[Description],
HU.code as Entity,
HU.[Description] as HUDescr,
isnull(T.Text,Ssl.name) as Status,
Statuschanged.StatusChanged,
DIM.Content as 'Markierungsvorschrift / Sondermarkierung'
from ServiceLine SL
inner join ServiceType ST on SL.ServiceTypeId = ST.Id
inner join HandlingUnit HU on SL.EntityId = HU.id
left join 
(select EntityId, DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId and df.Name = @CF
inner join Dimension D on DF.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join DimensionValue DV on DFV.DimensionValueId = DV.Id
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId and entity = 11) Dim on sl.EntityId = Dim.EntityId
inner join Status Ssl on SL.StatusId = Ssl.Id
inner join Status Shu on HU.StatusId = Shu.id
inner join (select
SL.ID slId,SL.StatusId,max(WFE.Created) StatusChanged
 from dbo.ServiceLine SL
inner join dbo.workflowentry WFE on SL.id = WFE.entityid and SL.Statusid = WFE.StatusID
group by SL.ID,SL.StatusId) StatusChanged on SL.StatusId = StatusChanged.StatusId and sl.id = StatusChanged.slId
left join translation T on ssl.Id = T.EntityId and T.Language = 'de'

where 
--St.Code in ('Nachträgliche Markierung','Sondermarkierung') and
Statuschanged.StatusChanged between @datefrom and @dateto
and Ssl.name = @status

union

select
ST.code,
SL.[Description],
LP.code as Entity,
LP.[Description] as HUDescr,
isnull(T.Text,Ssl.name) as Status,
Statuschanged.StatusChanged,
DIM.Content as 'Markierungsvorschrift / Sondermarkierung'
from ServiceLine SL
inner join ServiceType ST on SL.ServiceTypeId = ST.Id
inner join LoosePart LP on SL.EntityId = LP.id
left join 
(select EntityId, DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId and df.Name = @CF
inner join Dimension D on DF.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join DimensionValue DV on DFV.DimensionValueId = DV.Id
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId and entity = 15) Dim on sl.EntityId = Dim.EntityId
inner join Status Ssl on SL.StatusId = Ssl.Id
inner join Status Slp on LP.StatusId = Slp.id
inner join (select
SL.ID slId,SL.StatusId,max(WFE.Created) StatusChanged
 from dbo.ServiceLine SL
inner join dbo.workflowentry WFE on SL.id = WFE.entityid and SL.Statusid = WFE.StatusID
group by SL.ID,SL.StatusId) StatusChanged on SL.StatusId = StatusChanged.StatusId and sl.id = StatusChanged.slId
left join translation T on ssl.Id = T.EntityId and T.Language = 'de'

where 
--St.Code in ('Nachträgliche Markierung LP','Sondermarkierung LP') and
Statuschanged.StatusChanged between @datefrom and @dateto
and Ssl.name = @status
