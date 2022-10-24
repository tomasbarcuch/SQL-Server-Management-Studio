BEGIN TRANSACTION

--select 
update DocumentTemplate set 
filename = replace(filename,'Siemens_Berlin','Berlin') from DocumentTemplate where [FileName] like '%Berlin%'

ROLLBACK