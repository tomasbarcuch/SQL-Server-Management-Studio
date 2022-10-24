

update BusinessUnitPermission set PermissionType = 1
--select BU.NAme, CASE BUP.PermissionType when 0 then 'None'when 1 then 'READ WRITE'when 2 then 'READ ONLY'end as PermissionTypeName, *
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BU.Id = BUP.BusinessUnitId and BU.type = 2
inner join DocumentTemplate DT on BUP.DocumentTemplateId = DT.id and DT.Name not like 'DST%'
where DocumentTemplateId is not null and BUP.PermissionType <> 1

update BusinessUnitPermission set PermissionType = 2
--select BU.NAme, CASE BUP.PermissionType when 0 then 'None'when 1 then 'READ WRITE'when 2 then 'READ ONLY'end as PermissionTypeName, *
from BusinessUnitPermission BUP
inner join BusinessUnit BU on BU.Id = BUP.BusinessUnitId and BU.type <> 2
where DocumentTemplateId is not null and BUP.PermissionType = 1

update BusinessUnitPermission set PermissionType = 2
--select CASE BUP.PermissionType when 0 then 'None'when 1 then 'READ WRITE'when 2 then 'READ ONLY'end as PermissionTypeName, *
from BusinessUnitPermission BUP
--inner join BusinessUnit BU on BU.Id = BUP.BusinessUnitId and BU.type <> 2
inner join DocumentTemplate DT on BUP.DocumentTemplateId = DT.id and DT.Name like 'DST%'
where DocumentTemplateId is not null and BUP.PermissionType = 1

