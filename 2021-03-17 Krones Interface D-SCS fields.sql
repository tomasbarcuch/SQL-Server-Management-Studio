select 'CF' type,'CF_'+CF.name as CF_DSCS,CF.description from CustomField CF
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.id and BU.name = 'KRONES GLOBAL'
and CF.Entity = 15
union

SELECT 'ST',COLUMN_NAME,''
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'LoosePart'

union
select D.name type,'DF_'+DF.name as DF_DSCS,DF.description from DimensionField DF
inner join BusinessUnit BU on DF.ClientBusinessUnitId = BU.id and BU.name = 'KRONES GLOBAL'
inner join Dimension D on DF.DimensionId = D.Id

union
select 'Project', 'Name','Content'
union
select 'Project', 'Description','Content'
union
select 'Order', 'Name','Content'
union
select 'Order', 'Description','Content'
union
select 'Commission', 'Name','Content'
union
select 'Commission', 'Description','Content'