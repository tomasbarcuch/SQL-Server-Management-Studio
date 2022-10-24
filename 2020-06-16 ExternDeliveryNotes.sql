
select 
ExtSup.ExtSupN
,ExtSup.ExtSup
,ExtSup.DeliveryDate
,ExtSup.LoadingDate
,ExtSup.FromLocation
,ExtSup.ToLocation
,ExtSup.[Status]
,LP.Code
,LP.[Description]
,WC.QuantityBase
,LP.Weight
,LP.Length
,LP.Width
,LP.Height
,Dimensions.[External Supplier]
,Dimensions.[External Supply]
,isnull(Dimensions.Project,cus.Project) as Project
,Cus.Name CF_Name
,Cus.Note CF_Note
,Cus.Project CF_Project
,Cus.Supplier CF_Supplier
,ExtSup.TruckNumber TruckNumber
from 
(select
isnull(t.text,S.Name) Status,
DV.DimensionId,
DV.Content 'ExtSupN',
DV.[Description] 'ExtSup', 
--D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
--inner join Dimension D on DF.DimensionId = D.id and D.name = 'External supply'

inner join [Status] S on DV.StatusId = S.id
left join Translation T on S.id = T.EntityId and [Language] = 'cs' and T.[Column] = 'name'
where 
DV.Id in ('caf0b09c-0e06-40d2-b760-138334f83a38','d4d785a5-0042-4460-a4b7-df882b43f248') and
--DV.Id in ('d4d785a5-0042-4460-a4b7-df882b43f248') and
DF.name in (
'LoadingDate',
'DeliveryDate',
'FromLocation',
'ToLocation',
'TruckNumber'
))SRC
pivot (max(SRC.Content) for SRC.Name   in (
[LoadingDate],
[DeliveryDate],
[FromLocation],
[ToLocation],
[TruckNumber]

)) as ExtSup

inner join LoosePart LP on ExtSup.EntityId = LP.id
inner join WarehouseContent WC on LP.id = WC.LoosePartId

left join (
select D.name, DV.[Description]+' '+'['+DV.Content+']' as Content, edvr.EntityId from DimensionValue DV 
left join Dimension D on DV.DimensionId = D.id 
left join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
left join DimensionField DF on D.id = DF.DimensionId


where D.name in ('Project','External Supplier','External Supply')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[External Supplier],[External Supply])
        ) as Dimensions on lp.id = dimensions.EntityId

left join (select 
CV.EntityId,
CV.Content,
CF.Name FName 
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('Project','Name','Supplier','Note')) SRC
PIVOT (max(SRC.Content) for SRC.fname in ([Project],[Name],[Supplier],[Note])) as CUS on LP.id = Cus.EntityId

