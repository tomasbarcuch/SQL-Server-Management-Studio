select lp.id, lp.Code, lp.CreatedById from loosepart LP where code in (select lp.Code from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and bu.type = 2
group by Code,BU.name HAVING count(code) > 1)
--and lp.CreatedById = 'cf2607e9-db57-4c83-8f28-d816295fa1b7'