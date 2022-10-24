select 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
DimVal.Content as 'Project',
CV_Pos.Content as 'Position',
LP.[Description] as 'Inhalt',
LP.Length,
LP.Width,
LP.Height,
cast(case when (charindex(',',CV_BTTO.Content)) > 0 then
left(CV_BTTO.Content,(charindex(',',CV_BTTO.Content))-1)+'.'+right(CV_BTTO.Content,len(CV_BTTO.Content)-(charindex(',',CV_BTTO.Content)))
 else CV_BTTO.Content end as float) as 'Brutto',
LP.Weight as 'Netto',
CV.content as 'LKW'



from LoosePart LP
-- BU
LEFT JOIN BusinessUnitPermission BUP ON LP.Id = BUP.LoosePartId
LEFT JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id

--dimenze
LEFT JOIN BusinessUnitPermission BUP_Dim ON BU.Id = BUP_Dim.BusinessUnitId and BUP_Dim.DimensionId is not null
LEFT JOIN Dimension Proj ON BUP_Dim.DimensionId = Proj.Id and Proj.Name = 'Project'

--cislo projektu
LEFT JOIN EntityDimensionValueRelation EDVR ON LP.Id = EDVR.EntityId
LEFT JOIN DimensionValue DimVal ON EDVR.DimensionValueId = DimVal.Id

--LP position
LEFT JOIN CustomField CF_Pos ON BU.Id = CF_Pos.ClientBusinessUnitId and CF_Pos.Entity = '15' and CF_Pos.Name in ('Position')
LEFT JOIN CustomValue CV_Pos ON CF_Pos.Id = CV_Pos.CustomFieldId and CV_Pos.EntityId = LP.Id

--Brutto kg
LEFT JOIN CustomField CF_BTTO ON BU.Id = CF_BTTO.ClientBusinessUnitId and CF_BTTO.Entity = '15' and CF_BTTO.Name in ('Brutto kg')
LEFT JOIN CustomValue CV_BTTO ON CF_BTTO.Id = CV_BTTO.CustomFieldId and CV_BTTO.EntityId = LP.Id

--LP LKW
LEFT JOIN CustomField CF_LKW ON BU.Id = CF_LKW.ClientBusinessUnitId and CF_LKW.Entity = '15' and CF_LKW.Name in ('LKW Kennz.')
LEFT JOIN CustomValue CV_LKW ON CF_LKW.Id = CV_LKW.CustomFieldId and CV_LKW.EntityId = LP.Id

left join ShipmentLine SL on LP.id = SL.LoosePartId
left join ShipmentHeader SH on sl.ShipmentHeaderId = SH.Id

left join CustomField CF on BU.id = CF.ClientBusinessUnitId and Cf.Entity = '31' and CF.name = 'Truck Number'
left join CustomValue CV on cf.Id = CV.CustomFieldId and CV.EntityId = SH.Id

where 
BU.Name = 'Siemens Berlin'
 --and $X{IN, [LP].[Id], LoosePartIDs}
