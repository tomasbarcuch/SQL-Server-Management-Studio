use [DFCZ_OSLET_tst]

SELECT
--lp.TopHandlingUnitId,
--lp.id,
'LP' as 'Entität',
LP.code as 'Entität Kode',
dv.Content as 'Projekt',
df.name,
d
LP.[Description] as 'Beschreibung',
LP.Length as Länge,
LP.width as Breite,
 LP.Height as Höhe,
 0 as 'Brutto',
LP.Weight as 'Netto',
'' as 'Kollinummer',
'' as 'Kennwort',
CV_POSlp.content as 'Position (LP)',
s.Name as 'Status',
sdate.StatusChanged,
Cv_FNlp.Content as 'Feld Nr.'
,*
from loosepart LP

left join HandlingUnit HU on LP.topHandlingUNitid = HU.id
INNER join customfield CF_KENN on lp.ClientBusinessUnitId = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kennwort'
INNER join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = LP.Id
INNER join customfield CF_POSlp on lp.ClientBusinessUnitId = CF_POSlp.clientbusinessunitid and CF_POSlp.name = 'Position'
INNER join customvalue CV_POSlp on CV_POSlp.customfieldid = CF_POSlp.Id and CV_POSlp.EntityId = LP.Id
INNER join customfield CF_FNlp on lp.ClientBusinessUnitId = CF_FNlp.clientbusinessunitid and CF_FNlp.name = 'Feld Nr.'
INNER join customvalue CV_FNlp on CV_FNlp.customfieldid = CF_FNlp.Id and CV_FNlp.EntityId = LP.Id
inner join Status S on LP.StatusId = s.Id

 inner join dbo.EntityDimensionValueRelation EDVR on lp.ID = EDVR.EntityId and edvr.Entity = 15
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.id = 'ff69ece4-c69d-4cfd-a319-0552a8da1b83'
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0


left outer join 
(select 
lp.id lpId,
lp.statusid stid,
max(WE.Created) as StatusChanged
from loosepart LP 
left join dbo.workflowentry WE on lp.id = we.entityid 
group by lp.id,lp.statusid) sdate on lp.id = sdate.lpId and lp.StatusId = Sdate.stid

where lp.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' --and lp.code = 'LP3105-0001'


select count(id) from LoosePart where ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'
select count(distinct((id))) from LoosePart where ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'