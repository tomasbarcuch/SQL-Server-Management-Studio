DECLARE @BIANCO as TINYINT = 1
DECLARE @Client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
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
DECLARE @HandlingUnitIDs as UNIQUEIDENTIFIER = '48e08872-6a31-4c02-b81c-14d45d565cb7'


select
ENT.Id,
HU.Id,
ENT.Code,
ENT.Description as EntDescription,
ENT.InboundDate,
ENT.InboundCode,
ENT.Length*DUOM.BasicUnitCoef as EntLenght,
ENT.Width*DUOM.BasicUnitCoef as EntWidth,
ENT.Height*DUOM.BasicUnitCoef as EntHeight,
Ent.Weight*DUOM.WeightUnitCoef as EntWeight,
CF.[PACKINGTYPE] PackingType,
CF.[DUTIABLE_GOODS] DutiableGoods,
CF.[DANGEROUS_GOODS_CLASS] DangerousGoodsClass,
CF.[DAMAGE_DESCRIPTION] DamageDescription,
Dimensions.Project,
Dimensions.[Order],
Dimensions.Commission,
BU.name as ClientBusinessUnitName,
PackerBusinessUnitName = (select name from BusinessUnit where Id = @Packer),
CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.[Customer] else BU.Name end as [Customer],
CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = @Packer) ELSE [BU].[DMSSiteName] END as [DMSSiteName],
CASE WHEN LEN([BU].[ISPM15SiteName]) = 0 then (Select ISPM15SiteName from BusinessUnit where id = @Packer) ELSE [BU].[ISPM15SiteName] END as [ISPM15SiteName],
HU.Code,
''[DELIVERYNOTE],
HU. InboundDate [DELIVERY_DATE],
''[DELIVERER],
HUT.Description [PACKINGTYPE],
CAST(HU.[Length]*10 as decimal(10,2))*DUOM.BasicUnitCoef as [LENGHT],
CAST(HU.[Width]*10 as decimal(10,2))*DUOM.BasicUnitCoef as [WIDTH],
CAST(HU.[Height]*10 as decimal(10,2))*DUOM.BasicUnitCoef as [HEIGHT],
CAST(HU.[Weight] as decimal(10,2))*DUOM.WeightUnitCoef as [WEIGHT],
CF.[DANGEROUS_GOODS_CLASS],
''[NUMBER_OF_PACKAGES_OK],
''[GOODS_LABELED_AND_SCANNED],
''[NUMBER_OF_PACKAGES_OK_TEXT],
''[DAMAGE],
''[INVOICED],
CF.[DAMAGE_DESCRIPTION],
''[INVOICING_DATE],
''[DAMAGE_WHY],
''[NOTE],
Bin.Description as Bin

FROM HandlingUnit HU
INNER JOIN BusinessUnitPermission BUP on HU.Id = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Id = @Client
LEFT JOIN HandlingUnitType HUT on HU.TypeId = HUT.id
LEFT JOIN Bin on HU.ActualBinId = Bin.Id

LEFT join ( SELECT HU.[Id],[Code],null BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId] ActualHandlingUnitId,[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[InboundCode],[InboundDate] FROM HandlingUnit HU
UNION
SELECT LP.[Id],[Code],LP.BaseUnitOfMeasureId,[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,ActualHandlingUnitId,null,null,null,null,Netto,null,null,null,[InboundCode],[InboundDate] FROM LoosePart LP
)
ENT on HU.Id = Ent.ActualHandlingUnitId

LEFT JOIN  (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('PACKINGTYPE','DUTIABLE_GOODS','DANGEROUS_GOODS_CLASS','DAMAGE_DESCRIPTION') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([PACKINGTYPE],[DUTIABLE_GOODS],[DANGEROUS_GOODS_CLASS],[DAMAGE_DESCRIPTION])
        ) as CF  on HU.id = CF.EntityID

LEFT JOIN (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join DimensionField DF on D.id = DF.DimensionId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'de'

where D.name in ('Customer','Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission],[Customer])
        ) as Dimensions on HU.Id = Dimensions.EntityId

LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'en'   and [T].[Column] = 'Name'

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on [HU].[Id] = [CUSTOMER].[EntityId]


,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language = ISNULL(U.LastLanguage,'en') and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language = ISNULL(U.LastLanguage,'en') and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language = ISNULL(U.LastLanguage,'en') and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language = ISNULL(U.LastLanguage,'en') and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language = ISNULL(U.LastLanguage,'en') and W.[Column] = 'WeightUnitName'


WHERE  
HU.Id = @HandlingUnitIDs AND
U.Id =  'eba86d7e-e20e-40f0-8e6e-1831fe48e45a' 
AND ((case when @BIANCO = 1 /*and Ent.Id IS NULL */then 1 else 0 end) = 1
OR (case when @BIANCO = 0 /*and Ent.Id IS NOT NULL*/ then 1 else 0 end) = 1)
/*
AND ((case when @BIANCO = 0 and Ent.Id IS NULL then 1 else 0 end) = 1
OR
(case when @BIANCO = 1 and Ent.Id IS NOT NULL then 1 else 0 end) = 1)
*/

