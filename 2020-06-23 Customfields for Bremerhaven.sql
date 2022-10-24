select 
CF.Entity
,CF.Name 
,DT.Name 'DataType'
,CF.PossibleValues
,CF.MinLength
,CF.MaxLength
,CF.IsRequired
,CF.IsFilter
,CF.[Position]
,CF.Searchable
,CF.DefaultValue
,CF.Editable
,CF.Visible
,CF.Multiple
,CF.name [Description],
'CustomFields' as Tab

 from CustomField CF
inner join DataType DT on CF.DataTypeId = DT.Id

where CF.name in (
     'Anlagen'
,'Container No.'
,'Damage'
,'Damage description'
,'Dangerousgoods'
,'Doc-closing Datum'
,'Doc-closing Zeit'
,'Dutiablegoods'
,'ETA'
,'Freistellung'
,'HuInbound Date'
,'HuInbound No'
,'HuInbound No.'
,'Invoiced'
,'Ladeschluss Datum'
,'Ladeschluss Zeit'
,'Leerdepot'
,'Macros'
,'Makler'
,'PackingType'
,'Protection'
,'Rücklieferung'
,'Seal No.'
,'VGM'
,'VGM-closing Datum'
,'VGM-closing Zeit'
,'V-Schein'
)

group BY
CF.entity
,CF.name 
,DT.Name 
,CF.PossibleValues
,CF.MinLength
,CF.MaxLength
,CF.IsRequired
,CF.IsFilter
,CF.[Position]
,CF.Searchable
,CF.DefaultValue
,CF.Editable
,CF.Visible
,CF.Multiple
