select 
LP.code LPcode,
max(berlin.created) 'Rücklieferdatum', 
berlin.EntityId from( select Statusid,created,Id, EntityId from workflowentry WF 
where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where name in
('LpInbound',
'LpToBePainted',
'LpPainted') 
and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2')) Berlin 
inner join (

select WF.EntityId from workflowentry WF where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where name in
('LpInboundSiemens',
'LpToBePaintedSIEMENS',
'LpPaintedSiemens'
)and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2')) Siemens on Berlin.EntityId = Siemens.EntityId
inner join status S on berlin.StatusId = S.id
inner join LoosePart LP on berlin.EntityId = LP.id
inner join (
select WF.EntityId from workflowentry WF where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where name in
('LpInbound',
'LpToBePainted',
'LpPainted'
)
and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2')
group by EntityId
having count(id) > 1) CNT on berlin.EntityId = CNT.EntityId  and lp.code = '0000035427/000608'
group by berlin.EntityId,LP.code


