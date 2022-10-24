select * from (
    SELECT lp.updatedbyid,
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
'LP' as 'Entität',
LP.code as 'Entität Kode',
HU.Code as HUKode,
Project.ProjectNr as 'Projekt',
Project.Verpackungsart as 'Projekt Verp. Art',
Project.Project as 'ProjDesc',
LP.[Description] as 'Beschreibung',
LP.Length as Länge,
LP.width as Breite,
 LP.Height as Höhe,
 isnull(HU.Brutto,replace(LPCF.[Brutto kg],',','.')) as Brutto,
LP.Weight as 'Netto',
LPCF.Colli as 'Kollinummer',
LPCF.Kennwort as 'Kennwort',
LPCF.[Position] as 'Position',
'' as 'Teillieferung (geplant)',
'' as 'Ext. Lieferschein Nr.(Siemens)',
'Kollo' as 'Kistenart',
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum,
LPCF.[Feld Nr.] as 'Feld Nr.'

from loosepart LP with (NOLOCK)
left join BusinessUnitPermission BP on LP.id = BP.LoosePartId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
left join HandlingUnit HU on LP.topHandlingUNitid = HU.id

left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Kennwort','Position','Feld Nr.','Colli','Brutto kg') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Kennwort],[Position],[Feld Nr.],[Colli],[Brutto kg])
        ) as LPCF on LP.id = LPCF.EntityID


inner join Status S on LP.StatusId = s.Id
left join dbo.[Translation] T on S.ID = T.entityId and T.language = 'de'

inner join (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('Kennwort','Verpackungsart'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Verpackungsart])) as Project on lp.Id = Project.EntityId


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
and BP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')--$P{ClientBusinessUnitid} 
and Project.ProjectNr like '40315' --$P{ProjectNr}
and LP.topHandlingUNitid is null
and s.name = 'lpPacked' 

UNION

SELECT
hu.updatedbyid,
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
'HU' as 'Entität',
HU.code as 'Entität Kode',
'' as HUKode,
Project.ProjectNr 'Projekt',
Project.Verpackungsart as 'Projekt Verp. Art',
Project.Project as 'ProjDesc',
HU.[Description] as 'Beschreibung',
HU.Length as Länge,
HU.width as Breite,
 HU.Height as Höhe,
 cast(HU.Brutto as float) as 'Brutto',
HU.Netto as 'Netto',
HU.ColliNumber as 'Kollinummer',
HUCF.Kommentar as 'Kennwort',
HUCF.[Position] as 'Position',
HUCF.[Teillieferung (geplant)],
HUCF.[Ext. Lieferschein Nr.(Siemens)],
HUCF.Macros as 'Kistenart',
isnull(t.Text,s.name) as 'Status',
sdate.StatusChanged,
cast(sdate.StatusChanged as date) as Datum,
HUCF.[Feld Nr] as 'Feld Nr.'


from HandlingUnit HU with (NOLOCK)
left join BusinessUnitPermission BP on HU.id = BP.HandlingUnitId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID

inner join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Kommentar','Position','Feld Nr.','Teillieferung (geplant)','Lot Nr. (Teillieferung)','Ext. Lieferschein Nr.(Siemens)','Macros') and CV.Entity = 11
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Kommentar],[Position],[Feld Nr],[Teillieferung (geplant)],[Lot Nr. (Teillieferung)],[Ext. Lieferschein Nr.(Siemens)],[Macros])
        ) as HUCF on HU.id = HUCF.EntityID



inner join Status S on HU.StatusId = s.Id
left join dbo.[Translation] T on S.ID = T.entityId and T.language = 'DE'

 
 inner join (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('Kennwort','Verpackungsart'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Verpackungsart])) as Project on HU.Id = Project.EntityId


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


where BUPhu.BusinessUnitId =  (select id from BusinessUnit where name = 'Siemens Berlin')--$P{ClientBusinessUnitid} 



and Project.Project like '40315' --$P{ProjectNr}
and S.name in ('huPacked','HuPackedByPackingRule')
)data
where data.Datum >= '2018-12-01'--$P{FromDate}
and data.Datum <= '2019-12-15'-- $P{ToDate}
