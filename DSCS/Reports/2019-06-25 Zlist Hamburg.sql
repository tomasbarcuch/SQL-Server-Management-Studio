SELECT

case SH.[Type]
when 0 then 'Loading'
when 1 then 'Unloading'
end as SHType
,DB_NAME() AS 'Current Database'
,BU.name as ClientBusinessName
, [SH].[Code] AS [ShipmentHeaderCode]
,Commission.CommissionNr
,Commission.Commission
,Commission.OrderPosition
,Ord.OrderNr
,HU.ColliNumber as ColliNumber
,isnull([HU].[Code],[LP].[Code]) as HULPCode
,isnull([LP].[Description],[HU].[Description]) as [Description]
,HuTypeVal.Content as ContTyp
,[SL].[Status] AS [Status]
,isnull([TranStatusHU].Text,TranStatusLP.Text) as StatusName
,[UnitOfMeasure1].[Text] AS [UOMCTranslation]
,[SL].[Quantity] AS [Quantity]
,isnull(HU.Brutto,LP.Weight) as Brutto
,HU.Netto as HuNetto
,isnull(HU.Length,LP.Length) as Lenght
,isnull(HU.Width,LP.Width) as Width
,isnull(HU.Height,LP.Height) as Height
,Project.ProjectNr as Project
,Project.Project as ProjectDescription
,isnull(LocationLP.Code,LocationHU.Code) as [Location]
,isnull(ZoneLP.Name,ZoneHU.Name) as [Zone]
,isnull(BinLP.Code,BinHU.Code) as [Bin]
,isnull([HuPositionVal].Content,[LpPositionVal].Content) as [HuLpPosition]
,TruckNVal.Content as TruckN
,HUinHU.code Kcode
,HUinHU.[Description] KDescr
,HUinHU.Length KLength
,HUinHU.Width KWidth
,HUinHU.Height KHeight
,HUinHU.Weight KWeight
,HUinHu.Brutto KBrutto
,HUinHU.Netto KNetto
,HUinHU.ColliNumber KColli



FROM [ShipmentLine] AS SL 
Left outer join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
left outer join BusinessUnit BU on BUP.BusinessUnitId = BU.ID
 LEFT OUTER JOIN [ShipmentHeader] AS [SH] ON [SH].[Id] = [SL].[ShipmentHeaderId] 
 LEFT OUTER JOIN [HandlingUnit] AS [HU] ON [HU].[Id] = [SL].[HandlingUnitId]
 Left outer join  HandlingUnit As HUinHU on HU.id = HUinHU.TopHandlingUnitId
 LEFT OUTER join HandlingUnitType HUT on HU.TypeId = HUT.id
 LEFT OUTER JOIN [LoosePart] AS [LP] ON [LP].[Id] = [SL].[LoosePartId] 
 LEFT OUTER JOIN [UnitOfMeasure] AS [UnitOfMeasure] ON [UnitOfMeasure].[Id] = [SL].[UnitOfMeasureId] 
 LEFT OUTER JOIN [Translation] AS [UnitOfMeasure1] ON [UnitOfMeasure1].[EntityId] = [SL].[UnitOfMeasureId] and [UnitOfMeasure1].[Entity] = '21' and [UnitOfMeasure1].[Column] = 'Code' and [UnitOfMeasure1].[Language] = 'de' 
 LEFT OUTER JOIN [Status] AS [StatusNameLP] on LP.StatusId=StatusNameLP.Id
 LEFT OUTER JOIN [Translation] AS [TranStatusLP] ON [TranStatusLP].[EntityId] = LP.[StatusId]and [TranStatusLP].[Entity] = '27' and [TranStatusLP].[Column] = 'Name' and [TranStatusLP].[Language] = 'de'
 LEFT OUTER JOIN [Status] AS [StatusNameHU] on HU.StatusId=StatusNameHU.Id
 LEFT OUTER JOIN [Translation] AS [TranStatusHU] ON [TranStatusHU].[EntityId] = HU.[StatusId]and [TranStatusHU].[Entity] = '27' and [TranStatusHU].[Column] = 'Name' and [TranStatusHU].[Language] = 'de'
  LEFT OUTER JOIN [Status] AS [StatusNameHUinHU] on HUinHU.StatusId=StatusNameHUinHU.Id
 LEFT OUTER JOIN [Translation] AS [TranStatusHUinHU] ON [TranStatusHUinHU].[EntityId] = HU.[StatusId]and [TranStatusHUinHU].[Entity] = '27' and [TranStatusHUinHU].[Column] = 'Name' and [TranStatusHUinHU].[Language] = 'de'
 
 LEFT OUTER JOIN [CustomField] AS [LpPosition] ON [LpPosition].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [LpPosition].[Name] = 'Position' and [LpPosition].Entity ='15'
 LEFT OUTER JOIN [CustomValue] AS [LpPositionVal] ON [LpPositionVal].[CustomFieldId] = [LpPosition].[Id] AND [LpPositionVal].[EntityId] = [LP].[Id]

 LEFT OUTER JOIN [CustomField] AS [HuPosition] ON [HuPosition].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [HuPosition].[Name] = 'Position' and [HuPosition].Entity ='11'
 LEFT OUTER JOIN [CustomValue] AS [HuPositionVal] ON [HuPositionVal].[CustomFieldId] = [HuPosition].[Id] AND [HuPositionVal].[EntityId] = [HU].[Id]

 LEFT OUTER JOIN [CustomField] AS [HuType] ON [HuType].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [HuType].[Name] = 'TypeOfHU' and [HuType].Entity ='11'
 LEFT OUTER JOIN [CustomValue] AS [HuTypeVal] ON [HuTypeVal].[CustomFieldId] = [HuType].[Id] AND [HuTypeVal].[EntityId] = [HU].[Id]


 LEFT OUTER JOIN [CustomField] AS [TruckN] ON [TruckN].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [TruckN].[Name] = 'TruckNumber' and [TruckN].Entity ='31'
 LEFT OUTER JOIN [CustomValue] AS [TruckNVal] ON [TruckNVal].[CustomFieldId] = [TruckN].[Id] AND [TruckNVal].[EntityId] = [SH].[Id]


 LEFT OUTER JOIN [Location] AS [LocationLP] ON [LocationLP].[Id] = [LP].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] AS [ZoneLP] ON [ZoneLP].[Id] = [LP].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] AS [BinLP] ON [BinLP].[Id] = [LP].[ActualBinId]

 LEFT OUTER JOIN [Location] AS [LocationHU] ON [LocationHU].[Id] = [HU].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] AS [ZoneHU] ON [ZoneHU].[Id] = [HU].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] AS [BinHU] ON [BinHU].[Id] = [HU].[ActualBinId]


left outer join (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('GRAddressPostCode','GRAddressContactPerson','GRLanguage','GRAddressName','GRAddressPhoneNo','GRAddressStreet','GRAddressCity','GRAddressCountry','Comments'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on HU.Id=Project.entityID or LP.Id=Project.entityID


 left outer join  (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on HU.Id=Commission.entityID or LP.Id=commission.entityID

left join (
select
DV.Content 'OrderNr',
DV.[Description] 'Order', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Order'
where 
DF.name in ('Comments','DateOfPlannedDeliveryToCustomer'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on HU.id = Ord.entityID or LP.id = Ord.EntityId


 WHERE  [SL].[ShipmentHeaderId] in (select id from ShipmentHeader where /*type = 0 and */code =
 (select code from Shipmentheader where id = '358eba78-7cb0-49c6-ba13-6296e8edcb03' group by code )) and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
 --(select code from Shipmentheader where id = $P{ShHeaderID01} group by code )) and bup.BusinessUnitId = $P{ClientBusinessUnitID}