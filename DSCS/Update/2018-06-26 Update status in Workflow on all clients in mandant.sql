begin TRANSACTION
UPDATE Workflow set  
OldStatusId = US.id
  FROM Workflow W
inner join [Status] OS on W.OldStatusId = OS.Id and w.ClientBusinessUnitId = OS.ClientBusinessUnitId
inner join [Status] NS on W.NewstatusId = NS.Id and w.ClientBusinessUnitId = NS.ClientBusinessUnitId
inner join (select ID, ClientBusinessUnitId from status where name = 'BXNLSend') US on W.ClientBusinessUnitId = US.ClientBusinessUnitId
  where w.Created between '2018-06-25 00:00:00.000' and '2018-06-26 00:00:00.000'
  and w.PermissionId = 'd8095e6d-28ec-4dd1-a899-233b4f42232e'
  and os.name in ('BXNLSendSuccess','BXNLSendFailure') and ns.name <>('BXNLSend')
  --and w.ClientBusinessUnitId = '53df8029-a63d-4c95-9532-d4e9cb7b2119'
ROLLBACK