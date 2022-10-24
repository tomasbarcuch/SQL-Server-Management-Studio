
select
ent.Code 'ENTCode',
1 as quantity, 
year(wfe.Created) as Year,
month(wfe.Created) as Month,
day(wfe.Created) as Day,
cast(wfe.Created as date) as Date,
BU.name 'BusinessUnit', 
BUC.Name 'Client',
U.[FirstName]+' '+U.LastName as Person,
case wfe.entity
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
else 'X'end as 'entity',
wfe.Created,
CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    wfe.Created), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
       AS CreatedUTF,
       isnull(WFE.WorkflowAction,0),
case WFE.WorkflowAction
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
else cast(WorkflowAction as varchar) end as Action,
isnull(Twfe.Text,s.Name) as 'Status (de)',
S.name as 'Status',
ENT.Code,
ENT.[Description],
DIMENSIONS.Project,
DIMENSIONS.[Order],
DIMENSIONS.Commission,
ENT.BaseArea,
ENT.Surface,
ENT.Volume,
isnull(HUT.text,HT.Code) as CrateTyp,
ENT.Brutto,
ENT.Netto,
ENT.ColliNumber,
case HT.Container
when 0 then 'Crate'
when 1 then 'Container'
else 'Item' end as 'Container',
L.Name as ActualLocation,
c.*


from WorkflowEntry WFE 

left join 
( 
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
        UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart
        UNION
SELECT [Id],[Code],null,null,null,null,null,null,[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ToLocationId],null,null,[Id],null,[NumberSeriesId],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null  FROM ShipmentHeader)
 ENT on WFE.EntityId = ENT.id

left join (
select 
D.name, 
--Case D.name when 'Project' then DV.Content+' '+isnull(DV.[Description],'.') else DV.Content end as Content, 
DV.Content+' '+isnull(DV.[Description],'') as content,
--DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on ENT.Id = Dimensions.EntityId

inner join Calendar C on cast(WFE.Created as date) = C.[Date]
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
inner join BusinessUnitPermission BUP on ENT.ID = isnull(isnull(BUP.HandlingUnitId,BUP.LoosePartId),BUP.ShipmentHeaderId)
left join HandlingUnit HU on ent.id = HU.Id
left join LoosePart LP on ent.id = LP.Id
inner join BusinessUnit BUC on BUP.BusinessUnitId = BUC.Id and BUC.[Type] = 2
inner join [Status] S on WFE.StatusId = S.Id
left join Translation Twfe on S.Id = Twfe.EntityId and Twfe.[Language] = 'de'
inner join [User] U on WFE.CreatedById = U.id
left join [Location] L on ent.ActualLocationId = L.Id
left join HandlingUnitType HT on ent.TypeId = HT.Id
left join Translation HUT on ent.StatusId = HUT.EntityId and HUT.[Language] = 'de'and HUT.[Column] = 'Description'
left join Translation T on ent.StatusId = T.EntityId and t.[Language] = 'de'

where U.IsAdmin = 0 
and year(wfe.Created) = 2021
and month(wfe.Created) = 6
and day(wfe.Created) in (10,11)
--and BUC.Name = 'KRONES GLOBAL'
