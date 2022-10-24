SELECT
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
BU.id,
BU.name BUName,
DT.Name,
DT.[Description],
Tdescr.text as DescriptionTrans,
Tname.text as Nametrans,
DT.[FileName],
case DT.Reporttype
when 0 then 'RDLC'
When 1 then 'Jasper'
else 'x' end as 'Reporttype',
Case DT.DocumentType
When 0 then 'List'
when 1 then 'Detail'
When 2 then 'Subreport'
When 3 then 'Overview'
else 'X' end as DocumentType,
DT.DocumentType,
 case DT.entity
when 0 then 'Address'
when 1 then 'Bin'
when 2 then 'Warehouse Content'
when 3 then 'Business Unit'
when 4 then 'Custom Field'
when 5 then 'Custom Value'
when 6 then 'Data Type'
when 7 then 'Dimension'
when 8 then 'Dimension Field'
when 9 then 'Dimension Field Value'
when 10 then 'Dimension Value'
when 11 then 'Handling Unit'
when 13 then 'Handling Unit Type'
when 14 then 'Location'
when 15 then 'Loose Part'
when 16 then 'Loose Part Identifier'
when 17 then 'Loose Part Unit Of Measure'
when 18 then 'Permission'
when 19 then 'Role'
when 20 then 'Translation'
when 21 then 'Unit OfMeasure'
when 22 then 'User'
when 23 then 'Warehouse Entry'
when 24 then 'Zone'
when 25 then 'Workflow'
when 26 then 'Workflow Entry'
when 27 then 'Status'
when 28 then 'Packing Rule'
when 29 then 'Status Filter'
when 30 then 'Display UOM'
when 31 then 'Shipment Header'
when 32 then 'Shipment Line'
when 33 then 'BCS Action'
when 34 then 'Document Template'
when 35 then 'Packing Order Header'
when 36 then 'Packing Order Line'
when 37 then 'Inventory Header'
when 38 then 'Inventory Line'
when 39 then 'Number Series'
when 40 then 'Role Permission'
when 41 then 'Business Unit Relation'
when 42 then 'Document Template Subreport'
when 43 then 'BCS Action Permission'
when 44 then 'User Role'
when 45 then 'Log4Net'
when 46 then 'Comment'
when 47 then 'Service Type'
when 48 then 'Service Line'
when 49 then 'LogEntity'
when 50 then 'Component'
when 51 then 'Entity Device Placement'
else 'X'end as 'entity name',
Ucreated.FirstName+' '+Ucreated.LastName as CreatedBy,
DT.Created,
Uupdated.FirstName+' '+Uupdated.LastName as UpdatedBy,
DT.Updated


  FROM [DocumentTemplate] DT 
 left join BusinessUnit BU on DT.BusinessUnitId = bu.Id
  inner join [User] Ucreated on DT.CreatedById = Ucreated.Id
  inner join [User] Uupdated on DT.UpdatedById = Uupdated.Id
  left outer join Translation Tdescr on DT.id = Tdescr.EntityId and Tdescr.[Language] = 'de' and Tdescr.[Column] = 'Description'
  left outer join Translation Tname on DT.id = Tname.EntityId and Tname.[Language] = 'de' and Tname.[Column] = 'Name'
  order by 
  BU.Name,
  DT.Name