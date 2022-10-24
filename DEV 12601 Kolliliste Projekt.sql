use [DFCZ_OSLET_tst]

SELECT
--lp.TopHandlingUnitId,
--lp.id,
case when lp.TopHandlingUnitId is not null then 'HU' else 'LP' END as 'Entität',
isnull(HU.code,LP.code) as 'Entität Kode',
dv.Content as 'Projekt',
isnull(HU.[Description], LP.[Description]) as 'Beschreibung',
isnull(HU.Length,LP.Length) as Länge,
isnull(HU.width, LP.width) as Breite,
isnull(HU.Height, LP.Height) as Höhe,
isnull(HU.Brutto, 0) as 'Brutto',
--isnull(HU.Weight, 0) as 'Tara',
isnull(HU.Netto, LP.Weight) as 'Netto',
isnull(HU.colliNumber,'') as 'Kollinummer',
isnull(CV_KENN.Content,'') as 'Kennwort',
case when lp.TopHandlingUnitId is not null then '' else CV_POSlp.content end as 'Position (LP)',
--CV_POShu.content as 'Position (HU)',
s.Name as 'Status',
max(sdate.StatusChanged),
Cv_FNlp.Content as 'Feld Nr.'

from loosepart LP

left join HandlingUnit HU on LP.topHandlingUNitid = HU.id
INNER join customfield CF_KENN on lp.ClientBusinessUnitId = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kennwort'
INNER join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = LP.Id
INNER join customfield CF_POSlp on lp.ClientBusinessUnitId = CF_POSlp.clientbusinessunitid and CF_POSlp.name = 'Position'
INNER join customvalue CV_POSlp on CV_POSlp.customfieldid = CF_POSlp.Id and CV_POSlp.EntityId = LP.Id
INNER join customfield CF_FNlp on lp.ClientBusinessUnitId = CF_FNlp.clientbusinessunitid and CF_FNlp.name = 'Feld Nr.'
INNER join customvalue CV_FNlp on CV_FNlp.customfieldid = CF_FNlp.Id and CV_FNlp.EntityId = LP.Id
inner join customfield CF_POShu on lp.ClientBusinessUnitId = CF_POShu.clientbusinessunitid and CF_POShu.name = 'Position'
inner join customvalue CV_POShu on CV_POShu.customfieldid = CF_POShu.Id and CV_POShu.EntityId = isnull(lp.TopHandlingUnitId,lp.id)
inner join Status S on LP.StatusId = s.Id

 inner join dbo.EntityDimensionValueRelation EDVR on lp.ID = EDVR.EntityId
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.id = 'ff69ece4-c69d-4cfd-a319-0552a8da1b83'
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
 inner join dbo.Dimension D on DV.DimensionId = D.Id


left outer join 
(select 
lp.id lpId,
lp.statusid stid,
max(WE.Created) as StatusChanged
from loosepart LP 
left join dbo.workflowentry WE on lp.id = we.entityid 
group by lp.id,lp.statusid) sdate on lp.id = sdate.lpId and lp.StatusId = Sdate.stid

where lp.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' 

group by 

case when lp.TopHandlingUnitId is not null then 'HU' else 'LP' END,
isnull(HU.code,LP.code),
dv.Content,
isnull(HU.[Description], LP.[Description]),
isnull(HU.Length,LP.Length),
isnull(HU.width, LP.width),
isnull(HU.Height, LP.Height),
isnull(HU.Brutto, 0),
--isnull(HU.Weight, 0),
isnull(HU.Netto, LP.Weight),
isnull(HU.colliNumber,''),
isnull(CV_KENN.Content,''),
case when lp.TopHandlingUnitId is not null then '' else CV_POSlp.content end,
--CV_POShu.content,
s.Name,
Cv_FNlp.Content


select count(id) from LoosePart where ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'