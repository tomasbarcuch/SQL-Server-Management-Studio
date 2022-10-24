select cf.id,  case entity
when 0 then 'dbo.Address'
when 1 then 'dbo.Bin'
when 2 then 'dbo.WarehouseContent'
when 3 then 'dbo.BusinessUnit'
when 4 then 'dbo.CustomField'
when 5 then 'dbo.CustomValue'
when 6 then 'dbo.DataType'
when 7 then 'dbo.Dimension'
when 8 then 'dbo.DimensionField'
when 9 then 'dbo.DimensionFieldValue'
when 10 then 'dbo.DimensionValue'
when 11 then 'dbo.HandlingUnit'
when 13 then 'dbo.HandlingUnitType'
when 14 then 'dbo.Location'
when 15 then 'dbo.LoosePart'
when 16 then 'dbo.LoosePartIdentifier'
when 17 then 'dbo.LoosePartUnitOfMeasure'
when 18 then 'dbo.Permission'
when 19 then 'dbo.Role'
when 20 then 'dbo.Translation'
when 21 then 'dbo.UnitOfMeasure'
when 22 then 'dbo.User'
when 23 then 'dbo.WarehouseEntry'
when 24 then 'dbo.Zone'
when 25 then 'dbo.Workflow'
when 26 then 'dbo.WorkflowEntry'
when 27 then 'dbo.Status'
when 28 then 'dbo.PackingRule'
when 29 then 'dbo.StatusFilter'
when 30 then 'dbo.DisplayUOM'
when 31 then 'dbo.ShipmentHeader'
when 32 then 'dbo.ShipmentLine'
when 33 then 'dbo.BCSAction'
when 34 then 'dbo.DocumentTemplate'
when 35 then 'dbo.PackingOrderHeader'
when 36 then 'dbo.PackingOrderLine'
when 37 then 'dbo.InventoryHeader'
when 38 then 'dbo.InventoryLine'
when 39 then 'dbo.NumberSeries'
when 40 then 'dbo.RolePermission'
when 41 then 'dbo.BusinessUnitRelation'
when 42 then 'dbo.DocumentTemplateSubreport'
when 43 then 'dbo.BCSActionPermission'
when 44 then 'dbo.UserRole'
when 45 then 'dbo.Log4Net'
when 46 then 'dbo.Comment'
when 47 then 'dbo.ServiceType'
when 48 then 'dbo.ServiceLine'
when 49 then 'dbo.LogEntity'
when 50 then 'dbo.Component'
when 51 then 'dbo.EntityDevicePlacement'


else 'X'end as 'entity name', cf.name,records
 from CustomField cf
inner join BusinessUnit BU on cf.ClientBusinessUnitId = BU.id and BU.name = ('Siemens Berlin')
left join 
(
select
cfid, 
name,
count(cvid) as records
 FROM
(select
upper(cf.DefaultValue) def,
upper(cv.content) val,
cf.id cfid,
cv.id cvid,
cf.name

from CustomValue CV
inner join CustomField CF on cv.CustomFieldId = CF.Id
inner join BusinessUnit BU on cf.ClientBusinessUnitId = BU.id and BU.name = ('Siemens Berlin')

where upper(cf.DefaultValue) <> upper(cv.Content)) data 

group by Name,cfid
) data on cf.id = data.cfid
where  cf.visible = 1 and (records < 20 or records is null)
order by 'entity name', records



select count(*) from CustomValue where customfieldid in(
'9689b495-140c-494d-8aab-21178add2fc3'
)

/*
update CustomField  set visible = 0 where id in (
'20ef789d-0655-4d85-8202-e21cf7b2ec2b',
'9400270c-802d-4bce-9f23-3e504c61aca4',
'5085806d-5881-45ba-a5fd-c1342e577649',
'ab8ef6d1-c760-4403-a6ac-905b7401582d',
'27fd24bf-bb35-4968-93f7-a0b86722f6a3',
'7fbda907-6bcb-47eb-894f-245d70879392',
'f9017643-a397-4ee4-a08d-42e3682bdcff',
'522ffc94-edf8-4275-acfd-775001530959',
'de234b92-c0dc-40a4-b5ab-8b32b9afe4c6',
'f35ca1f0-3e45-4f4a-a63b-d5395f845c5f',
'd54de894-3ac5-4364-b4fe-f47074023104',
'20ef789d-0655-4d85-8202-e21cf7b2ec2b',
'd54de894-3ac5-4364-b4fe-f47074023104',
'd2fd0a8d-3b97-4d20-9420-8e4e9b7789c9',
'0d30d109-f67e-4b74-8e23-9edac4ef9df1',
'5ca4a835-d061-4d96-9ea8-d65352085aa7',
'4ebbc032-bf06-42d3-a905-fcc9a6e3cc96',
'176f0ec3-9428-4ee1-8851-09bf77d4dcc2',
'43bd77b1-5830-43fb-9871-eb28f155a07d'
) and visible = 1
*/