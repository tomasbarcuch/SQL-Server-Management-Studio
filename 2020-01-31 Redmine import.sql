select
'DSCS 2.0' as 'Project',
'REP' as 'Tracker',
'New' as 'Status',
'Convert report "'+DT.name+'" to MYSQL' as 'Subject',
'Change report query from MSSQL to MYSQL, test it and publish on TST/PRD Enviroment.'+ CHAR(13) + 
'Reportname: '+DT.Name+ CHAR(13) + 
'File: '+ Filename + CHAR(13) + 
'Report Description: '+ DT.[Description] as 'Description',
'Normal' as 'Priority',
'' as 'Category',
'tomas.barcuch' as 'Assignee',
'BACKLOG' as 'Target Version',
'Task' as 'User Story Priority',
'' as 'Story Points',
'' as 'Ticket',
'No' as 'Private',
17478 as 'Parent task',
'01.02.2020' as 'Start date',
'31.05.2020' as 'Due date',
6 'Estimated time',
0 as '% Done'

 from DocumentTemplate DT
where reporttype = 1-- and [FileName] not like '%label%'
and DT.Parameters is not null
 group by 
 Filename,
reporttype,
DT.Name,
DT.[Description]

