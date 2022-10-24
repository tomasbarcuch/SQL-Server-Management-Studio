SELECT

s.id,
S.name,
T.text

  FROM [dbo].[Status] S

left outer join BusinessUnitRelation BUR on S.ClientBusinessUnitId = BUR.BusinessUnitId
left outer join BusinessUnit BU on BUR.BusinessUnitId = BU.Id
left outer join BusinessUnit BR on BUR.RelatedBusinessUnitId = BR.id
left outer join dbo.Translation T on S.id =  t.EntityId and t.[Language] = 'DE' 
  where 
  BU.name in ('Siemens Berlin') 
  --and t.text is null 
  and s.IsClosed = 0 
  
group by

 s.id,
 S.name,
T.text
order by name
  


