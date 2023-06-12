select BU.Name As Client,U.Login CreatedBy,   COUNT(HU.Id) InboundedHandlingUnits FROM HandlingUnit HU



INNER JOIN (
select distinct WE.HandlingUnitId, WE.CreatedById from WarehouseEntry WE  

where WE.Created between '2023-02-01' AND '2023-02-28' AND we.QuantityBase > 0.00000 AND  we.CreatedById in (
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
 ))) DATA on HU.id = DATA.HandlingUnitId
inner join [User] U on DATA.CreatedById = U.Id 
inner join BusinessUnitPermission BUP on DATA.HandlingUnitId = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name like 'BASIS Client' )
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type = 2
group by BU.Name,U.Login


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


select BU.Name As Client,U.Login CreatedBy,   COUNT(HU.Id) InboundedHandlingUnits FROM HandlingUnit HU
inner join BusinessUnitPermission BUP on hu.Id = BUP.HandlingUnitId and BUP.BusinessUnitId = (select id from BusinessUnit where name like 'BASIS Client' )
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.type = 2
inner join [User] U on HU.UpdatedById = U.Id 
 where HU.ID in (
select distinct WE.HandlingUnitId from WarehouseEntry WE  

where WE.Created between '2023-02-01' AND '2023-02-28' AND we.QuantityBase > 0.00000 AND  we.CreatedById in (
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
 )))

 group by BU.Name,U.Login
