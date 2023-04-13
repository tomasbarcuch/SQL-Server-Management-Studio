BEGIN TRANSACTION

update LP set LP.Weight = 1.00000

--select LP.Weight 
from loosepart LP
inner join BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Mölnlycke Health Care')
where LP.Weight <> 1.00000

COMMIT


begin TRANSACTION
update bin set MaximumWeight = 1.00000 where zoneid = '87e01986-1754-4aba-b3fd-e67863f0bd30' and MaximumWeight <> 1.00000

ROLLBACK