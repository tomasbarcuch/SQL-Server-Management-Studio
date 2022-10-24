begin TRANSACTION

create TABLE #TEMP 
(
    ID UNIQUEIDENTIFIER
)

insert into #TEMP

select id from Workflow where id in (
select max(id) from workflow

group by 
Entity,
DimensionId,
OldStatusId,
NewStatusId,
[Action]

having count(id) > 1

)

delete from BusinessUnitPermission where WorkflowId in (select ID from #TEMP)
delete from Workflow where Id in (select ID from #TEMP)

Drop Table #Temp
COMMIT