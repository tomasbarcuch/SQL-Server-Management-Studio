
select  HU.ColliNumber, HU.Code, isnull(L.code,TL.Code) Location, SH.Code Shipment, T.text as status, ParHU.code as parhu, TopHU.code as tophu  from HandlingUnit HU
left join HandlingUnit ParHU on HU.ParentHandlingUnitId = ParHU.id
left join HandlingUnit TopHU on HU.TopHandlingUnitId = TopHU.id
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.name = 'Krones AG'
left join [Location] L on HU.ActualLocationId = L.id
left join ShipmentHeader SH on HU.ShipmentHeaderId = SH.Id
left join [Status] S on SH.StatusId = S.Id
left join Translation T on S.id = T.EntityId and T.[Language] = 'en'
left join [Location] TL on SH.ToLocationId = TL.Id
where 
--HU.ActualLocationId is not null and
HU.ColliNumber in (
'513'
)

order by sh.Code, tophu.code, parhu.Code, HU.ColliNumber
