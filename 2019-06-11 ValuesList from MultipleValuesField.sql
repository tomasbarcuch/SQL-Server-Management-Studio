select 
DB_NAME() AS 'Current Database', 
bu.Name as ClientBusinessName, 
tempT_PossibleValues.Id, 
tempT_PossibleValues.name, 
HH.CC.value('.','VARCHAR(8000)') as 'PossibleValues'
from
 (
 SELECT 
ID,ClientBusinessUnitId,CustomField.Name,
  cast(
  ('<HH><CC>'+ 
   REPLACE(PossibleValues,';','</CC><CC>')
   + '</CC></HH>') 
   as xml) as tempT_PossibleValues
    FROM CustomField 
    where 
    CustomField.id = (select id from CustomField where name = 'Foil' and CustomField.ClientBusinessUnitID = ((Select id from BusinessUnit where name = 'KRONES GLOBAL')) ) --$P{CustomFieldID}

    and ClientBusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL') --$P{ClientBusinessUnitID}  
    and Entity = 11

	) as tempT_PossibleValues   
	CROSS APPLY tempT_PossibleValues.nodes('/HH/CC') HH(CC)
inner join BusinessUnit BU on tempT_PossibleValues.ClientBusinessUnitId = BU.Id
  where HH.CC.value('.','VARCHAR(8000)') <> ''
  order by tempT_PossibleValues.name