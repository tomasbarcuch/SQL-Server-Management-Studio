/*select * from (
select
EDVR.EntityId,
D.name,
DV.Content+'-'+DV.[Description] as text
 from EntityDimensionValueRelation EDVR
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
where bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
)SRC pivot (max(SRC.text) for SRC.Name   in ([Project],[Order],[Commission])) as DIM*/
--select * from DimensionValue





SELECT
DB_NAME() AS 'Current Database'
,BU.name as ClientBusinessName
, [SH].[Code] AS [ShipmentHeaderCode]
,DIM.Project as ProjectNr
,'' as [Markierungsvorschrift / Sondermarkierung]
,isnull(HU.ColliNumber,ColliLPVal.Content) as ColliNumber
,isnull([HU].[Code],[LP].[Code]) as HULPCode
,isnull([LP].[Description],[HU].[Description]) as [Description]
,[SL].[Status] AS [Status]
,isnull([TranStatusHU].Text,TranStatusLP.Text) as StatusName
,[UnitOfMeasure1].[Text] AS [UOMCTranslation]
,[SL].[Quantity] AS [Quantity]
,isnull(HU.Brutto,LP.Weight) as Brutto
,HU.Netto as HuNetto
,isnull(HU.Length,LP.Length) as Lenght
,isnull(HU.Width,LP.Width) as Width
,isnull(HU.Height,LP.Height) as Height
,DIM.Project
,DIM.[Order]
,DIM.Commission
,'' as ProjectDescription
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

 LEFT OUTER JOIN [CustomField] AS [HuPosition] ON [HuPosition].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [HuPosition].[Name] = 'Position' and [HuPosition].Entity ='11'
 LEFT OUTER JOIN [CustomValue] AS [HuPositionVal] ON [HuPositionVal].[CustomFieldId] = [HuPosition].[Id] AND [HuPositionVal].[EntityId] = [HU].[Id]

 LEFT OUTER JOIN [CustomField] AS [TruckN] ON [TruckN].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [TruckN].[Name] = 'TruckNumber' and [TruckN].Entity ='31'
 LEFT OUTER JOIN [CustomValue] AS [TruckNVal] ON [TruckNVal].[CustomFieldId] = [TruckN].[Id] AND [TruckNVal].[EntityId] = [SH].[Id]
 
  LEFT OUTER JOIN [CustomField] AS [ColliLP] ON [ColliLP].[ClientBusinessUnitId] = BUP.[BusinessUnitId] AND [ColliLP].[Name] = 'Colli' and [ColliLP].Entity ='15'
 LEFT OUTER JOIN [CustomValue] AS [ColliLPVal] ON [ColliLPVal].[CustomFieldId] = [ColliLP].[Id] AND [ColliLPVal].[EntityId] = [LP].[Id]

 LEFT OUTER JOIN [Location] AS [LocationLP] ON [LocationLP].[Id] = [LP].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] AS [ZoneLP] ON [ZoneLP].[Id] = [LP].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] AS [BinLP] ON [BinLP].[Id] = [LP].[ActualBinId]

 LEFT OUTER JOIN [Location] AS [LocationHU] ON [LocationHU].[Id] = [HU].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] AS [ZoneHU] ON [ZoneHU].[Id] = [HU].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] AS [BinHU] ON [BinHU].[Id] = [HU].[ActualBinId]

left join (
select
EDVR.EntityId,
D.name,
DV.Content+'-'+DV.[Description] as text
 from EntityDimensionValueRelation EDVR
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId
where bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
)SRC pivot (max(SRC.text) for SRC.Name   in ([Project],[Order],[Commission])) as DIM on isnull(SL.HandlingUnitId,SL.LoosePartId) = DIM.EntityId
 
 
 
 WHERE  [SL].[ShipmentHeaderId] = '7cf6c36d-436e-4c87-ade1-8505cf67c15d'--$P{ShHeaderID01} 
 and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
 --WHERE  [SL].[ShipmentHeaderId] = $P{ShHeaderID01} and bup.BusinessUnitId = $P{ClientBusinessUnitID}





