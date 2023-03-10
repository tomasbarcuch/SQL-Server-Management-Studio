use [DFCZ_OSLET_TST]
SELECT
z.name as Zone,
z.description 'Zone Description',
b.code as Bin,
b.description 'Bin Description',
l.Code Location,
l.name as 'Location Description',
case l.onsite
when 0 then 'in house'
when 1 then 'on site'
else 'x' end as onsite

  FROM dbo.Bin B
  left outer join Zone z on b.zoneid = z.id
  left outer join Location L on B.locationid = L.id

  where B.ClientBusinessUnitId = 'AD5A5F6B-8EC4-463B-836A-0A8CB60A39D2' and b.disabled = 0