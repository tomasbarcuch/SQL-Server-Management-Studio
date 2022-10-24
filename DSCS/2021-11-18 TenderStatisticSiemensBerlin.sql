select
case WFE.Entity when 11 then 'HU' else 'LP' end as Entity
,isnull(HU.Code,LP.Code) Code
,ACHU.Code ActualHandlingUnit
,ISNULL(SHU.Text,SLP.Text) ActualStatus,
T.Text Status
,WFE.Created StatusChange
,LSC.LastStatusChange 
,ISNULL(LP.Length/10.0,HU.Length/10.0) Length
,ISNULL(LP.Width/10.0,HU.Width/10.0) Width
,ISNULL(LP.Height/10.0,HU.Height/10.0) Height
,ISNULL(LP.Surface,HU.Surface/10.0) Surface
,ISNULL(LP.BaseArea,HU.BaseArea/10.0) BaseArea
,ISNULL(LP.Volume,HU.Volume/10.0) Volume
from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.StatusId = BUP.StatusId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
inner join Status S on WFE.StatusId = S.Id and s.name in ('LpPacked','LpPackedManually','HuPacked') and  WFE.Entity in (11,15) and WFE.Created BETWEEN '2019-10-01' and '2020-09-30'
inner join Translation T on S.id = T.EntityId and T.[Column] = 'Name' and T.Language = 'de'
inner join (  select EntityId, max(Created) as LastStatusChange from WorkflowEntry  group by EntityId) LSC on WFE.EntityID = LSC.EntityId
left join LoosePart LP on WFE.EntityID = LP.id and WFE.Entity = 15
left join HandlingUnit HU on WFE.EntityID = HU.id and WFE.Entity = 11
left join HandlingUnit ACHU on LP.TopHandlingUnitId = ACHU.id
left join Translation SLP on LP.StatusId = SLP.EntityId and SLP.[Column] = 'Name' and SLP.Language = 'de'
left join Translation SHU on HU.StatusId = SHU.EntityId and SHU.[Column] = 'Name' and SHU.Language = 'de'


order  by LSC.LastStatusChange,isnull(HU.Code,LP.Code),WFE.Created