SELECT
B.code Action,
P.Name as Permission,
B.BCSAction,
B.[Description]
  FROM [BCSAction] B

  inner join BCSActionPermission AP on B.id = AP.ActionId
  inner join Permission P on AP.PermissionId = P.Id
  inner join BusinessUnitPermission BUP on B.id = BUP.BCSActionId and BUP.businessUnitId = (Select id from businessUnit where Name = 'DEUFOL CUSTOMERS')

  order by B.BCSAction