
use boxcad
SELECT ComissionNr as KistenNr,
Content1 description,
min(DateOfRecord) changed,
Users.Name 'user'
  FROM [VVInterface]
inner join BoxOrder on replace(VVInterface.ComissionNr,'-','') = BoxOrder.Code
inner join Users on BoxOrder.IDXUser = Users.IDX
  where ComissionNr in (
      '00015-00035356-002',
      '00015-00035356-001',
      '00015-00035356-004',
      '00015-00035356-003',
      '00015-00035833-019',
      '00015-00035833-020'
      )
      group by ComissionNr,
Content1,Users.Name
order by ComissionNr, min(DateOfRecord)

/*
SELECT ComissionNr,
count(distinct Content1),
min(DateOfRecord)
  FROM [VVInterface]

       group by ComissionNr

       having count(distinct Content1) > 1

SELECT ComissionNr,
Content1,
min(DateOfRecord)
  FROM [VVInterface]

  where ComissionNr in (
    SELECT ComissionNr
  FROM [VVInterface]
       group by ComissionNr

       having count(distinct Content1) > 1
      )


      group by ComissionNr,
Content1

order by ComissionNr, min(DateOfRecord)
*/