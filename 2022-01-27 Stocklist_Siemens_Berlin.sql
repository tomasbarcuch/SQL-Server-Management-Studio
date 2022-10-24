select TOP(1000)
DB_NAME() AS 'Current Database'
,BU.name as ClientBusinessName
,Project.Land
,Project.[Maschinen Typ] as 'Machinentyp'
,Project.ProjectNr as 'Projekt'
,Project.Project as 'Bezeichnung'
,Project.Kontierung
,DATA.Code
,DATA.[Position]
,DATA.[Description]
,DATA.Length
,DATA.Height
,DATA.Width
,DATA.Net
,DATA.Gros
,Project.Projektleiter
,Project.[Liefertermin Extern]
,Project.Produktlinie
,Project.Verpackungsart
,Project.[Status]
,DATA.Wareneingang
,data.[Datum WE (fix)]
,data.Lagerort
,cast(data.[Qm Wert] as decimal (10,2)) as 'Qm Wert'
--,datediff(day, data.Wareneingang, $P{ToDate}) as 'Lagerzeit Tage'
,datediff(day, data.Wareneingang, '2022-02-10') as 'Lagerzeit Tage'


from 

(SELECT
bup.BusinessUnitId,
EDVR.DimensionValueId,
DV.ID DimensionID,
min(inbdate.lpInbound) as 'Wareneingang',
'LP' as 'Entität',
LP.Id  EntityId,
LP.Code,
LPCF.[Position],
LP.[Description],
LP.Length,
LP.Width,
LP.Height,
LP.Weight as Net,
cast(case when (charindex(',',LPCF.[Brutto kg])) > 0 then
left(LPCF.[Brutto kg],(charindex(',',LPCF.[Brutto kg]))-1)+'.'+right(LPCF.[Brutto kg],len(LPCF.[Brutto kg])-(charindex(',',LPCF.[Brutto kg])))
 else LPCF.[Brutto kg] end as float(10)) as Gros,
Sum((cast(LP.Length as decimal)/1000)* (cast(LP.Width as decimal)/1000)) as 'Qm Wert',
 cast(min(LPCF.[Datum WE (fix)]) as date) as 'Datum WE (fix)',
L.Code+'/'+Z.Name+'/'+B.Code as 'Lagerort'

from loosepart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin') --$P{ClientBusinessUnitID}

LEFT JOIN (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Datum WE (fix)','Position','Feld Nr.','Colli','Brutto kg') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Datum WE (fix)],[Position],[Feld Nr.],[Brutto kg])
        ) as LPCF on LP.id = LPCF.EntityID

inner join Status S on LP.StatusId = s.Id and s.name not in ('lpNew')

left outer join (select lp.id lpId,lp.statusid stid,max(WE.Created) as StatusChanged from LoosePart LP left join dbo.workflowentry WE on lp.id = we.entityid group by lp.id,lp.statusid) sdate on lp.id = sdate.lpId and lp.StatusId = Sdate.stid 
left outer join (select lp.id lpId,lp.statusid stid,min(WE.Created) as lpInbound     from LoosePart LP left join dbo.workflowentry WE on lp.id = we.entityid inner join status S on WE.StatusId = S.Id and S.name = 'lpInbound'group by lp.id,lp.statusid) inbdate on lp.id = inbdate.lpId and lp.StatusId = inbdate.stid  

left outer join Bin B on lp.ActualBinId = B.Id
left outer join Zone Z on lp.ActualZoneId = Z.Id
INNER JOIN [Location] L on lp.ActualLocationId = L.id

left outer join dbo.EntityDimensionValueRelation EDVR on LP.id = EDVR.EntityId and EDVR.Entity = 15
left outer join dbo.DimensionValue DV on EDVR.DimensionValueId = DV.Id

where lp.ActualHandlingUnitId is null 



group by 
bup.BusinessUnitId,
EDVR.DimensionValueId,
DV.ID,
LP.Id,
LP.Code,
LPCF.[Position],
LP.[Description],
LP.Length,
LP.Width,
LP.Height,
LP.Weight,
cast(case when (charindex(',',LPCF.[Brutto kg])) > 0 then
left(LPCF.[Brutto kg],(charindex(',',LPCF.[Brutto kg]))-1)+'.'+right(LPCF.[Brutto kg],len(LPCF.[Brutto kg])-(charindex(',',LPCF.[Brutto kg])))
 else LPCF.[Brutto kg] end as float(10)),
L.Code+'/'+Z.Name+'/'+B.Code

union

SELECT
bup.BusinessUnitId,
EDVR.DimensionValueId,
DV.ID DimensionID,
min(inbdate.HuInbound) as 'Wareneingang',
'HU' as 'Entität',
HU.Id EntityId,
HU.Code,
HUCF.[Position],
HU.[Description],
HU.Length,
HU.Width,
HU.Height,
HU.Weight as Net,
HU.Brutto as Gros,
Sum((cast(HU.Length as decimal)/1000)* (cast(HU.Width as decimal)/1000)) as 'Qm Wert',
cast(min(HUCF.[Datum Fertigung]) as date) as 'Datum WE (fix)',
L.Code+'/'+Z.Name+'/'+B.Code as 'Lagerort'

from HandlingUnit HU

inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin') --$P{ClientBusinessUnitID}
LEFT JOIN (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Datum Fertigung','Position','Feld Nr.') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Datum Fertigung],[Position],[Feld Nr.])
        ) as HUCF on HU.id = HUCF.EntityID

inner join Status S on HU.StatusId = s.Id and s.name not in ('huNew')

left outer join (select hu.id huId,hu.statusid stid,max(WE.Created) as StatusChanged from HandlingUnit HU left join dbo.workflowentry WE on hu.id = we.entityid group by hu.id,hu.statusid) sdate on hu.id = sdate.huId and hu.StatusId = Sdate.stid 
left outer join (select hu.id huId,hu.statusid stid,min(WE.Created) as HuInbound from HandlingUnit HU left join dbo.workflowentry WE on hu.id = we.entityid inner join status S on WE.StatusId = S.Id and S.name = 'huInbound'group by hu.id,hu.statusid) inbdate on hu.id = inbdate.huId and hu.StatusId = inbdate.stid  
left outer join Bin B on HU.ActualBinId = B.Id
left outer join Zone Z on hu.ActualZoneId = Z.Id
INNER join [Location] L on hu.ActualLocationId = L.id

left outer join dbo.EntityDimensionValueRelation EDVR on HU.id = EDVR.EntityId and EDVR.Entity = 11
left outer join dbo.DimensionValue DV on EDVR.DimensionValueId = DV.Id

where HU.Empty = 0 

group by
bup.BusinessUnitId,
EDVR.DimensionValueId,
DV.ID
,HU.Id
,HU.Code
,HUCF.[Position]
,HU.[Description]
,HU.Length
,HU.Width
,HU.Height
,HU.Weight 
,HU.Brutto
,L.Code+'/'+Z.Name+'/'+B.Code
) DATA

INNER JOIN BusinessUnit BU on DATA.BusinessUnitId = BU.Id

LEFT JOIN (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content,
ISNULL(T.Text,S.name) as Status
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project' and D.[Disabled] = 0
inner join [Status] S on DV.StatusId = S.Id
left join dbo.Translation T on S.id = T.EntityId and t.[Language] = 'DE' and T.[Column] = 'Name'
where 
DF.name in ('Kennwort','Verpackungsart','Land','Projektleiter','Kontierung','Liefertermin Extern','Maschinen Typ','Produktlinie','Verpackungsart'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Land],[Projektleiter],[Kontierung],[Liefertermin Extern],[Maschinen Typ],[Produktlinie],[Verpackungsart])) as Project on DATA.EntityId= Project.EntityId

WHERE data.[Qm Wert] > 0