declare @HandlingUnitID as UNIQUEIDENTIFIER = 'f1364bc5-3232-4f3e-96d9-5a695434ed75'
declare @ClientBusinessUnitID as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Hitachi')


SELECT 
 [LpHU].[Entity] as [LP-HU]
 ,(Select sum(isnull([LPL].[Weight],[HUL].[Brutto])) as [HU Netto] from [PackingRule] PR

  LEFT JOIN LoosePart   [LPL] ON  [PR].[LoosePartId] = [LPL].[Id]  
  LEFT JOIN HandlingUnit [HUL] ON [PR].[HandlingUnitId] = [HUL].[Id]
  LEFT JOIN HandlingUnit [HU] ON [PR].[ParentHandlingUnitId] = [HU].[Id]
  where [PR].[ParentHandlingUnitId] = @HandlingUnitID --$P{HandlingUnitId} 
  group BY
  [HU].[Weight]) as [HuNettoSUM]
-- --------
,(Select sum(isnull([LPL].[Weight],[HUL].[Brutto])) + [HU].[Weight] as [HU Netto] from [PackingRule] PR

  LEFT JOIN LoosePart   [LPL] ON  [PR].[LoosePartId] = [LPL].[Id]  
  LEFT JOIN HandlingUnit [HUL] ON [PR].[HandlingUnitId] = [HUL].[Id]
  LEFT JOIN HandlingUnit [HU] ON [PR].[ParentHandlingUnitId] = [HU].[Id]
   where [PR].[ParentHandlingUnitId] =  @HandlingUnitID --$P{HandlingUnitId} 
  group BY
  [HU].[Weight]) as [HuBruttoSUM]
----
,[PRH].[Id] as PrhId
,BusinessUnitId
,[PrhHu].[Code] as PohCode
,[PrhHu].[Code] as [PohHu]
,'' as [Postcode]
,[BU].[Name] as [Kunde]
,[BU].[DMSSiteName]
,isnull([Dimensions].[Order],'Kein Auftrag') as [Auftrag]
,'' as [Konservierung]
,'' as [Vorschrift]
,[HUT].[Code] as [VP-Art]
,[PrhHu].[Description] as [Bemerkung]
,[LpHU].[Code] as [LpHuCode]
,[LpHu].[Description] as [Description]
,[LpHu].[Length] as [Length]
,[LpHu].[Width] as [Width]
,[LpHu].[Height] as [Height]
,[LpHu].[Weight] as [Weight]
,[LpHuBin].[Code] as [Bin]
,[LpHu].[Weight] as [Netto]
,[LpHu].[Weight] as [Brutto]
,[PrhHu].[ColliNumber] as [Colli]
,[PrhHu].[Length] as [HU Lange]
,[PrhHu].[Width] as [HU Breite]
,[PrhHu].[Height] as [HU Hohe]
,[PrhHu].[Weight] as [HU Tara]
,[PrhHu].Surface as [HU Surface]
,[PrhHu].BaseArea as [HU BaseArea]
,proj.*
,cus.*

From [PackingRule] PRH


left join (SELECT 'HU'as [Entity],[Id],Null as [BaseUnitOfMeasureId],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],NULL as [ActualHandlingUnitId], [ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled] FROM HandlingUnit
UNION
SELECT 'LP' as [Entity],[Id],[BaseUnitOfMeasureId],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ActualHandlingUnitId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null FROM LoosePart) as LpHU on LpHu.id = isnull(PRH.LoosePartId,PRH.HandlingUnitId)
left join HandlingUnit as PrhHu on PrhHu.Id=PRH.parentHandlingUnitId
inner JOIN BusinessUnitPermission BUP ON PrhHu.Id = BUP.HandlingUnitId
inner JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.[Type]= 2 and bup.BusinessUnitId = @ClientBusinessUnitID
left JOIN [Location] LOC ON PrhHu.ActualLocationId = LOC.Id
left JOIN Address AD ON LOC.AddressId = AD.Id
Left join HandlingUnitType as HUT on HUT.Id=PrhHu.TypeId
left join (
select D.name, DV.Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in (select name from Dimension group by name)
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as Dimensions on Prh.ParentHandlingUnitId = Dimensions.EntityId

left join  (
select
DV.Content 'ProjectNr',
DV.[Description] 'Project', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in (select name from DimensionField where ClientBusinessUnitId = @ClientBusinessUnitID group by name))SRC
pivot (max(SRC.Content) for SRC.Name   in (
[PackagingDate],
[PackagingType],
[Without welding],
[Protection],
[Material],
[Freigt]
)) as Proj  on Prh.ParentHandlingUnitId = Proj.EntityId

left join (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in (select name from CustomField group by name)) SRC
PIVOT (max(SRC.Content) for SRC.name in (
[WE Kolli],
[inner Lenght],
[inner Width],
[inner Height],
[Lagerbedingung],
[Zollgut]
)) as CUS on Prh.ParentHandlingUnitId = Cus.EntityId



--BIN
LEFT JOIN Bin LpHuBin ON LpHU.ActualBinId = LpHuBin.Id

where [PRH].ParentHandlingUnitId =  @HandlingUnitID --$P{HandlingUnitId} 

/* -- default value expression
(Arrays.asList(
"Macros",
"inner Lenght",
"inner Width"
))
*/