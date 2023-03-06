begin TRANSACTION

update DT set DT.PermissionId = P.Id --'55c2bbc5-95b5-4f79-a65b-1101510feab2' -- DocumentTemplatePrint
 from DocumentTemplate DT
inner join Permission P on DT.Name = left(P.Name,8)

ROLLBACK
