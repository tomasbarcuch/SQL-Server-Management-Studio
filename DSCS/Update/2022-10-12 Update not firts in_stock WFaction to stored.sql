
begin TRANSACTION 

update WorkflowEntry set StatusId = '9e8cb5ca-edd8-4305-a9af-2b53d0cde082' where id in 

(
select id from WorkflowEntry 
inner join
(
select 
Count(WFE.id) WFEId, 
MAX(WFE.Created) Created, 
WFE.EntityId from WorkflowEntry WFE 
where WFE.StatusId = '167d8dc5-fe7d-41e2-841a-e7b825d40fad'
group by WFE.EntityId having Count(WFE.id) > 1
)DATA on WorkflowEntry.EntityId = DATA.EntityId and WorkflowEntry.Created = DATA.Created

where StatusId = '167d8dc5-fe7d-41e2-841a-e7b825d40fad'
)
COMMIT