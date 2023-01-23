begin TRANSACTION
--update LoosePart set StatusId = data.StatusId 
select LP.StatusId,DATA.StatusId
from LoosePart LP inner join 
(select 
WFE.entityid,
WFE.Statusid
from WorkflowEntry WFE inner join (


select wfe.EntityId, Max(WFE.created) created from WorkflowEntry WFE
inner join BusinessUnitPermission BUP on WFE.EntityId = BUP.LoosePartId and bup.BusinessUnitId = (select id from businessunit where name = 'Air Liquide Group')
where entity = 15 and EntityId = 'd4396377-7b2e-4d57-8808-64cc12aaad5d'
group by WFE.EntityId 

) DATA on WFE.entityId = DATA.EntityId and WFE.Created = DATA.Created)
data on LP.id = data.EntityId-- where Loosepart.StatusId <> data.StatusId

ROLLBACK



select * from WorkflowEntry where EntityId = 'd4396377-7b2e-4d57-8808-64cc12aaad5d'


select * from [Status] S inner join (


select DATA.Id, SC.Id  from (
select
LP.Id, 
S.Name,
BUP.BusinessUnitId
from LoosePart LP 
inner join [Status] S on LP.StatusId = S.Id
inner join BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId --and bup.BusinessUnitId = (select id from businessunit where name = 'Air Liquide Group')
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Type] = 2
inner join BusinessUnitPermission BUPS on LP.StatusId = BUPS.StatusId 
inner join BusinessUnit BUS on BUPS.BusinessUnitId = BUS.Id and BUS.[Type] = 2

where BUS.Id <> BU.Id
) DATA

INNER JOIN (
    select S.Id, S.Name, BUP.BusinessUnitId  from [Status] S
    inner join BusinessUnitPermission BUP on S.Id = BUP.StatusId

) SC on DATA.Name = SC.Name and DATA.BusinessUnitId = SC.BusinessUnitId



begin TRANSACTION

update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '6aff9eb3-6d95-41cf-8344-77ac28654432'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '4867dcaf-ad23-4a46-97ad-25825dd59605'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '627d2502-b826-4175-b21b-047a91c13386'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'ecc40951-a56e-4a9a-843b-42be31c9a0ee'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'b849fa4f-0016-43f6-a3ea-9015ebe1d80b'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'b3121bcf-979f-4fdd-b896-cb2d9c0370d5'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'a6befe1e-5b62-4912-900f-733d2296dfa2'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'a823d4b1-b2d0-4c94-91ff-3a197c203b58'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '5046a788-a7dc-4f2f-8862-e13321f1511f'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '4c7e6f4d-aa20-41cf-9405-7391e8c4b8ee'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '0d1feaba-97b8-42b9-9fd2-1340eba3d712'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '4cafaf5f-e658-43da-8f6e-2ac90353df39'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '4fb92cfc-fdb9-4892-9014-d225830edbbb'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '18fddee1-2af3-482f-9705-76fcd67d325f'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'abe22ee7-135a-4436-a562-527f6a57e287'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'a6f6a92e-b0dc-4031-a057-dfccadf8d84c'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'bdec670d-08d3-480e-8f4d-754796492a65'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'ce11600d-af7d-4dec-b8f6-ab867f85ea36'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '5e2671c6-8790-4821-8a8f-4acb60951ea1'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '23350352-0c90-4375-9e94-2d0fdf6ab36c'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '6bacb6c2-69dd-401b-97a0-dc46d17cab1b'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'fdef4755-1453-436d-9af1-d83e0d7e66ae'
update LoosePart set StatusId = '4475cb75-ee54-4647-8060-af8a46ee6de9' where Id = 'd7f9717a-92d8-4fe3-803e-9056099205d8'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'c45bbb1a-1429-4407-b3b7-d71249e8c7c5'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'd4396377-7b2e-4d57-8808-64cc12aaad5d'
update LoosePart set StatusId = '4475cb75-ee54-4647-8060-af8a46ee6de9' where Id = 'b1ba73b8-8a27-4106-ba9f-d6d607399c9e'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '3087f46b-8c99-493e-8b0a-22deec8e9dec'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '24e37cee-34a2-4f23-b64a-9bd5e38d4344'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '4865156a-ea40-4705-b911-5793e4be4cb8'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'e4d70c46-2a1f-4f4c-bf97-62762b9daeca'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '518290ba-3ba5-4ed9-a39e-2dd1251e984e'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '074f1be5-fc30-417f-8344-d7d50ccad6a9'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '3b23e3bc-d61a-47ce-b42f-b0305ee12d84'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'bb712a03-6d08-41e3-baea-fb251b1e913e'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '5e80630d-3d28-420f-8dd0-f1ddea3b2f78'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '7acc34ee-2468-4bc2-a5c5-aad2a5058058'
update LoosePart set StatusId = '4475cb75-ee54-4647-8060-af8a46ee6de9' where Id = '5c7f7f7b-fc52-458a-8e87-83b42e487c12'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'efe1aae5-5a98-4e9b-bbc8-6206de26a7ad'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'e26bf0cf-53b2-4f22-9e58-e66b282e8b7f'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '2986bde6-695e-4f81-af30-ad18592d9fca'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '418b2407-d281-4bce-afa6-49a3890feb6c'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'ce50c316-7f9b-4688-b8b0-1e1af2ffc733'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '9656e0bc-69e4-468f-93b4-b214ffe04348'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '8aa75a6a-5542-413f-a6ce-ec0a7aefd520'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '175d29d7-5199-423d-bb03-1da451157343'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '146f38b7-7e1a-46ba-adc6-0347331b7c18'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = 'bb83462b-6ed4-4bb6-a2c8-d56c22be2b1f'
update LoosePart set StatusId = '9159ff97-3c4e-4c20-9ffe-e74c11bdd200' where Id = '9b8eb512-44f3-47f5-b8b1-6ba0f66e7859'


ROLLBACK