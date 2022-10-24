DECLARE @CLIENT as VARCHAR (250) = 'Diverse Kunden'


BEGIN TRANSACTION

update STATUS set NAME = 
CASE NAME 
when 'LpNew' then 'CREATED'
when 'LpCanceled' then 'CANCELED'
when 'HuCanceled' then 'CANCELED'
when 'HuBoxInShipped' then 'SHIPPED'
when 'LpOutOfWarehouse' then 'SHIPPED'
when 'PoCanceled' then 'CANCELED'
when 'SpReady' then 'READY_FOR_LOADING'
when 'HuPacked' then 'PACKED'
when 'PoProduced' then 'ASSIGNED'
when 'HuBoxOpened' then 'OPENED'
when 'HuBoxInLoaded' then 'ON_SHIPMENT'
when 'HuBoxPackedIn' then 'IN_CRATE'
when 'LpUnloading' then 'UNLOADED'
when 'HuBox closed' then 'CLOSED'
when 'Canceled' then 'CANCELED'
when 'HuBuilt' then 'CREATED'
when 'Created' then 'CREATED'
when 'LpOpened' then 'OPENED'
when 'HuInWarehouse' then 'ON_STOCK'
when 'PoBoxCad' then 'BXNLSend'
when 'HuUnpacking' then 'UNPACKED'
when 'LpFinished' then 'HANDED_OVER'
when 'SpTruck ordered' then 'CREATED'
when 'HuUnpacked2' then 'UNPACKED'
when 'Finished' then 'HANDED_OVER'
when 'SpShipped' then 'SHIPPED'
when 'Active' then 'ACTIVE'
when 'HuUnpacked' then 'UNPACKED'
when 'HuShipped' then 'SHIPPED'
when 'HuOn the way' then 'ON_THE_WAY'
when 'PoOnWay' then 'BXNLSuccess'
when 'LpDone' then 'HANDED_OVER'
when 'LpPreliminary on Site' then 'HANDED_OVER'
when 'SpOpened' then 'UNLOADED'
when 'HuOPI' then 'SHIPPED'
when 'HuOutOfWarehouse' then 'SHIPPED'
when 'HuPart inserted' then 'ITEM_INSIDE'
when 'SpUnloaded' then 'UNLOADED'
when 'HuContainerShipped' then 'SHIPPED'
when 'LpReceived OSL' then 'ON_STOCK'
when 'BXNLSend' then 'BXNLSend'
when 'LpInbound2' then 'ON_STOCK'
when 'HuContainerUnloaded' then 'UNLOADED'
when 'LpBackOrder' then 'CREATED'
when 'HuItemInserted' then 'ITEM_INSIDE'
when 'LpShip. ready' then 'READY_FOR_LOADING'
when 'HuDesigned' then 'CREATED'
when 'LpHanded over' then 'HANDED_OVER'
when 'HuPartInsertedOUT' then 'ITEM_INSIDE'
when 'HuCompleted' then 'PACKED'
when 'HuUnload' then 'UNLOADED'
when 'LpClosed' then 'CLOSED'
when 'SpLoading' then 'ON_SHIPMENT'
when 'HuInbound' then 'ON_STOCK'
when 'SLCanceled' then 'CANCELED'
when 'LpInbound' then 'ON_STOCK'
when 'HuReceived OSL' then 'HANDED_OVER'
when 'PoHuAssigned' then 'ASSIGNED'
when 'HuContainerOpened' then 'OPENED'
when 'PoLBprinted' then 'LABEL_PRINTED'
when 'HuHanded over' then 'HANDED_OVER'
when 'LpDispatched' then 'SHIPPED'
when 'DiClosed' then 'CLOSED'
when 'HuUnloaded' then 'UNLOADED'
when 'DiNew' then 'ACTIVE'
when 'LpReceived' then 'ON_STOCK'
when 'PoDelivered' then 'ON_STOCK'
when 'HuLoading' then 'ON_SHIPMENT'
when 'LpPrinted' then 'LABEL_PRINTED'
when 'HuShip. ready' then 'READY_FOR_LOADING'
when 'HuContainerOut' then 'ON_THE_WAY'
when 'DiCanceled' then 'CANCELED'
when 'HuUnpackedfromCo' then 'UNPACKED'
when 'BXNLFailure' then 'BXNLFailure'
when 'SpNew' then 'CREATED'
when 'LpPacked' then 'IN_CRATE'
when 'HuContainerZu' then 'CLOSED'
when 'HuContainer closed' then 'CLOSED'
when 'LpUnpacked' then 'UNPACKED'
when 'PoNew' then 'CREATED'
when 'HuNew' then 'CREATED'
when 'LpLoading' then 'ON_SHIPMENT'
when 'BXNLSuccess' then 'BXNLSuccess'
when 'LpReady' then 'READY_FOR_LOADING'
when 'HuBoxInReceived2' then 'ON_STOCK'
when 'LpShipped' then 'SHIPPED'
when 'DiActive' then 'ACTIVE'
end


from STATUS S
inner join BusinessUnitPermission BUP on S.Id = BUP.StatusId and BUP.BusinessUnitId = (select id from BusinessUnit where name = @CLIENT)


ROLLBACK



/*

DECLARE @CLIENT2 as VARCHAR (250) = 'Basis Client'

select S.Name 
from STATUS S
inner join BusinessUnitPermission BUP on S.Id = BUP.StatusId and BUP.BusinessUnitId = (select id from BusinessUnit where name = @CLIENT2)
*/