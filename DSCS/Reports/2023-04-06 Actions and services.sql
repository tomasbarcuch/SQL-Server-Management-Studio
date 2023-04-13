Declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
Declare @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
Declare @LocationTo as UNIQUEIDENTIFIER = (Select id from [Location] where code = 'Deufol Rosshafen')
Declare @DimensionValueId as UNIQUEIDENTIFIER = (select DV.Id from DimensionValue DV INNER JOIN BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId and BUP.BusinessUnitId = @BusinessUnitID  where Content = 'C005533')
Declare @NoDates as TINYINT = 0
Declare @FromDate as DATE = '2023-03-01'
Declare @ToDate as DATE = '2023-03-31'
Declare @Language as VARCHAR (2) = 'en'

Select 
*
 FROM (
SELECT
Packer.Name Packer
,Client.Name Client
,CASE WFE.WorkFlowAction
when 0 then 'none'
when 1 then 'Inbound'
when 2 then 'Outbound'
when 3 then 'Transfer'
When 4 then '4'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 8 then 'Packing In'
when 9 then 'Unpacking From'
when 10 then 'Unloading'
when 11 then 'Loading To'
when 12 then 'Unloading from'
when 13 then 'Loaded All'
when 14 then 'Unloaded All'
When 15 then '15'
when 16 then 'Printing'
when 17 then 'Change Status'
When 18 then '18'
When 19 then '19'
When 20 then '20'
when 21 then 'Assigned'
when 22 then 'Packed All'
when 23 then 'Unpacked All'
when 24 then 'Assign Value'
When 25 then '25'
When 26 then '26'
When 27 then '27'
When 28 then '28'
when 29 then 'Add shipment line'
when 30 then 'Delete shipment line'
when 31 then 'First shipment line added'
when 32 then 'Last shipment line deleted'
when 33 then 'Forward shipment'
when 34 then 'Reservation Header create'
when 35 then 'Reservation Header inbound'
when 36 then 'Reservation Header All inbounded'
when 37 then 'Reservation Header outbound'
when 38 then 'Reservation Header closed'
when 39 then 'Packing Order disconected'
when NULL then 'X' end as 'WorkFlowAction'
,CASE WFE.Entity
when 10 then 'DimensionValue'
when 11 then 'HandlingUnit'
when 15 then 'LoosePart'
when 31 then 'ShipmentHeader'
when 35 then 'PackingOrderHeader'
when 37 then 'InventoryHeader'
when 48 then 'ServiceLine'
when 65 then 'BinReservation'
END AS Entity
,ENT.Code
,WFE.EntityId
,CASE WHEN @NoDates = 0 THEN (CONVERT(decimal,convert(datetime, WFE.Created))) 
ELSE 
CASE WHEN @NoDates = 1 THEN  CAST(CAST(WFE.Created as DATE) AS VARCHAR) 
ELSE 
CASE WHEN @NoDates = 2 THEN  CAST(ENT.Surface AS VARCHAR)  
ELSE 
CASE WHEN @NoDates = 3 THEN  CAST(ENT.Weight AS VARCHAR)  
END END END END as Done
--,CASE WFE.Created when NULL THEN 0 ELSE 1 END as Done
FROM WorkflowEntry WFE
INNER JOIN EntityDimensionValueRelation EDVR on WFE.EntityId = EDVR.EntityId
AND EDVR.DimensionValueId = @DimensionValueId 
AND WFE.ClientBusinessUnitId = @ClientBusinessUnitId 
AND WFE.BusinessUnitId = @BusinessUnitID
AND WFE.Entity in (10,11,15,31,35,37,48,65)

INNER JOIN BusinessUnit Client on WFE.ClientBusinessUnitId = Client.id
INNER JOIN BusinessUnit Packer on WFE.BusinessUnitId = Packer.Id
  LEFT JOIN 
  ( SELECT [Id],[Code],[Weight],[Volume],[Surface],[BaseArea],[Netto],[Brutto]  FROM HandlingUnit
UNION
SELECT     [Id],[Code],[Weight],[Volume],[Surface],[BaseArea],[Netto],[Weight] as Brutto  FROM LoosePart
UNION
SELECT     [Id],[Code],[Netto],NULL,NULL,NULL,[Netto],[Brutto]  FROM ShipmentHeader)
ENT on WFE.EntityId = ENT.Id


WHERE WFE.Created between @FromDate AND @ToDate



) SRC
PIVOT (Min(src.Done) for src.WorkFlowAction  in (
--[X],[4],[15],[18],[19],[20],[25],[26],[27],[28]
--,[none]
[Inbound]
,[Outbound]
,[Transfer]
,[Packing]
,[Unpacking]
,[Loading]
,[Packing In]
,[Unpacking From]
,[Unloading]
,[Loading To]
,[Unloading from]
,[Loaded All]
,[Unloaded All]
,[Printing]
--,[Change Status]
--,[Assigned]
,[Packed All]
,[Unpacked All]
--,[Assign Value]
--,[Add shipment line]
--,[Delete shipment line]
--,[First shipment line added]
--,[Last shipment line deleted]
,[Forward shipment]
--,[Reservation Header create]
--,[Reservation Header inbound]
--,[Reservation Header All inbounded]
--,[Reservation Header outbound]
--,[Reservation Header closed]
--,[Packing Order disconected]
)

        ) as WorkflowEntry



left join (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, EDVR.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join Translation T on D.Id = T.EntityId and T.[Language] = @Language
and T.[Column] = 'Name'
where D.name in ('Project','Order','Commission','Customer') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission],[Customer])
        ) as Dimensions on WorkflowEntry.EntityId = Dimensions.EntityId
