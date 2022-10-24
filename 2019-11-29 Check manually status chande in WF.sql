select BU.name, OldS.name, A.[Description], P.Name, News.Name from Workflow WF
inner join Permission P on WF.PermissionId = P.Id
inner join BCSAction A on WF.[Action] = A.BCSaction
inner join Status NewS on WF.NewStatusId = News.Id
inner join Status OldS on WF.OldStatusId = OldS.Id
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and bu.type = 2
where WF.NewStatusId in (Select Id from [Status] S where S.Name like 'HuPacked') 