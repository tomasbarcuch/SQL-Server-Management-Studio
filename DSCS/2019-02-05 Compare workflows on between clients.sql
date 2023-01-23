select 
1 as count,
Packer.name as Packer,
Client.name as Client,
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
else 'X'end as 'entity',
case wf.Action
when 0 then 'none'
when 1 then 'Inbound'
when 2 then 'Outbound'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 8 then 'Packing In'
when 9 then 'Unpacking From'
when 10 then 'Unloading'
when 11 then 'Loading To'
when 13 then 'Loaded All'
when 14 then 'Unloaded All'
when 16 then 'Printing'
when 17 then 'Change Status'
when 21 then 'Assigned'
when 22 then 'Packed All'
when 24 then 'Assign Value'
else 'X' end as 'action',
OS.Name as old_status,
NS.Name as new_status, 
WF.DESCRIPTION
 from workflow WF
inner join BusinessUnitPermission BUP on wf.Id = bup.WorkflowId
inner join BusinessUnit Client on BUP.BusinessUnitId = Client.Id
inner join BusinessUnitRelation BUR on BUP.BusinessUnitId = BUR.BusinessUnitId
inner join BusinessUnit Packer on BUR.RelatedBusinessUnitId = Packer.Id
inner join [Status] OS on WF.OldStatusId = OS.Id
inner join [Status] NS on WF.NewStatusId = NS.Id


where bup.BusinessUnitId in ( select BusinessUnitId from BusinessUnitRelation BUR where BUR.RelatedBusinessUnitId in (select id from BusinessUnit where name in ('Deufol Hamburg Rosshafen')))