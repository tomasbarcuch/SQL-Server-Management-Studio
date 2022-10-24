SELECT 
W.Entity,
s_new.Name NewStatus,
p.name Permission,
W.Action,
W.[Description],
D.Name as Dimension,
s_old.Name as OldStatus



  FROM [dbo].[Workflow] w
  inner join dbo.Permission p on w.PermissionId = p.id
  inner join BusinessUnitPermission BUP on W.id = BUP.WorkflowId
  inner join dbo.businessunit bu on BUP.BusinessUnitId = bu.id and BUP.businessUnitId = (Select id from businessUnit where Name = '1.20.37.0 Client')
  left join dbo.status s_old on w.oldstatusid = s_old.id
  inner join dbo.status s_new on w.newstatusid = s_new.id
left join Dimension D on W.DimensionId = D.Id

order by w.Entity