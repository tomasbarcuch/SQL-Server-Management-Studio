--get colation and language setting from server and database

SELECT 
name as 'Database', 
CONVERT (varchar, SERVERPROPERTY('collation')) as 'server_collation' ,
collation_name as 'db_collation',
@@LANGUAGE as 'server_language'
 FROM sys.databases where name like 'DFCZ%'

--example: use language setting to covert nvarchar custom field value to float 

select
case when @@LANGUAGE = 'us_english' then cast(replace(cv.content,',','.') as float) else cast((cv.content) as float) end,
cast(cv.content collate Latin1_General_100_CI_AS_SC as nchar)
 from LoosePart LP
 inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
 inner join CustomField CF on BUP.BusinessUnitId = CF.ClientBusinessUnitId and CF.name = 'Brutto kg'
 inner join CustomValue CV on CF.Id = CV.CustomFieldId and CV.EntityId = LP.Id
where BUP.BusinessUnitId in (select ID from BusinessUnit where name = 'Siemens Berlin')
and case when @@LANGUAGE = 'us_english' then cast(replace(cv.content,',','.') as float) else cast((cv.content) as float) end between 1 and 5
 OR (case when @@LANGUAGE = 'us_english' then cast(replace(cv.content,',','.') as float) else cast((cv.content) as float) end > 10
 and case when @@LANGUAGE = 'us_english' then cast(replace(cv.content,',','.') as float) else cast((cv.content) as float) end < 20)