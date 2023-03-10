
  



  select 
  s.name,
  t.text,
    * from dbo.Status S
    inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
inner join dbo.businessunit BU on BUP.BusinessUnitId = BU.ID
left join dbo.[Translation] T on S.ID = T.entityId
  where s.name in ('%BXNL%','%CAD%','An BoxCAD übermittelt - Korrekt','BXNLSendSuccess','An BoxCAD übermittelt','An BoxCAD übermittelt - Fehler','BXNLSendFailure','BXNLSend')
  and language = 'DE' and s.disabled = 'false'