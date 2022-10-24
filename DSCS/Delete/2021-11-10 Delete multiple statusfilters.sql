declare @ID as UNIQUEIDENTIFIER =  ( select TOP(1) max(Id)
from StatusFilter
group by Action, Entity,StatusId,DimensionId
having count(id)>1)

delete from BusinessUnitPermission where StatusFilterId = @ID
delete from StatusFilter where Id = @ID