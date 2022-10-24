select
BU.name as Client,
POH.Code PackingOrder,
contnr.Content ContainerNr,
HUT.Container IsContainer,
sealnr.Content SealNr,
projdesc.[Description] ProjectDescription,
OrdD.Code OrderCode, 
ProjD.Code ProjectCode,
HU.Code HUCode, HU.[Description] HUDescription,HU.Length as HUlenght, HU.Width as HUWidth, HU.Height as HUHight, HU.Weight HUWeight ,HU.Netto HUNetto,HU.Brutto HUBrutto,
HUt.[Description] as HUType


from 

HandlingUnit HU 

left join ( Select EDVR.entityid, DV.Content as 'Code' from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Order'
) OrdD on hu.id = OrdD.EntityId

left join ( Select EDVR.entityid, DV.Content as 'Code' from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Project'
) ProjD on hu.id = ProjD.EntityId

left join ( Select EDVR.entityid, DV.Content as 'Description' from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Project'
) ProjDesc on hu.id = ProjDesc.EntityId

left join PackingOrderHeader POH on POH.HandlingUnitId = hu.id
left join HandlingUnitType HUT on hu.TypeId = HUT.Id

left join (select EntityId, Content from  customvalue where customfieldid in (select id from customfield where name = 'Container No.') and Entity = 11) contnr on hu.id = contnr.EntityId
left join (select EntityId, Content from  customvalue where customfieldid in (select id from customfield where name = 'Seal No.') and Entity = 11) sealnr on hu.id = sealnr.EntityId
inner join BusinessUnitPermission BUP on hu.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.[Type] = 2

where 
--($X{IN,HU.id,HuIDs})

hu.id in ('6647b552-a667-49bb-b5e4-1e2ba2f01773','bcbb5b29-588f-46b3-a27c-70abd989970f','964d4fc4-45da-4d3e-9811-ac0a85da99bc') 



