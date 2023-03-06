
--smazání duplicitně vytvořené LP - patrně chyba frameworku při zakládání importované položky
begin TRANSACTION 
declare @loosepartid as UNIQUEIDENTIFIER
DECLARE ENTITYID CURSOR FOR 

select  LP.ID from LoosePart LP
inner join 
(select LP.code, max(LP.ClusteredId) CLUSTEREDID
from LoosePart lp
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1) DATA on LP.Code = DATA.Code and LP.ClusteredId = DATA.CLUSTEREDID

OPEN ENTITYID;
FETCH NEXT FROM ENTITYID INTO @loosepartid;
WHILE @@FETCH_STATUS = 0  
BEGIN

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

FETCH NEXT FROM ENTITYID INTO @loosepartid;
END;
CLOSE ENTITYID;
DEALLOCATE ENTITYID;

COMMIT
--smazání duplicitně vytvořené HU - patrně chyba frameworku při zakládání importované položky
 BEGIN TRANSACTION
declare @handlingunitid as UNIQUEIDENTIFIER
DECLARE ENTITYID CURSOR FOR 

select  HU.ID from HandlingUnit HU
inner join 
(select hu.code, max(hu.ClusteredId) CLUSTEREDID
from HandlingUnit hu
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and [Type] = 2
group by code, bu.Name
having 
count(code) > 1) DATA on HU.Code = DATA.Code and HU.ClusteredId = DATA.CLUSTEREDID

OPEN ENTITYID;
FETCH NEXT FROM ENTITYID INTO @handlingunitid;
WHILE @@FETCH_STATUS = 0  
BEGIN

delete from BusinessUnitPermission where LoosePartId = @handlingunitid
delete from EntityDimensionValueRelation where EntityId = @handlingunitid
delete from CustomFieldValueMapping where EntityId = @handlingunitid
delete from WarehouseEntry where LoosepartId = @handlingunitid
delete from WarehouseContent where LoosePartId = @handlingunitid
delete from LoosePartUnitOfMeasure where LoosePartId = @handlingunitid
delete from LoosePartIdentifier where LoosePartId = @handlingunitid
delete from LoosePart where id = @handlingunitid

INSERT INTO [IndexQueue] VALUES(
 --select
NEWID(), 
'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', -- 'Deufol.OSL.EntryTool.Data.Model.LoosePart, Deufol.OSL.EntryTool.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
@handlingunitid, -- EntityId
1, -- 0 = Insert x 1 = Delete
NULL,
(select id from [User] where login = 'tomas.barcuch'), -- user id
(select id from [User] where login = 'tomas.barcuch'), -- user id
GETUTCDATE(),
GETUTCDATE()
)

FETCH NEXT FROM ENTITYID INTO @handlingunitid;
END;
CLOSE ENTITYID;
DEALLOCATE ENTITYID;

COMMIT