

select S.name, T.[Column], T.text, T.language from status S
left join Translation T on S.id = T.EntityId
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')

where Entity = 27
order by T.EntityId