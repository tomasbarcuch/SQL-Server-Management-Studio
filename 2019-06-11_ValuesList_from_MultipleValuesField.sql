declare @ClientBusinessUnit as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS' )
declare @BusinessUnit as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Frankenthal' )
declare @CustomFieldId as UNIQUEIDENTIFIER = 'dfd4cd00-46f7-4ad0-953e-5a1d4da00906'

select
PossibleValues.Name
,SUBSTRING(PossibleValues.PossibleValues,CHARINDEX('[',PossibleValues.PossibleValues)+1, CHARINDEX(']',PossibleValues.PossibleValues,CHARINDEX('[',PossibleValues.PossibleValues)+1) -CHARINDEX('[',PossibleValues.PossibleValues)-1) as 'SUBCLASS'
,SUBSTRING(PossibleValues.PossibleValues,CHARINDEX('[',PossibleValues.PossibleValues)+1,1) 'MAINCLASS'
,PossibleValues.PossibleValues
,Usedvalues.EntityId
,CASE WHEN UsedValues IS NULL then 'FALSE' ELSE 'TRUE' END AS Used
 from (
select 
tempT_PossibleValues.CustomFieldId, 
tempT_PossibleValues.name, 
HH.CC.value('.','VARCHAR(8000)') as 'PossibleValues'
from
 (
 SELECT 
ID CustomFieldId,CustomField.Name,
  cast(
  ('<HH><CC>'+ 
   REPLACE(PossibleValues,';','</CC><CC>')
   + '</CC></HH>') 
   as xml) as tempT_PossibleValues
    FROM CustomField 
    where 
    CustomField.id = @CustomFieldId --$P{CustomFieldID}
    --and ClientBusinessUnitId = @ClientBusinessUnit --$P{ClientBusinessUnitID}  
    
	) as tempT_PossibleValues   
	CROSS APPLY tempT_PossibleValues.nodes('/HH/CC') HH(CC)
  where HH.CC.value('.','VARCHAR(8000)') <> ''
) possiblevalues


left join (
select
CustomFieldId,
EntityId,
HH.CC.value('.','VARCHAR(8000)') as 'UsedValues'
from
 (
 SELECT 
CustomValue.CustomFieldId,
CustomValue.EntityId,
  cast(
  ('<HH><CC>'+ 
   REPLACE(Content,',','</CC><CC>')
   + '</CC></HH>') 
   as xml) as tempT_UsedValues
    FROM CustomValue
    where 
    CustomFieldId = 'dfd4cd00-46f7-4ad0-953e-5a1d4da00906' --@CustomFieldId --$P{CustomFieldID}
    --and ClientBusinessUnitId = @ClientBusinessUnit --$P{ClientBusinessUnitID}  
    
	) as tempT_UsedValues   
	CROSS APPLY tempT_UsedValues.nodes('/HH/CC') HH(CC)

  where HH.CC.value('.','VARCHAR(8000)') <> ''
) usedvalues on possiblevalues.CustomFieldId = usedvalues.CustomFieldId and possiblevalues.PossibleValues = usedvalues.UsedValues