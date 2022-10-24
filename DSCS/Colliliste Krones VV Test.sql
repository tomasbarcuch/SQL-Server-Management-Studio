


select * from (
    SELECT
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
'LP' as 'Entität',
LP.code as 'Entität Kode',
HU.Code as HUKode,
dim.dvContent as 'Projekt',
dim.DFVContent as 'ProjDesc',
LP.[Description] as 'Beschreibung',
cast (LP.Length as decimal) /10 as Länge,
cast (LP.width as decimal) /10 as Breite,
cast (LP.height as decimal) /10 as Höhe,
'' as Brutto,
LP.Weight as 'Netto',
'Kollo' as 'Kistenart',
'' as Kollinumer,
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum


from loosepart LP
left join BusinessUnitPermission BP on LP.id = BP.LoosePartId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
left join HandlingUnit HU on LP.topHandlingUNitid = HU.id
left outer join  (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Container No.','Seal No.')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Container No.],[Seal No.])) as CUS on LP.id = CUS.EntityId


inner join Status S on LP.StatusId = s.Id
left join dbo.[Translation] T on S.ID = T.entityId and T.language = 'DE'
left outer join 
 (select
BUP.businessUnitID clientbusinessUnitID,
edvr.entityid as entityID,
edvr.entity as Entity,
d.name as DimensionName,
d.description as DimensionDescription , 
df.name as DFName,
dfv.content as DFVContent ,
dv.content as DVContent,
dv.description VDescritpion

 from 
 dbo.EntityDimensionValueRelation EDVR
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Project')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0
left outer join BusinessUnitPermission BUP on D.id = BUP.DimensionId) Dim on lp.id = dim.entityID  and dim.entity = 15
 


left outer join 
(select 
lp.id lpId,
lp.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from loosepart LP 
left join dbo.workflowentry WE on lp.id = we.entityid 
group by lp.id,lp.statusid) sdate on lp.id = sdate.lpId and lp.StatusId = Sdate.stid

where  LP.topHandlingUNitid is null
and BP.BusinessUnitId = (select id from businessunit where name = 'Krones AG VV')--$P{ClientBusinessUnitid} 
--and dim.dvContent like $P{ProjectNr} 
and LP.topHandlingUNitid is null
--and case when s.name = 'lpPacked' then 1 else 0 end in ($P{JustPacked},1)

UNION

SELECT
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
'HU' as 'Entität',
HU.code as 'Entität Kode',
'' as HUKode,
dim.dvContent as 'Projekt',
dim.DFVContent as 'ProjDesc',
HU.[Description] as 'Beschreibung',
cast (HU.Length as decimal) /10 as Länge,
cast (HU.Width as decimal) /10as Breite,
cast (HU.height as decimal) /10 as Höhe,
 cast(HU.Brutto as float) as 'Brutto',
HU.Netto as 'Netto',
HUT.Code as KistenArt,
HU.ColliNumber as 'Kollinummer',
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum



from HandlingUnit HU
left join BusinessUnitPermission BP on HU.id = BP.HandlingUnitId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
inner join handlingunittype HUT on HU.TypeId = HUT.Id
left outer join  (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Container No.','Seal No.')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Container No.],[Seal No.])) as CUS on HU.id = CUS.EntityId

inner join Status S on HU.StatusId = s.Id
left join dbo.[Translation] T on S.ID = T.entityId and T.language = 'DE'
left outer join 
 (select
BUP. BusinessUnitId clientbusinessUnitID,
edvr.entityid as entityID,
edvr.entity as Entity,
d.name as DimensionName,
d.description as DimensionDescription , 
df.name as DFName,
dfv.content as DFVContent ,
dv.content as DVContent,
dv.description VDescritpion

 from 
 dbo.EntityDimensionValueRelation EDVR
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Project')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0
left outer join BusinessUnitPermission BUP on D.id = BUP.DimensionId) Dim on HU.id = dim.entityID and dim.entity = 11

left outer join 
(select 
HU.id HUId,
HU.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
left join dbo.workflowentry WE on HU.id = we.entityid 
group by HU.id,HU.statusid) sdate on HU.id = sdate.HUId and HU.StatusId = Sdate.stid
left outer join (SELECT HandlingUnitId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE HandlingUnitId is not null) BUPhu on HU.id = BUPhu.HandlingUnitId

where BUPhu.BusinessUnitId = (select id from businessunit where name = 'Krones AG VV') --$P{ClientBusinessUnitid} 
--and dim.dvContent like  $P{ProjectNr}
--and case when s.name = 'huPacked' then 1 else 0 end in  ($P{JustPacked},1)
)data
where data.Datum >= '2019-05-01'--$P{FromDate}
and data.Datum <=  '2019-05-31'--$P{ToDate}