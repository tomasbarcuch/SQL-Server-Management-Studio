
begin TRANSACTION

--update BUP set BUP.DocumentTemplateId = DATA.id 

select *, BUP.DocumentTemplateId, DT.[FileName], DT.DocumentType, DT.Entity

from BusinessUnitPermission BUP
inner join DocumentTemplate DT on BUP.DocumentTemplateId = DT.Id

left join (
select max(DT.id) id,count(DT.id) count,DT.[FileName] from DocumentTemplate DT
inner join BusinessUnitPermission BUP on DT.id = BUP.DocumentTemplateId
group by DT.[FileName],DT.[DocumentType],DT.Entity, BUP.BusinessUnitId having count(DT.id) > 1) data on DT.[FileName] = data.[FileName]

where DT.[Disabled] = 0 
and DATA.id <> BUP.DocumentTemplateId

ROLLBACK

BEGIN TRANSACTION
delete from DocumentTemplateSubreport 
--select * from DocumentTemplateSubreport 

where  DocumentTemplateSubreport.SubreportId in (
SELECT DT.id
FROM DocumentTemplate DT
left join BusinessUnitPermission BUP on DT.id = BUP.DocumentTemplateId
where BUP.DocumentTemplateId is NULL
) or DocumentTemplateSubreport.DocumentTemplateId in (
SELECT DT.id
FROM DocumentTemplate DT
left join BusinessUnitPermission BUP on DT.id = BUP.DocumentTemplateId
where BUP.DocumentTemplateId is NULL
)

ROLLBACK

BEGIN TRANSACTION
--update DocumentTemplate set [Disabled] = 1
delete from DocumentTemplate
--select * from DocumentTemplate
 
where id in (
SELECT DT.id
FROM DocumentTemplate DT
left join BusinessUnitPermission BUP on DT.id = BUP.DocumentTemplateId
where BUP.DocumentTemplateId is NULL
)

ROLLBACK

BEGIN TRANSACTION
delete from BusinessUnitPermission where id in (
select max(BUP.id) from BusinessUnitPermission BUP
left join DocumentTemplate DT on BUP.DocumentTemplateId = DT.Id
where BUP.DocumentTemplateId is not null
group by bup.DocumentTemplateId, DT.DocumentType, DT.Entity, bup.BusinessUnitId
having count(BUP.id)>1
)
ROLLBACK

--select * from DocumentTemplate