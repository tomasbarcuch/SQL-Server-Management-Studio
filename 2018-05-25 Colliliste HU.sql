use [DFCZ_OSLET_tst]

SELECT
--HU.TopHandlingUnitId,
--HU.id,
'HU' as 'Entität',
HU.code as 'Entität Kode',
dim.dvContent+'-'+dim.DFVContent as 'Projekt',
HU.[Description] as 'Beschreibung',
HU.Length as Länge,
HU.width as Breite,
 HU.Height as Höhe,
 HU.Brutto as 'Brutto',
HU.Weight as 'Netto',
HU.ColliNumber as 'Kollinummer',
CV_kenn.Content as 'Kennwort',
CV_POSHU.content as 'Position (HU)',
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

where HU.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' --and HU.code = '0000034769/000812'







select count(id) from HandlingUnit where ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'
select count(distinct((id))) from LoosePart where ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'