begin TRANSACTION

--select NS.Code,
update NS set NS.Code =

LEFT(
Case NS.Entity
when 11 then 'HU'
when 15 then 'LP'
when 31 then 'SP'
when 35 then 'PO'
when 50 then 'COM'
when 37 then 'INV'
when 57 then 'TEN'
end +'-'+BU.Name,30)

from numberseries NS 
inner join BusinessUnitPermission BUP on NS.id = BUP.NumberSeriesId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.ID and BU.[Disabled] = 0

where 
NS.[Disabled] = 0 and 
Entity not in (1,7)

and LEFT(
Case NS.Entity
when 11 then 'HU'
when 15 then 'LP'
when 31 then 'SP'
when 35 then 'PO'
when 50 then 'COM'
when 37 then 'INV'
when 57 then 'TEN'
end +'-'+BU.Name,30) <> NS.Code

ROLLBACK