Select  
 NEWID() Id, 
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
  isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId) as EntityID, 
 sum(isnull(isnull(lp.BaseArea,HU.BaseArea),PHU.BaseArea)) as BaseArea, 
 min(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then RegisteringDate else null end) as Inbounddate, 
 max(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then RegisteringDate else null end) as OutboundDate 
 from WarehouseEntry WE 
 left outer join LoosePart LP on WE.LoosepartId = LP.Id and we.HandlingUnitId is null 
 left outer join HandlingUnit HU on WE.HandlingUnitId = HU.id and we.ParentHandlingUnitId is null 
 left outer join HandlingUnit PHU on WE.ParentHandlingUnitId = PHU.id 
 Where we.LocationId is not null  
 --and EXISTS(select * from BusinessUnitPermission where BusinessUnitId = (Select id from BusinessUnit where name = 'Siemens Berlin') and 
 --and EXISTS(select * from BusinessUnitPermission where BusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' and
 and ((LoosepartId = WE.LoosePartId and WE.LoosePartId is not null) or  
 (HandlingUnitId = WE.HandlingUnitId and WE.HandlingUnitId is not null) or 
 (HandlingUnitId = WE.ParentHandlingUnitId and WE.ParentHandlingUnitId is not null))
 group by  
 WE.LocationId, 
 isnull(isnull(WE.LoosepartId,WE.HandlingUnitId),WE.ParentHandlingUnitId), 
 (isnull(isnull(lp.Code,HU.Code),PHU.Code)) 
 ) data 
 left outer join [Location] L on DATA.LocationId = L.Id 
 left outer join (select  L.id LocationId,  Capacity as LocCapacity   from Location L  where  L.[Disabled] = 0 ) LCap on data.LocationId = LCap.LocationId 
 left outer join BusinessUnitPermission BUP on data.LocationId = BUP.LocationId
 where bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
 group by 
 Data.LocationId, 
 L.Name, 
 Lcap.LocCapacity, 
 Data.Inbounddate, 
 isnull(data.OutboundDate,getdate()-1)) OnWarehouse 
 , 
 Calendar
 where calendar.DATE between OnWarehouse.Inbounddate and OnWarehouse.Outbounddate 
 group by 
 LocCapacity,
 OnWarehouse.LocationId, 
 OnWarehouse.[Location], 
 calendar.date 


