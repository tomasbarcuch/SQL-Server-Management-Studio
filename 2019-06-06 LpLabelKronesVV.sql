SELECT 
       [LP].[Id] as LPId
      ,isnull(LPI.Identifier,[LP].[Code]) as Code
      ,LP.Code as LPCode
      ,[LP].[Description]
            ,[LP].[TopHandlingUnitId]
      ,[LP].[Length]
      ,[LP].[Width]
      ,[LP].[Weight]
      ,[LP].[LotNo]
      ,[LP].[SerialNo]
      ,[LPCF].MaterialNo as [ColliNumber]
      ,[LP].[ActualLocationId]
      ,[LP].[ActualZoneId]
      ,[LP].[ActualBinId]
      ,[LP].[Height]
      ,T.[Text] as [Status]
      ,[LP].[ShipmentHeaderId]
      ,[LP].[Weight] as Netto
      ,[LP].[Volume]
      ,[LP].[NumberSeriesId]
       ,[LP].[TopHandlingUnitId]
      ,[POL].[PackingOrderHeaderId]
      ,POH.Code
      ,[LP].[Surface]
      ,[LP].[BaseArea]
      --,[LP].[NettoCalc]
      --,[LP].[BruttoCalc]
      --,[LP].[CapacityCheckDisabled]
      ,[Ord].OrderNr
      ,Ord.[Order]
      ,BU.Name as [BuName]
      ,BU.DMSSiteName as [DMSSiteName]
      ,LPCF.DeliveryItem
      ,LPCF.VVID
      ,Commission.CommissionNr
       ,Commission.Commission
      ,Project.ProjectNr
      ,Project.Project
      ,project.GRAddressCountry as Land
  FROM [Loosepart] as LP

 LEFT OUTER JOIN [Status] S ON S.[Id] = [LP].[StatusId] 
 LEFT OUTER JOIN [Translation] T ON T.[EntityId] = [LP].[StatusId] and T.[Language] = 'de'
 LEFT OUTER JOIN [Location] L ON L.[Id] = [LP].[ActualLocationId] 
 LEFT OUTER JOIN [Zone] Z ON Z.[Id] = [LP].[ActualZoneId] 
 LEFT OUTER JOIN [Bin] B ON B.[Id] = [LP].[ActualBinId]
 LEFT OUTER JOIN LoosepartIdentifier LPI on LP.id = LPI.LoosepartId
 LEFT OUTER JOIN PackingOrderLine POL on LP.id = POL.LoosePartId
 LEFT OUTER JOIN PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id
 INNER JOIN BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV')
 INNER join BusinessUnit as BU on BUP.BusinessUnitId = BU.Id and BU.[Type]='2'

left outer join  (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on LP.Id=Commission.entityID


left outer join  (
select
DV.Content 'OrderNr',
DV.[Description] 'Order', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Order'
where 
DF.name in ('Comments','DateOfPlannedDeliveryToCustomer'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on LP.Id=Ord.entityID

left outer join(
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
DF.name in ('GRAddressPostCode','GRAddressContactPerson','GRLanguage','GRAddressName','GRAddressPhoneNo','GRAddressStreet','GRAddressCity','GRAddressCountry','Comments'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on LP.Id=Project.entityID


left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('VVID','ZZPack','MaterialNo','Comments','Delivery','LpBarcode','DeliveryItem','AttachedTo') and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([VVID],[ZZPack],[MaterialNo],[Comments],[Delivery],[LpBarcode],[DeliveryItem],[AttachedTo])
        ) as LPCF on LP.id = LPCF.EntityID

 WHERE LP.id = (Select id from LoosePart where code = '2791435000008000')
order by LP.[Code] asc