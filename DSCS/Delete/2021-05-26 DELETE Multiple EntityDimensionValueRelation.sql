
--delete from EntityDimensionValueRelation where id = (
select TOP(1) ID from EntityDimensionValueRelation where EntityId in (
select EntityId
from EntityDimensionValueRelation edvr
inner JOIN DimensionValue DV on edvr.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.Id
group by EntityId, D.id
having count(DimensionValueId) > 1)
--)
/*
delete from [Queue] where XMLDocument = (
select TOP(1)XMLDocument from (
SELECT XMLDocument FROM [Queue]
  GROUP BY XMLDocument HAVING COUNT(*) > 1))
  */