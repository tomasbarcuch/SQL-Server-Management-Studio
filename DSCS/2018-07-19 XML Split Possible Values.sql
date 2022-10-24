
select DB_NAME() AS 'Current Database', bu.Name, tempT_PossibleValues.Id, tempT_PossibleValues.name, HH.CC.value('.','VARCHAR(8000)') as 'PossibleValues'
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
    CustomField.name = 'Sperrlager Gründe' 
    and ClientBusinessUnitId = 'bb81845e-67ba-4497-b849-7228ea32c38c' and Entity = 11
	) as tempT_PossibleValues   
	CROSS APPLY tempT_PossibleValues.nodes('/HH/CC') HH(CC)
inner join BusinessUnit BU on tempT_PossibleValues.ClientBusinessUnitId = BU.Id
  where HH.CC.value('.','VARCHAR(8000)') <> ''
  order by tempT_PossibleValues.name
