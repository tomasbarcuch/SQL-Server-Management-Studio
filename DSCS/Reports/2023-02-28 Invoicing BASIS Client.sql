select 

distinct count(HU.Code) HandlingUnits
,U.LOGIN
from HandlingUnit hu

inner join BusinessUnitPermission BUP on hu.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name like 'BASIS Client' )
inner join [User] U on HU.CreatedById = U.Id
--INNER JOIN WarehouseEntry we ON hu.id = we.HandlingUnitId
WHERE HU.Created BETWEEN '2023-03-01' AND '2023-03-31' and --and we.QuantityBase > 0.00000
 HU.CreatedById in (
select id from [User] where login in (
'alex.myshkin',
'alexander.nelde',
'arnold.orovecz',
'bora.abshagen',
'cengiz.arikan',
'gentiana.muja',
'gyoergy.venyerscan',
'christian.libke',
'jan.naujoks',
'janka.selbmann',
'josef.aumer',
'klaus.hornischer',
'lenka.grabsch',
'lulzim.krasniqui',
'maria.pasat',
'masse.date.kokouvi',
'michael.schmid',
'milan.obradovic',
'noemi.nicoara',
'peter.varnai',
'srboljub.kostic',
'tobias.beer'

 ))
group by U.[Login]