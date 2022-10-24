SELECT
DB_NAME() AS 'Current Database'
,BU.name as ClientBusinessName
, [SH].[Code] AS [ShipmentHeaderCode]
,Dimen.DVContent as ProjectNr
 ,DIMEN.DFVContent as [Markierungsvorschrift / Sondermarkierung]
,isnull(HU.ColliNumber,ColliLPVal.Content) as ColliNumber
,isnull([HU].[Code],[LP].[Code]) as HULPCode
,isnull([LP].[Description],[HU].[Description]) as [Description]
,[SL].[Status] AS [Status]
,isnull([TranStatusHU].Text,TranStatusLP.Text) as StatusName
,[UnitOfMeasure1].[Text] AS [UOMCTranslation]
,[SL].[Quantity] AS [Quantity]
,isnull(HU.Brutto,replace(LpBruttoVal.Content,',','.')) as Brutto
,isnull(HU.Netto, LP.Weight) as HuNetto
,isnull(HU.Length,LP.Length) as Lenght
,isnull(HU.Width,LP.Width) as Width
,isnull(HU.Height,LP.Height) as Height
,isnull(DimVal.Content,DimVal01.Content) as Project
,isnull(DimVal.[Description],DimVal01.[Description]) as ProjectDescription
,isnull(LocationLP.Code,LocationHU.Code) as [Location]
,isnull(ZoneLP.Name,ZoneHU.Name) as [Zone]
,isnull(BinLP.Code,BinHU.Code) as [Bin]
,isnull([HuPositionVal].Content,[LpPositionVal].Content) as [HuLpPosition]
,TruckNVal.Content as TruckN

FROM [ShipmentLine] AS SL 
Left outer join BusinessUnitPermission BUP on SL.id = BUP.ShipmentLineId
left outer join BusinessUnit BU on BUP.BusinessUnitId = BU.ID
 LEFT OUTER JOIN [ShipmentHeader] AS [SH] ON [SH].[Id] = [SL].[ShipmentHeaderId] 
 LEFT OUTER JOIN [HandlingUnit] AS [HU] ON [HU].[Id] = [SL].[HandlingUnitId] 
 LEFT OUTER JOIN [LoosePart] AS [LP] ON [LP].[Id] = [SL].[LoosePartId] 



 LEFT OUTER JOIN [UnitOfMeasure] AS [UnitOfMeasure] ON [UnitOfMeasure].[Id] = [SL].[UnitOfMeasureId] 
 LEFT OUTER JOIN [Translation] AS [UnitOfMeasure1] ON [UnitOfMeasure1].[EntityId] = [SL].[UnitOfMeasureId] and [UnitOfMeasure1].[Entity] = '21' and [UnitOfMeasure1].[Column] = 'Code' and [UnitOfMeasure1].[Language] = 'de' 
 LEFT OUTER JOIN [Status] AS [StatusNameLP] on LP.StatusId=StatusNameLP.Id
 LEFT OUTER JOIN [Translation] AS [TranStatusLP] ON [TranStatusLP].[EntityId] = LP.[StatusId]and [TranStatusLP].[Entity] = '27' and [TranStatusLP].[Column] = 'Name' and [TranStatusLP].[Language] = 'de'
 LEFT OUTER JOIN [Status] AS [StatusNameHU] on HU.StatusId=StatusNameHU.Id
 LEFT OUTER JOIN [Translation] AS [TranStatusHU] ON [TranStatusHU].[EntityId] = HU.[StatusId]and [TranStatusHU].[Entity] = '27' and [TranStatusHU].[Column] = 'Name' and [TranStatusHU].[Language] = 'de'
 
 LEFT OUTER JOIN [CustomField] AS [LpPosition] ON [LpPosition].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [LpPosition].[Name] = 'Position' and [LpPosition].Entity ='15'
 LEFT OUTER JOIN [CustomValue] AS [LpPositionVal] ON [LpPositionVal].[CustomFieldId] = [LpPosition].[Id] AND [LpPositionVal].[EntityId] = [LP].[Id]

 LEFT OUTER JOIN [CustomField] AS [LpBrutto] ON [LpBrutto].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [LpBrutto].[Name] = 'Brutto Kg' and [LpBrutto].Entity ='15'
 LEFT OUTER JOIN [CustomValue] AS [LpBruttoVal] ON [LpBruttoVal].[CustomFieldId] = [LpBrutto].[Id] AND [LpBruttoVal].[EntityId] = [LP].[Id]

 LEFT OUTER JOIN [CustomField] AS [HuPosition] ON [HuPosition].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [HuPosition].[Name] = 'Position' and [HuPosition].Entity ='11'
 LEFT OUTER JOIN [CustomValue] AS [HuPositionVal] ON [HuPositionVal].[CustomFieldId] = [HuPosition].[Id] AND [HuPositionVal].[EntityId] = [HU].[Id]

 LEFT OUTER JOIN [CustomField] AS [TruckN] ON [TruckN].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [TruckN].[Name] = 'Truck Number' and [TruckN].Entity ='31'
 LEFT OUTER JOIN [CustomValue] AS [TruckNVal] ON [TruckNVal].[CustomFieldId] = [TruckN].[Id] AND [TruckNVal].[EntityId] = [SH].[Id]
 
  LEFT OUTER JOIN [CustomField] AS [ColliLP] ON [ColliLP].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [ColliLP].[Name] = 'Colli' and [ColliLP].Entity ='15'
 LEFT OUTER JOIN [CustomValue] AS [ColliLPVal] ON [ColliLPVal].[CustomFieldId] = [ColliLP].[Id] AND [ColliLPVal].[EntityId] = [LP].[Id]
 
 LEFT OUTER JOIN [EntityDimensionValueRelation] Edvr on HU.Id = Edvr.EntityId
 LEFT OUTER JOIN [DimensionValue] as DimVal on Edvr.DimensionValueId = DimVal.Id
 LEFT OUTER JOIN [Dimension] as DM on DM.Id=DimVal.DimensionId and DM.Name='Project'

 LEFT OUTER JOIN [EntityDimensionValueRelation] Edvr01 on LP.Id = Edvr01.EntityId
 LEFT OUTER JOIN [DimensionValue] as DimVal01 on Edvr01.DimensionValueId = DimVal01.Id
 LEFT OUTER JOIN [Dimension] as DM01 on DM01.Id=DimVal01.DimensionId and DM01.Name='Project'

 LEFT OUTER JOIN [Location] AS [LocationLP] ON [LocationLP].[Id] = [LP].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] AS [ZoneLP] ON [ZoneLP].[Id] = [LP].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] AS [BinLP] ON [BinLP].[Id] = [LP].[ActualBinId]

 LEFT OUTER JOIN [Location] AS [LocationHU] ON [LocationHU].[Id] = [HU].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] AS [ZoneHU] ON [ZoneHU].[Id] = [HU].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] AS [BinHU] ON [BinHU].[Id] = [HU].[ActualBinId]

 left outer join (
select
BUP.BusinessUnitId clientbusinessUnitID
,edvr.entityid as entityID
,edvr.entity as Entity
,D.name as DimensionName
,D.description as DimensionDescription 
,DF.name as DFName
,DFV.content as DFVContent
,DV.content as DVContent
,DV.description VDescritpion

 from 
 dbo.EntityDimensionValueRelation EDVR
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Markierungsvorschrift / Sondermarkierung')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
 inner join dbo.Dimension D on DV.DimensionId = D.Id and D.Disabled = 0
 left outer join BusinessUnitPermission BUP on D.id = BUP.DimensionId) as DIMEN on BUP.BusinessUnitId=DIMEN.ClientBusinessUnitId and HU.Id=DIMEN.entityID or LP.Id=DIMEN.entityID
-- WHERE  [SL].[ShipmentHeaderId] = $P{ShHeaderID01} and bup.BusinessUnitId = $P{ClientBusinessUnitID}
where [SL].[ShipmentHeaderId] = 'c66aad47-e42d-42a0-948a-14cf44bbb062' and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'