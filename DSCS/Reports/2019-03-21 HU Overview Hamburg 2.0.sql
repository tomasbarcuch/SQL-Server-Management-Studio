declare @id1 as UNIQUEIDENTIFIER
declare @id2 as UNIQUEIDENTIFIER
declare @id3 as UNIQUEIDENTIFIER
declare @id4 as UNIQUEIDENTIFIER

set @id1 = '7d9a0f2f-8a8e-4077-9b9c-d16c5e5fac53'
set @id2 = '26eeb0ed-63da-4dc9-95d2-246579ff3922'
--set @id3 = 'db3894eb-d835-4e90-b341-ece5da4a9836'
--set @id3 = '43c7ed0e-5c40-416c-9639-8517936e5bb2'
--set @id3 = '3b612ce2-567f-4c26-a926-103187167e23'
--set @id3 = 'f5eaa665-1512-4abc-a996-2ae1986c5909'
set @id3 = '7d9a0f2f-8a8e-4077-9b9c-d16c5e5fac53'
--set @id4 = 'f5eaa665-1512-4abc-a996-2ae1986c5909'
set @id4 = '7d9a0f2f-8a8e-4077-9b9c-d16c5e5fac53'
--set @id3 = NULL

select
BU.Name Client,
isnull(POH.Code,POHpart.Code) PackingOrder,
contnr.Content ContainerNr,
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
(case when @id3 is not null and (contcrate.conttid in (@id3) or contcrate.crateid in (@id3)) then 1 else 0 end) = 1
or
(case when @id4 is not null and (contcrate.conttid = (@id4) or contcrate.crateid = (@id4)) then 1 else 0 end) = 1


) DATA

left join HandlingUnit Container on data.conttid = Container.Id
left join HandlingUnitType HUT on Container.TypeId = HUT.Id
left join HandlingUnit Crate on data.crateid = Crate.Id
left join LoosePart Part on data.lpid = Part.id
left join LoosePart CratePart on data.cratepart = cratePart.id
where
(case when Container.Empty = 'TRUE' then 1 else 0 end) = 1
or 
(case when Container.Empty = 'FALSE' and ((crateid is not null and lpid is not null) or cratepart is not null) then 1 else 0 end) = 1
OR
(case when Container.Empty = 'FALSE' and ((crateid is not null or lpid is not null) or cratepart is not null) then 1 else 0 end) = 1

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


/*($X{IN,contcrate.conttid,HuIDs} or $X{IN,contcrate.crateid,HuIDs}) or
($X{IN,contcrate.conttid,HuIDs} or $X{IN,contcrate.crateid,HuIDs}) or
(contcrate.conttid =  $P{HuID}  or contcrate.crateid =  $P{HuID} ) */