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
replace(LPCF.[Brutto kg] ,',','.') as 'Brutto',
LP.Weight as 'Netto',
LPCF.Colli as 'Kollinummer',
LPCF.Kennwort,
LPCF.Position,
'' as 'Teillieferung (geplant)',
LPCF.[Lot Nr. (Teillieferung)],
'' as 'Ext. Lieferschein Nr.(Siemens)',
'Kollo' as 'Kistenart',
CASE when LP.id in (
    select LoosePartId from PackingRule PR
    inner join HandlingUnit HU on PR.ParentHandlingUnitId = HU.Id
    inner join 
(select 
HU.id HUId,
HU.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
inner join dbo.workflowentry WE on HU.id = we.entityid and hu.StatusId = (select id from status where name = 'HuPackedByPackingRule')
group by HU.id,HU.statusid) sdate on PR.ParentHandlingUnitId = sdate.HUId and HU.StatusId = Sdate.stid) then 'LP in HU Vorverpackt' else isnull(t.Text,s.name) end  as Status,
CASE when LP.id in (
    select LoosePartId from PackingRule PR
    inner join HandlingUnit HU on PR.ParentHandlingUnitId = HU.Id
    inner join 
(select 
HU.id HUId,
HU.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
inner join dbo.workflowentry WE on HU.id = we.entityid and hu.StatusId = (select id from status where name = 'HuPackedByPackingRule')
group by HU.id,HU.statusid) sdate on PR.ParentHandlingUnitId = sdate.HUId and HU.StatusId = Sdate.stid) then husdate.Datum else sdate.Datum end as Datum,
sdate.StatusChanged,
LPCF.[Feld Nr.],
LPCF.SBExport,
LPCF.SBExportExtra

from loosepart LP
left join BusinessUnitPermission BP on LP.id = BP.LoosePartId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
left join HandlingUnit HU on LP.topHandlingUNitid = HU.id
left join PackingRule PR on LP.id = PR.LoosePartId
left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Kennwort','Position','Feld Nr.','Colli','Brutto kg','Lot Nr. (Teillieferung)','SBExport','SBExportExtra') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Kennwort],[Position],[Feld Nr.],[Colli],[Brutto kg],[Lot Nr. (Teillieferung)],[SBExport],[SBExportExtra])
        ) as LPCF on LP.id = LPCF.EntityID

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

 left join 
(select 
HU.id HUId,
HU.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
inner join dbo.workflowentry WE on HU.id = we.entityid and hu.StatusId = (select id from status where name = 'HuPackedByPackingRule')
group by HU.id,HU.statusid) husdate on PR.ParentHandlingUnitId = husdate.HUId


where 
BP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')--$P{ClientBusinessUnitid} 
and dim.dvContent like '37696'--  $P{ProjectNr}
and LP.TopHandlingUnitId is null
and LP.TopHandlingUnitId is null
and case when ( 
((
(s.name in ('lpPacked','LpPackedManually'))))
or ( 
LP.id in (
    select LoosePartId from PackingRule PR
    inner join HandlingUnit HU on PR.ParentHandlingUnitId = HU.Id
    inner join 
(select 
HU.id HUId,
HU.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
inner join dbo.workflowentry WE on HU.id = we.entityid and hu.StatusId = (select id from status where name = 'HuPackedByPackingRule')
group by HU.id,HU.statusid) sdate on PR.ParentHandlingUnitId = sdate.HUId and HU.StatusId = Sdate.stid))

) then 1 else 0 end in (0,1)--($P{JustPacked},1)

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
cast (HU.Width as decimal) /10 as Breite,
cast (HU.height as decimal) /10 as Höhe,
 cast(HU.Brutto as float) as 'Brutto',
HU.Netto as 'Netto',
HU.ColliNumber as 'Kollinummer',
HUCF.Kommentar as 'Kennwort',
HUCF.Position,
HUCF.[Teillieferung (geplant)],
HUCF.[Lot Nr. (Teillieferung)],
HUCF.[Ext. Lieferschein Nr.(Siemens)],
HUCF.Macros as 'Kistenart',
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum,
HUCF.[Feld Nr],
HUCF.SBExport,
HUCF.SBExportExtra


from HandlingUnit HU
inner join BusinessUnitPermission BP on HU.id = BP.HandlingUnitId
inner join BusinessUnit BU on BP.BusinessUnitId = BU.ID and BU.id = (select id from BusinessUnit where name = 'Siemens Berlin')
left join  (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Kommentar','Position','Feld Nr.','Teillieferung (geplant)','Lot Nr. (Teillieferung)','Ext. Lieferschein Nr.(Siemens)','Macros','SBExport','SBExportExtra') and CV.Entity = 11
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Kommentar],[Position],[Feld Nr],[Teillieferung (geplant)],[Lot Nr. (Teillieferung)],[Ext. Lieferschein Nr.(Siemens)],[Macros],[SBExport],[SBExportExtra])
        ) as HUCF on HU.id = HUCF.EntityID

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

where BUPhu.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')--$P{ClientBusinessUnitid}
and dim.dvContent like '37696'--  $P{ProjectNr}
and case when s.name in ('huPacked','HuPackedByPackingRule') then 1 else 0 end in (0,1)--($P{JustPacked},1)
 ) data

where cast(Datum as date) >= '2019-05-01'--$P{FromDate}
and cast(Datum as date) <=  '2019-08-31'--$P{ToDate}
