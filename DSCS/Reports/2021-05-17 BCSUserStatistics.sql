select * from(
select
ClientBusinessUnit = 'KRONES GLOBAL', 
BusinessUnit = 'Deufol Neutraubling',
ISNULL(T.Text,A.[Description]) as ActionDescription,
case A.BCSaction
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
when '35' then 'Packing with Dimension'
when '36' then 'Remove dimensions'
when '37' then 'Remove shipment line'
else cast(A.BCSaction as varchar) end as Action,
A.BCSaction,count(BCSLog.id) Scans, 
case result 
when 0 then 'Success'
when 1 then 'Success'
when 2 then 'Error'
end as result, 
C.[Date], C.Week, C.DayOfWeek from BCSLog
inner join BCSAction A on BCSLog.ActionId = A.Id and A.BCSaction = 1
left join Calendar C on cast(BCSLog.Created as date) = C.[Date]
left join Translation T on A.Id = T.EntityId and T.[Column] = 'Description' and T.[Language] = 'de'


Where BCSLog.ClientBusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL') 
--and BCSLog.PackerBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Neutraubling')
group by ISNULL(T.Text,A.[Description]),A.BCSaction,BCSLog.Result, C.[Date], C.Week, C.DayOfWeek
) SRC
PIVOT (sum(src.scans) for src.result  in ([Success],[Error])
        ) as BCSLog
        where BCSLog.[Date] BETWEEN '2021-09-01' AND '2021-11-30'


