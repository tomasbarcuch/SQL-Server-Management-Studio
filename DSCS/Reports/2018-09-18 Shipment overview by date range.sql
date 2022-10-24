select 
       SHresult.Code

      ,Shresult.Description
      ,SUM(isnull(SHresult.BaseArea,0)) as BaseArea
	  ,SUM(isnull(SHresult.Brutto,0)) as Brutto
	  ,COUNT(Shresult.code) as LoadingUnit
	  ,Shresult.name as Status
	  ,Shresult.ToAddressName as Address
	  ,Shresult.LoadingDate
	  ,Shresult.DeliveryDate
         ,SHresult.HUT
from

(
select 
SH.ClientID,
SH.PackerID,
SH.CustomerID,
SH.VendorID,
       SH.[Code]
      ,SH.[Description]
	  ,sh.[Name]
	  ,SH.[ToAddressName]
      ,cast(SH.[LoadingDate] as date) as LoadingDate
	  ,cast(SH.DeliveryDate as date) as DeliveryDate
      ,SH.[Type]
      ,SH.[UnloadingShipmentHeaderId]
	  ,HU.Brutto
	  ,HU.BaseArea
         ,HU.ColliNumber
         ,HUT.[Description] as HUT
         
	  
from

(
SELECT 

Client.Id ClientID,
Customer.id CustomerID,
packer.Id PackerID,
vendor.id VendorID,
       SH.[Id]
      ,SH.[Code]
      ,SH.[Description]
	  ,Status.[Name]
      ,SH.[ToAddressName]
      ,SH.[LoadingDate]
      ,SH.[DeliveryDate]
      ,Packer.Id [PackerBusinessUnitId]
      ,Vendor.id [VendorBusinessUnitId]
      ,Client.Id [ClientBusinessUnitId]
      ,Customer.id [Customer]
      ,SH.[Type]
      ,SH.[UnloadingShipmentHeaderId]
	  ,isnull(SL.[HandlingUnitId],SL.LoosePartId) lshuid

FROM dbo.[ShipmentLine] as SL

inner join dbo.ShipmentHeader SH On SL.ShipmentHeaderId = SH.Id
left join BusinessUnitPermission BUPclient on SL.id = BUPClient.ShipmentLineId
left join BusinessUnitPermission BUPcustomer on SL.id = BUPCustomer.ShipmentLineId
left join BusinessUnitPermission BUPPacker on SL.id = BUPPacker.ShipmentLineId
left join BusinessUnitPermission BUPVendor on SL.id = BUPVendor.ShipmentLineId
left join BusinessUnit Packer on BUPpacker.BusinessUnitId = Packer.Id and Packer.type = 0
left join BusinessUnit Customer on BUPCustomer.BusinessUnitId = Customer.Id and Customer.type = 1
left join BusinessUnit Client on BUPClient.BusinessUnitId = Client.Id and Client.type = 2
left join BusinessUnit Vendor on BUPVendor.BusinessUnitId = Vendor.Id and Vendor.type = 3
left join dbo.Status ON SH.StatusId = Status.Id

where 
--Client.Id =  $P{ClientBusinessUnitID}   and --'5edc9d81-6c28-4088-a8fd-b7b0c7b8b040'  and 
SH.Type='0'
) as SH

left outer join 

(
SELECT
     LocationId
     ,isnull(LoosePartId,HandlingUnitId) lphuid

 FROM dbo.WarehouseContent
) as WC on SH.lshuid = WC.lphuid
 
left outer join dbo.HandlingUnit HU on SH.lshuid = HU.Id
left join HandlingUnitType HUT on HU.TypeId = HUT.Id
left outer join dbo.LoosePart LP on SH.lshuid = LP.id
 where locationid is null
 ) as SHresult
 
where LoadingDate >=  '2019-07-01'  and LoadingDate <= '2019-07-31' 

 Group by

        Shresult.Code
       ,Shresult.Description
	   ,Shresult.name 
	   ,Shresult.ToAddressName
	   ,Shresult.LoadingDate
	   ,Shresult.DeliveryDate
