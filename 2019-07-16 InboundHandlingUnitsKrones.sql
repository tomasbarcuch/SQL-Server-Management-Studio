select
SH.code as WECode,
SH.[Type],
HU.Code as Kiste,
isnull(InbDate.BuName,BU.name) BUName,
count(distinct HU.code) Anzahl,
sum(HU.weight) Gewicht,
sum(HU.Netto) Netto,
Sum(Hu.brutto) brutto,
min(Inbdate.Created) WEDatum,
Project.ProjectNr,
Ord.[OrderNr],
Commission.CommissionNr


  from HandlingUnit HU
left join ShipmentLine SL on HU.id = SL.HandlingUnitId
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id and SH.[Type]= 1
  left outer join dbo.HandlingUnit HUT on HU.TopHandlingUnitId = HUT.Id
  left outer join dbo.Status SHU on HU.statusid = SHU.id

  
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join dbo.businessunit BU on BUP.BusinessUnitId = BU.id and BU.type = 2



 inner join (select WFE.StatusId,
 BU.Name as BUName,
  WFE.EntityId,
  WFE.created
  from WorkflowEntry WFE
  left join BusinessUnit BU on WFE.BusinessUnitId = BU.id
  where entity = 11
  --and entityid = '9a087c1e-42ce-40ee-85dd-1b2377968a67'
  and StatusId in (
      select S.id from status S
      inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
      inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.name = 'Krones AG VV' --$P{BusinessUnitID}
  where S.Name in ('HuAtStock','HuInbound')
  )   ) InbDate on HU.Id = InbDate.EntityId

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
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on HU.Id=Commission.entityID


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
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on HU.Id=Ord.entityID

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
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on HU.Id=Project.entityID



  where 
InbDate.Created >= '2019-05-01' and --$P{FromDate} and
InbDate.Created < getdate() --$P{ToDate} and
--and hu.id = '9a087c1e-42ce-40ee-85dd-1b2377968a67'

group by 
SH.Code,
SH.[Type],
HU.Code,
isnull(InbDate.BuName,BU.name),
Project.ProjectNr,
Ord.[OrderNr],
Commission.CommissionNr

--select id from BusinessUnit where name = 'Krones AG Migration'

--select Id, Name from [Status] where [Disabled] = 0