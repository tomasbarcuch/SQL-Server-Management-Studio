
select 
case 
sh.type 
when 0 then 'Loading'
when 1 then 'Unolading'
end as type,
SH.code, 
HU.code HU,
HU.[Description] HUDescription,
HU.ColliNumber,
HU.SerialNo,
LocFrom.Code LocFrom,
LocTo.Code LocTo,
SH.created, 
sl.created from shipmentline SL
inner join shipmentheader SH on SL.ShipmentHeaderId = SH.id
left join [Location] LocFrom on SH.FromLocationId = LocFrom.id
inner join [Location] LocTo on SH.ToLocationId = LocTo.id
inner join HandlingUnit HU on SL.HandlingUnitId = HU.Id
where SL.HandlingUnitId = '636e644f-bc4f-433e-8e37-0f4e399abf00'
order by SH.code, Sh.type, sl.created



select 
case 
sh.type 
when 0 then 'Loading'
when 1 then 'Unolading'
end as type,
SH.code, 
LP.code LP,
LP.[Description] LPDescription,
'',
LP.SerialNo,
LocFrom.Code LocFrom,
LocTo.Code LocTo,
SH.created, 
sl.created from shipmentline SL
inner join shipmentheader SH on SL.ShipmentHeaderId = SH.id
inner join [Location] LocFrom on SH.FromLocationId = LocFrom.id
inner join [Location] LocTo on SH.ToLocationId = LocTo.id
inner join LoosePart LP on SL.LoosePartId = LP.Id
where SL.LoosePartId = 'e566c032-0caa-4a02-91d2-b64bac05ed7f'
order by SH.code, Sh.type, sl.created


select 
case 
sh.type 
when 0 then 'Loading'
when 1 then 'Unolading'
end as type,
SH.code, 
HU.code HU,
HU.[Description] HUDescription,
HU.ColliNumber,
HU.SerialNo,
LocFrom.Code LocFrom,
LocTo.Code LocTo,
SH.created headercreated, 
sl.created linecreated from shipmentline SL with (nolock)
inner join shipmentheader SH on SL.ShipmentHeaderId = SH.id
left join [Location] LocFrom on SH.FromLocationId = LocFrom.id
inner join [Location] LocTo on SH.ToLocationId = LocTo.id
left join HandlingUnit HU on SL.HandlingUnitId = HU.Id
where SL.HandlingUnitId = (select tophandlingunitid from LoosePart where id = 'e9c8d76f-966c-492d-8ff8-1ab26402b1dc')
or SL.HandlingUnitId = 'e9c8d76f-966c-492d-8ff8-1ab26402b1dc'
or SL.HandlingUnitId in (select ParentHandlingUnitId id from WarehouseEntry where HandlingUnitId = 'e9c8d76f-966c-492d-8ff8-1ab26402b1dc' and ParentHandlingUnitId is not null
group by ParentHandlingUnitId)
or SL.HandlingUnitId in (select ParentHandlingUnitId id from WarehouseEntry where HandlingUnitId = (select tophandlingunitid from LoosePart where id = 'e9c8d76f-966c-492d-8ff8-1ab26402b1dc') and ParentHandlingUnitId is not null
group by ParentHandlingUnitId)
order by SH.code, Sh.type, sl.created

