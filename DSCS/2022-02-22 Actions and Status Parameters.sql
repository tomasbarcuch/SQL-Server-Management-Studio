select S.Id, ISNULL(T.Text,S.Name) as Status from STATUS S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitId = '2afb0812-aa09-4494-b2d3-777460852831'
LEFT join Translation T on S.id = T.EntityId and T.[Column] = 'Name' and T.[Language] = 'de'

Select
WF.Action, 
CASE WF.ActionName
when '0' then 'Status Change'
when '1' then 'Inbound'
when '2' then 'Outbound'
when '3' then 'Transfer'
when '4' then 'Movement'
when '5' then 'Packing'
when '6' then 'Unpacking'
when '7' then 'Loading'
when '8' then 'Packing in'
when '9' then 'Unpacking from'
when '10' then 'Unloading'
when '11' then 'Loading to'
when '12' then 'Unloading from'
when '13' then 'LoadedAll'
when '14' then 'Unloaded all'
when '15' then 'Inventory'
when '16' then 'Printing'
when '17' then 'Change status'
when '18' then 'Item info'
when '19' then 'Create shipment'
when '20' then 'Import'
when '21' then 'Assigned'
when '22' then 'Packed all'
when '23' then 'Unpacked all'
when '24' then 'Assign value'
when '25' then 'Show container visual model'
when '27' then 'Upload to DMS'
when '28' then 'Change client'
when '29' then 'Add shipment line'
when '30' then 'Delete shipment line'
when '31' then 'First shipment line added'
when '32' then 'Last shipment line deleted'

 end as Action
from Workflow WF
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId and BUP.BusinessUnitId = '2afb0812-aa09-4494-b2d3-777460852831'
group by Action