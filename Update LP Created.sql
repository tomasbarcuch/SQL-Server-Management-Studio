use DFCZ_OSLET_TST

----begin transaction
----UPDATE WE SET WE.created = lp.created 

--select 
--lp.created as lpcreated,
--we.created as wecreated,
--b.code,
--CAST(CAST(cast(lp.created as date) as varchar)+' '+'00:00:00.000' AS DATETIME) AS BEG,
--CAST(CAST(cast(lp.created as date) as varchar)+' '+'23:59:59.997' AS DATETIME) AS EN,
--cast(CAST(we.created AS DATE)as datetime) as wecreated,
--* 
--from WarehouseEntry WE
--right OUTER JOIN loosepart lp on we.loosepartid = lp.id
--left outer join dbo.bin B on lp.ActualBinId = b.Id

--where
--we.created not between  CAST(CAST(cast(lp.created as date) as varchar)+' '+'00:00:00.000' AS DATETIME)
--and
-- CAST(CAST(cast(lp.created as date) as varchar)+' '+'23:59:59.997' AS DATETIME) and
----CAST(lp.created AS DATE) <> CAST(we.created AS DATE) and 
----lp.created = we.created and 
--lp.ClientBusinessUnitId = 'AD5A5F6B-8EC4-463B-836A-0A8CB60A39D2'

----b.code = 'Dummy_bin'
----and lp.code = '0000032415/000301'
----rollback

begin tran
update WE set we.created = cast(cast (lp.created as date) as datetime)+0.0416667 --plus hodina od pùlnoci
--select

--lp.created as lpcreated,
--we.created as wecreated,
--cast(cast (lp.created as date) as datetime)+0.0416667

from loosepart lp 
 
left outer JOIN WarehouseEntry WE on we.loosepartid = lp.id
where 

(lp.createdbyid = '4A9F1DDF-47A8-4DED-B522-F1D4A41A05C5' --vvmigration
or
lp.updatedbyid = '4A9F1DDF-47A8-4DED-B522-F1D4A41A05C5') --vvmigration
rollback