select
POH.Created,
POH.Code POCODE,
POH.Description PODESC,
HU.Code HUCODE,
HU.DESCRIPTION HUDESC
 from PackingOrderHeader POH
inner join HandlingUnit HU on POH.HandlingUnitId = HU.id
inner join BusinessUnitPermission BUP on POH.id = BUP.PackingOrderHeaderId


where 
HU.DESCRIPTION not like POH.Description
and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin')
and poh.code in ('PO-000106','PO-000107','PO-000108','PO-000109','PO-000558','PO-000557')
order by poh.Created desc