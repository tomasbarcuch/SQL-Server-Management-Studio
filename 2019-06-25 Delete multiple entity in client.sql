
--vybrat duplicitní bedny na klientovi bez přiřazené objednávky balení
select hu.id, hu.code, hu.updated, POH.HandlingUnitId 
from HandlingUnit HU
left join packingorderheader POH on Hu.id = POH.HandlingUnitId
where hu.code in (
select code from handlingunit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.[Type] = 2
group by code, bup.BusinessUnitId
having count(*)>1) and poh.HandlingUnitId is null
order by code, updated

--smazat duplictní bedny na klientovi bez přiřazené objednávky balení (výpis ukazuje počet zbylých)

begin TRANSACTION 
declare @handlingunitid as UNIQUEIDENTIFIER
declare @parenthandlingunitid as UNIQUEIDENTIFIER
set @handlingunitid = '8e546bd5-41ef-4d07-8aec-d19524818814'


delete from BusinessUnitPermission where HandlingUnitId = @handlingunitid
delete from EntityDimensionValueRelation where EntityId = @handlingunitid
delete from BusinessUnitPermission where ShipmentLineid in (select id from ShipmentLine where HandlingUnitId = @handlingunitid)
delete from BusinessUnitPermission where HandlingUnitId = @parenthandlingunitid
delete from WarehouseEntry where HandlingUnitId = @handlingunitid
delete from WarehouseEntry where HandlingUnitId = @parenthandlingunitid
delete from WarehouseEntry where ParentHandlingUnitId = @handlingunitid
delete from WarehouseContent where ParentHandlingUnitId = @handlingunitid
delete from WarehouseContent where HandlingUnitId = @handlingunitid
delete from HandlingUnitIdentifier where HandlingUnitId = @handlingunitid
delete from ShipmentLine where HandlingUnitId = @handlingunitid
delete from HandlingUnit where parenthandlingunitid = @handlingunitid
--delete from BusinessUnitPermission where PackingOrderLineId = (select id from PackingOrderLine where HandlingUnitId = @handlingunitid)
--delete from PackingOrderLine where HandlingUnitId = @handlingunitid
delete from HandlingUnit where id = @handlingunitid

INSERT INTO [IndexQueue] VALUES(NEWID(), 'Deufol.OSL.EntryTool.Data.Model.HandlingUnit, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', @handlingunitid, 1, NULL,(select id from [User] where login = 'tomas.barcuch'), (select id from [User] where login = 'tomas.barcuch'), GETUTCDATE(),GETUTCDATE());

COMMIT


--vyhledání duplicitních loosepartů v rámci klienta
select BU.Name, LP.updated, LP.created, LP.id, code from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where code in (select code
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1)
order by code, updated


--smazání duplicitně vytvořené LP - patrně chyba frameworku při zakládání importované položky
begin TRANSACTION 
declare @loosepartid as UNIQUEIDENTIFIER
--set @loosepartid = '7a9d82f5-fb2f-4da7-8ba6-63bf0a8d72a6'

set @loosepartid = (select top(1) LP.id from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where code in (select code
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1)
)

delete from BusinessUnitPermission where LoosePartId = @loosepartid
delete from EntityDimensionValueRelation where EntityId = @loosepartid
delete from CustomFieldValueMapping where EntityId = @loosepartid
delete from WarehouseEntry where LoosepartId = @loosepartid
delete from WarehouseContent where LoosePartId = @loosepartid
delete from LoosePartUnitOfMeasure where LoosePartId = @loosepartid
delete from LoosePartIdentifier where LoosePartId = @loosepartid
delete from LoosePart where id = @loosepartid

INSERT INTO [IndexQueue] VALUES(
 --select
NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', -- 'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
@loosepartid, -- EntityId
1, -- 0 = Insert x 1 = Delete
NULL,
(select id from [User] where login = 'tomas.barcuch'), -- user id
(select id from [User] where login = 'tomas.barcuch'), -- user id
GETUTCDATE(),
GETUTCDATE()
)



COMMIT


---report query 
/*
select 'HU' as entity, BU.Name as Client, hu.id, hu.code, hu.updated, POH.HandlingUnitId 
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
left join packingorderheader POH on Hu.id = POH.HandlingUnitId
where hu.code in (
select code from handlingunit HU
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.[Type] = 2
group by code, bup.BusinessUnitId
having count(*)>1) and poh.HandlingUnitId is null
--order by code, updated

union 

select 'LP', BU.name, LP.ID, Code, LP.updated, NULL from LoosePart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
where code in (select code
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1)
order by Entity , code, updated
*/