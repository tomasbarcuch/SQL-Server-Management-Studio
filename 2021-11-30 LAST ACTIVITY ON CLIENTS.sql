SELECT DATA.Name Client, SUM(DATA.Entities) as Entities,MAX(DATA.LastUpdate) [Last activity]
--,DATA.Packer 
FROM(

select  COUNT(LP.id) Entities, MAX(LP.Updated) LastUpdate,BU.Name,PA.Name as Packer
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id 
inner join LoosePart LP on BUP.LoosePartId = LP.Id
and BU.[Disabled] = 0 and BU.[Type] = 2
inner join BusinessUnitRelation BUR on BU.id = BUR.BusinessUnitId
INNER JOIN BusinessUnit PA on BUR.RelatedBusinessUnitId = PA.Id and PA.[Disabled] = 0
group by BU.Name, PA.Name

union

select  COUNT(HU.id),MAX(HU.Updated) LastUpdate,BU.Name,PA.Name as Packer
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join HandlingUnit HU on BUP.HandlingUnitId = HU.Id
and BU.[Disabled] = 0 and BU.[Type] = 2
inner join BusinessUnitRelation BUR on BU.id = BUR.BusinessUnitId
INNER JOIN BusinessUnit PA on BUR.RelatedBusinessUnitId = PA.Id and PA.[Disabled] = 0
group by BU.Name, PA.Name

union
select  COUNT(SH.id),MAX(SH.Updated) LastUpdate,BU.Name,PA.Name as Packer
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id 
inner join ShipmentHeader SH on BUP.ShipmentHeaderId = SH.Id
and BU.[Disabled] = 0 and BU.[Type] = 2
inner join BusinessUnitRelation BUR on BU.id = BUR.BusinessUnitId
INNER JOIN BusinessUnit PA on BUR.RelatedBusinessUnitId = PA.Id and PA.[Disabled] = 0
group by BU.Name, PA.Name

union
select  COUNT(PO.id),MAX(PO.Updated) LastUpdate,BU.Name,PA.Name as Packer
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id 
inner join PackingOrderHeader PO on BUP.PackingOrderHeaderId = PO.Id
and BU.[Disabled] = 0 and BU.[Type] = 2
inner join BusinessUnitRelation BUR on BU.id = BUR.BusinessUnitId
INNER JOIN BusinessUnit PA on BUR.RelatedBusinessUnitId = PA.Id and PA.[Disabled] = 0
group by BU.Name, PA.Name


) DATA 
--where DATA.Packer = 'Deufol Frankenthal' 
group by DATA.Name--, DATA.Packer
order by MAX(DATA.LastUpdate) desc,  DATA.Name
--, DATA.Packer--MAX(DATA.lastupdate) asc

