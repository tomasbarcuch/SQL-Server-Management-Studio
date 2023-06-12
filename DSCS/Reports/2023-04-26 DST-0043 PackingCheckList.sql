
SELECT 
BU.Name Client
,HU.Code
,HU.[Description]
,HU.Brutto*DUOM.WeightUnitCoef Brutto
,HU.Netto*DUOM.WeightUnitCoef Netto
,HU.Length*DUOM.BasicUnitCoef Length
,HU.Height*DUOM.BasicUnitCoef Height
,HU.Width*DUOM.BasicUnitCoef Width
,HU.Volume*DUOM.VolumeUnitCoef Volume
,HU.BaseArea*DUOM.AreaUnitCoef BaseArea
,ENT.Code
,ENT.Description
,DATA.PACKED
,DATA.[PACKING RULE]
,DATA.[PACKING ORDER]
,D.Customer
,D.Project
,D.[Order]
,D.Commission
,A.Text AreaUnitName
,W.Text WeightUnitName
,B.Text BasicUnitName
,V.Text VolumeUnitName
,DUOM.WeightUnitDec
,DUOM.VolumeUnitDec
,DUOM.LengthUnitDec
,DUOM.AreaUnitDec
,DUOM.BasicUnitDec

 FROM
(SELECT 'PACKING ORDER' as 'T',1'1', POL.LoosePartId EntityId, POH.HandlingUnitId ParentHandlingUnitId FROM PackingOrderLine POL INNER JOIN PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id WHERE POL.LoosePartId IS NOT NULL AND POH.HandlingUnitId IS NOT NULL
UNION
SELECT 'PACKING RULE' as 'T',1'1', PR.LoosePartId EntityId, PR.ParentHandlingUnitId FROM PackingRule PR WHERE PR.LoosePartId IS NOT NULL
UNION
SELECT 'PACKED' as 'T',1'1', WC.LoosePartId EntityId,WC.HandlingUnitId FROM WarehouseContent WC where WC.ParentHandlingUnitId IS NULL AND WC.LoosePartId IS NOT NULL
UNION
SELECT 'PACKING ORDER' as 'T',1'1', POL.HandlingUnitId, POH.HandlingUnitId ParentHandlingUnitId FROM PackingOrderLine POL INNER JOIN PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id WHERE POL.HandlingUnitId IS NOT NULL AND POH.HandlingUnitId IS NOT NULL
UNION
SELECT 'PACKING RULE' as 'T',1'1', PR.HandlingUnitId, PR.ParentHandlingUnitId FROM PackingRule PR WHERE PR.HandlingUnitId IS NOT NULL
UNION
SELECT 'PACKED' as 'T',1'1', WC.HandlingUnitId,WC.ParentHandlingUnitId FROM WarehouseContent WC where WC.ParentHandlingUnitId IS NOT NULL AND WC.HandlingUnitId IS NOT NULL
) SRC
PIVOT (MAX([SRC].[1]) for [SRC].[T]  in ([PACKING ORDER],[PACKING RULE],[PACKED])
        )  as [DATA] 

INNER JOIN HandlingUnit HU ON DATA.ParentHandlingUnitId = HU.Id
INNER JOIN BusinessUnitPermission BUP ON HU.Id = BUP.HandlingUnitId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Type = 2--(Select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')--'Siemens Duisburg')
INNER JOIN 
  ( SELECT [Id],[Code],[Description],[Weight],[Volume],[Surface],[BaseArea],[Netto],[Brutto]  FROM HandlingUnit
UNION
SELECT     [Id],[Code],[Description],[Weight],[Volume],[Surface],[BaseArea],[Netto],[Weight] as Brutto  FROM LoosePart
)
ENT on Data.EntityId = ENT.Id

LEFT JOIN (
SELECT [D].[name], [T].[text]+': '+[DV].[Description]+' ['+DV.Content+']' as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = 'en' /*$P{Language}*/   and [T].[Column] = 'name'

WHERE [D].[name] in (select [name] from [Dimension] group by [name])
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer],[Project],[Order],[Commission])
        )  as [D] on [HU].[Id] = [D].[EntityId]

,[User] U
inner join DisplayUOM DUOM on U.DisplayUOMId = DUOM.Id
inner join Translation A on DUOM.id = A.EntityId and A.Language ='en' /*$P{Language}*/   and A.[Column] = 'AreaUnitName'
inner join Translation B on DUOM.id = B.EntityId and B.Language ='en' /*$P{Language}*/   and B.[Column] = 'BasicUnitName'
inner join Translation L on DUOM.id = L.EntityId and L.Language ='en' /*$P{Language}*/   and L.[Column] = 'LengthUnitName'
inner join Translation V on DUOM.id = V.EntityId and V.Language ='en' /*$P{Language}*/   and V.[Column] = 'VolumeUnitName'
inner join Translation W on DUOM.id = W.EntityId and W.Language ='en' /*$P{Language}*/   and W.[Column] = 'WeightUnitName'

WHERE --DATA.ParentHandlingUnitId IN ('b5fdaedb-676c-4a55-9e91-3bcd8ce16326','bc6c835b-2b3c-4bac-9853-36fa03b4b2ff')--'3e466232-e717-4848-a3ed-e985ab118fc0'
 U.Id =  (Select id from [User] U where login = 'tomas.barcuch')
AND HU.PackingRuleType = 2





/*

and HU.Code in 
--('0000200250423066')
('0000200250423063')

*/








/*
select 
POH.Code POH
,POHU.Code POHU
,POHU.PackingRuleType
,POLLP.Code POLLP
,POLLP.id POLLPID
,POL.Created
,ACTHU.Code ACTHU
,ACTHU.Id ACTHUID
,PRLP.Code PRLP
,PR.Created
  from PackingOrderHeader POH 
inner join HandlingUnit POHU on POH.HandlingUnitId = POHU.id
inner join PackingOrderLine POL on POH.Id = POL.PackingOrderHeaderId
left join LoosePart POLLP on POL.LoosePartId = POLLP.Id
inner join HandlingUnit ACTHU on POLLP.ActualHandlingUnitId = ACTHU.Id
left join PackingRule PR on ACTHU.ID = PR.ParentHandlingUnitId and PR.LoosePartId = POL.LoosePartId
left join LoosePart PRLP on PR.LoosePartId = PRLP.Id and POLLP.id = PRLP.Id
where POH.Id in ('22caf241-ccd1-4dcf-b18c-53364d3c1c72','37649d8d-02ce-4278-99f0-602b1d8024c8')

order by poh.code

*/
