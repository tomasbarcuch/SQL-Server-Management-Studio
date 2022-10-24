BEGIN TRANSACTION
update SH set SH.Brutto = calc.SLBrutto, SH.Netto = calc.SLNetto from ShipmentHeader SH
inner join 
(select 
SH.ID SHID,
sum(isnull(HU.Netto,0)+isnull(LP.Weight,0)) as SLNetto,
sum(isnull(HU.Brutto,0)+isnull(LP.Weight,0)) as SLBrutto
from ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
left join LoosePart LP on SL.LoosePartId = LP.Id
group by 
SH.ID
) calc on SH.id = calc.SHID
ROLLBACK