select 
case  ent 
when 'BCS' then code 
when 'L' then code
when 'B' then code
when 'BU' then code
else cast(id as varchar(40)) end as id,code, ent from(
select id,code, 'LP' ent from LoosePart
union
select id,code, 'HU' from HandlingUnit
union
select id,code, 'SH' from ShipmentHeader
union
select id,code, 'PO' from PackingOrderHeader
union
select id, description, 'SL' from ServiceLine
union
select id,text, 'CM' from Comment
union
select id,name, 'A' from Address
union
select id,code, 'L' from [Location]
union
select id,code, 'B' from Bin
union
select id,code, 'BCS' from BCSAction
union
select id,[Login], 'U' from [User]
union
select id,name, 'BU' from BusinessUnit

) entity

where UPPER (id) in ('28fcbcac-19f1-4717-b835-bd3d333e45cd','ef431c88-dfa7-4b9b-8ccd-044dc112b44d')



select id from LoosePart