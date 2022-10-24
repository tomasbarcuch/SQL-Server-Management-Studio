
select --top 100
CUSF.[2HU]
,LP.Code
,LP.[Description] 'Bemerkung'
,DIMF.[Customer project] 'Projekt'
,CUSF.KdAPos 
,ISNULL(T.Text,s.name) Status
,L.name  'Aktuelle Location'
,B.Code 'Aktuelles Lagerplatz'
,ActHU.Code'Aktuelle Handling Unit'
,case when LP.ActualHandlingUnitId = LP.TopHandlingUnitId then NULL else TopHU.code end  'Top Handling Unit'
,LP.Updated 'Aktualisiert am'
--,case when len(CUSF.Ampel)>0 then 1 else 0 end as Ampel
 from LoosePart LP
inner join status S on LP.StatusId = S.id
left join Translation T on S.id = T.EntityId and T.[Language] = 'de' and [Column] = 'Name'
left join [Location] L on LP.ActualLocationId = L.Id
left join Bin B on LP.ActualBinId = B.id
left join HandlingUnit ActHU on LP.ActualHandlingUnitId = ActHU.Id
left join HandlingUnit TopHU on lp.TopHandlingUnitId = TopHU.id

inner join  BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId =  
(select id from BusinessUnit BU where BU.Name = 'Siemens Nürnberg')

left join (
select 
D.name, 
--Case D.name when 'Project' then DV.Content+' '+isnull(DV.[Description],'.') else DV.Content end as Content, 
DV.Content+' '+isnull(DV.[Description],'') as content,
--DV.Content, 
edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Customer project','Order') 
) SRC
PIVOT (max(src.Content) for src.Name  in ([Customer project],[Order])
        ) as DIMF on LP.Id = DIMF.EntityId



left join (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Ampel','KdAPos','2HU')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([Ampel],[KdAPos],[2HU])) as CUSF on LP.id = CUSF.EntityId
where len(CUSF.Ampel)>0 and S.name in ('LpNew')

