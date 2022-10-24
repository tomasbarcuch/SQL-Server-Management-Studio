UPDATE WorkflowEntry 
SET ClientBusinessUnitId = (CASE wfe.Entity  
WHEN '10' THEN 
  (SELECT TOP 1 bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.DimensionValueId )
WHEN '11' THEN 
  (SELECT TOP 1 bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.HandlingUnitId )
WHEN '15' THEN 
  (SELECT TOP 1 bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.LoosePartId )
WHEN '31' THEN 
  (SELECT TOP 1 bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.ShipmentHeaderId )
WHEN '35' THEN 
  (SELECT TOP 1 bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.PackingOrderHeaderId )
WHEN '48' THEN 
  (SELECT bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.ServiceLineId ) 
WHEN '57' THEN 
  (SELECT TOP 1 bup.BusinessUnitId  FROM BusinessUnitPermission AS bup  JOIN BusinessUnit AS bu  ON bu.Id = bup.BusinessUnitId
  WHERE bu.Type = 2  AND bu.Disabled = 0  AND wfe.EntityId = bup.TenderHeaderId ) 
END)
FROM WorkflowEntry AS wfe 