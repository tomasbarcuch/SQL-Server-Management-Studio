SELECT DISTINCT
 DB_NAME() AS [Current Database] 
,LpHu.Entity
,'0.0.0' as 'Gem. Preisliste'
,0.0 as 'Materialbewegung (zweifacher Weg) in €'
,BU.Name as [ClientBusinessName]
,LpHU.Code as LpHU
,WE1.Created as [StatusChangedDate]
,LpHU.Macros as Kistenart
,isnull(LpHU.[InboundDate],cast(inbdate.HUPacked as date)) as [Abrechnung Eingang ZV]
,[CV_MAR].[Content] as [Markierungstyp]
,CV_ANZ.Content as 'Anzahl Markierungen'
,CV_ANZPG.Content as 'Anzahl Seiten'
,Project.[Kennwort]  as [Kennwort]
,Project.[Deufol order]  as [Auftrag Deufol]
,isnull([LpHU].[ColliNumber],CV_Colli.Content)  as [Kolli-Nr.]
,Project.Produktlinie as [P-Linie]
,Project.[ProjectNr] AS [Projekt]
,LpHU.[Length] AS [Lange]
,LpHU.[Width] AS [Breite]
,LpHU.[Height] AS [Hohe]
,CAST(LpHU.Netto as FLOAT) as Netto
,CAST(LPHU.Brutto as FLOAT) as Brutto
,CAST(LPHU.Brutto as Int) as BruttoInt
,LpHU.[Description] as [Bemerkung]
,cast(max(SlStart.Created)  as date) SlStart
,cast(max(SlDone.Created) as date) 'SlFertig'
,CV_ADS.content as 'Art der Spezialsymbole'

FROM [BusinessUnitPermission] BUPslId 

-- adding all Service lines
inner Join BusinessUnit BU on BUPslId.BusinessUnitId=Bu.Id 
inner Join ServiceLine SL on SL.Id=BUPslId.ServiceLineId
--Filtering just SL with S type Nachträgliche Markierung','Nachträgliche Markierung LP. They had to be in Status SlStart or SlDone in the past or they are now in status SlStart or SlDone
inner Join ServiceType ST on SL.ServiceTypeId=ST.Id and St.Code in ('Nachträgliche Markierung','Nachträgliche Markierung LP') 
LEFT JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart')) 
LEFT JOIN WorkflowEntry SlDone ON SL.Id = SlDone.EntityId and SlDone.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlDone')) 

-- Union of LPs and HUs
inner join (SELECT 'HU'as [Entity],[Id],Null as [BaseUnitOfMeasureId],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],NULL as [ActualHandlingUnitId], [ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled],[InboundDate],[Macros] FROM HandlingUnit
UNION
SELECT 'LP' as [Entity],[Id],[BaseUnitOfMeasureId],[Code],[Length],[Width],[Height],0,[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ActualHandlingUnitId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,Netto,Weight,null,null,null,null,null,[InboundDate],'Kollo' FROM LoosePart) as LpHU on LpHU.Id=SL.EntityId

--date of the last Workflow Change
inner join (Select EntityId,max(Created)as Created from WorkflowEntry group by EntityId) WE1 on WE1.EntityId=Sl.EntityId
--Date of first packed item to HU
LEFT JOIN (select HU.Id as HUId,HU.statusid stid,min(WE.Created) as HUPacked from HandlingUnit HU LEFT JOIN dbo.WorkflowEntry WE on HU.Id = WE.EntityId inner join status S on WE.StatusId = S.Id and S.name = 'HuItemInserted' group by HU.Id,HU.StatusId) inbdate on LpHU.Id = inbdate.HUId

--Custom Fields

left join(
      select CFV.EntityId,CFV.Content,CF.Name,CF.Entity from CustomValue as CFV 
      join CustomField as CF on CustomFieldId=Cf.Id and CF.Name='Markierung' --and CF.Entity ='11'or CF.Entity = '15'
      where CF.ClientBusinessUnitId = (select Id from BusinessUnit where BusinessUnit.Name = 'Siemens Berlin')) CV_MAR on CV_MAR.EntityId=SL.Id 

left join(
      select CFV.EntityId,CFV.Content,CF.Name,CF.Entity from CustomValue as CFV 
      join CustomField as CF on CustomFieldId=Cf.Id and CF.Name='Colli' and CF.Entity in ('11','15')
      where CF.ClientBusinessUnitId = (select Id from BusinessUnit where BusinessUnit.Name = 'Siemens Berlin')) CV_Colli on CV_Colli.EntityId=LpHU.Id 
left join(
      select CFV.EntityId,CFV.Content,CF.Name,CF.Entity from CustomValue as CFV 
      join CustomField as CF on CustomFieldId=Cf.Id and CF.Name= 'PagesCount' and CF.Entity='48'
      where CF.ClientBusinessUnitId = (select Id from BusinessUnit where BusinessUnit.Name = 'Siemens Berlin')) CV_ANZPG on CV_ANZPG.EntityId=SL.Id 
left join(
      select CFV.EntityId,CFV.Content,CF.Name,CF.Entity from CustomValue as CFV 
      join CustomField as CF on CustomFieldId=Cf.Id and CF.Name= 'Anzahl markierung' and CF.Entity='48'
      where CF.ClientBusinessUnitId = (select Id from BusinessUnit where BusinessUnit.Name = 'Siemens Berlin')) CV_ANZ on CV_ANZ.EntityId=SL.Id 
      
 left join(
      select CFV.EntityId,CFV.Content,CF.Name,CF.Entity from CustomValue as CFV 
      join CustomField as CF on CustomFieldId=Cf.Id and CF.Name= 'Art der Spezialsymbole' and CF.Entity='48'
      where CF.ClientBusinessUnitId = (select Id from BusinessUnit where BusinessUnit.Name = 'Siemens Berlin')) CV_ADS on CV_ADS.EntityId=SL.Id 

--Dimensions

LEFT JOIN (
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
DF.name in ('Kennwort','Deufol order','Produktlinie'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Deufol order],[Produktlinie])) as Project on LpHU.id = Project.EntityId



WHERE [ServiceLineId] is not null and Bu.Name='Deufol Berlin'

GROUP BY
LpHu.Entity
,BU.Name 
,LpHU.Code
,WE1.Created
,LpHU.[InboundDate]
,[CV_MAR].[Content]
,CV_ANZ.Content
,CV_ANZPG.Content
,CV_ADS.content
,inbdate.HUPacked
,LpHU.Brutto
,Project.Produktlinie
,CV_Colli.Content
,Project.[Deufol order]
,Project.Kennwort
,[LpHU].[ColliNumber]
,Project.ProjectNr
,LpHU.[Length]
,LpHU.[Width]
,LpHU.[Height]
,LpHU.[Weight]
,LpHU.[Description]
,LpHU.[Netto]
,LpHU.Macros

--having cast(max(SlDone.Created)  as date) between $P{FromDate}   and  $P{ToDate}
having cast(max(SlDone.Created)  as date) between '2023-04-01'   and  '2023-05-09'