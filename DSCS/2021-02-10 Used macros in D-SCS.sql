select 
POH.macro, Count(POH.id), MAX(POH.Created)

from PackingOrderHeader POH
inner join status S on POH.StatusId = S.id
where POH.HandlingUnitId is not NULL and len(Macro)>1
and s.name in ('BXNLCrateProduced','BXNLSuccess','BXNLProduced','ASSIGNED')
group by macro