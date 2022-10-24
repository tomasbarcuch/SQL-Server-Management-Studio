select
SH.Code Shipment
,HUT.Code Typ
,CUS.TruckNumber
,CUS.[Container No.]
,Project.ProjectNr
,project.Project
,ord.OrderNr
,ord.[Order]
,Commission.CommissionNr
,Commission.Commission
,Ord.DateOfPlannedDeliveryToCustomer
,Project.GRAddressCountry
,CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,sh.LoadingDate),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as LoadingDate
,CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,SH.DeliveryDate),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as DeliveryDate
,SH.FromAddressName
,sh.ToAddressName
,Entities.ColliNumber
,CUS.TypeOfHU
,Entities.Length
,Entities.Width
,Entities.Height
,Entities.Weight
,Entities.Brutto
,Entities.Netto
,Entities.Volume
,Entities.Surface
,Entities.BaseArea
,Entities.[Description]

from ShipmentLine SL
inner join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
left join HandlingUnitType HUT on SH.HandlingUnitTypeId = HUT.Id
inner join BusinessUnitPermission BUP on SH.id = BUP.ShipmentHeaderId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.type = 2 and bu.Name = 'Krones AG VV'

left join (
               ( SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit
UNION
SELECT [Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart)
) Entities on isnull(SL.HandlingUnitId,SL.LoosePartId) = Entities.id
    inner join Status on Entities.StatusId = status.id
      left join Translation on Status.id = Translation.EntityId and Translation.[Language] = 'de'
left join HandlingUnitType ENT on Entities.TypeId = ENT.Id

left join (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('TypeOfHU','Container No.','Seal No.','TruckNumber')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([TypeOfHU],[Container No.],[Seal No.],[TruckNumber])) as CUS on isnull(SL.HandlingUnitId,SL.LoosePartId) = CUS.EntityId



left join (
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
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on isnull(SL.HandlingUnitId,SL.LoosePartId) = Commission.EntityId

left join (
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
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on isnull(SL.HandlingUnitId,SL.LoosePartId) = Ord.EntityId

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
pivot (max(SRC.Content) for SRC.Name   in ([GRAddressPostCode],[GRAddressContactPerson],[GRLanguage],[GRAddressName],[GRAddressPhoneNo],[GRAddressStreet],[GRAddressCity],[GRAddressCountry],[Comments])) as Project on isnull(SL.HandlingUnitId,SL.LoosePartId) = Project.EntityId




where SH.id = 
 '7ec90e34-245f-4925-8fb7-7bacafe0e35d'
--(select id from ShipmentHeader where code = 'NRS858-249748')

select id from BusinessUnit where name = 'Krones AG VV'

