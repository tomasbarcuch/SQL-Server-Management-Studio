

begin TRANSACTION


update LoosePart set Description = REPLACE([Description],'□','') from LoosePart where [Description] LIKE '%□%'
update HandlingUnit set [Description] = REPLACE([Description],'□','') from HandlingUnit where [Description] LIKE '%□%'
update BCSLog set description = REPLACE([Description],'□','') from BCSLog where [Description] LIKE '%□%'

ROLLBACK