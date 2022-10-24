use [DFCZ_OSLET_tst]

SELECT
--lp.TopHandlingUnitId,
--lp.id,
'LP' as 'Entität',
LP.code as 'Entität Kode',
HU.Code as HUKode,
dim.dvContent+'-'+dim.DFVContent as 'Projekt',
LP.[Description] as 'Beschreibung',
LP.Length as Länge,
LP.width as Breite,
 LP.Height as Höhe,
 0 as 'Brutto',
LP.Weight as 'Netto',
'' as 'Kollinummer',
CV_kenn.Content as 'Kennwort',
CV_POSlp.content as 'Position',
s.Name as 'Status',
sdate.StatusChanged,
Cv_FNlp.Content as 'Feld Nr.'

from loosepart LP

left join HandlingUnit HU on LP.topHandlingUNitid = HU.id
INNER join customfield CF_KENN on lp.ClientBusinessUnitId = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kennwort'
INNER join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = LP.Id
INNER join customfield CF_POSlp on lp.ClientBusinessUnitId = CF_POSlp.clientbusinessunitid and CF_POSlp.name = 'Position'
INNER join customvalue CV_POSlp on CV_POSlp.customfieldid = CF_POSlp.Id and CV_POSlp.EntityId = LP.Id
INNER join customfield CF_FNlp on lp.ClientBusinessUnitId = CF_FNlp.clientbusinessunitid and CF_FNlp.name = 'Feld Nr.'
INNER join customvalue CV_FNlp on CV_FNlp.customfieldid = CF_FNlp.Id and CV_FNlp.EntityId = LP.Id
inner join Status S on LP.StatusId = s.Id
left outer join 
 (select
d.clientbusinessUnitID,
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
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0) Dim on lp.id = dim.entityID and lp.ClientBusinessUnitId = dim.ClientBusinessUnitId and dim.entity = 15

left outer join 
(select 
lp.id lpId,
lp.statusid stid,
max(WE.Created) as StatusChanged
from loosepart LP 
left join dbo.workflowentry WE on lp.id = we.entityid 
group by lp.id,lp.statusid) sdate on lp.id = sdate.lpId and lp.StatusId = Sdate.stid

where lp.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' --and lp.code = '0000034769/000812'





UNION


SELECT
--HU.TopHandlingUnitId,
--HU.id,
'HU' as 'Entität',
HU.code as 'Entität Kode',
'' as HUKode,
dim.dvContent+'-'+dim.DFVContent as 'Projekt',
HU.[Description] as 'Beschreibung',
HU.Length as Länge,
HU.width as Breite,
 HU.Height as Höhe,
 HU.Brutto as 'Brutto',
HU.Weight as 'Netto',
HU.ColliNumber as 'Kollinummer',
CV_kenn.Content as 'Kennwort',
CV_POSHU.content as 'Position',
s.Name as 'Status',
sdate.StatusChanged,
Cv_FNHU.Content as 'Feld Nr.'

from HandlingUnit HU

--left join HandlingUnit HU on HU.topHandlingUNitid = HU.id
INNER join customfield CF_KENN on HU.ClientBusinessUnitId = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kommentar'
INNER join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = HU.Id
INNER join customfield CF_POSHU on HU.ClientBusinessUnitId = CF_POSHU.clientbusinessunitid and CF_POSHU.name = 'Position'
INNER join customvalue CV_POSHU on CV_POSHU.customfieldid = CF_POSHU.Id and CV_POSHU.EntityId = HU.Id
INNER join customfield CF_FNHU on HU.ClientBusinessUnitId = CF_FNHU.clientbusinessunitid and CF_FNHU.name = 'Feld Nr.'
INNER join customvalue CV_FNHU on CV_FNHU.customfieldid = CF_FNHU.Id and CV_FNHU.EntityId = HU.Id
inner join Status S on HU.StatusId = s.Id
left outer join 
 (select
d.clientbusinessUnitID,
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
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0) Dim on HU.id = dim.entityID and HU.ClientBusinessUnitId = dim.ClientBusinessUnitId and dim.entity = 11

left outer join 
(select 
HU.id HUId,
HU.statusid stid,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
left join dbo.workflowentry WE on HU.id = we.entityid 
group by HU.id,HU.statusid) sdate on HU.id = sdate.HUId and HU.StatusId = Sdate.stid

where HU.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'