select 

distinct count(HU.Code)

from HandlingUnit hu

inner join BusinessUnitPermission BUP on hu.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name like 'BASIS Client' )
--INNER JOIN WarehouseEntry we ON hu.id = we.HandlingUnitId
WHERE HU.Created BETWEEN '2023-02-01' AND '2023-02-28' and --and we.QuantityBase > 0.00000
 HU.CreatedById in (
select id from [User] where login in (
 'alex.myshkin',
 'alexander.nelde',
 'arnold.orovecz',
 'bora.abshagen',
 'cengiz.arikan',
 'christian.libke',
 'gyoergy.venyerscan',
 'jan.naujoks',
 'janka.selbmann',
 'klaus.hornischer',
 'lenka.grabsch',
 'maria.pasat',
 'masse.date.kokouvi',
 'milan.obradovic',
 'peter.varnai',
 'srboljub.kostic',
 'tobias.beer'
 ))
