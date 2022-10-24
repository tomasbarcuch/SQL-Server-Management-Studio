--select code, name, max (id), count(id) from location group by code, name having count (id) > 1


select B.id,B.code, Z.id,Z.name, L.id, L.code from location L
inner join Zone Z on L.id = Z.LocationId
inner join bin B on L.id = B.LocationId and b.ZoneId = Z.id
where L.code in (select code from location group by code, name having count (id) > 1)



select id from location where code = 'Deufol Frankenthal'

select code,id from bin where LocationId = '4f20ff86-fae3-4292-b058-bf970c95563c' and ZoneId in (
select id from Zone where LocationId = 'a3d10490-fb5a-4e30-80ea-574cf44da38f')

select id, LocationId from Zone where LocationId in(select id from location where code = 'Deufol Frankenthal')


--update bin set locationid = 'a3d10490-fb5a-4e30-80ea-574cf44da38f'  from bin where bin.id in (
select 
bin.id binid
--bin.ZoneId, 
--bin.LocationId locidbin, 
--zone.locationid locidzone,
--bin.ZoneId 
from bin 
inner join zone on bin.ZoneId = zone.id
where bin.LocationId in(select id from location where code = 'Deufol Frankenthal')
and bin.locationid <> zone.LocationId
--)

--update zone set LocationId = 'a3d10490-fb5a-4e30-80ea-574cf44da38f' where id in (
'3a7c6ea4-a240-4cf7-9726-8f1ec08dc54b',
'3e0a2ed3-19f8-4990-bb9c-086a226efeb7',
'460283f5-19d2-4638-a991-796c2c9007bd',
'478d028b-630d-4cec-918b-3f81e59fe7fe',
'71521434-c3ad-44c1-8529-aeb586407409',
'a8c88438-2605-4a85-9568-b3eed180776f',
'c66242c7-6194-46bf-b2db-d5a515b2a1d8',
'c85d35ee-8e75-48c5-8c0e-2c8b67549575',
'ca50a43e-f42e-4d99-970f-78812056e454',
'cd606e8a-a213-4b61-b1c1-28ab65992e42',
'df83c3d7-882f-4f9d-b98a-aae2027d3892',
'fc0573a3-43ed-4ef2-a898-670126c362bb'
 
)





select * from zone where locationid = 'a3d10490-fb5a-4e30-80ea-574cf44da38f'