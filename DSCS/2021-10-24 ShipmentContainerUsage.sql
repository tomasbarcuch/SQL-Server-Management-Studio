select 
DATA.ShipmentCode,
DATA.ContainerTyp,
DATA.BruttoShipment,
DATA.LoadCapacity,
SUM(DATA.Volume) LoadVolume, 
ROUND(DATA.ContainerVolume,-0,1) ContainerVolume,
SUM(DATA.BaseArea) LoadBaseArea, 
ROUND(DATA.ContainerBaseArea,-0,1) ContainerBaseArea, 
DATA.Updated,
(SUM(DATA.Volume)/ROUND(DATA.ContainerVolume,-0,1))*100.00 'Volume Usage %',
(SUM(DATA.BaseArea)/ROUND(DATA.ContainerBaseArea,-0,1))*100.00 'BaseArea Usage %' 
from (

select
SH.Code ShipmentCode
,HUT.[Description] as ContainerTyp
,ISNULL(LP.Volume,HU.Volume) Volume
,ISNULL(LP.BaseArea,HU.BaseArea) BaseArea
,(HUT.Length/1000.00) * (HUT.Width/1000.00) * (HUT.Height/1000.00) ContainerVolume
,(HUT.Length/1000.00) * (HUT.Width/1000.00) ContainerBaseArea
,SH.Brutto BruttoShipment
,HUT.LoadCapacity
,SH.Updated
from ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id and SH.[Type] = 0
inner join BusinessUnitPermission BUP on SH.id = BUP.ShipmentHeaderId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
left join HandlingUnitType HUT on SH.HandlingUnitTypeId = HUT.Id
left join LoosePart lp on SL.LoosePartId  = LP.Id
left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
where HUT.Container = 1

) DATA


group by 
DATA.ShipmentCode, 
DATA.ContainerTyp,
DATA.ContainerVolume,
DATA.LoadCapacity,
DATA.BruttoShipment,
DATA.ContainerBaseArea,
DATA.Updated

order by DATA.Updated desc