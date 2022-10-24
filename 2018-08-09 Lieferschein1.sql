SELECT
      Sh.[LoadingDate] AS ShLoadingDate
      ,Sts.[Name] As Status
	  ,[FromAddressName]
      ,[FromAddressStreet]
      ,[FromAddressCity]
      ,[FromAddressPostCode]
      ,[FromAddressCountry]
      ,[ToAddressName]
      ,[ToAddressStreet]
      ,[ToAddressCity]
      ,[ToAddressPostCode]
      ,[ToAddressCountry]
	  ,isnull(Lp.Length, hu.Length) As Lange
	  ,isnull(Lp.Width,hu.Width) As Breite
	  ,isnull(Lp.Height,hu.Height) As Hohe 
	  ,isnull(Lp.[Weight],hu.Weight) As Netto
	  ,isnull(Lp.[Description],hu.[Description]) AS Descr
	  ,ISNULL(HU.[Code], 0 )  As HuCode
	  ,ISNULL(HU.Netto, 0 )  AS HuNetto
	  ,ISNULL(HU.Brutto, 0 )  AS HuBrutto
	  ,D.[Name] As DimensionName
	  ,CV.[Content] AS CVContentPosition
	  ,DV.[Content] As DimValContent
	  ,CFTruck.[Name] As CFTruckName
	  ,CVTruck.[Content] AS CCVTruckContent,
isnull(sl.LoosePartId,sl.HandlingUnitId) as EntityID,
case when sl.LoosePartId is not null then 15 else 11 end as Entity
 from ShipmentLine SL

 inner JOIN [dbo].[ShipmentHeader]					AS Sh		ON Sl.[ShipmentHeaderId] = Sh.[Id]
    inner JOIN [dbo].[Status]							AS Sts      ON Sh.StatusId = Sts.Id	
  left JOIN [dbo].[LoosePart]						AS Lp		ON SL.LoosePartId = Lp.Id 
  left JOIN [dbo].[HandlingUnit]						AS HU		ON SL.HandlingUnitId = Lp.Id 

left join EntityDimensionValueRelation EDVR on isnull(sl.LoosePartId,sl.HandlingUnitId) = EDVR.EntityId and EDVR.Entity = case when sl.LoosePartId is not null then 15 else 11 end

left join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id 
left join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.Name = 'Kennwort'
left join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id 
left join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0 and d.name = 'Project'

  left JOIN [dbo].[CustomField]				AS CF		ON isnull(Lp.[ClientBusinessUnitId],hu.ClientBusinessUnitId) = CF.ClientBusinessUnitId AND CF.Entity in (11,15)   AND CF.Name IN ('Position')
  left JOIN [dbo].CustomValue					AS CV		ON CV.CustomFieldId = CF.Id AND CV.EntityId = Lp.Id

  inner JOIN  [dbo].[CustomField]				AS CFTruck  ON Sh.[ClientBusinessunitId] = CFTruck.ClientBusinessUnitId  AND CFTruck.Name IN ('Truck Number')
  inner JOIN  [dbo].CustomValue					AS CVTruck	ON CVTruck.CustomFieldId = CFTruck.Id AND CVTruck.EntityId = Sh.Id


where SL.ShipmentHeaderId = '5214bf84-55c9-4efd-96c5-05d0dc07aeef'
and sh.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'
and sh.PackerBusinessUnitId = 'c1ecee02-67e2-44da-9c67-03b827ba2e4f'