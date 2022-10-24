 --všechny dimenze a na nich loseparty
 SELECT ent.code,edvr.EntityId, dv.Content
 FROM [DimensionValue] AS dv 
left outer JOIN [EntityDimensionValueRelation] AS edvr ON (edvr.DimensionValueId = dv.id) 
 left outer JOIN [LoosePart] AS ent ON (ent.id = edvr.EntityId AND edvr.[Entity] = '15' ) 


 --všechny LP a k nim dimenze
 select bu.name,lp.id, lp.clientbusinessunitid,edvr.EntityId,dv.Content from loosepart lp
 left outer join [EntityDimensionValueRelation] edvr on lp.id = edvr.entityid
 left outer join dimensionvalue dv on edvr.dimensionvalueid = dv.id
 left outer join businessunit bu on lp.clientbusinessunitid = bu.id

 select count(id) from loosepart


  --všechny dimenze a na nich hu
 SELECT ent.code,edvr.EntityId, dv.Content
 FROM [DimensionValue] AS dv 
left outer JOIN [EntityDimensionValueRelation] AS edvr ON (edvr.DimensionValueId = dv.id) 
 left outer JOIN [LoosePart] AS ent ON (ent.id = edvr.EntityId AND edvr.[Entity] = '11' ) 