select 
Client.Name Client
,Packer.Name Packer
, CASE A.BCSAction
when 1 then 'Inbound'
when 2 then 'Outbound'
when 3 then 'Transfer'
when 4 then 'Movement'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 10 then 'Unloading'
when 11 then 'Direct Loading'
when 13 then 'Release Shipment'
when 15 then 'Inventory'
when 17 then 'New Status'
when 18 then 'Item Info'
when 19 then 'Create Shipment'
when 23 then 'Unpack all'
when 24 then 'Set value'
when 26 then 'Assign CPC'
when 27 then 'Add Picture'
when 28 then 'Change Client'
when 29 then 'Treeview'
when 30 then 'Split Losepart'
when 31 then 'Add Identifier'
when 32 then 'Lock Status'
when 33 then 'Unlock Status'
when 34 then 'Disconnect CPC'
when 35 then 'Packing with Dimensions'
when 36 then 'Remove Dimensions'
when 37 then 'Remove Shipment Line'
when 38 then 'Create Packing Order'
when 39 then 'Assign HU to PO'
when 40 then 'Resend Shipment'
when 41 then 'Close Box'
when 42 then 'ISPM Certification'
when 43 then 'Remove ISPM Certification '
when 44 then 'Dimension Assign'
 END [ACTION]
 /*
 ,CASE BCS.Result
 WHEN 0 then 'none'
 WHEN 1 then 'success'
 WHEN 2 then 'error'
END Result*/
,AVG(BCS.Duration) as Duration
,CAST(DATEPART(YEAR, BCS.[Created]) as VARCHAR)+'-'+FORMAT(DATEPART(MONTH, BCS.[Created]), '00')+'-'+FORMAT(DATEPART(DAY, BCS.[Created]),'00')+' '+FORMAT(DATEPART(HOUR, BCS.[Created]),'00') As Interval
,DATEPART(WEEKDAY, BCS.[Created]) as 'Weekday'
,FORMAT(DATEPART(HOUR, BCS.[Created]),'00') as DailyHour

from BCSLog BCS 

inner join BusinessUnit Packer on BCS.PackerBusinessUnitId = Packer.Id
INNER JOIN BusinessUnit Client on BCS.ClientBusinessUnitId = Client.Id
inner join BCSAction A on BCS.ActionId = A.Id
WHERE BCS.Result in (0,1) AND BCS.Created > '2023-04-18 13:00'

group by 
Client.Name
,Packer.Name
,A.BCSAction
,DATEPART(YEAR, BCS.[Created]),
DATEPART(MONTH, BCS.[Created]),
DATEPART(DAY, BCS.[Created]),
DATEPART(HOUR, BCS.[Created]),
DATEPART(WEEKDAY, BCS.[Created])