select
Dimension,
DimName,
RespPerson,
case data.entity
when 0 then 'Address'
when 1 then 'Bin'
when 2 then 'WarehouseContent'
when 3 then 'BusinessUnit'
when 4 then 'CustomField'
when 5 then 'CustomValue'
when 6 then 'DataType'
when 7 then 'Dimension'
when 8 then 'DimensionField'
when 9 then 'DimensionFieldValue'
when 10 then 'DimensionValue'
when 11 then 'HandlingUnit'
when 13 then 'HandlingUnitType'
when 14 then 'Location'
when 15 then 'LoosePart'
when 16 then 'LoosePartIdentifier'
when 17 then 'LoosePartUnitOfMeasure'
when 18 then 'Permission'
when 19 then 'Role'
when 20 then 'Translation'
when 21 then 'UnitOfMeasure'
when 22 then 'User'
when 23 then 'WarehouseEntry'
when 24 then 'Zone'
when 25 then 'Workflow'
when 26 then 'WorkflowEntry'
when 27 then 'Status'
when 28 then 'PackingRule'
when 29 then 'StatusFilter'
when 30 then 'DisplayUOM'
when 31 then 'ShipmentHeader'
when 32 then 'ShipmentLine'
when 33 then 'BCSAction'
when 34 then 'DocumentTemplate'
when 35 then 'PackingOrderHeader'
when 36 then 'PackingOrderLine'
when 37 then 'InventoryHeader'
when 38 then 'InventoryLine'
when 39 then 'NumberSeries'
when 40 then 'RolePermission'
when 41 then 'BusinessUnitRelation'
when 42 then 'DocumentTemplateSubreport'
when 43 then 'BCSActionPermission'
when 44 then 'UserRole'
when 45 then 'Log4Net'
when 46 then 'Comment'
when 47 then 'ServiceType'
when 48 then 'ServiceLine'
when 49 then 'LogEntity'
when 50 then 'Component'
when 51 then 'EntityDevicePlacement'
else 'X'end as 'entity name',
(isnull(TLP.Text,THU.Text)) as Status,
sum(case when data.Entity = 11 then 1 else 0 end) + sum(case when data.Entity = 15 then 1 else 0 end) as Count

  from 
(select
DFV.Content as RespPerson,
DV.Content as Dimension,
DV.[Description] as DimName,
entity,
entityid
 from EntityDimensionValueRelation EDVR
 inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
 inner join DimensionFieldValue DFV on DFV.DimensionValueId = DV.Id
inner join DimensionField DFcp on DFV.DimensionFieldId = DFcp.id and DFcp.name = 'Contact Person'
 inner join (
select
D.name,
D.id dimid, 
BU.name buName,
DV.[Content],
DV.[Description],
S.name StatusName,
DV.StatusId from Dimension D
inner join DimensionValue DV on D.id = DV.DimensionId
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id
inner join Status S on DV.StatusId = S.id
where bup.BusinessUnitId in(
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = (
select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen'))
and d.name = 'Order' and s.Name = 'Active'
)Dim on DV.DimensionId = Dim.dimId) DATA


left join LoosePart LP on DATA.EntityId = LP.Id and DATA.Entity = 15
left join status SLP on LP.StatusId = SLP.Id
left join Translation TLP on SLP.id = TLP.EntityId and Tlp.[Language] = 'de'
left join HandlingUnit HU on DATA.EntityId = HU.Id and DATA.Entity = 11
left join status SHU on HU.StatusId = SHU.Id
left join Translation THU on SHU.id = THU.EntityId and THU.[Language] = 'de'

where data.Entity in (11,15)
group by Dimension,(isnull(TLP.Text,THU.Text)),data.entity,RespPerson,DimName

order by Dimension, data.Entity,status