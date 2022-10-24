BEGIN TRANSACTION

DECLARE @CUSTOMFIELDID as UNIQUEIDENTIFIER
DECLARE @CUSTOMFIELDNAME as VARCHAR(250)
DECLARE @CLIENT as VARCHAR (250) = 'DEMO OSL Client'

DECLARE CUSTOM_FIELD CURSOR FOR 
select 

CF.id, CF.Name, BU.Name from customfield CF with (NOLOCK) 
inner join BusinessUnit BU with (NOLOCK) on CF.ClientBusinessUnitId = BU.id and BU.[Type] = 2 
and BU.[Disabled] = 1 
and CF.Visible = 0
--and BU.Created < '2021-09-01' 
--and BU.name = @CLIENT
--where CF.NAME in ('VVID','VVBIN')  
--where (CF.ID not in (select CustomFieldId from CustomValue with (NOLOCK) where LEN(Content) > 0 group by CustomFieldId) and CF.name not in ('BXNLErrorMsg','TruckNumber','ReleaseProduction','Macros'))
--where (CF.ID not in (select CustomFieldId from CustomValue with (NOLOCK) where Content = 'TRUE' group by CustomFieldId) and CF.DataTypeId = (select id from DataType where name = 'Boolean'))

--and CF.Created < '2021-09-01' 
group by CF.id,CF.Name, BU.Name order by BU.NAME, CF.Name

OPEN CUSTOM_FIELD;
FETCH NEXT FROM CUSTOM_FIELD INTO @CUSTOMFIELDID,@CUSTOMFIELDNAME,@CLIENT;
WHILE @@FETCH_STATUS = 0  
    BEGIN  
PRINT '=== DELETE CUSTOM FIELD VALUE MAPPING: ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENT+'] ===';
delete from CustomFieldValueMapping where CustomFieldId = @CUSTOMFIELDID 
PRINT '=== DELETE CUSTOM VALUES FROM FIELD: ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENT+'] ===';
delete from CustomFieldValue where CustomFieldId = @CUSTOMFIELDID
PRINT '=== DELETE CUSTOM FIELD: ['+@CUSTOMFIELDNAME+'] IN CLIENT: ['+@CLIENT+'] ===';
delete from CustomField where Id = @CUSTOMFIELDID

FETCH NEXT FROM CUSTOM_FIELD INTO @CUSTOMFIELDID,@CUSTOMFIELDNAME,@CLIENT;

END;
CLOSE CUSTOM_FIELD;
DEALLOCATE CUSTOM_FIELD;

COMMIT

