select
IH.Created,
IH.code,
IL.ExpectedQuantity,
IL.CurrentQuantity,
isnull(isnull(WClp.QuantityBase,wchu.QuantityBase),0) as WarehouseContent,
ILB.code ILbin,
ACB.code actualbin,
isnull(WCBINlp.Code,WCBINhu.code) as wcbin,
isnull(LP.Code,HU.Code) as EntityCode,
IL.Created
 from InventoryLine IL
inner join InventoryHeader IH on IL.InventoryHeaderId = IH.id
inner join BusinessUnitPermission BUP on IL.Id = BUP.InventoryLineId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.name = 'Krauss Maffei SK'
left join bin ILB on IL.BinId = ILB.ID
left join LoosePart LP on  IL.LoosePartId = LP.Id
left join bin ACB on LP.ActualBinId = ACB.ID
left join HandlingUnit HU on IL.HandlingUnitId = HU.id
left join WarehouseContent WClp on LP.id = WClp.LoosePartId and wclp.LocationId is not null
left join WarehouseContent WChu on HU.id = WChu.HandlingUnitId and wchu.LocationId is not null
left join bin WCBINlp on WClp.BinId = WCBINlp.id
left join bin WCBINhu on WChu.BinId = WCBINhu.id
where 
IH.Code = 'INVKMT-0007' 
--and CurrentQuantity is not null
--and lP.Code = '2018KM-0001822'
and (
IL.BinId <> LP.ActualBinId
OR
LP.ActualBinId <> WClp.BinId
OR
wclp.BinId <> IL.BinId

)

select IH.Code, IH.created, IH.[Status], 
count(il.id) as Records, 
sum(case when CurrentQuantity is null then 0 else 1 end) as RecordsProcessed
 from
InventoryLine IL
inner join InventoryHeader IH on IL.InventoryHeaderId = IH.id
inner join BusinessUnitPermission BUP on IL.Id = BUP.InventoryLineId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.name = 'Krauss Maffei SK'

group by IH.Code, IH.created, IH.[Status]
order by IH.Created DESC

