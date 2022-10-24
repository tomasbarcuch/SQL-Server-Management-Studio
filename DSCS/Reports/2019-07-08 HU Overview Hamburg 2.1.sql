select
BU.name as Client,
isnull(POH.Code,POHpart.Code) PackingOrder,
contnr.Content ContainerNr,
HUT.Container IsContainer,
sealnr.Content SealNr,
projdesc.[Description] ProjectDescription,
OrdD.Code OrderCode, 
ProjD.Code ProjectCode,
container.id contid,
crate.id crateid,
part.id partid,
Container.Code ContainerCode, Container.[Description] ContainerDescription, container.Length containerLength, container.Width containerWidth, container.Height containerHeight, container.Weight containerWeight,container.Netto containerNetto,container.Brutto containerBrutto,
hut.[Description] as ContainerType,
crate.Code crateCode, crate.[Description] crateDescription,crate.Length as cratelenght, crate.Width as crateWidth, crate.Height as CrateHight, crate.Weight CrateWeight ,crate.Netto crateNetto,crate.Brutto crateBrutto,
Cratet.[Description] as CrateType,
part.code partcode, part.[Description]  partDescription,part.Length partLength,part.Width partWidth, part.Height partHeight , part.Weight partWeight

from (
select
case when (hut.Container is not null and crate.id is not null) then Container.id else crate.id end as ContainerID, 
case when ((hut.Container is null or hut.Container = 0) and crate.id is null) then Container.id else crate.id end as CrateID, 
isnull(part.id, cratepart.id) as PartID from 
(select conttid,crateid, part.lpid, contpart.lpid as cratepart from (
select 
HU.id conttid, 
HU.TopHandlingUnitId,
crate.crateid
from HandlingUnit HU 
left join (select HU.id crateid, HU.TopHandlingUnitId from HandlingUnit HU) crate on HU.id = crate.TopHandlingUnitId) contcrate
left join (select lp.id lpid,LP.ActualHandlingUnitId, LP.TopHandlingUnitId from LoosePart LP) part on contcrate.crateid = part.ActualHandlingUnitId and contcrate.conttid = part.TopHandlingUnitId
left join (select lp.id lpid,LP.ActualHandlingUnitId, LP.TopHandlingUnitId from LoosePart LP) contpart on contcrate.conttid = contpart.ActualHandlingUnitId and contcrate.conttid = contpart.TopHandlingUnitId
where 
--($X{IN,contcrate.conttid,HuIDs} or $X{IN,contcrate.crateid,HuIDs})
contcrate.conttid in ('76a57c63-6239-4d2a-99bf-db12c86ab603') or contcrate.crateid in ('76a57c63-6239-4d2a-99bf-db12c86ab603')
--contcrate.conttid in ('6647b552-a667-49bb-b5e4-1e2ba2f01773','bcbb5b29-588f-46b3-a27c-70abd989970f','964d4fc4-45da-4d3e-9811-ac0a85da99bc')  or contcrate.crateid in ('6647b552-a667-49bb-b5e4-1e2ba2f01773','bcbb5b29-588f-46b3-a27c-70abd989970f','964d4fc4-45da-4d3e-9811-ac0a85da99bc')
) DATA

left join HandlingUnit Container on data.conttid = Container.Id
left join HandlingUnitType HUT on Container.TypeId = HUT.Id
left join HandlingUnit Crate on data.crateid = Crate.Id
left join LoosePart Part on data.lpid = Part.id
left join LoosePart CratePart on data.cratepart = cratePart.id
 
where
(case when Container.Empty = 1 then 0 else 1 end) = 1
--or (case when Container.Empty = 0 and ((crateid is not null and lpid is not null) or cratepart is not null) then 1 else 0 end) = 1
--or (case when Container.Empty = 0 and ((crateid is not null or lpid is not null) or cratepart is not null) then 1 else 0 end) = 1
or (case when Container.Empty = 0 and ((crateid is not null or lpid is not null) or cratepart is not null) and HUT.Container is null then 1 else 0 end) = 1
) data

left join HandlingUnit Container on data.ContainerID = container.id
left join HandlingUnitType HUT on Container.TypeId = HUT.Id
left join HandlingUnit Crate on data.CrateID = crate.Id
left join HandlingUnitType CRATET on Crate.TypeId = CRATET.Id
left join LoosePart Part on data.PartID = Part.id


left join ( Select EDVR.entityid, DV.Content as 'Code' from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Order'
) OrdD on isnull(data.ContainerID,data.CrateID) = OrdD.EntityId

left join ( Select EDVR.entityid, DV.Content as 'Code' from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Project'
) ProjD on isnull(data.ContainerID,data.CrateID) = ProjD.EntityId

left join ( Select EDVR.entityid, DV.Content as 'Description' from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id and d.name = 'Project'
) ProjDesc on isnull(data.ContainerID,data.CrateID) = ProjDesc.EntityId

left join PackingOrderHeader POH on POH.HandlingUnitId = isnull(data.ContainerID, data.CrateID)
left join (select POL.LoosePartId, HandlingUnitId, PackingOrderHeaderId from PackingOrderLine POL) POL on POH.Id = POL.PackingOrderHeaderId and pol.LoosePartId = data.PartID
left join PackingOrderHeader POHpart on POL.PackingOrderHeaderId = POHpart.id

left join (select EntityId, Content from  customvalue where customfieldid in (select id from customfield where name = 'Container No.') and Entity = 11) contnr on data.ContainerID = contnr.EntityId
left join (select EntityId, Content from  customvalue where customfieldid in (select id from customfield where name = 'Seal No.') and Entity = 11) sealnr on data.ContainerID = sealnr.EntityId
left join (select EntityId, Content from  customvalue where customfieldid in (select id from customfield where name = 'Container No.') and Entity = 11) contnrcrate on data.CrateID = contnrcrate.EntityId
left join (select EntityId, Content from  customvalue where customfieldid in (select id from customfield where name = 'Seal No.') and Entity = 11) sealnrcrate on data.CrateID = sealnrcrate.EntityId
inner join BusinessUnitPermission BUP on ISNULL(ContainerID,CrateID) = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.[Type] = 2


order by container.code