select
poh.id,
BUP.BusinessUnitId,
L.Name LocationName,
L.[Description] LocationDescr,
A.Street,
A.PostCode,
A.City,
A.Name AddressName,
POH.Code PackingOrder,
POH.[Description],
POH.InnerHeight,
POHU.Height,
POH.InnerLength,
POHU.Length,
POH.InnerWidth,
POHU.width,
POH.NetWeight,
POHU.Brutto,
POHU.Netto,
POLHU.weight,
POLLP.Weight,
POHU.CODE,
DIMVAL.*,
CFVAL.*,
--POH.HandlingUnitId,
--pol.HandlingUnitId,
--pol.LoosePartId,
pollp.code,
polhu.code
from PackingOrderHeader POH

left join HandlingUnit POHU on POH.HandlingUnitId = POHU.id

left join PackingOrderLine POL on POH.id = POL.PackingOrderHeaderId
left join LoosePart POLLP on POL.LoosePartId = POLLP.Id
left join HandlingUnit POLHU on POL.HandlingUnitId = POLHU.Id
inner join (select DATA.* from 
(select edvr.Entity,EdVR.EntityId, DF.Name dfname, DFV.Content dvfcontent,D.Name dname, DV.Content dvcontent from EntityDimensionValueRelation EDVR
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.Id and d.name = 'Order'
inner join DimensionField DF on D.Id = DF.DimensionId
inner join DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id ) Dimension
pivot (max(dvfcontent) for dfname in ( [Port of destination],[Termin fix],[Order notes],[Responsible person],[Loading date],[Ship],[Contact Person])) 
as DATA ) DIMVAL on poh.Id = DIMVAL.EntityId

inner join BusinessUnitPermission BUP on POH.id = BUP.PackingOrderHeaderId


left join (select P.* from (
SELECT 
Customfield.clientbusinessunitid,
CustomField.Name as CF_Name, 
CustomValue.Entity as CV_Entity, 
CustomValue.EntityId as CV_EntityID,
CustomValue.Content as CV_Content
FROM CustomField 
INNER JOIN CustomValue ON (CustomField.Id = CustomValue.CustomFieldId)
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Seal No.],[Container No.])
        ) as P) CFVAL on POH.Id = CFVAL.CV_EntityID and CFVAL.ClientBusinessUnitId = BUP.BusinessUnitId

inner join [Location] L on POH.LocationId = L.Id
inner join Address A on L.AddressId = A.Id

where 
--BUP.BusinessUnitId = 'f55a5fea-0b37-4a8c-876c-a016e3f43bd4' and
BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Induga') and
 POH.Code = 'PO012-000026'
--POH.Code = 'PO019-000131'
--poh.id = '48f6fe1e-306d-435e-8ab8-526d97161eb4'

 
