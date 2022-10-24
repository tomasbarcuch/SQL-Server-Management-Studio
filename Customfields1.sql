declare 
		@columns nvarchar(max),
		@table nvarchar(max)

select @columns = (select left(fields,len(fields)-1) as cols from
(select (
select '['+CF.name+'] '+ isnull(' ', '') + 
case CF.fieldtype 
when 'String' then 'nvarchar'
when 'boolean' then 'int'
else CF.fieldtype end +','
from (select distinct customfield.name,replace(datatype.fieldtype ,'System.','') as fieldtype 
from customfield inner join datatype on customfield.datatypeid = datatype.id) as CF 
for xml path ('')) fields) c)

select @table = ' declare @table table ('+@columns+')'

exec sp_executesql  @table = @table



--declare @table table (col1 nvarchar, col2 int) select * from @table


/*SELECT TOP (100) PERCENT * 
FROM OPENROWSET('SQLOLEDB', 'Trusted_Connection=Yes;Server=(local);Database=DFCZ_OSLET_TST', 'exec CustomFieldsValues with result sets undefined') 
AS datatable
*/

(select left(fields,len(fields)-1) as cols from
(select (
select '['+CF.name+'] '+ isnull(' ', '') + 
case CF.fieldtype 
when 'String' then 'nvarchar'
when 'boolean' then 'int'
else CF.fieldtype end +','
from (select distinct customfield.name,replace(datatype.fieldtype ,'System.','') as fieldtype 
from customfield inner join datatype on customfield.datatypeid = datatype.id) as CF 
for xml path ('')) fields) c)


/*
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO
*/

--sp_linkedservers