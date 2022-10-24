select 
hu.code,
 cast (HU.Length as nvarchar) +' mm' as Lenght,
 --cast(round(cast (HU.Length as decimal) /10,0) as int) Length_rounded,
 cast(ceiling(cast (hu.Length as decimal) /10) as nvarchar) + ' cm'   Lenght_ceiled,

  cast ( hu.Width as nvarchar) +' mm' as Width,
 --cast(round(cast (hu.Width as decimal) /10,0) as int),
 cast(ceiling(cast (hu.Width as decimal) /10) as nvarchar) + ' cm' width_ceiled,
 cast ( hu.Height as nvarchar) +' mm' Height,
 --cast(round(cast (hu.height as decimal) /10,0) as int),
 cast(ceiling(cast (hu.Height as decimal) /10) as nvarchar) + ' cm'  height_ceiled
from handlingunit HU 
inner join BusinessUnitPermission BUP on HU.id = bup.HandlingUnitId
where 
(HU.Length/10 <> cast(round(cast (HU.Length as decimal) /10,0) as int)
OR
HU.Width/10 <> cast(round(cast (HU.Width as decimal) /10,0) as int)
OR
HU.Height/10 <> cast(round(cast (HU.Height as decimal) /10,0) as int))

and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
and hu.ActualLocationId is not null
--where code = '0001500037250027'