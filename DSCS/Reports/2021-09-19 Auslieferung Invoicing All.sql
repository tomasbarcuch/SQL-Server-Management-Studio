
declare @Invoicing_1 as TINYINT = 0
declare @Invoicing_2 as TINYINT = 0
declare @Invoicing_3 as TINYINT = 0
declare @Invoicing_4 as TINYINT = 0
declare @Invoicing_5 as TINYINT = 1


select * from (
select
CASE WHEN HU.Brutto < 5 then '5.2.1' else
CASE WHEN HU.Description like ('%palet%') and HU.Brutto < 1000 then '5.2.2' else
CASE WHEN HU.Description not like ('%kiste%') and HU.Description not like ('%palet%') and HU.Brutto > 5 then '5.2.3' else
CASE WHEN HU.Description like ('%kiste%') then '5.2.4' else 'nicht definiert' end end end end as 'Sorting',
CASE WHEN HU.Brutto < 5 then 'Stückgut (Hand) kleiner 5 kg/Stk.' else
CASE WHEN HU.Description like ('%palet%') and HU.Brutto < 1000 then 'Palettengut (Stapler), kleiner 1 Tonne/Stk.' else
CASE WHEN HU.Description not like ('%kiste%') and HU.Description not like ('%palet%') and HU.Brutto > 5 then 'Stapler groß bei Kiste bzw. bei Palette > 1 Tonne mind. 1 Tonne, >1to=KG genau' else
CASE WHEN HU.Description like ('%kiste%') then 'Krangut' else 'nicht definiert' end end end end as 'Kategorie',
HU.Code,
Dimensions.Project,
Dimensions.[Description] 'Kennwort',
HU.Brutto as 'Weight',
WFS.Name as 'Status',
WFE.Created,
CV_Pos.Content as 'Position',
'1' as 'isHU',
HU.[Description]
from WorkflowEntry WFE
INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id 
INNER JOIN HandlingUnit HU ON WFE.EntityId = HU.Id and HU.TopHandlingUnitId is NULL
INNER JOIN BusinessUnitPermission BUP ON HU.Id = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Name = 'Siemens Berlin'
LEFT JOIN (
select
D.Name, 
DV.[Description], 
DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project])
        ) as Dimensions on HU.id = Dimensions.EntityId

INNER JOIN CustomField CF_Pos ON BU.Id = CF_Pos.ClientBusinessUnitId and CF_Pos.Entity = '11' and CF_Pos.Name in ('Position')
INNER JOIN CustomValue CV_Pos ON CF_Pos.Id = CV_Pos.CustomFieldId and CV_Pos.EntityId = HU.Id

WHERE
WFE.Entity = 11
and WFS.Name = 'HuDispatched'
and cast(wfe.created as date) >= '2021-09-01'
-->= $P{Von}   
and cast(wfe.created as date) <= '2021-09-15'
--<= $P{Bis}



UNION ALL

select
CASE WHEN LP.Weight < 5 then '5.2.1' else
CASE WHEN LP.Weight < 1000 and LP.Description like ('%palet%') then '5.2.2' else
CASE WHEN LP.Description not like ('%kiste%') and LP.Description not like ('%palet%') and LP.Weight > 5 then '5.2.3' else
CASE WHEN LP.Description like ('%kiste%') then '5.2.4' else 'nicht definiert' end end end end  as 'Sorting', 
CASE WHEN LP.Weight < 5 then 'Stückgut (Hand) kleiner 5 kg/Stk.' else
CASE WHEN LP.Weight < 1000 and LP.Description like ('%palet%') then 'Palettengut (Stapler), kleiner 1 Tonne/Stk.' else
CASE WHEN LP.Description not like ('%kiste%') and LP.Description not like ('%palet%') and LP.Weight > 5 then 'Stapler groß bei Kiste bzw. bei Palette > 1 Tonne mind. 1 Tonne, >1to=KG genau' else
CASE WHEN LP.Description like ('%kiste%') then 'Krangut' else 'nicht definiert' end end end end as 'Kategorie',
LP.Code,
Dimensions.Project,
Dimensions.[Description] 'Kennwort',
LP.Weight,
WFS.Name as 'Status',
WFE.Created,
CF.Position,
'0' as 'isHU',
LP.[Description]

from WorkflowEntry WFE
INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id 
INNER JOIN Loosepart LP ON WFE.EntityId = LP.Id and LP.TopHandlingUnitId is NULL

INNER JOIN BusinessUnitPermission BUP ON LP.Id = BUP.LoosepartId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Name = 'Siemens Berlin'

LEFT JOIN (
select
D.Name, 
DV.[Description], 
DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project])
        ) as Dimensions on LP.id = Dimensions.EntityId

left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in (select name from CustomField where ClientBusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin') group by name) and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Abrechnungskategorie],[Brutto kg],[Datum WE (fix)])
        ) as CF on LP.id = CF.EntityID


WHERE
WFE.Entity = 15
and WFS.Name = 'LpShipped'
and cast(wfe.created as date) >= '2021-09-01'
-->= $P{Von}   
and cast(wfe.created as date) <= '2021-09-15'
--<= $P{Bis}

) DATA
where (
(CASE WHEN DATA.Sorting = '5.2.1' and @Invoicing_1 = 1 then 1 else 0 end ) = 1
OR 
(CASE WHEN DATA.Sorting = '5.2.2' and @Invoicing_2 = 1 then 1 else 0 end ) = 1
OR
(CASE WHEN DATA.Sorting = '5.2.3' and @Invoicing_3 = 1 then 1 else 0 end ) = 1
OR
(CASE WHEN DATA.Sorting = '5.2.4' and @Invoicing_4 = 1 then 1 else 0 end ) = 1
OR
(CASE WHEN DATA.Sorting = 'nicht definiert' and @Invoicing_5 = 1 then 1 else 0 end ) = 1
)