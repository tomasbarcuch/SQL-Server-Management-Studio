begin TRANSACTION

DECLARE @EDVRID as VARCHAR(250)
DECLARE EDVR_ID CURSOR FOR 

select ID from EntityDimensionValueRelation where EntityId in (
select EntityId
from EntityDimensionValueRelation edvr
inner JOIN DimensionValue DV on edvr.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.Id
group by EntityId, D.id
having count(DimensionValueId) > 1)

OPEN EDVR_ID;
FETCH NEXT FROM EDVR_ID INTO @EDVRID;
WHILE @@FETCH_STATUS = 0  
    BEGIN  
delete from EntityDimensionValueRelation where Id = @EDVRID

FETCH NEXT FROM EDVR_ID INTO @EDVRID;

END;

CLOSE EDVR_ID;
DEALLOCATE EDVR_ID;


ROLLBACK

/*
delete from [Queue] where XMLDocument = (
select TOP(1)XMLDocument from (
SELECT XMLDocument FROM [Queue]
  GROUP BY XMLDocument HAVING COUNT(*) > 1))
  */