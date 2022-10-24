
select
hu.code, 
HU.Length, 
HU.width,
HU.height,
round(HU.Length*BasicUnitCoef,BasicUnitDec)LenghtR,
round(HU.width*BasicUnitCoef,BasicUnitDec)WidthR,
round(HU.height*BasicUnitCoef,BasicUnitDec)HeightR,
(cast(HU.Length as decimal)*cast(HU.width as decimal)*2+
cast(HU.width as decimal)*cast(HU.height as decimal)*2+
cast(HU.Length as decimal)*cast(HU.height as decimal)*2
)/1000000 SurfaceUnrouded,

(round(HU.Length*BasicUnitCoef,BasicUnitDec)*round(HU.width*BasicUnitCoef,BasicUnitDec)*2+
round(HU.width*BasicUnitCoef,BasicUnitDec)*round(HU.height*BasicUnitCoef,BasicUnitDec)*2+
round(HU.Length*BasicUnitCoef,BasicUnitDec)*round(HU.height*BasicUnitCoef,BasicUnitDec)*2)/10000 SurfaceRounded
from HandlingUnit HU
inner join BusinessUnitPermission BUP on HU.id = bup.HandlingUnitId
, DisplayUOM DUOM 

where DUOM.code = 'CM x KG Berlin'
and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
--and hu.code = '0001500035449018'


/*declare @nr as INT
set @nr = 1234
select
@nr, 
round(@nr*BasicUnitCoef,BasicUnitDec),
* from DisplayUOM
where code = 'CM x KG Berlin'
*/