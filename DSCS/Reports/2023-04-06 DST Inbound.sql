Declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
Declare @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
Declare @LocationTo as UNIQUEIDENTIFIER = (Select id from [Location] where code = 'Deufol Rosshafen')
Declare @DimensionValueId as UNIQUEIDENTIFIER = (select DV.Id from DimensionValue DV INNER JOIN BusinessUnitPermission BUP on DV.id = BUP.DimensionValueId and BUP.BusinessUnitId = @BusinessUnitID  where Content = 'C005533')

select
DV.[Description] Customer
,Packer.Name as Packer
,Location = (Select NAme from [Location] where Id = @LocationTo)
,ENT.Code
,CAST(ISNULL(ENT.InboundDate, WFE.Created) as Date) InboundDate
,ENT.Surface
,ENT.BaseArea
,ENT.Brutto
,ENT.Netto
, CASE WFE.WorkFlowAction
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
when 23 then 'Unpacking from'
when 24 then 'Assign Value'
else 'X' end as 'action name'


  from WorkflowEntry WFE
 INNER JOIN EntityDimensionValueRelation EDVR on WFE.EntityId = EDVR.EntityId AND EDVR.DimensionValueId = @DimensionValueId
 INNER JOIN DimensionValue DV on EDVR.DimensionValueId = DV.Id
 INNER JOIN Dimension D on DV.DimensionId = D.Id and D.Name = 'Customer'
  INNER JOIN BusinessUnit Client on WFE.ClientBusinessUnitId = Client.id 
  INNER JOIN BusinessUnit Packer on WFE.BusinessUnitId = Packer.id
  
  AND Client.Id = @ClientBusinessUnitId 
  AND WFE.BusinessUnitId = @BusinessUnitID
  AND WFE.WorkflowAction in (1,2,22)
  AND WFE.Entity in (11,15)
  INNER JOIN 
  ( SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[InboundDate],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[TopHandlingUnitId],[Surface],[BaseArea],[ParentHandlingUnitId],[ColliNumber],[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId]  FROM HandlingUnit
UNION
SELECT     [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[InboundDate],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,[Netto],[Weight],null,null  FROM LoosePart)
ENT on WFE.EntityId = ENT.Id



WHERE 
WFE.Created between '2023-03-01' and '2023-03-31' 

