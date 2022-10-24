
select 
SH.Code,
SH.LoadingDate,
SH.FromAddressName,
SH.ToAddressName,
Commission.CommissionNr,
Commission.Commission,
Ord.OrderNr,
Ord.[Order],
SHCF.TruckNumber,
SHCF.VVID
from shipmentheader SH
inner join BusinessUnitPermission BUP on SH.Id = BUP.ShipmentHeaderId and BUP.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG VV')

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
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on SH.Id=Commission.entityID


left outer join  (
select
DV.Content 'Order',
DV.[Description] OrderNr, 
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
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on SH.Id=Ord.entityID



left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('VVID','Gross','Spedition','Comments','TruckNumber') and CV.Entity = 31
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([VVID],[Gross],[Spedition],[Comments],[TruckNumber])
        ) as SHCF on SH.id = SHCF.EntityID

       where SH.ID = (select id from shipmentheader where Code = 'ST4182M-256073')
        




   