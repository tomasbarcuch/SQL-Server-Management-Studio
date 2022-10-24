
/*	INSERT INTO [Bin] 
				([Id],[Code],[LocationId],zoneid,[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[MaximumVolume])     
				SELECT NEWID(),Bin.Code,'9534936C-7857-400A-85D3-209507DE257B',null,Bin.[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],bin.[Disabled],bin.[CreatedById],bin.[UpdatedById],GETDATE(),GETDATE(),[MaximumVolume]   
from WarehouseEntry
inner join Bin on WarehouseEntry.BinId = bin.Id
left join (select code,id from Bin where locationid = '9534936C-7857-400A-85D3-209507DE257B') bmain on bin.code = bmain.Code
 where BinId in (
select id from bin where LocationId in ('04E9E957-2857-4370-B8C4-11DC1735E823'))
group by bin.Code,
Bin.[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],bin.[Disabled],bin.[CreatedById],bin.[UpdatedById],[MaximumVolume]   
*/

/*
	INSERT INTO [Bin] 
				([Id],[Code],[LocationId],zoneid,[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[MaximumVolume])     
				SELECT NEWID(),Bin.Code,'9534936C-7857-400A-85D3-209507DE257B',null,Bin.[Description],Bin.[Length],Bin.[Width],Bin.[Height],Bin.[Empty],[MaximumWeight],[BlockMovement],bin.[Disabled],bin.[CreatedById],bin.[UpdatedById],GETDATE(),GETDATE(),[MaximumVolume]   

from HandlingUnit
inner join Bin on HandlingUnit.actualBinId = bin.Id
left join (select code,id from Bin where locationid = '9534936C-7857-400A-85D3-209507DE257B') bmain on bin.code = bmain.Code and HandlingUnit.Actualbinid <> bin.id
 where ActualBinId in (
select id from bin where LocationId = '04E9E957-2857-4370-B8C4-11DC1735E823') 
group by bin.Code, Bin.[Description],bin.Length,Bin.Width,Bin.[Height],Bin.[Empty],[MaximumWeight],[BlockMovement],bin.[Disabled],bin.[CreatedById],bin.[UpdatedById],[MaximumVolume]   

*/

update location set code = 'TRDLO' where id = 'A1BAD147-33AA-4618-B885-ED1BA33BFC14'



select
bin.id, bin.code, bmain.Id

from WarehouseEntry
inner join Bin on WarehouseEntry.BinId = bin.Id
left join (select code,id from Bin where locationid = '9534936C-7857-400A-85D3-209507DE257B') bmain on bin.code = bmain.Code --and WarehouseEntry.binid <> bin.id
 where BinId in (
select id from bin where LocationId = '04E9E957-2857-4370-B8C4-11DC1735E823') 
group by bin.Code,bin.id, bin.code, bmain.Id


select code from bin where LocationId = '04E9E957-2857-4370-B8C4-11DC1735E823'
select
bin.code,
bmain.code
from HandlingUnit
inner join Bin on HandlingUnit.actualBinId = bin.Id
left join (select code,id from Bin where locationid = '9534936C-7857-400A-85D3-209507DE257B') bmain on bin.code = bmain.Code-- and HandlingUnit.Actualbinid <> bin.id
 where ActualBinId in (
select id from bin where LocationId = '04E9E957-2857-4370-B8C4-11DC1735E823') 
group by bin.Code, bmain.code




select * from handlingunit where ActualBinId in (select id from bin where LocationId = '8D9915C1-7D58-4566-921D-8786C9D946FD')


select 
zone.name
from WarehouseEntry
inner join Zone on WarehouseEntry.ZoneId = Zone.Id
left join (select Name,id from Zone where locationid = '9D10F414-3CEB-472F-84DC-EF9835CFA9F7') Zmain on Zone.name = zmain.name
 where ZoneId in (
select id from Zone where LocationId = '8D9915C1-7D58-4566-921D-8786C9D946FD')
group by Zone.Name

--delete from bin where LocationId = '534037B9-E706-470E-8A67-CE08CAEBE340' and created > '2019-08-08 13:10:00.000'




select count(id) from zone where LocationId in (select id from location where code = 'Neutraubling') group by name

--delete from location where id = 'E204980B-77A0-40D5-BBAE-A1B68C81650F'


select bu.Name from BusinessUnitPermission BUP
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
 where LocationId in (select id from [Location] where code = 'Neutraubling')
 --where LocationId = 'e204980b-77a0-40d5-bbae-a1b68c81650f'

 select code, count(id) from bin where LocationId in (select id from [Location] where code = 'Neutraubling') group by code