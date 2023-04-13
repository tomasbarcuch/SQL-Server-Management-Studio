select
BU.id as ClientID,
POH.Code as Verpackungsauftrag,
ISNULL(HU.ContainerNumber,'') as 'Container Nr.',
ISNULL(HU.SealNumber,'') as 'Seal No.',
HU.Id as  "Id",
HU.Code as "HU",
AD.Street as "Street",
AD.City as "City",
AD.PostCode as "Postcode",
AD.Country as "Country",
CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.Customer else BU.Name end as [Kunde],
Packer = (Select name from BusinessUnit where id = '3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c'), --$P{BusinessUnitID}),
CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = '3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c' /*$P{BusinessUnitID}*/ ) ELSE [BU].[DMSSiteName] END as [DMSSiteName],
BU.DMSSiteName,
isnull(Dimensions.[Project],'') as "Projekt",
isnull(Dimensions.[Order],'') as "Auftrag",
isnull(Dimensions.[Commission],'') as "Kommission",
ISNULL(HUP.TEXT,HUT.Description) as "VP-Art",
HU."Description" as "Bemerkung",
HU.Surface,
HU.BaseArea, 
LP.Code as isLP,
isnull(HUL.Code,LP.Code) as 'Code',
LPHU.Code as LPCode,
isnull(LP.[Description], HUL.[Description]) as 'Description',
isnull(LP.Length, HUL.Length) as 'Length',
isnull(LP.Width, HUL.Width) as 'Width',
isnull(LP.Height, HUL.Height) as 'Height',
isnull(LP.Weight, HUL.Weight) as 'Weight',
isnull(LPB.Code, HUB.Code) as 'Bin',
isnull(LP.Weight,HUL.Netto) as 'Netto',
isnull(LP.Weight,HUL.Brutto) as 'Brutto',
ISNULL(HU.ColliNumber,'') as 'Colli',
HU.Length as 'HU Lange',
HU.Width as 'HU Breite',
HU.Height as 'HU Hohe',
HU.Netto as 'HU Netto',
HU.Brutto as 'HU Brutto',
HU.Weight as 'Tara',
LPHU.Length Lengthlp,
LPHU.Width Widthlp,
LPHU.Height Heightlp,
LPHU.Surface Surfacelp,
LPHU.BaseArea BaseArealp,
LPHU.Weight Weightlp,
LPHU.[Description] Descriptionlp,
HUL.ColliNumber as 'LPHUColli'

from HandlingUnit HU
LEFT JOIN [Location] LOC ON HU.ActualLocationId = LOC.Id
LEFT JOIN Address AD ON LOC.AddressId = AD.Id

--HU type
INNER JOIN HandlingUnitType HUT ON HU.TypeId = HUT.Id and HUT.Container = 1
LEFT JOIN Translation HUP on HUT.id = HUP.EntityId and language = 'de' and HUP.[Column] = 'Description'

-- BU Name
INNER JOIN BusinessUnitPermission BUP ON HU.Id = BUP.HandlingUnitId 
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Id = '3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c' --$P{ClientBusinessUnitId} 

--dimenze
left join (
select D.name, T.text+': '+DV.[Description]+' ['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join Translation T on D.Id = T.EntityId and T.[Language] = 'de' --$P{Language} 
and T.[Column] = 'Name'
where D.name in ('Project','Order','Commission','Customer') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission],[Customer])
        ) as Dimensions on HU.id = Dimensions.EntityId

  LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Column] = 'name' and [T].[Language] = 'de'--$P{Language}

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on HU.Id = [CUSTOMER].[EntityId]   


LEFT JOIN PackingRule PRL ON HU.Id = PRL.ParentHandlingUnitId
LEFT JOIN  LoosePart   LP ON  PRL.LoosePartId = LP.Id  
LEFT JOIN  HandlingUnit HUL ON PRL.HandlingUnitId = HUL.Id
LEFT JOIN LoosePart LPHU on HUL.id = LPHU.ActualHandlingUnitId

LEFT JOIN Bin LPB ON LP.ActualBinId = LPB.Id 
LEFT JOIN Bin HUB on HUL.ActualBinId = HUB.Id 

LEFT JOIN PackingOrderHeader POH on POH.HandlingUnitId = HU.Id

where
LOC.Id is not null
and HU.Id IN  ('0d77a9a6-7010-462b-922a-22cb912c0e71','7e4a313a-c22e-4875-ba4d-9f552530480c')
--and $X{IN, HU.id, HandlingUnitIDs} -- BU=='3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c'