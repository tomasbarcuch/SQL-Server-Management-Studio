--použitá varianta

select LoosePart.id,sb.statusblocked from LoosePart
left join(
select LP.id,
(select Count(*) from EntityDisableStatus eds where LP.Id = eds.EntityId and eds.entity = 15) as statusblocked
 from LoosePart LP) sb on LoosePart.id = sb.Id


--varianta 1

select lp.id, isnull(STATUSBLOCKED.blocked,0) as statusblocked  from LoosePart LP
left join (
select eds.entityid,
case when eds.Entity is null then 0 else 1 end as blocked
 from EntityDisableStatus EDS) STATUSBLOCKED on LP.id = STATUSBLOCKED.EntityId


--varianta 2
select LoosePart.id,sb.statusblocked from LoosePart
left join(
SELECT lp.id, 1 as statusblocked FROM loosepart LP, EntityDisableStatus AS EDS
    WHERE lp.id= eds.EntityId
UNION ALL
SELECT LP.Id, 0 
FROM LoosePart AS LP
WHERE NOT EXISTS (
    SELECT * FROM EntityDisableStatus AS EDS
    WHERE lp.id= eds.EntityId)) sb on LoosePart.id = sb.Id





