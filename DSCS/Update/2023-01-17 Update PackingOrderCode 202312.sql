BEGIN TRANSACTION
UPDATE PO set PO.Code = REPLACE(PO.Code,'202312','202301')
--select PO.Code, REPLACE(PO.Code,'202312','202301') 
from PackingOrderHeader PO 
inner join BusinessUnitPermission BUP on PO.Id = BUP.PackingOrderHeaderId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Duisburg')

and PO.Code LIKE '%202312%'

ROLLBACK