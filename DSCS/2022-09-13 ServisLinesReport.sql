

declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'DEUFOL CUSTOMERS')
declare @BusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Frankenthal')
declare @Language as varchar(2) = 'de'

select
 [CUSTOMER].Customer as Client
 ,ClientBusinessUnitName = (select name from BusinessUnit where id = @ClientBusinessUnitId) --$P{ClientBusinessUnitId})
 ,CASE WHEN BU.name = 'DEUFOL CUSTOMERS' and CUSTOMER.Customer is not null then CUSTOMER.[Customer] else BU.Name end as [BuName]
 ,CASE WHEN LEN([BU].[DMSSiteName]) = 0 then (Select DMSSiteName from BusinessUnit where id = @BusinessUnitID ) ELSE [BU].[DMSSiteName] END as [DMSSiteName]
 ,SL.Id as LineID
 ,CF.PRODUCTION_DATE
,Ent.Id EntityID
,Ent.Code as EntityCode
,B.Code as Bin
,Z.Name as Zone
,L.Name as Location
,ISNULL(SLT.Text, ST.DESCRIPTION) as [ServisLineType]
,SL.[Description]
,ISNULL(T.text,S.Name) as Status
,Dimensions.[Description]
,Dimensions.Project
,Dimensions.[Order]
,Dimensions.Commission

 from ServiceLine SL WITH (NOLOCK)
 inner join BusinessUnitPermission BUP WITH (NOLOCK) on SL.id = BUP.ServiceLineId and BUP.BusinessUnitId = @ClientBusinessUnitId --$P{ClientBusinessUnitId}
 inner join BusinessUnit BU on BUP.BusinessUnitID = BU.id
 inner join ServiceType ST on SL.ServiceTypeid = ST.id and ST.disabled = 0
 left join dbo.[Translation] SLT on ST.ID = SLT.entityId and SLT.LANGUAGE = @Language and SLT.[Column] = 'Description'
 inner join status S on SL.statusid = S.Id
 left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = @Language and T.[Column] = 'Name'

inner join (
    select HU.Id,Code,ActualBinId from HandlingUnit HU
         inner join BusinessUnitPermission BUP on [BUP].[HandlingUnitId] = HU.Id AND [BUP].[BusinessUnitId] = @BusinessUnitID --$P{BusinessUnitID})) 

    union 
    select LP.Id,Code,ActualBinId from LoosePart LP
         inner join BusinessUnitPermission BUP on [BUP].[LoosePartId] = LP.Id AND [BUP].[BusinessUnitId] = @BusinessUnitID --$P{BusinessUnitID})) 
    union 

    select SH.Id,Code,NULL from ShipmentHeader SH
         inner join BusinessUnitPermission BUP on [BUP].[ShipmentHeaderId] = SH.Id AND [BUP].[BusinessUnitId] = @BusinessUnitID --$P{BusinessUnitID})) 

    ) ENT on SL.EntityId = Ent.Id


left join Bin B on ENT.ActualBinId = B.Id
left join Zone Z on B.ZoneId = Z.Id
left join [Location] L on B.LocationId = L.Id

left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField  WITH (NOLOCK)
INNER JOIN CustomValue CV WITH (NOLOCK) ON (CustomField.Id = CV.CustomFieldId) and CustomField.Entity = 48

where name in (select name from CustomField where ClientBusinessUnitId = @ClientBusinessUnitId group by name) and CV.Entity = 48
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([PRODUCTION_DATE])
        ) as CF on SL.id = CF.EntityID

left join (
select D.name, DV.[Description],'['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId

where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on SL.EntityId = Dimensions.EntityId

LEFT JOIN (
SELECT [D].[name], [DV].[Description] as [Content], [EDVR].[EntityId] from [DimensionValue] [DV]
INNER JOIN [Dimension] [D] on [DV].[DimensionId] = [D].[id]
INNER JOIN [EntityDimensionValueRelation] [EDVR] on [DV].[Id] = [EDVR].[DimensionValueId]
LEFT JOIN [Translation] [T] on [D].[Id] = [T].[EntityId] and [T].[Language] = @Language   and [T].[Column] = 'Name'

WHERE [D].[name] in ('CUSTOMER')
) SRC
PIVOT (max([SRC].[Content]) for [SRC].[Name]  in ([Customer])
        )  as [CUSTOMER] on [SL].[Id] = [CUSTOMER].[EntityId]



WHERE EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] =  @ClientBusinessUnitId)) --$P{ClientBusinessUnitId})) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] AS BUP WHERE ([BUP].[ServiceLineId] = SL.Id) AND ([BUP].[BusinessUnitId] = @BusinessUnitID)) --$P{BusinessUnitID}))
--AND SL.Id in ('1d5b1836-638b-43e8-aabf-175d33e70183','cae4bb96-6e4f-497d-869a-4269598ccc11','be588c93-c233-43f4-baa4-797a53b8325a','df600564-9637-48d4-8f04-b59177d9249e')

