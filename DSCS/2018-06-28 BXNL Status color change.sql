update [DFCZ_OSLET].[dbo].[Status]
  set [Color] = '#00FF00'
    where name = 'BXNLSendSuccess'


update [DFCZ_OSLET].[dbo].[Status]
  set [Color] = '#FF0000'
    where name = 'BXNLSendFailure'