select 
LP.code as Loosepart,
LP.[Description], 
WC.QuantityBase,
CF.MaterialNo,
S.Name as Status, 
WF.Updated as StatusChanged, 
getdate() as currentdate,
DATEDIFF(hh,WF.Updated,getdate()) as DurationHours,
L.Code as Location, 
D.Project,
D.[Order],
D.Commission
from loosepart LP
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.Name = 'Krones AG' 
inner join [Status] S on LP.StatusId = S.id and s.name = 'LpUnpacked'

--tady omezím vícenásobné změny stavu
inner join (select max(wf.updated) updated, wf.EntityId from WorkflowEntry WF where wf.Entity = 15 group by wF.EntityID) as WF on LP.id = WF.EntityId

--tady rozšířím lokaci o Freising
inner join Location L on LP.ActualLocationId = L.Id and L.Code in ('UMB', 'FREISING')

--tady připojím množtsví na skladu
inner join WarehouseContent WC on LP.id = WC.LoosePartId

--tady připojím pře pivot strukturu dimenzí project, order a commission
inner join  (
select D.name, DV.Content, edvr.EntityId from DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.id 
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
where D.name in ('Project','Order','Commission')
) SRC
PIVOT (max(src.Content) for src.Name  in ([Project],[Order],[Commission])
        ) as D on LP.id = D.EntityId

-- tady připojím custom field MaterialNo
left join(
select CV.Content as 'MaterialNo',CV.EntityId from CustomField CF
 inner join CustomValue CV on CF.id = CV.CustomFieldId and CF.name = 'MaterialNo') CF on LP.id = CF.EntityId

--tady omezím dobu na rovno nebo delší než 12 hodin
where DATEDIFF(hh,WF.Updated,getdate()) >= 12

order by DATEDIFF(hh,WF.Updated,getdate()) desc





