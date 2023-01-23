BEGIN TRANSACTION

INSERT into HandlingUnitIdentifier

select 
NEWID()
,HU.Id
,'00'+SUBSTRING(LEFT(HU.Code,15),2,14)
,(Select id from [User] where login = 'vvmigration')
,(Select id from [User] where login = 'vvmigration')
,GETDATE()
,GETDATE()
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where Name = 'Siemens Duisburg')
where HU.Code like '2%'

ROLLBACK
