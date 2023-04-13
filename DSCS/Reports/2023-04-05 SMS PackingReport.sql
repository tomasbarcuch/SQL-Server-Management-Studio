select

LP.Code 'Versandeinheit'
,CAST(LP.InboundDate as DATE) 'WE Sammelkiste'
,Dimensions.Project 'Projekt'
,Dimensions.Description 'Projekt Name'
,POH.Code 'VE Aufmass'
,CAST(Closed.LastCreated as DATE) 'VE verpackt'
,CAST(Packed.FirstCreated as DATE) 'VE gestaut'
,CAST(Shipped.FirstCreated as DATE) 'Ve Verschifft'

from loosepart LP
inner join BusinessUnitPermission BUP on LP.Id = BUP.LoosePartId and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'SMS Group')
LEFT JOIN PackingOrderLine POL on LP.ActualHandlingUnitId = POL.HandlingUnitId
LEFT JOIN PackingOrderHeader POH on POL.PackingOrderHeaderId = POH.Id


LEFT JOIN  (
select
MIN(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated,
MAX(WFE.created)  over (PARTITION by WFE.EntityId) as LastCreated,  
Wfe.Created,
WFE.EntityId
--,U.FirstName+' '+U.LastName [User],
--BU.Name as BU
from WorkflowEntry WFE  WITH (NOLOCK)
--inner join [User] U on WFE.CreatedById = u.Id
--inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'HuBox closed'
) and WFE.Entity = 11
) Closed on (Select ACTHU.ParentHandlingUnitId FROM LoosePart LPI left join HandlingUnit ACTHU on LPI.ActualHandlingUnitId = ACTHU.Id where LPI.Id = LP.Id) = Closed.EntityId and Closed.LastCreated = Closed.Created

LEFT JOIN  (
select
MIN(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated,
MAX(WFE.created)  over (PARTITION by WFE.EntityId) as LastCreated,  
Wfe.Created,
WFE.EntityId
--,U.FirstName+' '+U.LastName [User],
--BU.Name as BU
from WorkflowEntry WFE  WITH (NOLOCK)
--inner join [User] U on WFE.CreatedById = u.Id
--inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'HuShipped'
) and WFE.Entity = 11
) Shipped on LP.TopHandlingUnitId = Shipped.EntityId and Shipped.FirstCreated = Shipped.Created

LEFT JOIN  (
select
MIN(WFE.created)  over (PARTITION by WFE.EntityId) as FirstCreated,
MAX(WFE.created)  over (PARTITION by WFE.EntityId) as LastCreated,  
Wfe.Created,
WFE.EntityId
--,U.FirstName+' '+U.LastName [User],
--BU.Name as BU
from WorkflowEntry WFE  WITH (NOLOCK)
--inner join [User] U on WFE.CreatedById = u.Id
--inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
where WFE.StatusId in (select id from status where name = 'HuBoxPackedIn'
) and WFE.Entity = 11
) Packed on (Select ACTHU.ParentHandlingUnitId FROM LoosePart LPI left join HandlingUnit ACTHU on LPI.ActualHandlingUnitId = ACTHU.Id where LPI.Id = LP.Id) = Packed.EntityId
 and Packed.LastCreated = Packed.Created



INNER JOIN (
select D.name, DV.[Description],DV.Content as Content, edvr.EntityId from DimensionValue DV 
left join Dimension D on DV.DimensionId = D.id 
left join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId

where DV.Id in (select id from DimensionValue where Content = 'A02955L210.20.1000')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project])
        ) as Dimensions on LP.id = Dimensions.EntityId

        --WHERE Dimensions.Description = 'TRAESUEZ'
         --and LP.Code = 'LP030-004493'