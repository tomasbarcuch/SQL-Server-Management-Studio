
select --top 100
CUSF.[2HU]
,LP.Code
,LP.[Description] 'Bemerkung'
,DIMF.[Customer project] 'Projekt'
,CUSF.KdAPos 
,ISNULL(Tlp.Text,slp.name) Status
,L.name  'Aktuelle Location'
,B.Code 'Aktuelles Lagerplatz'
,ActHU.Code'Aktuelle Handling Unit'
,case when LP.ActualHandlingUnitId = LP.TopHandlingUnitId then NULL else TopHU.code end  'Top Handling Unit'
,LP.Updated 'Aktualisiert am'

--,Shu.Name as 'StatusHU'
--,case when len(CUSF.Ampel)>0 then 1 else 0 end as Ampel
 from LoosePart LP
inner join status Slp on LP.StatusId = Slp.id
left join Translation Tlp on Slp.id = Tlp.EntityId and Tlp.[Language] = 'de' and Tlp.[Column] = 'Name'
left join [Location] L on LP.ActualLocationId = L.Id
left join Bin B on LP.ActualBinId = B.id
inner join HandlingUnit ActHU on LP.ActualHandlingUnitId = ActHU.Id
inner join status Shu on ActHU.StatusId = Shu.id
left join Translation Thu on Shu.id = Thu.EntityId and Thu.[Language] = 'de' and Thu.[Column] = 'Name'
left join HandlingUnit TopHU on lp.TopHandlingUnitId = TopHU.id

inner join  BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.BusinessUnitId =  
(select id from BusinessUnit BU where BU.Name = 'Siemens Nürnberg')

left join (
select 
D.name, 
DV.Content+' '+isnull(DV.[Description],'') as content,
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
where Slp.name in ('Lppacked') and Shu.name not in ('HuPacked')

