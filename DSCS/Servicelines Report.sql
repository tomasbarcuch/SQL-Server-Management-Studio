select 
data.*,
CV_POS.content as Position
 from
(select
SL.ClientBusinessUnitId,
A.code as ChangeStatus,
SL.ENTITY as Entity,
--isnull(CV_POS.Content,CV_poshu.Content) as Position,
SL.Id as LineID,
isnull(HU.id,lp.ID) as EntityID,
isnull(HU.Code,lp.Code) as EntityKode,
isnull(BHU.Code,Blp.Code) as Bin,
isnull(ZHU.name,ZLP.name) as Zone,
ST.DESCRIPTION as [Servis Line Beschreibung],
SL.[Description],
DimVAl.content as [ProjektNr.],
T.text as Status



from ServiceLine SL
inner join ServiceType ST on SL.ServiceTypeid = st.id
inner join status S on SL.statusid = S.Id

left join LoosePart LP on SL.EntityId = LP.Id and SL.Entity =  15
left join HandlingUnit HU on SL.EntityId = HU.Id and SL.Entity =  11
left OUTER join Bin BLP on LP.ActualBinId = BLP.Id
left outer join Bin BHU on HU.ActualBinId = BHU.Id
left outer join zone ZLP on BLP.ZoneId = ZLP.Id
left outer join zone ZHU on BHU.ZoneId = ZHU.id
left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE' and s.disabled = 'false'
  JOIN Dimension AS Dim		ON SL.[ClientBusinessUnitId] = Dim.[ClientBusinessUnitId] AND Dim.Name = 'Project'
  JOIN DimensionValue AS DimVal	ON Dim.[Id] = DimVal.[DimensionId]
   JOIN [EntityDimensionValueRelation]	AS Edvr		ON Edvr.[DimensionValueId] = DimVal.Id AND Edvr.[Entity] in ('11','15') AND Edvr.[EntityId] = Lp.Id  
   inner join dbo.DimensionValue DV on EDVR.DimensionValueId =  DV.Id
 inner join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name = 'Kennwort'
 inner join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id

LEFT join BCSAction A on SL.ClientBusinessUnitId = A.ClientBusinessUnitId and A.BCSaction = 17 and a.code = '6176'

WHERE 
SL.ClientBusinessUnitId =  $P{ClientID} and
$X{IN,SL.id,ServiceLinesIDs} and
 ST.code in (
    'Lackierung',
    'Nachträgliche Markierung',
    'Nachträgliche Lackierung',
    'Sondermarkierung',
    'Nachträgliche Markierung',
    'Sondermarkierung',
    'Lackschaden'
) and ST.disabled = 0 
  and s.Name not in  ('SlStart','SlDone','SlEnd')
  ) data

left JOIN customfield CF_POS on data.ClientBusinessUnitId = CF_POS.clientbusinessunitid and CF_POS.name = 'Position' and CF_POS.Entity = Data.Entity
left JOIN customvalue CV_POS on CV_POS.customfieldid = CF_POS.Id and CV_POS.EntityId = data.EntityId

select id from ServiceLine