BEGIN TRANSACTION
--select CF.NAME,SH.Code,LEFT(CV.Content,50)
update SH set SH.TruckNumber = LEFT(CV.Content,50) 
from CustomField CF 
inner join CustomValue CV on CF.id = CV.CustomFieldId and lEN(CV.Content)>0
inner join ShipmentHeader SH on CV.EntityId = SH.id
where CF.NAME in ('LKW Nummer','TruckNumber','Truck license plate','Number plate')  and DataTypeId = 'a9d5f9a7-383c-4547-a562-66c281b3de7e'

ROLLBACK


BEGIN TRANSACTION

DECLARE @CUSTOMFIELDID as UNIQUEIDENTIFIER
DECLARE @CUSTOMFIELDNAME as VARCHAR(250)
DECLARE @CLIENT as VARCHAR (250)

DECLARE CUSTOM_FIELD CURSOR FOR 
select 

CF.id, CF.Name, BU.Name from customfield CF with (NOLOCK) 
inner join BusinessUnit BU with (NOLOCK) on CF.ClientBusinessUnitId = BU.id and BU.[Type] = 2 

where CF.NAME in ('LKW Nummer','TruckNumber','Truck license plate','Number plate')  and DataTypeId = 'a9d5f9a7-383c-4547-a562-66c281b3de7e' 
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

ROLLBACK
