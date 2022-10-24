select 
BU.Name,
HU.Code,
HU.[Description],
HU.Length,
HU.Width,
HU.Height,
HU.Weight,
HU.Netto,
HU.Brutto,
HU.BaseArea,
HU.Surface,
HUT.Code as 'Typ',
ISNULL(LPl.Code,HUl.Code) as 'L-Code',
ISNULL(LPl.[Description],HUl.[Description]) as 'L-Bezeichnung',
ISNULL(LPl.Weight,HUl.Weight) as 'L-Weight',
ISNULL(LPl.Length,HUl.Length) / 10 as 'L-Length',
ISNULL(LPl.Width,HUl.Width) / 10 as 'L-Width',
ISNULL(LPl.Height,HUl.Height) / 10 as 'L-Height',
CV_VA.Content as 'L-Verpackungsart',
ISNULL(Lpl.LotNo,' ') as 'L-Lieferschein',
Project.content as 'Project',
Auftrag.Content as 'Auftrag'

from HandlingUnit HU

LEFT JOIN HandlingUnitType HUT ON HU.TypeId = HUT.Id

INNER JOIN BusinessUnitPermission BUP ON HU.Id = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.[Type] = 2

LEFT JOIN Loosepart LPl ON HU.Id = LPl.ActualHandlingUnitId
LEFT JOIN HandlingUnit HUl ON HU.Id = HUl.ParentHandlingUnitId

--Dimenze Project
LEFT JOIN BusinessUnitPermission BUP_P ON BU.Id = BUP_P.BusinessUnitId and BUP_P.DimensionId is not null
LEFT JOIN Dimension Dim_P ON BUP_P.DimensionId = Dim_P.Id and Dim_P.Name = 'Project'

--Projekt nummer
LEFT JOIN EntityDimensionValueRelation EDVR_P ON HU.Id = EDVR_P.EntityId and EDVR_P.DimensionValueId in (Select DV.Id from DimensionValue DV where DV.DimensionId = Dim_P.Id)
LEFT JOIN DimensionValue Project ON EDVR_P.DimensionValueId = Project.Id

-- Verpackungsart
LEFT JOIN CustomField CF_VA ON BU.Id = CF_VA.ClientBusinessUnitId AND CF_VA.Name in ('PackingType') and CF_VA. Entity = 15
LEFT JOIN CustomValue CV_VA ON CF_VA.Id = CV_VA.CustomFieldId and CV_VA.EntityId = LPl.Id

--Dimenze Order
LEFT JOIN BusinessUnitPermission BUP_O ON BU.Id = BUP_O.BusinessUnitId and BUP_O.DimensionId is not null
LEFT JOIN Dimension Dim_O ON BUP_O.DimensionId = Dim_O.Id 

-- Auftrag nummer
LEFT JOIN EntityDimensionValueRelation EDVR_O ON HU.Id = EDVR_O.EntityId and EDVR_O.DimensionValueId in (Select DV.Id from DimensionValue DV where DV.DimensionId = Dim_O.Id)
LEFT JOIN DimensionValue Auftrag ON EDVR_O.DimensionValueId = Auftrag.Id

where 
HU.Id = '82a090ed-9aa6-4eea-80c2-33c691cec03d'-- $P{HUId} 

and Dim_P.Name is not NULL
and Dim_O.Name = 'Order'