select * from (
Select
'Art' as 'Art',
Project.ProjectNr as 'Projekt Nr',
Project.Project as 'Projekt Kennwort',
Project.[Deufol order] as 'Auftrag Deufol',
hu.[Description] as 'Inhalt Deutsch',
CUS.Produktlinie as 'P-Linie',
CUS.Macros as 'Kisten-art',
'1' as 'Anz',
HUWFS.Name as 'Status', 
TR.Text as 'Status (DE)',
hu.ColliNumber as 'Kolli-Nr',
hu.Code as 'Kiste Nr',
CUS.[Abrechnung Eingang ZV] as 'Abrechnung Eingang ZV',
SlStart.Created as 'SlStart',
cast(WFE.Created as date) as 'SlFertig',
hu.Length,
hu.Width,
hu.Height,
hu.Netto,
hu.Brutto,
hu.Surface,
CUS.Markierung as 'Markierung'

from WorkflowEntry  WFE with (NOLOCK)

INNER JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.ServiceLineId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id AND BU.Name = ('Siemens Berlin')

INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id and WFS.Name = 'SlDone'

INNER JOIN ServiceLine SL ON WFE.EntityId = SL.Id
INNER JOIN ServiceType ST ON SL.ServiceTypeId = ST.Id and ST.Code = ('Nachträgliche Markierung')

INNER JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart'))


INNER JOIN HandlingUnit HU ON SL.EntityId = HU.Id


INNER JOIN (
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
DF.name in ('Kennwort','Deufol order'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Deufol order])) as Project on HU.id = Project.EntityId

LEFT JOIN (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Abrechnung Eingang ZV','Produktlinie','Macros','Brutto kg','Colli','Markierung')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Abrechnung Eingang ZV],[Produktlinie],[Macros],[Markierung])) as CUS on HU.id = CUS.EntityId


INNER JOIN [Status] HUWFS ON hu.StatusId = HUWFS.Id
LEFT JOIN Translation TR ON HUWFS.Id = TR.EntityId and TR.[Language] = 'de'






UNION


Select
'Art' as 'Art',
Project.ProjectNr as 'Projekt Nr',
Project.Project as 'Projekt Kennwort',
Project.[Deufol order] as 'Auftrag Deufol',
lp.[Description] as 'Inhalt Deutsch',
CUS.Produktlinie as 'P-Linie',
'Kollo' as 'Kisten-art',
'1' as 'Anz',
LPWFS.Name as 'Status', 
TR.Text as 'Status (DE)',
CUS.Colli as 'Kolli-Nr',
lp.Code as 'Kiste Nr',
CUS.[Abrechnung Eingang ZV] as 'Abrechnung Eingang ZV',
SlStart.Created as 'SlStart',
cast(WFE.Created as date) as 'SlFertig',
lp.Length,
lp.Width,
lp.Height,
lp.Weight as Netto,
cast(case when (charindex(',',CUS.[Brutto kg])) > 0 then
left(CUS.[Brutto kg],(charindex(',',CUS.[Brutto kg]))-1)+'.'+right(CUS.[Brutto kg],len(CUS.[Brutto kg])-(charindex(',',CUS.[Brutto kg])))
 else CUS.[Brutto kg] end as float) as 'Brutto',
lp.Surface,
CV_Markierung.Content as 'Markierung'

from WorkflowEntry WFE 

INNER JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.ServiceLineId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id AND BU.Name = ('Siemens Berlin')

INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id and WFS.Name = 'SlDone'

INNER JOIN ServiceLine SL ON WFE.EntityId = SL.Id
INNER JOIN ServiceType ST ON SL.ServiceTypeId = ST.Id and  ST.Code = ('Nachträgliche Markierung LP')

LEFT JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart'))

LEFT JOIN CustomField CF_Markierung ON BU.Id = CF_Markierung.ClientBusinessUnitId and CF_Markierung.Name in ('Markierung')
LEFT JOIN CustomValue CV_Markierung ON CF_Markierung.Id = CV_Markierung.CustomFieldId and CV_Markierung.EntityId = SL.Id

INNER JOIN LoosePart LP ON SL.EntityId = LP.Id


INNER JOIN (
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
DF.name in ('Kennwort','Deufol order'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Deufol order])) as Project on LP.id = Project.EntityId

LEFT JOIN (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Abrechnung Eingang ZV','Produktlinie','Macros','Brutto kg','Colli')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Abrechnung Eingang ZV],[Produktlinie],[Macros],[Brutto kg],[Colli])) as CUS on LP.id = CUS.EntityId

LEFT JOIN [Status] LPWFS ON LP.StatusId = LPWFS.Id
LEFT JOIN Translation TR ON LPWFS.Id = TR.EntityId and TR.[Language] = 'de'
) data --where data.SlFertig >=  $P{Von}   and data.SlFertig <=   $P{Bis} 
where data.SlFertig between '2021-12-01' and '2021-12-31'