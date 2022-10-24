select A.Code Action, A.BCSaction Enum, P.Name Permission from BCSAction A
inner join BusinessUnitPermission BUP on A.id = BUP.BCSActionId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
inner join BCSActionPermission AP on A.Id = AP.ActionId
inner join Permission P on AP.PermissionId = P.Id
