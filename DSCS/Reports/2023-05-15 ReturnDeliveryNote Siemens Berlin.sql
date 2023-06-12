select 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
Dimensions.Project,
CustomField.[Position],
LP.[Description] as 'Inhalt',
LP.Length,
LP.Width,
LP.Height,
LP.Weight as 'Brutto',
LP.Netto

from LoosePart LP

INNER JOIN BusinessUnitPermission BUP ON LP.Id = BUP.LoosePartId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Id =  (select id from BusinessUnit where name = 'Siemens Berlin')--$P{ClientBusinessUnitId} 


LEFT JOIN (
select 
D.name, 
DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project])
        ) as Dimensions ON LP.Id = Dimensions.EntityId

LEFT JOIN (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Position')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Position])) as CustomField on LP.ID = CustomField.EntityId

where 
 --$X{IN, [LP].[Id], LoosePartIDs}
 LP.Id in ('4b2bd11a-d501-4444-bcf8-8a2da9f4c0d1','7af6574b-5bcb-4fa4-ad45-8d678ba3d5a8')