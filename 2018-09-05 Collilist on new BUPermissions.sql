select * from (SELECT
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
/* cast(case when (charindex(',',CV_BR.content)) > 0 then
left(CV_BR.content,(charindex(',',CV_BR.content))-1)+'.'+right(CV_BR.content,len(CV_BR.content)-(charindex(',',CV_BR.content)))
 else CV_BR.content end as float(10)) as 'Brutto',*/
replace(CV_BR.content,',','.') as 'Brutto',
LP.Weight as 'Netto',
CV_COLP.Content as 'Kollinummer',
CV_kenn.Content as 'Kennwort',
CV_POSlp.content as 'Position',
'' as 'Teillieferung (geplant)',
CV_LNLP.Content as 'Lot Nr. (Teillieferung)',
'' as 'Ext. Lieferschein Nr.(Siemens)',
'Kollo' as 'Kistenart',
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum,
Cv_FNlp.Content as 'Feld Nr.'

from loosepart LP
left join BusinessUnitPermission BP on LP.id = BP.LoosePartId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
left join HandlingUnit HU on LP.topHandlingUNitid = HU.id
INNER join customfield CF_KENN on BP.BusinessUnitId = CF_KENN.clientbusinessunitid and BP.LoosePartId = LP.id and CF_KENN.name = 'Kennwort'
INNER join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and BP.LoosePartId = LP.id and CV_KENN.EntityId = LP.Id
INNER join customfield CF_POSlp on BP.BusinessUnitId = CF_POSlp.clientbusinessunitid and CF_POSlp.name = 'Position'
INNER join customvalue CV_POSlp on CV_POSlp.customfieldid = CF_POSlp.Id and BP.LoosePartId = LP.id and CV_POSlp.EntityId = LP.Id
INNER join customfield CF_FNlp on BP.BusinessUnitId = CF_FNlp.clientbusinessunitid and CF_FNlp.name = 'Feld Nr.'
INNER join customvalue CV_FNlp on CV_FNlp.customfieldid = CF_FNlp.Id and BP.LoosePartId = LP.id and CV_FNlp.EntityId = LP.Id
INNER join customfield CF_COLP on BP.BusinessUnitId = CF_COLP.clientbusinessunitid and CF_COLP.name = 'Colli'
INNER join customvalue CV_COLP on CV_COLP.customfieldid = CF_COLP.Id and BP.LoosePartId = LP.id and CV_COLP.EntityId = LP.Id
INNER join customfield CF_BR on BP.BusinessUnitId = CF_BR.clientbusinessunitid and CF_BR.name = 'Brutto kg'
INNER join customvalue CV_BR on CV_BR.customfieldid = CF_BR.Id and BP.LoosePartId = LP.id and CV_BR.EntityId = LP.Id
INNER join customfield CF_LNLP on BP.BusinessUnitId = CF_LNLP.clientbusinessunitid and BP.LoosePartId = LP.id and CF_LNLP.name = 'Lot Nr. (Teillieferung)'
INNER join customvalue CV_LNLP on CV_LNLP.customfieldid = CF_LNLP.Id and CV_LNLP.EntityId = LP.Id


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
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
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
and BP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
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
HU.ColliNumber as 'Kollinummer',
CV_kenn.Content as 'Kennwort',
CV_POSHU.content as 'Position',
CV_TLHU.Content as 'Teillieferung (geplant)',
CV_LNHU.Content as 'Lot Nr. (Teillieferung)',
CV_ELHU.Content as 'Ext. Lieferschein Nr.(Siemens)',
CV_MAHU.Content as 'Kistenart',
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum,
Cv_FNHU.Content as 'Feld Nr.'


from HandlingUnit HU
left join BusinessUnitPermission BP on HU.id = BP.HandlingUnitId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
INNER join customfield CF_KENN on BP.BusinessUnitId = CF_KENN.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_KENN.name = 'Kommentar'
INNER join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = HU.Id
INNER join customfield CF_POSHU on BP.BusinessUnitId = CF_POSHU.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_POSHU.name = 'Position'
INNER join customvalue CV_POSHU on CV_POSHU.customfieldid = CF_POSHU.Id and CV_POSHU.EntityId = HU.Id
INNER join customfield CF_FNHU on BP.BusinessUnitId = CF_FNHU.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_FNHU.name = 'Feld Nr.'
INNER join customvalue CV_FNHU on CV_FNHU.customfieldid = CF_FNHU.Id and CV_FNHU.EntityId = HU.Id
INNER join customfield CF_TLHU on BP.BusinessUnitId = CF_TLHU.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_TLHU.name = 'Teillieferung (geplant)'
INNER join customvalue CV_TLHU on CV_TLHU.customfieldid = CF_TLHU.Id and CV_TLHU.EntityId = HU.Id
INNER join customfield CF_LNHU on BP.BusinessUnitId = CF_LNHU.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_LNHU.name = 'Lot Nr. (Teillieferung)'
INNER join customvalue CV_LNHU on CV_LNHU.customfieldid = CF_LNHU.Id and CV_LNHU.EntityId = HU.Id
INNER join customfield CF_ELHU on BP.BusinessUnitId = CF_ELHU.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_ELHU.name = 'Ext. Lieferschein Nr.(Siemens)'
INNER join customvalue CV_ELHU on CV_ELHU.customfieldid = CF_ELHU.Id and CV_ELHU.EntityId = HU.Id
INNER join customfield CF_MAHU on BP.BusinessUnitId = CF_MAHU.clientbusinessunitid and BP.HandlingUnitId = HU.id and CF_MAHU.name = 'Macros'
INNER join customvalue CV_MAHU on CV_MAHU.customfieldid = CF_MAHU.Id and CV_MAHU.EntityId = HU.Id

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
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
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

where BUPhu.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
--and dim.dvContent like  --$P{ProjectNr}
--and case when s.name = 'huPacked' then 1 else 0 end in  ($P{JustPacked},1)
)data
where data.Datum >= '2019-06-01'
and data.Datum <=  '2019-06-30'