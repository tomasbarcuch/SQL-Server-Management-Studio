--UPDATE BCS ACTION

BEGIN TRANSACTION 

update AP set AP.permissionID = 
(select ID from Permission where NAME = 'Status_change_manually_0') 
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 0 and AP.permissionID <>  
(select ID from Permission where NAME = 'Status_change_manually_0') 
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 0 and AP.permissionID <> 
(select id from Permission where Name = 'Status_change_manually_0'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Inbound_BCSAction_1')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 1 and AP.permissionID <>  
(select id from Permission where Name = 'Inbound_BCSAction_1')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 1 and AP.permissionID <> 
(select id from Permission where Name = 'Inbound_BCSAction_1'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Outbound_BCSAction_2')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 2 and AP.permissionID <>  
(select id from Permission where Name = 'Outbound_BCSAction_2')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 2 and AP.permissionID <> 
(select id from Permission where Name = 'Outbound_BCSAction_2'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Transfer_BCSAction_3')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 3 and AP.permissionID <>  
(select id from Permission where Name = 'Transfer_BCSAction_3')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 3 and AP.permissionID <> 
(select id from Permission where Name = 'Transfer_BCSAction_3'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Movement_BCSAction_4')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 4 and AP.permissionID <>  
(select id from Permission where Name = 'Movement_BCSAction_4')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 4 and AP.permissionID <> 
(select id from Permission where Name = 'Movement_BCSAction_4'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Packing_BCSAction_5')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 5 and AP.permissionID <>  
(select id from Permission where Name = 'Packing_BCSAction_5')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 5 and AP.permissionID <> 
(select id from Permission where Name = 'Packing_BCSAction_5'))
 
update AP set AP.permissionID = 
(select id from Permission where Name = 'Unpacking_BCSAction_6')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 6 and AP.permissionID <>  
(select id from Permission where Name = 'Unpacking_BCSAction_6')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 6 and AP.permissionID <> 
(select id from Permission where Name = 'Unpacking_BCSAction_6'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Loading_BCSAction_7')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 7 and AP.permissionID <>  
(select id from Permission where Name = 'Loading_BCSAction_7')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 7 and AP.permissionID <> 
(select id from Permission where Name = 'Loading_BCSAction_7'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Unloading_BCSAction_10')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 10 and AP.permissionID <>  
(select id from Permission where Name = 'Unloading_BCSAction_10')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 10 and AP.permissionID <> 
(select id from Permission where Name = 'Unloading_BCSAction_10'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'LoadingTo_BCSAction_11')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 11 and AP.permissionID <> 
(select id from Permission where Name = 'LoadingTo_BCSAction_11')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 11 and AP.permissionID <> 
(select id from Permission where Name = 'LoadingTo_BCSAction_11'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'UnloadingFrom_BCSAction_12')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 12 and AP.permissionID <> 
(select id from Permission where Name = 'UnloadingFrom_BCSAction_12')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 12 and AP.permissionID <> 
(select id from Permission where Name = 'UnloadingFrom_BCSAction_12'))
  
update AP set AP.permissionID = 
(select id from Permission where Name = 'LoadedAll_BCSAction_13')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 13 and AP.permissionID <> 
(select id from Permission where Name = 'LoadedAll_BCSAction_13')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 13 and AP.permissionID <> 
(select id from Permission where Name = 'LoadedAll_BCSAction_13'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'UnloadedAll_BCSAction_14')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 14 and AP.permissionID <> 
(select id from Permission where Name = 'UnloadedAll_BCSAction_14')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 14 and AP.permissionID <> 
(select id from Permission where Name = 'UnloadedAll_BCSAction_14'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Inventory_BCSAction_15')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 15 and AP.permissionID <> 
(select id from Permission where Name = 'Inventory_BCSAction_15')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 15 and AP.permissionID <> 
(select id from Permission where Name = 'Inventory_BCSAction_15'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Printing_BCSAction_16')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 16 and AP.permissionID <> 
(select id from Permission where Name = 'Printing_BCSAction_16')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 16 and AP.permissionID <> 
(select id from Permission where Name = 'Printing_BCSAction_16'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'ChangeStatus_BCSAction_17')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 17 and AP.permissionID <> 
(select id from Permission where Name = 'ChangeStatus_BCSAction_17')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 17 and AP.permissionID <> 
(select id from Permission where Name = 'ChangeStatus_BCSAction_17'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'ItemInfo_BCSAction_18')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 18 and AP.permissionID <> 
(select id from Permission where Name = 'ItemInfo_BCSAction_18')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 18 and AP.permissionID <> 
(select id from Permission where Name = 'ItemInfo_BCSAction_18'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'CreateShipment_BCSAction_19')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 19 and AP.permissionID <> 
(select id from Permission where Name = 'CreateShipment_BCSAction_19')
 and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 19 and AP.permissionID <> 
(select id from Permission where Name = 'CreateShipment_BCSAction_19'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Import_BCSAction_20')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 20 and AP.permissionID <> 
(select id from Permission where Name = 'Import_BCSAction_20')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 20 and AP.permissionID <> 
(select id from Permission where Name = 'Import_BCSAction_20'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Assigned_BCSAction_21')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 21 and AP.permissionID <> 
(select id from Permission where Name = 'Assigned_BCSAction_21')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 21 and AP.permissionID <> 
(select id from Permission where Name = 'Assigned_BCSAction_21'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'PackedAll_BCSAction_22')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 22 and AP.permissionID <> 
(select id from Permission where Name = 'PackedAll_BCSAction_22')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 22 and AP.permissionID <> 
(select id from Permission where Name = 'PackedAll_BCSAction_22'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'UnpackedAll_BCSAction_23')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 23 and AP.permissionID <>  
(select id from Permission where Name = 'UnpackedAll_BCSAction_23')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 23 and AP.permissionID <> 
(select id from Permission where Name = 'UnpackedAll_BCSAction_23'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'AssignValue_BCSAction_24')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 24 and AP.permissionID <> 
(select id from Permission where Name = 'AssignValue_BCSAction_24')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 24 and AP.permissionID <> 
(select id from Permission where Name = 'AssignValue_BCSAction_24'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'ShowContainerVisualModel_BCSAction_25')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 25 and AP.permissionID <> 
(select id from Permission where Name = 'ShowContainerVisualModel_BCSAction_25')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 25 and AP.permissionID <> 
(select id from Permission where Name = 'ShowContainerVisualModel_BCSAction_25'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'AssignDevice_BCSAction_26')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 26 and AP.permissionID <> 
(select id from Permission where Name = 'AssignDevice_BCSAction_26')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 26 and AP.permissionID <> 
(select id from Permission where Name = 'AssignDevice_BCSAction_26'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'UploadToDMS_BCSAction_27')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 27 and AP.permissionID <> 
(select id from Permission where Name = 'UploadToDMS_BCSAction_27')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 27 and AP.permissionID <> 
(select id from Permission where Name = 'UploadToDMS_BCSAction_27'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'ChangeClient_BCSAction_28')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 28 and AP.permissionID <> 
(select id from Permission where Name = 'ChangeClient_BCSAction_28')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 28 and AP.permissionID <> 
(select id from Permission where Name = 'ChangeClient_BCSAction_28'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Treeview_BCSAction_29')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 29 and AP.permissionID <>  
(select id from Permission where Name = 'Treeview_BCSAction_29')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 29 and AP.permissionID <> 
(select id from Permission where Name = 'Treeview_BCSAction_29'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Split_BCSAction_30')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 30 and AP.permissionID <>  
(select id from Permission where Name = 'Split_BCSAction_30')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 30 and AP.permissionID <> 
(select id from Permission where Name = 'Split_BCSAction_30'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'AddIdentifier_BCSAction_31')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 31 and AP.permissionID <> 
(select id from Permission where Name = 'AddIdentifier_BCSAction_31') 
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 31 and AP.permissionID <> 
(select id from Permission where Name = 'AddIdentifier_BCSAction_31'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'LockStatus_BCSAction_32')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 32 and AP.permissionID <> 
(select id from Permission where Name = 'LockStatus_BCSAction_32')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 32 and AP.permissionID <> 
(select id from Permission where Name = 'LockStatus_BCSAction_32'))
  
update AP set AP.permissionID = 
(select id from Permission where Name = 'UnlockStatus_BCSAction_33')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 33 and AP.permissionID <> 
(select id from Permission where Name = 'UnlockStatus_BCSAction_33')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 33 and AP.permissionID <> 
(select id from Permission where Name = 'UnlockStatus_BCSAction_33'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'DisconnectDevice_BCSAction_34')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 34 and AP.permissionID <> 
(select id from Permission where Name = 'DisconnectDevice_BCSAction_34')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 34 and AP.permissionID <> 
(select id from Permission where Name = 'DisconnectDevice_BCSAction_34'))

update AP set AP.permissionID = 
(select id from Permission where Name = 'Packing_BCSAction_5')
from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 35 and AP.permissionID <> 
(select id from Permission where Name = 'Packing_BCSAction_5')
and AP.ID = (select top(1) AP.id from BCSActionPermission AP
inner join BCSAction A on AP.ActionId = A.id
where A.BCSaction = 35 and AP.permissionID <> 
(select id from Permission where Name = 'Packing_BCSAction_5'))


commit

--UPDATE WORKFLOW ACTIONS


BEGIN TRANSACTION
update workflow set PermissionId = 
(select id from Permission where Name = 'Status_change_manually_0') 
where Action = 0 and PermissionId <> 
(select id from Permission where Name = 'Status_change_manually_0') 

update workflow set PermissionId = 
(select id from Permission where Name = 'Inbound_PortalAction_1') 
where Action = 1 and PermissionId <> 
(select id from Permission where Name = 'Inbound_PortalAction_1')

update workflow set PermissionId = 
(select id from Permission where Name = 'Outbound_PortalAction_2') 
where Action = 2 and PermissionId <> 
(select id from Permission where Name = 'Outbound_PortalAction_2')

update workflow set PermissionId = 
(select id from Permission where Name = 'Transfer_PortalAction_3') 
where Action = 3 and PermissionId <> 
(select id from Permission where Name = 'Transfer_PortalAction_3')

update workflow set PermissionId = 
(select id from Permission where Name = 'Movement_PortalAction_4') 
where Action = 4 and PermissionId <> 
(select id from Permission where Name = 'Movement_PortalAction_4')

update workflow set PermissionId = 
(select id from Permission where Name = 'Packing_PortalAction_5') 
where Action = 5 and PermissionId <> 
(select id from Permission where Name = 'Packing_PortalAction_5')

update workflow set PermissionId = 
(select id from Permission where Name = 'Unpacking_PortalAction_6') 
where Action = 6 and PermissionId <> 
(select id from Permission where Name = 'Unpacking_PortalAction_6')

update workflow set PermissionId = 
(select id from Permission where Name = 'Loading_PortalAction_7') 
where Action = 7 and PermissionId <> 
(select id from Permission where Name = 'Loading_PortalAction_7')

update workflow set PermissionId = 
(select id from Permission where Name = 'PackingIn_PortalAction_8') 
where Action = 8 and PermissionId <> 
(select id from Permission where Name = 'PackingIn_PortalAction_8')

update workflow set PermissionId = 
(select id from Permission where Name = 'UnpackingFrom_PortalAction_9') 
where Action = 9 and PermissionId <> 
(select id from Permission where Name = 'UnpackingFrom_PortalAction_9')

update workflow set PermissionId = 
(select id from Permission where Name = 'Unloading_PortalAction_10') 
where Action = 10 and PermissionId <> 
(select id from Permission where Name = 'Unloading_PortalAction_10')

update workflow set PermissionId = 
(select id from Permission where Name = 'LoadingTo_PortalAction_11') 
where Action = 11 and PermissionId <> 
(select id from Permission where Name = 'LoadingTo_PortalAction_11')

update workflow set PermissionId = 
(select id from Permission where Name = 'UnloadingFrom_PortalAction_12') 
where Action = 12 and PermissionId <> 
(select id from Permission where Name = 'UnloadingFrom_PortalAction_12')

update workflow set PermissionId = 
(select id from Permission where Name = 'LoadedAll_PortalAction_13') 
where Action = 13 and PermissionId <> 
(select id from Permission where Name = 'LoadedAll_PortalAction_13')

update workflow set PermissionId = 
(select id from Permission where Name = 'UnloadedAll_PortalAction_14') 
where Action = 14 and PermissionId <> 
(select id from Permission where Name = 'UnloadedAll_PortalAction_14')

update workflow set PermissionId = 
(select id from Permission where Name = 'Inventory_PortalAction_15') 
where Action = 15 and PermissionId <> 
(select id from Permission where Name = 'Inventory_PortalAction_15')

update workflow set PermissionId = 
(select id from Permission where Name = 'Printing_PortalAction_16') 
where Action = 16 and PermissionId <> 
(select id from Permission where Name = 'Printing_PortalAction_16')

update workflow set PermissionId = 
(select id from Permission where Name = 'ChangeStatus_PortalAction_17') 
where Action = 17 and PermissionId <> 
(select id from Permission where Name = 'ChangeStatus_PortalAction_17')

update workflow set PermissionId = 
(select id from Permission where Name = 'ItemInfo_PortalAction_18') 
where Action = 18 and PermissionId <> 
(select id from Permission where Name = 'ItemInfo_PortalAction_18')

update workflow set PermissionId = 
(select id from Permission where Name = 'CreateShipment_PortalAction_19') 
where Action = 19 and PermissionId <> 
(select id from Permission where Name = 'CreateShipment_PortalAction_19')

update workflow set PermissionId = 
(select id from Permission where Name = 'Import_PortalAction_20') 
where Action = 20 and PermissionId <> 
(select id from Permission where Name = 'Import_PortalAction_20')

update workflow set PermissionId = 
(select id from Permission where Name = 'Assigned_PortalAction_21') 
where Action = 21 and PermissionId <> 
(select id from Permission where Name = 'Assigned_PortalAction_21')

update workflow set PermissionId = 
(select id from Permission where Name = 'PackedAll_PortalAction_22') 
where Action = 22 and PermissionId <> 
(select id from Permission where Name = 'PackedAll_PortalAction_22')

update workflow set PermissionId = 
(select id from Permission where Name = 'UnpackedAll_PortalAction_23')
where Action = 23 and PermissionId <> 
(select id from Permission where Name = 'UnpackedAll_PortalAction_23')

update workflow set PermissionId = 
(select id from Permission where Name = 'AssignValue_PortalAction_24') 
where Action = 24 and PermissionId <> 
(select id from Permission where Name = 'AssignValue_PortalAction_24')

update workflow set PermissionId = 
(select id from Permission where Name = 'ShowContainerVisualModel_PortalAction_25') 
where Action = 25 and PermissionId <> 
(select id from Permission where Name = 'ShowContainerVisualModel_PortalAction_25')

update workflow set PermissionId = 
(select id from Permission where Name = 'AssignDevice_PortalAction_26') 
where Action = 26 and PermissionId <> 
(select id from Permission where Name = 'AssignDevice_PortalAction_26')

update workflow set PermissionId = 
(select id from Permission where Name = 'UploadToDMS_PortalAction_27') 
where Action = 27 and PermissionId <> 
(select id from Permission where Name = 'UploadToDMS_PortalAction_27')

update workflow set PermissionId = 
(select id from Permission where Name = 'ChangeClient_PortalAction_28') 
where Action = 28 and PermissionId <> 
(select id from Permission where Name = 'ChangeClient_PortalAction_28')

update workflow set PermissionId = 
(select id from Permission where Name = 'AddShipmentLine_PortalAction_29') 
where Action = 29 and PermissionId <> 
(select id from Permission where Name = 'AddShipmentLine_PortalAction_29')

update workflow set PermissionId = 
(select id from Permission where Name = 'DeleteShipmentLine_PortalAction_30') 
where Action = 30 and PermissionId <> 
(select id from Permission where Name = 'DeleteShipmentLine_PortalAction_30')

update workflow set PermissionId =  
(select id from Permission where Name = 'FirstShipmentLineAdded_PortalAction_31') 
where Action = 31 and PermissionId <> 
(select id from Permission where Name = 'FirstShipmentLineAdded_PortalAction_31')

update workflow set PermissionId = 
(select id from Permission where Name = 'LastShipmentLineDeleted_PortalAction_32') 
where Action = 32 and PermissionId <> 
(select id from Permission where Name = 'LastShipmentLineDeleted_PortalAction_32')





COMMIT



