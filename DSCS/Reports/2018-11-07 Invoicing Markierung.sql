declare @CF as varchar (max)
declare @datefrom as DATE
declare @dateto as DATE
set @CF = 'Markierungsvorschrift / Sondermarkierung'
set @datefrom = '2018-10-01'
set @dateto = '2018-10-31'

select
HU.code as HUCode,
HU.[Description] as HUDescr,
isnull(T.Text,S.name) as Status,
Statuschanged.StatusChanged,
DF.Name,
DFV.Content as 'Markierungsvorschrift / Sondermarkierung'
from DimensionField DF
inner join DimensionFieldValue DFV on DF.id = DFV.DimensionFieldId
inner join Dimension D on DF.DimensionId = D.Id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join DimensionValue DV on DFV.DimensionValueId = DV.Id
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId and entity = 11
inner join HandlingUnit HU on EDVR.EntityId = HU.Id
inner join Status S on HU.StatusId = S.Id
inner join (select
HU.ID huId,HU.StatusId,max(WFE.Created) StatusChanged
 from dbo.HandlingUnit HU
inner join dbo.workflowentry WFE on HU.id = WFE.entityid and HU.Statusid = WFE.StatusID
group by HU.ID,HU.StatusId) StatusChanged on HU.StatusId = StatusChanged.StatusId and HU.id = StatusChanged.huId
left join Translation T on S.id = T.EntityId and T.Language = 'de'
where DF.name = @CF and DFV.Content <> ''
and StatusChanged.StatusChanged between @datefrom and @dateto
