DECLARE @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where Name = 'KRONES GLOBAL')
DECLARE @FROM_DATE as DATE = '2022-01-01'
DECLARE @TO_DATE as DATE = '2022-05-31'
select
CAST(YEAR(WFE.Created) as VARCHAR) +'-'+CAST(FORMAT(WFE.Created,'MM') as VARCHAR) MonthYear,
Packer.Name as Packer,
CASE WFE.WorkflowAction
WHEN 0 THEN 'Status'
WHEN 1 THEN 'Inbound'
WHEN 2 THEN 'Outbound'
WHEN 3 THEN 'Transfer'
WHEN 4 THEN 'Movement'
WHEN 5 THEN 'Packing'
WHEN 6 THEN 'Unpacking'
WHEN 7 THEN 'Loading'
WHEN 8 THEN 'Packing In'
WHEN 9 THEN 'UnpackingFrom'
WHEN 10 THEN 'Unloading'
WHEN 11 THEN 'LoadingTo'
WHEN 12 THEN 'Unloading From'
WHEN 13 THEN 'Loaded All'
WHEN 15 THEN 'Unloaded All'
WHEN 15 THEN 'Inventory'
WHEN 16 THEN 'Printing'
WHEN 17 THEN 'Change Status'
WHEN 18 THEN 'Item Info'
WHEN 19 THEN 'Create Shipment'
WHEN 20 THEN 'Import'
WHEN 21 THEN 'Assigned'
WHEN 22 THEN 'Packed All'
WHEN 23 THEN 'Unpacked All'
WHEN 24 THEN 'Assign Value'
WHEN 25 THEN 'Show Container Visual Model'
WHEN 26 THEN 'Assign Device'
WHEN 27 THEN 'Upload To DMS'
WHEN 28 THEN 'Change Client'
WHEN 29 THEN 'Add Shipment Line'
WHEN 30 THEN 'Delete Shipment Line'
WHEN 31 THEN 'First Shipment Line Added'
WHEN 32 THEN 'Last Shipment Line Deleted'
WHEN 33 THEN 'Forward Shipment'
end as Action,
case WFE.Entity
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
when 15 then 'LoosePart'
when 16 then 'LoosePart Identifier'
when 17 then 'LoosePart Unit Of Measure'
when 18 then 'Permission'
when 19 then 'Role'
when 20 then 'Translation'
when 21 then 'Unit Of Measure'
when 22 then 'User'
when 23 then 'Warehouse Entry'
when 24 then 'Zone'
when 25 then 'Workflow'
when 26 then 'Workflow Entry'
when 27 then 'Status'
when 28 then 'Packing Rule'
when 29 then 'Status Filter'
when 30 then 'Displa UOM'
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
when 49 then 'Log Entity'
when 50 then 'Component'
when 51 then 'Entity Device Placement'
else 'X'end as 'entity',
COUNT(WFE.ID) as Count
from WorkflowEntry WFE
inner join BusinessUnit Packer on WFE.BusinessUnitId = Packer.Id
Where (WFE.BusinessUnitId 
in ( select RelatedBusinessUnitId from BusinessUnitRelation where BusinessUnitId = @Client )
OR WFE.ClientBusinessUnitId = @Client
)
and WFE.Created between @FROM_DATE and @TO_DATE
and WFE.WorkFlowAction is not null

group by 
WFE.Entity, WFE.WorkflowAction, Packer.Name, CAST(YEAR(WFE.Created) as VARCHAR) +'-'+CAST(FORMAT(WFE.Created,'MM') as VARCHAR)

order by 
Packer.Name, WFE.WorkflowAction, WFE.Entity, CAST(YEAR(WFE.Created) as VARCHAR) +'-'+CAST(FORMAT(WFE.Created,'MM')  as VARCHAR)