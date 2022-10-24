declare @LocationToDelete as UNIQUEIDENTIFIER = '78748269-6a4d-4e7a-bb47-6aefb40ca27d'
declare @LocationToMove as UNIQUEIDENTIFIER = 'f838ae03-5472-4bf7-b6e9-639d929a1f61'

begin TRANSACTION
update [Zone] set LocationId = @LocationToMove where LocationId = @LocationToDelete
update Bin set LocationId = @LocationToMove  where LocationId = @LocationToDelete
update WarehouseEntry set LocationId = @LocationToMove  where LocationId = @LocationToDelete
update WarehouseContent set LocationId = @LocationToMove  where LocationId = @LocationToDelete
update LoosePart set ActualLocationId = @LocationToMove  where ActualLocationId = @LocationToDelete
update HandlingUnit set ActualLocationId = @LocationToMove where ActualLocationId = @LocationToDelete
update ShipmentHeader set ToLocationId = @LocationToMove  where ToLocationId = @LocationToDelete
update ShipmentHeader set FromLocationId = @LocationToMove where FromLocationId = @LocationToDelete
update [User] set LastLocationId = @LocationToMove where LastLocationId = @LocationToDelete


ROLLBACK
