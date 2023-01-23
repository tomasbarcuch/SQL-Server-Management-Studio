Declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Duisburg')
Declare @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Mülheim')
DECLARE @PackingOrderHeaderIDs as UNIQUEIDENTIFIER = '26c6b4d6-1dba-43c5-8e02-e0a7709e8c92'--'4210fa3a-0f5f-42c3-8504-f53bd6e07c73'
declare @LoggedUserId as UNIQUEIDENTIFIER = (select id from [User] u where U.Login = 'tomas.barcuch')
DECLARE @Language as VARCHAR(2) = 'de'

select
 CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.Customer else BU.Name end as [Customer]
 ,Packer = (Select name from BusinessUnit where id = @ClientBusinessUnitId)
,CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = @BusinessUnitID ) ELSE [BU].[DMSSiteName] END as [DMSSiteName]

      ,POH.Id POHId
      ,POH.Code POHCode
      ,POH.[Description] POHDescription
      ,POH.Note POHNote 
      ,POH.InnerLength*DUOM.BasicUnitCoef  POHInnerLength
      ,POH.InnerWidth*DUOM.BasicUnitCoef POHInnerWidth
      ,POH.InnerHeight*DUOM.BasicUnitCoef POHInnerHeight
      ,POH.NetWeight*DUOM.WeightUnitCoef POHNetWeight
      ,POHLoc.Name as POHLocation
      ,POH.Protection POHProtection
      ,POH.ColliNumber POHColliNumber
      ,POH.CountLines 
      ,POH.DeliveryDate POHInboundDate
      ,POH.PackingDate POHPackingDate
      ,M.[Description] POHMacro
      ,ISNULL(POHStatus.Text,POHS.Name) as POHStatus
      ,ISNULL(POHHUType.Text, POHHUT.[Description]) as POHHUType
      ,ProjectFields.PACKINGTYPE
      ,ProjectFields.COUNTRY
      ,Dimensions.Project
      ,Dimensions.[Order]
      ,Dimensions.Commission
      
      
      ,HU.Id as HUId
      ,HU.Code as HUCode
      ,HU.[Description] HUDescription
      ,HU.Length*DUOM.BasicUnitCoef HULength
      ,HU.Width*DUOM.BasicUnitCoef HUWidth
      ,HU.Height*DUOM.BasicUnitCoef HUHeight
      ,HU.Weight*DUOM.WeightUnitCoef HUWeight
      ,HULoc.Name as HULocation
      ,HU.Protection as HUProtection
      ,HU.ColliNumber HUColliNumber
      ,HU.InboundDate
      ,HU.BoxClosedDate
      ,HU.Macros as HUMacro
      ,ISNULL(HUStatus.Text,HUS.Name) as HUStatus
      ,ISNULL(HUType.Text, HUT.[Description]) as HUType
      ,HUCUS.DANGEROUS_GOODS_CLASS
      ,HUCUS.DUTIABLE_GOODS

      ,ENT.Id
      ,ENT.Code
      ,ENT.[Description]
      ,ENT.Length*DUOM.BasicUnitCoef ENTLength
      ,ENT.Width*DUOM.BasicUnitCoef ENTWidth
      ,ENT.Height*DUOM.BasicUnitCoef ENTHeight
      ,ENT.Weight*DUOM.WeightUnitCoef ENTWeight
      ,ENT.Netto*DUOM.WeightUnitCoef ENTNetto
      ,ENT.Brutto*DUOM.WeightUnitCoef ENTBrutto
      ,ENTLoc.Name as ENTLocation
      ,ReceiptGoodsFields.ReceiptGoodsNr
      ,ReceiptGoodsFields.ReceiptGoods
      ,cast(ReceiptGoodsFields.LENGHT as numeric(10,2))
      ,ReceiptGoodsFields.WIDTH
      ,ReceiptGoodsFields.HEIGHT
      ,ReceiptGoodsFields.GROSSW
      ,ReceiptGoodsFields.DAMAGE
      ,ReceiptGoodsFields.DANGEROUS_GOODS
      ,ReceiptGoodsFields.Dimension
      --,ISNULL(ENTStatus.Text,ENTS.Name) as ENTStatus

      ,A.Text AreaUnitName
      ,W.Text WeightUnitName
      ,B.Text BasicUnitName
      ,V.Text VolumeUnitName
      ,DUOM.WeightUnitDec
      ,DUOM.VolumeUnitDec
      ,DUOM.LengthUnitDec
      ,DUOM.AreaUnitDec
      ,DUOM.BasicUnitDec

FROM [PackingOrderHeader] [POH] WITH (NOLOCK)
INNER JOIN BusinessUnitPermission BUP on POH.id = BUP.PackingOrderHeaderId and BUP.BusinessUnitId = @ClientBusinessUnitId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.id
LEFT JOIN PackingOrderLine POL on POH.id = POL.PackingOrderHeaderId
LEFT JOIN (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'cs'

where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions ON POH.Id = Dimensions.EntityId

  LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Column] = 'name' and [T].[Language] = @Language

WHERE [D].[name] in ('Customer')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on POH.Id = [CUSTOMER].[EntityId]   

LEFT JOIN HandlingUnit HU on POH.HandlingUnitId = HU.Id


LEFT join ( SELECT HU.[Id],[Code],null BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[InboundCode],[InboundDate],[BoxClosedDate] FROM HandlingUnit HU
UNION
SELECT LP.[Id],[Code],LP.BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,Netto,0,null,null,[InboundCode],[InboundDate],NULL FROM LoosePart LP
)
ENT on ISNULL(POL.LoosePartId,POL.HandlingUnitId) = ENT.id

LEFT JOIN Location POHLoc on POH.LocationId = POHLoc.Id
INNER JOIN [Status] POHS on POH.StatusId = POHS.Id
LEFT JOIN Translation POHStatus on POHS.id = POHStatus.EntityId and POHStatus.[Column] = 'Name' and POHStatus.[Language] = @Language
LEFT JOIN BXNLMacro M on POH.BXNLMacroId = M.Id
LEFT JOIN HandlingUnitType POHHUT on POH.HandlingUnitTypeId = POHHUT.Id
LEFT JOIN Translation POHHUType on POHHUT.id = POHHUType.EntityId and POHHUType.[Column] = 'Description' and POHHUType.[Language] = @Language

LEFT JOIN Bin HUBin on HU.ActualBinId = HUBin.Id
LEFT JOIN Location HULoc on HU.ActualLocationId = HULoc.Id
LEFT JOIN [Status] HUS on HU.StatusId = HUS.Id
LEFT JOIN Translation HUStatus on HUS.id = HUStatus.EntityId and HUStatus.[Column] = 'Name' and HUStatus.[Language] = @Language
LEFT JOIN HandlingUnitType HUT on HU.TypeId = HUT.id
LEFT JOIN Translation HUType on HUT.id = HUType.EntityId and HUType.[Column] = 'Description' and HUType.[Language] = @Language


LEFT JOIN Location ENTLoc on ENT.ActualLocationId = ENTLoc.Id
--INNER JOIN [Status] ENTS on ENT.StatusId = ENTS.Id
--LEFT JOIN Translation ENTStatus on ENTS.id = ENTStatus.EntityId and ENTStatus.[Column] = 'Name' and ENTStatus.[Language] = @Language

left join  (
select
[DV].[Content] [ProjectNr],
[DV].[Description] [Project], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF] WITH (NOLOCK)
inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] [EDVR] on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'Project'
where 
[DF].[Name] in ('DELIVERY_DATE','NOTE','RESPONSIBLE','MARKING','PACKINGTYPE','COUNTRY')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([DELIVERY_DATE],[NOTE],[RESPONSIBLE],[MARKING],[PACKINGTYPE],[COUNTRY])) as [ProjectFields] on [POH].[Id] = [ProjectFields].[EntityId]

left join  (
select
[DV].[Content] [ReceiptGoodsNr],
[DV].[Description] [ReceiptGoods], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
from [DimensionField] [DF] WITH (NOLOCK)
inner join [DimensionFieldValue] [DFV] WITH (NOLOCK) on [DF].[Id] = [DFV].[DimensionFieldId]
inner join [EntityDimensionValueRelation] [EDVR] on [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
inner join [DimensionValue] [DV] on [EDVR].[DimensionValueId] = [DV].[Id]
inner join [Dimension] [D] on [DF].DimensionId = [D].[Id] and [D].[Name] = 'ReceiptGoods'
where 
[DF].[Name] in ('LENGHT','WIDTH','HEIGHT','GROSSW','HUTYPE','DANGEROUS_GOODS','DAMAGE')) [SRC]
pivot (max([SRC].[Content]) for [SRC].[Name]   in ([LENGHT],[WIDTH],[HEIGHT],[GROSSW],[HUTYPE],[DANGEROUS_GOODS],[DAMAGE])) as [ReceiptGoodsFields] on [ENT].[Id] = [ReceiptGoodsFields].[EntityId]

LEFT JOIN (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('DANGEROUS_GOODS_CLASS','DUTIABLE_GOODS')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([DANGEROUS_GOODS_CLASS],[DUTIABLE_GOODS])) as HUCUS on HU.Id = HUCUS.EntityId

,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language = @Language   and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language = @Language   and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language = @Language   and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language = @Language  and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language = @Language   and W.[Column] = 'WeightUnitName'


WHERE U.Id =  @LoggedUserId 

AND POH.Id in (@PackingOrderHeaderIDs) --$X{IN,PO.Id,PackingOrderHeaderIDs} 






