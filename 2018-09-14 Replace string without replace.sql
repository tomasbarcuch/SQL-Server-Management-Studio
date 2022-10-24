select

cast(case when (charindex(',',customvalue.Content)) > 0 then
left(CustomValue.Content,(charindex(',',customvalue.Content))-1)+'.'+right(CustomValue.Content,len(customvalue.Content)-(charindex(',',customvalue.Content)))
 else CustomValue.Content end as float) as 'Brutto',

customvalue.Content
from CustomField 
inner join customvalue on CustomField.id = CustomValue.CustomFieldId

where customfield.Name = 'Brutto kg'

--and (charindex(',',customvalue.Content)) >0


USE DFCZ_OSLET;  
GO  
SELECT compatibility_level  
FROM sys.databases WHERE name = 'DFCZ_OSLET';  
GO 

SELECT SERVERPROPERTY('ProductVersion');  

