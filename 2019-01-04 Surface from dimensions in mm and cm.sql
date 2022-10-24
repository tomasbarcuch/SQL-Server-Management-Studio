
select
hu.id,
hu.code, 
bu.name,
bu.type,
--uc.[Login],
--ue.[Login],
Width,
Length,
Height,
cast(0.000002*(cast (Width as decimal)*cast(Length as decimal)+cast (Width as decimal)*cast(Height as decimal)+ cast( Length as decimal)* cast(Height as decimal)) as decimal(20,2)) as surface_calc_mm,
cast(0.0002*(cast (Width/10 as int)*cast(Length/10 as int)+cast (Width/10 as int)*cast(Height/10 as int)+ cast( Length/10 as int)* cast(Height/10 as int)) as decimal(20,2)) as surface_calc_cm,
surface surface_dscs,
round(0.000002*(cast (Width as decimal)*cast(Length as decimal)+cast (Width as decimal)*cast(Height as decimal)+ cast( Length as decimal)* cast(Height as decimal))- surface,1) as Difference
 from HandlingUnit HU
inner join [User] Uc on HU.CreatedById = Uc.Id
inner join [User] Ue on HU.updatedById = Ue.Id
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.type = 0
where 
--width+Weight+Length >0 
round(0.000002*(cast (Width as decimal)*cast(Length as decimal)+cast (Width as decimal)*cast(Height as decimal)+ cast( Length as decimal)* cast(Height as decimal))- surface,1) > 1
and
 bu.name = 'Deufol Hamburg Rosshafen'

/*
update handlingunit set surface = 23.69 where id = 'f3f1612f-a506-4317-98c5-018342cca77c'
update handlingunit set surface = 11.14 where id = '4e9916d8-e581-425a-a646-0c604cc579f2'
update handlingunit set surface = 37.69 where id = '1116413b-185b-44ca-a61d-1e265e709ad5'
update handlingunit set surface = 138.5 where id = '71822a14-d843-44c2-9cbe-227f0ee4d1c8'
update handlingunit set surface = 69.56 where id = 'ed024961-bf3a-48e0-83e9-2b1b199f3443'
update handlingunit set surface = 86.1 where id = 'c4fb04af-c70c-4cca-96df-38a385d45fb1'
update handlingunit set surface = 138.5 where id = '3998709e-d6cb-4ddb-87ba-5b58390aa5e2'
update handlingunit set surface = 60.4 where id = '19d81ffd-c382-418d-862a-70d100645432'
update handlingunit set surface = 115.14 where id = 'd5e7ed50-de3a-46cb-bafa-7dc254b4be52'
update handlingunit set surface = 86.1 where id = '4100670a-4fe0-4651-8eb8-8d0f00b1ef71'
update handlingunit set surface = 22.23 where id = '0f356640-1372-4948-bf67-a4357c49e370'
update handlingunit set surface = 7.26 where id = 'df273e4c-47ad-49cf-92a9-b8373fb2c63f'
update handlingunit set surface = 69.56 where id = '2ff4c20d-a460-4238-8c32-ef0aa8e71442'
update handlingunit set surface = 27.56 where id = '967419b8-bdff-4c6e-b5f4-fa3366a93590'
update handlingunit set surface = 104.47 where id = '683c5a69-3dbb-4fbb-9543-fd957e0cd392'

*/