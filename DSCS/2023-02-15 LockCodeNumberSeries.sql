select LP.Code LP, BU.Name, LP.Created from LoosePart LP 
inner join BusinessUnitPermission BUP on LP.Id= BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where LP.NumberSeriesId = (select Id as 'LockCodeNumberSeries'from NumberSeries where code = 'LockCode')

and LP.Created > '2023-02-17 11:00'

select HU.Code HU, BU.Name, HU.Created from HandlingUnit HU 
inner join BusinessUnitPermission BUP on HU.Id= BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where HU.NumberSeriesId = (select Id as 'LockCodeNumberSeries'from NumberSeries where code = 'LockCode')

and HU.Created > '2023-02-17 11:00'


select POH.Code POH, BU.Name, POH.Created from PackingOrderHeader POH 
inner join BusinessUnitPermission BUP on POH.Id= BUP.PackingOrderHeaderId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where POH.NumberSeriesId = (select Id as 'LockCodeNumberSeries'from NumberSeries where code = 'LockCode')

and POH.Created > '2023-02-17 11:00'



select DV.Content DV, BU.Name, DV.Created from DimensionValue DV
inner join BusinessUnitPermission BUP on DV.Id= BUP.DimensionValueId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where DV.NumberSeriesId = (select Id as 'LockCodeNumberSeries'from NumberSeries where code = 'LockCode')

and DV.Created > '2023-02-17 11:00'

