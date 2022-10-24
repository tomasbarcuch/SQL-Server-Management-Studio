select
CF.Name,
Client.Name,
DT.Name
from CustomField CF
inner join BusinessUnit Client on CF.ClientBusinessUnitId = Client.id and Client.[Disabled] = 0
inner join DataType DT on CF.DataTypeId = DT.Id
where Entity = 15 and CF.NAME in (
  'Article',
'Artikel Nummer',
'Material n.',
'MaterialNo',
'Material n.',
'Manufactory Code',
'MaterialNo',
'Netto',
'NetWeight',
'Dangerous goods',
'Dangerousgoods',
'LpInbound Date',
'LpInbound No',
'DAMAGED',
'Damage'
)
order by CF.name




select
CF.Name,
CF.Entity
from CustomField CF
inner join BusinessUnit Client on CF.ClientBusinessUnitId = Client.id and Client.[Disabled] = 0
inner join DataType DT on CF.DataTypeId = DT.Id
where Entity = 15
Group by CF.NAme,CF.Entity
order by CF.name



