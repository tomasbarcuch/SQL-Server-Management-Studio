/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
select 
data.*,
dimen.DVContent as [ProjektNr.],
CV_POS.content as Position

  from (select 
SL.ClientBusinessUnitId,
A.code as ChangeStatus,
SL.ENTITY as Entity,
SL.Id as LineID,
isnull(HU.id,lp.ID) as EntityID,
isnull(HU.Code,lp.Code) as EntityKode,
isnull(BHU.Code,Blp.Code) as Bin,
isnull(ZHU.name,ZLP.name) as Zone,
ST.DESCRIPTION as [Servis Line Beschreibung],
SL.[Description],
T.text as Status
 from ServiceLine SL
inner join ServiceType ST on SL.ServiceTypeid = ST.id
inner join status S on SL.statusid = S.Id
left outer join LoosePart LP on SL.EntityId = LP.Id and SL.Entity =  15
left outer join HandlingUnit HU on SL.EntityId = HU.Id and SL.Entity =  11
left outer join Bin BLP on LP.ActualBinId = BLP.Id
left outer join Bin BHU on HU.ActualBinId = BHU.Id
left outer join zone ZLP on BLP.ZoneId = ZLP.Id
left outer join zone ZHU on BHU.ZoneId = ZHU.id
left outer join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE' and s.disabled = 'false' 
left outer join BCSAction A on SL.ClientBusinessUnitId = A.ClientBusinessUnitId and A.BCSaction = 17 and a.code = '6176'

where 
--$X{IN,SL.id,ServiceLinesIDs} and  $P{ClientID} =  SL.ClientBusinessUnitId
SL.id in ('31874f11-ea40-4496-bbcf-00f3a9eba7f1','4a47696f-7215-4a14-b11d-00fde64ee2ad','620577af-ee1b-46be-b18c-01b6e355b043') 
and ST.disabled = 0
and ST.code in ('Lackierung','Nachträgliche Markierung','Nachträgliche Lackierung','Sondermarkierung','Nachträgliche Markierung','Sondermarkierung','Lackschaden')
and s.Name not in  ('SlStart','SlDone','SlEnd')
) as DATA


left outer join (
select
d.clientbusinessUnitID,
edvr.entityid as entityID,
edvr.entity as Entity,
d.name as DimensionName,
d.description as DimensionDescription , 
df.name as DFName,
dfv.content as DFVContent ,
dv.content as DVContent,
dv.description VDescritpion

 from 
 dbo.EntityDimensionValueRelation EDVR
 inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in  ('Kennwort')
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id
inner join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0) as DIMEN on DATA.ClientBusinessUnitId = DIMEN.ClientBusinessUnitId and DATA.EntityID = Dimen.entityID

left JOIN customfield CF_POS on data.ClientBusinessUnitId = CF_POS.clientbusinessunitid and CF_POS.name = 'Position' and CF_POS.Entity = Data.Entity
left JOIN customvalue CV_POS on CV_POS.customfieldid = CF_POS.Id and CV_POS.EntityId = data.EntityId
