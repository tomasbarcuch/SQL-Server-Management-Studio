select 
ord.[Order] as 'Anlagen Nr.'
,Project.ProjectNr
,Commission.CommissionNr
,ORD.OrderNr
,HU.ColliNumber
,Commission.orderPosition
,Project.GRAddressCountry
,HU.code
,HU.[Description]
,HU.Length
,hu.Width
,hu.Height
,HU.Weight
,* 

from HandlingUnit HU



inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId and bup.BusinessUnitId = (Select id from BusinessUnit where name = 'Krones AG VV')

left join  (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Container No.','Seal No.')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Container No.],[Seal No.])) as CUS on HU.id = CUS.EntityId


left join  (
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
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on HU.id = Commission.EntityId

left join   (
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
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on HU.id = Ord.EntityId

left join  (
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
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on HU.id = Project.EntityId

where hu.id = 'a31b33eb-3ae0-4b4e-a50c-e53fde35a63d'