select 

CASE WHEN DATA.Sorting = 'Kiste > 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'Verpackung o. Konserv.' THEN '2.2.1' ELSE 
CASE WHEN DATA.Sorting = 'Kiste < 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'Verpackung o. Konserv.' THEN '2.2.2' ELSE 
CASE WHEN DATA.Sorting = 'Kiste > 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A12' THEN '2.3.1' ELSE 
CASE WHEN DATA.Sorting = 'Kiste < 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A12' THEN '2.3.2' ELSE
CASE WHEN DATA.Sorting = 'Schwim. Verpack.' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A12' THEN '2.3.3' ELSE
CASE WHEN DATA.Sorting = 'Kiste > 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A24' THEN '2.4.1' ELSE 
CASE WHEN DATA.Sorting = 'Kiste < 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A24' THEN '2.4.2' ELSE
CASE WHEN DATA.Sorting = 'Schwim. Verpack.' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A24' THEN '2.4.3' ELSE
CASE WHEN DATA.Sorting = 'Kiste > 2t' AND DATA.CRATE = 'OSB KISTE' AND DATA.Verpackungsart = 'seemäßig A12 HT' THEN '2.5.1' ELSE 

'NOT DEFINED' 
END END END END END END END END END 
as 'Gem.Preisliste',
* from (

select 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName ,
CASE WHEN REPLACE([HU].[Macros],';','') IN ('VG','VERSCHLAG KISTE') AND [HU].[Netto] >= 2000 THEN 'Verschlag > 2t' ELSE
CASE WHEN REPLACE([HU].[Macros],';','') IN ('VG','VERSCHLAG KISTE') AND [HU].[Netto] < 2000 THEN 'Verschlag < 2t' ELSE
CASE WHEN isnull(CFPO.[Schwimmende Verpackung],'false') = 'true' THEN  'Schwim. Verpack.' ELSE
CASE WHEN REPLACE([HU].[Macros],';','') IN ('Kiste','BO','OSB Kiste','OSB-Kiste','BOOSB KISTE','KISTE','NON-WOOD-KISTE','ConPLY Kiste') AND [HU].[Netto] >= 2000 then 'Kiste > 2t' ELSE
CASE WHEN REPLACE([HU].[Macros],';','') IN ('Kiste','BO','OSB Kiste','OSB-Kiste','BOOSB KISTE','KISTE','NON-WOOD-KISTE','ConPLY Kiste') AND [HU].[Netto] < 2000 then 'Kiste < 2t' ELSE
CASE WHEN REPLACE([HU].[Macros],';','') IN ('Boden','BD','BRETTWARE') THEN 'Boden' ELSE 'Unbekannt'
END END END END END END as 'Sorting',
CASE REPLACE([HU].[Macros],';','') 
WHEN 'BRETTWARE' THEN 'Boden'
ELSE REPLACE(Macros,';','') end
as Crate,
HU.Code,
HU.[Description],
HU.Length,
HU.Width,
HU.Height,
HU.ColliNumber,
HU.Weight,
HU.Netto,
HU.Brutto,
ROUND(HU.BaseArea,3) BaseArea,
ROUND(HU.Surface,3) Surface,
isnull(TR.Text,CWS.Name) as 'Status',
Project.ProjectNr as 'Projekt',
Project.Kennwort,
Project.Produktlinie,
Project.[Deufol order] as 'Auftrag Deufol',
CF.Verpackungsart,
HU.Macros,
CF.Abrechnungshinweis,
ISNULL(CFPO.[Schwimmende Verpackung],'false') as 'Schwimmende Verpackung',
ISNULL(CFPO.[CF6],'false') as 'CF6',
WFE.Created as 'Datum'

from WorkflowEntry WFE with (NOLOCK)
INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id
INNER JOIN HandlingUnit HU ON WFE.EntityId = HU.Id
INNER JOIN BusinessUnitPermission BUP ON HU.Id = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.name = 'Siemens Berlin'
INNER JOIN [Status] as CWS ON HU.StatusId = CWS.Id

left join (SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField with (NOLOCK)
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('Abrechnungshinweis','Schwimmende Verpackung','Verpackungsart')) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Abrechnungshinweis],[Schwimmende Verpackung],[Verpackungsart])) as CF on HU.id = CF.EntityID



inner join (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF with (NOLOCK)
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId 
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('Verpackungsart','Produktlinie','Kennwort','Deufol order'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Verpackungsart],[Produktlinie],[Kennwort],[Deufol order])) as Project on HU.id = Project.EntityId


left join (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV with (NOLOCK)
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Schwimmende Verpackung','CF6')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Schwimmende Verpackung],[CF6])) as CFPO on HU.PackingOrderHeaderId = CFPO.EntityId
LEFT JOIN Translation TR ON CWS.Id = TR.EntityId and TR.[Language] =  'de'--$P{Language}
left JOIN WorkflowEntry as WFE_Parent ON WFE.EntityId = WFE_Parent.EntityId and WFE_Parent.Created < WFE.Created and WFE_Parent.StatusId in (select [Status].Id from [Status] where [Status].Name in ('HuPacked','HuPackedafterPackingRule'))

where 
WFS.Name in ('HuPacked','HuPackedafterPackingRule')
and WFE_Parent.Id is  NULL
and cast(wfe.created as date) >=  '2022-01-27' --$P{Von} 
and cast(wfe.created as date) <=   '2022-01-27'--$P{Bis}
and macros not in ('Kollo','Rohrcolli')

) DATA