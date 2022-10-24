


SELECT 
sum(case when match in (4,8) then 1 else 0 end)/
sum(0.01) as 'Workflow% match'
 from (

select count(Name) match from (

select ISNULL(OldS.Name,'') OldStatus, NewS.Name NewStatus,WF.Entity,WF.[Action], BU.Name from Workflow WF 
left join Status OldS on WF.OldStatusId = OldS.Id
left join Status NewS on WF.NewStatusId = NewS.Id
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
WHERE BU.Name in (
    'DEUFOL CUSTOMERS',
    'KRONES GLOBAL'
    )
) DATA

GRoup by 
DATA.OldStatus,
DATA.NewStatus,
DATA.Entity,
DATA.Action

) DATA



select * from (
select ISNULL(OldS.Name,'') OldStatus, NewS.Name NewStatus,
case WF.Entity

when 7 then 'Dimension'
when 11 then 'HandlingUnit'
when 15 then 'LoosePart'
when 31 then 'ShipmentHeader'
when 35 then 'PackingOrderHeader'
when 37 then 'InventoryHeader'
when 46 then 'Comment'
when 48 then 'ServiceLine'
when 49 then 'LogEntity'
when 50 then 'Component'
when 57 then 'Tender'
else 'X'end as 'Entity'

,CASE WF.[Action]
when '0' then 'None'
when '1' then 'Inbound'
when '2' then 'Outbound'
when '3' then 'Transfer'
when '4' then 'Movement'
when '5' then 'Packing'
when '6' then 'Unpacking'
when '7' then 'Loading'
when '8' then 'PackingIn'
when '9' then 'UnpackingFrom'
when '10' then 'Unloading'
when '11' then 'LoadingTo'
when '12' then 'UnloadingFrom'
when '13' then 'LoadedAll'
when '14' then 'UnloadedAll'
when '15' then 'Inventory'
when '16' then 'Printing'
when '17' then 'ChangeStatus'
when '18' then 'ItemInfo'
when '19' then 'CreateShipment'
when '20' then 'Import'
when '21' then 'Assigned'
when '22' then 'PackedAll'
when '23' then 'UnpackedAll'
when '24' then 'AssignValue'
when '25' then 'ShowContainerVisualModel'
when '26' then 'AssignDevice'
when '27' then 'UploadToDMS'
when '28' then 'Change Client'
when '29' then 'Add shipment line'
when '30' then 'Delete shipment line'
when '31' then 'First shipment line added'
when '32' then 'Last shipment line deleted'
when '33' then 'Transshipment
'
else cast(WF.Action as varchar) end as Action

, BU.Name from Workflow WF 
left join Status OldS on WF.OldStatusId = OldS.Id
left join Status NewS on WF.NewStatusId = NewS.Id
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
WHERE BU.Name in (
   'DEUFOL CUSTOMERS',
    'KRONES GLOBAL'
    ))SRC
pivot (max(SRC.Name) for SRC.Name   in ([DEUFOL CUSTOMERS],[KRONES GLOBAL])) as WF

order by Entity, OldStatus,NewStatus,[Action]