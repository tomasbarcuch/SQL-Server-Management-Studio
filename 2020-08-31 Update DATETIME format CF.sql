
begin TRANSACTION

select  Convert(varchar, Convert(VarChar, DFV.Created, 120)),DFV.content
--update DFV set DFV.content = Convert(varchar, Convert(VarChar, DFV.Created, 120))
 from dimensionfieldValue DFV where DFV.DimensionFieldId in 
(select id from DimensionField DF where DF.DataTypeId = (select id from DataType DT where DT.name = 'DateTime'))
and len(DFV.Content)>0 and content = 'NOW'

ROLLBACK

begin TRANSACTION
select CV.* 
--update CV set CV.content = Convert(varchar, Convert(VarChar, CV.Created, 120))
from CustomValue CV 

where CV.CustomFieldId in 
(select id from CustomField CF where CF.DataTypeId = (select id from DataType DT where DT.name = 'DateTime'))
and len(CV.Content)>0 and content = 'NOW'

rollback


/*
select * from dimensionfieldValue DFV 

inner join [USER] U on DFV.CreatedById = U.id
where DFV.DimensionFieldId in 
(select id from DimensionField DF where DF.DataTypeId = (select id from DataType DT where DT.name = 'DateTime'))
and len(DFV.Content)>0 and content = 'NOW'
*/


