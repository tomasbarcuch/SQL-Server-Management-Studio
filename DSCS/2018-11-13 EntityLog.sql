declare @Client as varchar(max)
declare @FROM as DATE
Declare @TO as DATE
set @Client = 'Siemens Berlin'
set @FROM = '2018-11-01'
set @TO = '2018-11-30'

select 
case entity
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
else 'X'end as 'Entity name',
isnull(POH.code,HU.code) as 'EntityCode',
U.LOGIN as 'User',
ColumnName as 'Column',
OldValue,
NewValue,
LE.created
 from LogEntity LE 
inner join [User] U on LE.CreatedById = U.id
left join PackingOrderHeader POH on LE.EntityId = POH.Id
left join HandlingUnit HU on LE.EntityId = HU.Id
where 
(ClientBusinessUnitId in (Select id from BusinessUnit where name = @Client) or 
PackerBusinessUnitId in (Select id from BusinessUnit where name = @Client))
and LE.Created between @FROM and @TO
--and isnull(POH.code,HU.code) in ('PO-000540','PO-000557','0001500035833019','0001500035833020')

order by Created desc


