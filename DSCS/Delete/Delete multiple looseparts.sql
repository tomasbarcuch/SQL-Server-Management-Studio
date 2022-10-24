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