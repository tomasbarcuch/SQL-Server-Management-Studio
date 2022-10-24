Declare @CRATES as bit = 0
Declare @PODEST as bit = 0
Declare @CARTONS as bit = 0
Declare @PALANDUNPAC as bit = 0

select 
BU.Name,
HU.Code,
HU.[Description],
DIMS.Project as 'Project',
DIMS.[Order] as 'Order',
DIMS.Commission as 'Commission',
HUTTRAN.Text as Typ,
Hu.ColliNumber,
HU.Length,
HU.Width,
HU.Height,
HU.Brutto Weight, 
HU.BaseArea, 
HU.Surface,
isnull(HUTTRAN.Text,HUT.Code)  as 'Typ',
WFE.Status,
WFE.Created,
DFV.Content as 'Zielland',
case CFV_Foil.Content 
when 'Alu,schrumpfen,schweissen,abdecken' then '3'
when 'schrumpfen,abdecken' then '2'
when 'abdecken' then '3' else
'0'+' '+CFV_Foil.Content  end
as Foil 

 from (
select * from (
select 
max(WFE.created)  over (PARTITION by WFE.EntityId,WFS.Name) as Created, 
WFE.EntityId,
WFE.BusinessUnitId,
isnull(T.text,WFS.Name) as Status 
from WorkflowEntry WFE 
INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id and WFS.Name in ('HuBox closed','BOX_CLOSED') and WFE.Entity = 11
LEFT join Translation T on WFE.StatusId = T.EntityId and T.[Language] = 'de' and T.[Column] = 'Name'
) data
group by EntityId, created,Data.[Status], BusinessUnitId) WFE


inner join BusinessUnit PA on WFE.BusinessUnitId = PA.Id and PA.[Id] = '5a73300c-1b1d-4ebe-9a7b-f335947ea422' --$P{PackerID}
INNER JOIN HandlingUnit HU ON WFE.EntityId = HU.Id
left join HandlingUnitType HUT on HU.TypeId = HUT.id
left join Translation HUTTRAN on HUT.id = HUTTRAN.EntityId and HUTTRAN.[Language]= 'de' and HUTTRAN.[Column] = 'Description'

INNER JOIN BusinessUnitPermission BUP ON HU.Id = BUP.HandlingUnitId  and BUP.BusinessUnitId = '2afb0812-aa09-4494-b2d3-777460852831' --$P{ClientBusinessUnitId} 
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id

inner join  (
Select EDVR.EntityId,D.name, DV.content from  EntityDimensionValueRelation EDVR 
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id
)SRC
pivot (max(SRC.Content) for SRC.Name   in ([Project],[Order],[Commission])) as Dims on HU.id = Dims.EntityId

INNER JOIN CustomField CF_TypOfHU ON BUP.BusinessUnitId = CF_TypOfHU.ClientBusinessUnitId and CF_TypOfHU.Name in ('TypeOfHU')
INNER JOIN CustomValue CFV_TypOfHU ON CF_TypOfHU.Id = CFV_TypOfHU.CustomFieldId and CFV_TypOfHU.EntityId = HU.Id

INNER JOIN CustomField CF_Foil ON BUP.BusinessUnitId = CF_Foil.ClientBusinessUnitId and CF_Foil.Name in ('Foil')
INNER JOIN CustomValue CFV_Foil ON CF_Foil.Id = CFV_Foil.CustomFieldId and CFV_Foil.EntityId = HU.Id

inner join EntityDimensionValueRelation EDVR on HU.id = EDVR.EntityId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join DimensionFieldValue DFV on DV.Id = DFV.DimensionValueId
inner join DimensionField DF on DFV.DimensionFieldId = DF.Id and DF.Name = 'GRAddressCountry'
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'

WHERE
(
(case when @PODEST = 1 and HUT.Code in ('PODEST') then 1 else 0 end =1)
or
(case when @CRATES = 1 and HUT.Code in ('KI','KI-OSB','KI-OSB - KDI','WOODEN CRATE','CRATE-Ply','CRATE') then 1 else 0 end =1)
or
(case when @CARTONS = 1 and HUT.Code like ('%Carton%') then 1 else 0 end =1)
or
(case when @PALANDUNPAC = 1 and HUT.Code in ('NON','PALLET','METAL_PALLET','EURO Palette') then 1 else 0 end =1)
or
(case when @PALANDUNPAC = 0 and  @PALANDUNPAC = 0 and @CARTONS = 0 and @CRATES = 0 and @PODEST = 0 then 1 else 0 end =1)
)

and WFE.Created BETWEEN '2020-09-01' and '2020-09-15'
 --and WFE.Created BETWEEN $P{Von}  and $P{Bis} 
--and HUT.Code in ('PODEST','PALETT','EURO Palette','METAL_PALLET') 
and HUT.Container = 0
