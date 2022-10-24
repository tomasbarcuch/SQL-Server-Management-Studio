
select
WF.id,
case WF.Action
when 0 then 'none'
when 1 then 'Inbound'
when 2 then 'Outbound'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 8 then 'Packing In'
when 9 then 'Unpacking From'
when 10 then 'Unloading'
when 11 then 'Loading To'
when 13 then 'Loaded All'
when 14 then 'Unloaded All'
when 16 then 'Printing'
when 17 then 'Change Status'
when 21 then 'Assigned'
when 22 then 'Packed All'
when 23 then 'Unpacking from'
when 24 then 'Assign Value'
else 'X' end as 'action name', * from workflow WF 
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId and BUP.BusinessUnitId = (select ID from BusinessUnit where name = 'Krones AG')
--inner join BCSAction A on WF.[Action] = 
where action <> 0 and PermissionId not in (select ID from Permission where name like '%_Action' and name <> 'OSL_action')







select 
ID,
name,
right(left(name,len(name)-7),Len(left(name,len(name)-7))-CHARINDEX('_',left(name,len(name)-7)))
 from Permission 
 where name like '%_Action' and name <> 'OSL_action'
 
/*
update workflow set PermissionID = 'f1718e01-a482-419c-91ce-1635b152a8b6' where ID = '2b00e700-b0f7-4b69-8d5c-4c47abee866c'
update workflow set PermissionID = '3d20b0f1-9ec1-44bf-9463-372c74ec2fa6' where ID = '9991bfbb-fcc7-4888-abd7-ea888cd152e2'
update workflow set PermissionID = 'f1718e01-a482-419c-91ce-1635b152a8b6' where ID = 'f0f11ace-d243-4ad6-ad88-f1ba667ccc53'
update workflow set PermissionID = '51eb338d-3c55-49fb-8e3c-e83bca392f64' where ID = '391e3e0f-141f-43bd-a373-f6043ebb6a84'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = '257ea1e6-28bf-43b3-8559-512254d8bffa'
update workflow set PermissionID = '752f1eda-08b4-452d-8f6e-d3befe98aaf9' where ID = '6f1fc8fd-d2d9-4eb9-9ab4-521aaa52d0ea'
update workflow set PermissionID = 'fda4e48b-8835-4922-b1cf-e3025ea172eb' where ID = 'd7cfcb84-2bd0-4327-ad44-c160700cf58b'
update workflow set PermissionID = '6aba9d8b-aebd-49a3-8ba9-e13be4544672' where ID = '001de297-e6ba-4764-831f-449ffb76b0fb'
update workflow set PermissionID = 'fda4e48b-8835-4922-b1cf-e3025ea172eb' where ID = '9d4bba00-333b-4288-9d1c-44e559c9ed60'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = '016f0c52-a03c-4446-be08-c2908090f8d3'
update workflow set PermissionID = 'f1718e01-a482-419c-91ce-1635b152a8b6' where ID = '8eaedf0a-2c92-4fcc-9a57-4cb16296b00d'
update workflow set PermissionID = '6aba9d8b-aebd-49a3-8ba9-e13be4544672' where ID = '42b7fa90-a4c1-4d8f-9dbb-5e70102d8c94'
update workflow set PermissionID = '50992c4c-f9af-40d0-8959-e00b60938b6c' where ID = '4a6e84c6-a39a-486d-9326-644567c08df6'
update workflow set PermissionID = '3d20b0f1-9ec1-44bf-9463-372c74ec2fa6' where ID = '29f25c66-8815-452b-9cb1-03b687b63b88'
update workflow set PermissionID = '50992c4c-f9af-40d0-8959-e00b60938b6c' where ID = '5dd50064-e668-4a35-a507-2f507efc2a11'
update workflow set PermissionID = '3d20b0f1-9ec1-44bf-9463-372c74ec2fa6' where ID = 'a26a0f54-b596-4820-90a2-2f70ce80353a'
update workflow set PermissionID = '81735bf0-9a8b-4153-852c-f82f37ce8b0e' where ID = 'e2947055-5e6e-457b-b6a9-329f8c8d8179'
update workflow set PermissionID = 'a6311c71-a8a7-436f-80a1-ebf36a676f4b' where ID = '5d33e3cb-321c-4c50-893f-ce42b57720a8'
update workflow set PermissionID = 'a6311c71-a8a7-436f-80a1-ebf36a676f4b' where ID = 'a729c540-7606-452f-891b-cfa3aa9a857f'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = '81c41255-d46c-487e-b959-d4b4516d0f5c'
update workflow set PermissionID = '50992c4c-f9af-40d0-8959-e00b60938b6c' where ID = 'f726303e-f2ec-4b2c-ab54-d59cae551376'
update workflow set PermissionID = 'fda4e48b-8835-4922-b1cf-e3025ea172eb' where ID = '65cd2a05-dd7c-46e2-9530-4e54a1c6e05a'
update workflow set PermissionID = 'f1718e01-a482-419c-91ce-1635b152a8b6' where ID = '3f225556-cb40-41df-9f2a-d93105072830'
update workflow set PermissionID = '81735bf0-9a8b-4153-852c-f82f37ce8b0e' where ID = '5494b03d-36c9-4a4d-98ab-95088b9b152e'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = 'e6461430-1972-40b2-bd73-6618d676e211'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = 'bb5d0cb3-e814-44c5-9a91-10d9184e2a22'
update workflow set PermissionID = 'fda4e48b-8835-4922-b1cf-e3025ea172eb' where ID = '358cd89c-3716-4508-842a-11e65938be50'
update workflow set PermissionID = 'a6311c71-a8a7-436f-80a1-ebf36a676f4b' where ID = '70aadccb-f8c0-4978-949c-14c20cc7c64f'
update workflow set PermissionID = 'a6311c71-a8a7-436f-80a1-ebf36a676f4b' where ID = '7329d018-8c34-4b10-a682-71239b975488'
update workflow set PermissionID = '81735bf0-9a8b-4153-852c-f82f37ce8b0e' where ID = '66843198-33cf-45e6-b315-719862074ca2'
update workflow set PermissionID = 'f1718e01-a482-419c-91ce-1635b152a8b6' where ID = 'e8f25833-6d7a-4fe7-a368-276adb958885'
update workflow set PermissionID = '81735bf0-9a8b-4153-852c-f82f37ce8b0e' where ID = 'e946e452-a83d-4ea1-9afe-a6bf9207490b'
update workflow set PermissionID = '51eb338d-3c55-49fb-8e3c-e83bca392f64' where ID = 'fab705a0-da15-4c24-b8ae-2965ae262920'
update workflow set PermissionID = '6aba9d8b-aebd-49a3-8ba9-e13be4544672' where ID = '43355251-59c0-4dbf-99c8-2b0d570bb275'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = '4ca2dc49-c5f8-420f-90e7-62bc042f7207'
update workflow set PermissionID = '7bd6d35f-5f0c-488d-ae9b-77d58e1e2300' where ID = '6c1e02e1-b8fa-439c-94a8-bf00e021038b'
update workflow set PermissionID = '81735bf0-9a8b-4153-852c-f82f37ce8b0e' where ID = '947b78e2-97cd-41fa-a3a0-391b04a5048a'
update workflow set PermissionID = 'f1718e01-a482-419c-91ce-1635b152a8b6' where ID = '752957dd-c6bd-4b8a-b12e-b12efc827187'
update workflow set PermissionID = '3d20b0f1-9ec1-44bf-9463-372c74ec2fa6' where ID = '12d00316-a268-4475-adba-b1e641dc8357'
update workflow set PermissionID = '5e52a20f-0b62-41ff-9b2c-02c5236a6ba5' where ID = 'f4797b94-b859-4b47-b342-dda01869177a'
update workflow set PermissionID = 'a6311c71-a8a7-436f-80a1-ebf36a676f4b' where ID = '84d11546-0b21-4a6f-ac87-e0aa1128e2db'
update workflow set PermissionID = '6aba9d8b-aebd-49a3-8ba9-e13be4544672' where ID = '5ac9b2c4-b916-4a27-92ea-e6aedab1bafd'
*/