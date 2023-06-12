DECLARE @BIANCO as TINYINT = 1
DECLARE @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Duisburg')
--'825f4bff-17ce-4dad-af48-94c5298a1a96'
--'3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c'
DECLARE @Packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Mülheim')
--'825f4bff-17ce-4dad-af48-94c5298a1a96'
--'3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c'
DECLARE @DimensValuesIDS as UNIQUEIDENTIFIER = 
--'f1066734-bbb4-4ca1-b27f-7b1adf6c5dcc'
--'6834a265-04e6-48d7-aaf9-412b290d0aad'
--'c372175b-466b-4961-8191-32fc0c644592'
--'ea61889f-b3e6-4ab8-b452-864d2539c437'
'e04ba73d-c7c8-48c7-928c-c6f0641b8c15'



select
ENT.Id,
ReceiptGoods.Id,
ReceiptGoods.ReceiptGoods, 
ENT.Code,
ENT.Description as EntDescription,
ENT.InboundDate,
ENT.InboundCode,
ENT.Length*DUOM.BasicUnitCoef as EntLenght,
ENT.Width*DUOM.BasicUnitCoef as EntWidth,
ENT.Height*DUOM.BasicUnitCoef as EntHeight,
Ent.Weight*DUOM.WeightUnitCoef as EntWeight,
CF.[PACKINGTYPE] EntPackingType,
CF.[DUTIABLE_GOODS] EntDutiableGoods,
CF.[DANGEROUS_GOODS_CLASS] EntDangerousGoodsClass,
CF.[DAMAGE_DESCRIPTION] EntDamageDescription,
Dimensions.Project EntProject,
Dimensions.[Order] EntOrder,
Dimensions.Commission EntCommission,
BU.name as ClientBusinessUnitName,
PackerBusinessUnitName = (select name from BusinessUnit where Id = @Packer),
CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.[Customer] else BU.Name end as [Customer],
CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = @Packer) ELSE [BU].[DMSSiteName] END as [DMSSiteName],
CASE WHEN LEN([BU].[ISPM15SiteName]) = 0 then (Select ISPM15SiteName from BusinessUnit where id = @Packer) ELSE [BU].[ISPM15SiteName] END as [ISPM15SiteName],
ReceiptGoods.ReceiptGoodsCode,
ReceiptGoods.[DELIVERYNOTE],
ReceiptGoods.[DELIVERY_DATE],
ReceiptGoods.[DELIVERER],
ReceiptGoods.[PACKINGTYPE],
CAST(ReceiptGoods.[LENGHT]*10 as decimal(10,2))*DUOM.BasicUnitCoef as [LENGHT],
CAST(ReceiptGoods.[WIDTH]*10 as decimal(10,2))*DUOM.BasicUnitCoef as [WIDTH],
CAST(ReceiptGoods.[HEIGHT]*10 as decimal(10,2))*DUOM.BasicUnitCoef as [HEIGHT],
CAST(ReceiptGoods.[WEIGHT] as decimal(10,2))*DUOM.WeightUnitCoef as [WEIGHT],
ReceiptGoods.[DANGEROUS_GOODS_CLASS],
ReceiptGoods.[NUMBER_OF_PACKAGES_OK],
ReceiptGoods.[GOODS_LABELED_AND_SCANNED],
ReceiptGoods.[NUMBER_OF_PACKAGES_OK_TEXT],
ReceiptGoods.[DAMAGE],
ReceiptGoods.[INVOICED],
ReceiptGoods.[DAMAGE_WHAT],
ReceiptGoods.[INVOICING_ DATE],
ReceiptGoods.[DAMAGE_WHY],
ReceiptGoods.[NOTE],
Bin.Description as Bin

FROM (
select
DV.Id,
DV.Content ReceiptGoodsCode,
DV.[Description] ReceiptGoods, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
left join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on DFV.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'ReceiptGoods'
where DV.Id in (@DimensValuesIDS) and
DF.name in ('DELIVERYNOTE','DELIVERY_DATE','DELIVERER','PACKINGTYPE','LENGHT','WEIGHT','WIDTH','DANGEROUS_GOODS_CLASS','HEIGHT','NUMBER_OF_PACKAGES_OK','GOODS_LABELED_AND_SCANNED','NUMBER_OF_PACKAGES_OK_TEXT','DAMAGE','INVOICED','DAMAGE_WHAT','INVOICING_ DATE','DAMAGE_WHY','NOTE'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([DELIVERYNOTE],[DELIVERY_DATE],[DELIVERER],[PACKINGTYPE],[LENGHT],[WEIGHT],[WIDTH],[DANGEROUS_GOODS_CLASS],[HEIGHT],[NUMBER_OF_PACKAGES_OK],[GOODS_LABELED_AND_SCANNED],[NUMBER_OF_PACKAGES_OK_TEXT],[DAMAGE],[INVOICED],[DAMAGE_WHAT],[INVOICING_ DATE],[DAMAGE_WHY],[NOTE])
) as ReceiptGoods


LEFT join ( SELECT HU.[Id],[Code],null BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[InboundCode],[InboundDate] FROM HandlingUnit HU
UNION
SELECT LP.[Id],[Code],LP.BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,Netto,null,null,null,[InboundCode],[InboundDate] FROM LoosePart LP
)
ENT on ReceiptGoods.EntityId = ENT.Id

INNER JOIN BusinessUnitPermission BUP on ReceiptGoods.Id = BUP.DimensionValueId
INNER JOIN BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Id = @Client

LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'en'   and [T].[Column] = 'Name'

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on [ENT].[Id] = [CUSTOMER].[EntityId]
LEFT JOIN (
select 
D.name, 
DV.Content+' '+isnull(DV.[Description],'') as content,
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on ENT.Id = Dimensions.EntityId
LEFT JOIN Bin on ENT.ActualBinId = Bin.Id

LEFT JOIN  (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('PACKINGTYPE','DUTIABLE_GOODS','DANGEROUS_GOODS_CLASS','	DAMAGE_DESCRIPTION') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([PACKINGTYPE],[DUTIABLE_GOODS],[DANGEROUS_GOODS_CLASS],[DAMAGE_DESCRIPTION])
        ) as CF  on ENT.id = CF.EntityID



,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language = ISNULL(U.LastLanguage,'en') and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language = ISNULL(U.LastLanguage,'en') and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language = ISNULL(U.LastLanguage,'en') and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language = ISNULL(U.LastLanguage,'en') and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language = ISNULL(U.LastLanguage,'en') and W.[Column] = 'WeightUnitName'


WHERE  U.Id =  'eba86d7e-e20e-40f0-8e6e-1831fe48e45a'
AND ((case when @BIANCO = 1 /*and Ent.Id IS NULL */then 1 else 0 end) = 1
OR (case when @BIANCO = 0 /*and Ent.Id IS NOT NULL*/ then 1 else 0 end) = 1)
/*
AND ((case when @BIANCO = 0 and Ent.Id IS NULL then 1 else 0 end) = 1
OR
(case when @BIANCO = 1 and Ent.Id IS NOT NULL then 1 else 0 end) = 1)
*/

