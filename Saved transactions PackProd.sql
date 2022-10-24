

use [DFCZ_OSLET]
 SELECT 
 
 COUNT(DATA.ENTITYID) as 'Saved transactions' from
  (SELECT 
      case w.entity
	  when '15' then 'LP'
	  when '11' then 'HU'
	  when '48' then 'SERVICE'
	  when '9' then 'DIMENSION'
	  when '31' then 'SHIPMENT'
	  when '35' then 'PACKORDER'
	  else '' end as EntityShortcut

	  ,w.EntityID
	  
  FROM [dbo].[WorkflowEntry] as w
    where w.Entity in ('15','11','48','9','31','35')

 and cast (w.Created as date) = cast (getdate() as date)
  ) DATA
  where 
  --data.entityshortcut = 'LP' 
  data.entityshortcut = 'HU' 
  --data.entityshortcut = 'SERVICE' 
  --data.entityshortcut = 'DIMENSION' 
  --data.entityshortcut = 'SHIPMENT' 
  --data.entityshortcut = 'PACKORDER' 