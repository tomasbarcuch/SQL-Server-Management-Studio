begin TRANSACTION

update LPUOM set LPUOM.UnitOfMeasureId = LP.BaseUnitOfMeasureId
from LoosePartUnitOfMeasure LPUOM 
inner join LoosePart LP on LPUOM.LoosePartId = LP.id 
where LP.BaseUnitOfMeasureId <> LPUOM.UnitOfMeasureId

ROLLBACK
