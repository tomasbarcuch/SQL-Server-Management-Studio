select BU.Name, HU.Length,HU.Width,HU.Height, HU.Volume,HU.Surface, HU.BaseArea, HU.Code, HU.Created, HU.CreatedById from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2 
where HU.BaseArea = 0 and Volume = 0 and Length <> 0 and Width <> 0 and code like '00%'