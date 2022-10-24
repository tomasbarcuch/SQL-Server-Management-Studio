SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
select
Packer.name,
Client.name,
case when (HUT.code = 'KI' or TypeOfHU = 'Kiste') then 'Kiste' else NULL end,
len(HUCF.DeliveryType),
left(HUCF.DeliveryType,4),
HU.Surface,
HU.Brutto,
COALESCE(
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) < 2 and HU.Surface > 12.0 and HU.Brutto <= 5000.0  then '1.1.1.1.1.307.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) < 2 and HU.Surface < 12.0 and HU.Brutto between 0.0 and 5000.0  then '1.1.1.1.1.320.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) < 2 and HU.Surface > 12.0 and HU.Brutto between 5001.0 and 10000.0  then '1.1.1.1.1.309.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) > 2 and HU.Surface > 12.0 and HU.Brutto between 5001.0 and 10000.0  then '1.1.1.1.1.3091.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) < 2 and HU.Surface > 12.0 and HU.Brutto between 10001.0 and 20000.0  then '1.1.1.1.1.311.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) < 2 and HU.Surface > 12.0 and HU.Brutto between 20001.0 and 300000.0  then '1.1.1.1.1.313.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) < 2 and HU.Surface > 12.0 and HU.Brutto between 30001.0 and 40000.0  then '1.1.1.1.1.315.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and len(HUCF.DeliveryType) > 3 and HU.Surface <= 12.0 and HU.Brutto < 1500.0  then '1.1.1.1.1.319.' else NULL end,
case when (HUT.code = 'KI' or TypeOfHU like '%Kiste%') and HUCF.DeliveryType in (',LKW', 'LKW','') and HU.Surface <= 12.0 and HU.Brutto < 1500.0 then '1.1.1.1.1.320.' else NULL end )
as InvoicingPriceList,


HUCF.*,
HU.Code,
Project.ProjectNr as 'Project',
Ord.OrderNr as 'Order',
Commission.CommissionNr as 'Commission',
Hu.ColliNumber,
HU.Brutto,
HU.Length,
HU.Width,
HU.Height,
HU.Weight,
HU.Surface,
HUCF.TypeOfHU as 'Typ',
HUT.Code as 'HUTyp',
WFS.Name,
WFE.Created,
Project.GRAddressCountry as 'Zielland'
--,[Location].Name

from WorkflowEntry WFE



INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id
INNER JOIN HandlingUnit HU ON WFE.EntityId = HU.Id
LEFT join HandlingUnitType HUT on HU.TypeId = HUT.Id
INNER JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.HandlingUnitId and BUP.BusinessUnitId =  (select Id from BusinessUnit where name = 'Krones AG VV')




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

left join  (
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
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on HU.id = Ord.EntityID

left join (
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
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on HU.id = Project.EntityID

left join (
SELECT
CustomField.Name as CF_Name, 

CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in ('VVID','TypeOfHU','Foil','DeliveryType','USSealNo') and CV.Entity = 11
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([VVID],[TypeOfHU],[Foil],[DeliveryType],[USSealNo])
        ) as HUCF on HU.id = HUCF.EntityID

inner join BusinessUnit Client on BUP.BusinessUnitId = Client.Id and Client.[Type] = 2
inner join BusinessUnit Packer on WFE.BusinessUnitId = Packer.Id

--INNER JOIN (select WarehouseEntry.id,WarehouseEntry.LocationId,WarehouseEntry.Created from WarehouseEntry) WHE ON WHE.Id = (select TOP 1 CWE.Id from WarehouseEntry CWE where CWE.LocationId is not null and CWE.HandlingUnitId=HU.Id and CWE.Created <= WFE.Created ORDER BY WHE.Created DESC)
--INNER JOIN [Location] ON WHE.LocationId = [Location].Id

WHERE

WFE.StatusId = 
(select StatusId from BusinessUnitPermission BUP
where BUP.BusinessUnitId in (select Id from BusinessUnit where name = 'Krones AG VV')
and BUP.StatusId in (select id from status where name = 'HuBox closed')
and wfe.Created between '2019-08-20' and '2019-08-31')
and (HUT.code = 'KI' or TypeOfHU like '%Kiste%')
and hu.Surface > 0