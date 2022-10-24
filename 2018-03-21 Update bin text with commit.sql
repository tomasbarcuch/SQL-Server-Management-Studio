select * from bin

where ClientBusinessUnitId = 'AD5A5F6B-8EC4-463B-836A-0A8CB60A39D2' and code like '04-%'


BEGIN TRANSACTION;
update dbo.bin
set code = replace(code,'4-','04-')
where ClientBusinessUnitId = 'AD5A5F6B-8EC4-463B-836A-0A8CB60A39D2' and code like '4-%'
COMMIT TRANSACTION;