select 
lp.code,
bu.name,
bu.id,
BaseArea

from loosepart lp
inner join BusinessUnit bu on lp.ClientBusinessUnitId = bu.id 
where lp.id in(
 '7ca11b85-9c13-49bc-999a-c79253dc02d0'
)


