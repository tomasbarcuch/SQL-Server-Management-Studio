
select we.id weid, we.Created, wc.LoosePartId, wc.id wcid,wc.updated,we.Quantity from WarehouseEntry WE
inner join (
select wc.id, WC.LoosePartId, updated from WarehouseContent WC 
where WC.LoosePartId in (
select 
WC.LoosePartID as entityid from WarehouseContent WC
inner join businessunitpermission BUP on WC.loosepartid = BUP.loosepartid
inner join businessunit BU on BUP.businessunitid = BU.id and BU.type = 1
where WC.LoosePartId is not null 
group by 
WC.LoosePartId
having count (*) > 1)) WC on WE.LoosepartId = WC.LoosePartId and WE.updated = WC.updated --and wc.LoosePartId = '3b39372c-c55e-425f-97fa-05c43857d815'

order by wc.LoosePartId,we.Quantity, wc.updated




select  we.id weid, we.Created, wc.HandlingUnitId, wc.id wcid,wc.updated,we.Quantity from WarehouseEntry WE 
inner join (
select wc.id, WC.HandlingUnitId, updated from WarehouseContent WC where WC.HandlingUnitId in (
select 
WC.HandlingUnitId from WarehouseContent WC

where WC.HandlingUnitId is not null and WC.LoosePartId is null
group by WC.HandlingUnitId
having count (*) > 1)) WC on WE.HandlingUnitId = WC.HandlingUnitId and WE.Created = WC.updated and WE.LoosePartId is null
order by WC.HandlingUnitId, we.Quantity, WC.updated


select LP.code, BU.name,* from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
where 
--LP.id = '12da78ef-597d-4004-8e44-00353cc82be2'
LP.id in (
'011a7943-c14f-4051-a8a1-7019aaead06c',
'200390e8-62a7-4b2b-bcad-84d07be8daa4',
'991e084e-fad4-41ab-b10d-cd467263b65e'

)

/*--vyhledání duplicitních loosepartů v rámci klienta
select updated, created, id, code from LoosePart where code in (select code
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1)
order by code, updated*/


/*--smazaní duplicitně vytvořené LP - patrně chyba frameworku při zakládání importované položky
begin TRANSACTION 
declare @loosepartid as UNIQUEIDENTIFIER
set @loosepartid = '12c3b88d-b805-4bb9-8501-6134e821bb06'

delete from BusinessUnitPermission where LoosePartId = @loosepartid
delete from WarehouseEntry where LoosepartId = @loosepartid
delete from WarehouseContent where LoosePartId = @loosepartid
delete from LoosePartUnitOfMeasure where LoosePartId = @loosepartid
delete from LoosePart where id = @loosepartid
ROLLBACK
*/






