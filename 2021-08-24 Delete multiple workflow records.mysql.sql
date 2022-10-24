

create temporary table IF NOT EXISTS TEMP
SELECT 
MAX(Id) `Id`
FROM dfczdscsdev.Workflow WF
group by WF.Entity,WF.DimensionId,WF.OldStatusId,WF.NewStatusId,WF.Action

having count(Id) > 1
;

delete  from BusinessUnitPermission where WorkflowId in (select Id from TEMP);
delete  from Workflow where Id in (select Id from TEMP);
select * from TEMP;
drop temporary table TEMP;

