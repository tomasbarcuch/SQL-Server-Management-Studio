declare @client as UNIQUEIDENTIFIER
declare @packer as UNIQUEIDENTIFIER

--set @client = '581b954a-c3c0-4fd6-8da4-39153177ad95'
set @packer = 'd03232f5-385a-45d0-af59-f08d37566695'
--set @packer = NULL
--set @client = NULL

Select  
 NEWID() Id,
 BUpa.Name BusinessUnitName,
 BU.name ClientUnitName,
 OnWarehouse.LocationId, 
 OnWarehouse.[Location] LocationName, 
 Sum(Onwarehouse.basearea) UsedArea, 
LocCapacity as Capacity,
 cast(case when max(OnWarehouse.LocCapacity) > 0 then  Sum(Onwarehouse.basearea)/max(OnWarehouse.LocCapacity)*100 else 100 end as decimal(20,1)) Utilisation, 
 calendar.date Date from  
 (select 
 Data.LocationId,
 L.Name as Location, 
 Lcap.LocCapacity, 
 sum(data.BaseArea) as BaseArea, 
 Data.Inbounddate, 
 isnull(data.OutboundDate,getdate()-1) as Outbounddate 
 from ( 
 select 
 WE.LocationId,
  coalesce(coalesce(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID, 
 sum(isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea)) as BaseArea, 
 min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate, 
 max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate 
 from WarehouseEntry WE 
 left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null 
 left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null 
 left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id
 
 Where we.LocationId is not null  
 and (((LoosepartId = WE.LoosePartId and WE.LoosePartId is not null) or  
 (HandlingUnitId = WE.HandlingUnitId and WE.HandlingUnitId is not null) or 
 (HandlingUnitId = WE.ParentHandlingUnitId and WE.ParentHandlingUnitId is not null))) 
 group by  
 WE.LocationId, 
 coalesce(coalesce(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId), 
 (isnull(isnull(lp.Code,HU.Code),PHU.Code)) 
 ) DATA 
 
inner join (select BusinessUnitId,isnull(LoosePartId,HandlingUnitID) buphulpid from BusinessUnitPermission BUP where BusinessUnitId in (
select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId in (select RelatedBusinessUnitId from BusinessUnitRelation BUR where 
RelatedBusinessUnitID = @packer))) bupr on DATA.EntityID = bupr.buphulpid 
 left outer join [Location] L on DATA.LocationId = L.Id 
 left outer join (select 
 L.id LocationId,
  Capacity as LocCapacity 
  from Location L 
 where  L.[Disabled] = 0 
) LCap on data.LocationId = LCap.LocationId 
 group by 
 Data.LocationId, 
 L.Name, 
 Lcap.LocCapacity, 
 Data.Inbounddate, 
 isnull(data.OutboundDate,getdate()-1)) OnWarehouse 
inner join  BusinessUnitPermission BUP on OnWarehouse.LocationId = BUP.LocationId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2

left join BusinessUnitRelation BUR on BU.id = BUR.BusinessUnitId
left join BusinessUnit BUpa on BUR.RelatedBusinessUnitId = BUpa.id

 , 
 Calendar
 where calendar.DATE between OnWarehouse.Inbounddate and OnWarehouse.Outbounddate 
 group by
 BUpa.Name, 
  BU.name,
 LocCapacity,
 OnWarehouse.LocationId, 
 OnWarehouse.[Location], 
 calendar.date 

order by [Date]






