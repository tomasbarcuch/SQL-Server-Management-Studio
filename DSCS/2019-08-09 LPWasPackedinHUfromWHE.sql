select lp.code, min(warehouseentry.created), HU.code, loosepartid, HandlingUnitId from WarehouseEntry
inner join LoosePart LP on WarehouseEntry.LoosepartId = LP.Id
inner join HandlingUnit HU on WarehouseEntry.HandlingUnitId = HU.Id

		where loosepartid is not null and HandlingUnitId is not null and HandlingUnitId = 'fb6d259a-bbb0-45e7-9e86-c4f30dc8b45f'
		group by lp.code,loosepartid,HandlingUnitID,HU.code
        order by min(warehouseentry.Created)
      