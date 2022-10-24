SELECT
S.type,
SH.type,
BU.*,
SH.*,
S.*,
LP.*

  FROM [ShipmentLine] S
 inner join ShipmentHeader SH on S.ShipmentHeaderId = SH.id
 left outer join LoosePart LP on S.LoosePartId = LP.Id
 left outer join HandlingUnit HU on S.HandlingUnitId = HU.Id
 inner join BusinessUnit BU on S.ClientBusinessUnitId = BU.Id
 where 
 bu.Name = 'Ziersch'
 and SH.Code = '0601594/1631/1547'
 and SH.type = 0 -- for loading