select * from (

select
'Status' Source
,S.Name STATUS
,WFE.Created
,U.[Login]
,HU.Code HandlingUnit
,POH.Code PackingOrder
,LP.Code Loosepart
,NULL Barcode
,NULL MESSAGE
 from WorkflowEntry WFE
inner join [Status] S on WFE.StatusId = S.id
left join HandlingUnit HU on WFE.EntityId = HU.Id
left join PackingOrderHeader POH on WFE.EntityId = POH.ID
left join LoosePart LP on WFE.EntityId = LP.ID
inner join [User] U on WFE.CreatedById = U.Id
where WFE.EntityId in (
'1b0fec8d-5236-4c83-8041-30ef956c0d18',
'b81cb47e-903d-4617-8aa4-8ae1a7ee56ea'

)
 OR  WFE.EntityId in ( (Select id from LoosePart where TopHandlingUnitId = '8fab3fa0-f246-466c-b57a-ebf0c66bcf94'))
OR  WFE.EntityId in ( (Select id from HandlingUnit where TopHandlingUnitId = '1b0fec8d-5236-4c83-8041-30ef956c0d18')
)


union

select
'BCS' 
,A.[Description]
,BCS.Created
,U.[Login]
,HU.Code HU
,POH.Code PO
,LP.Code Loosepart
,BCS.Barcode
,BCS.ErrorMessage
 from BCSLog BCS
inner join [Status] S on BCS.EntityStatusId = S.id
left join HandlingUnit HU on BCS.EntityId = HU.Id
left join PackingOrderHeader POH on BCS.EntityId = POH.ID
left join LoosePart LP on BCS.EntityId = LP.ID
inner join [User] U on BCS.CreatedById = U.Id
inner join BCSAction A on BCS.ActionId = A.Id

where BCS.EntityId in (
'1b0fec8d-5236-4c83-8041-30ef956c0d18',
'b81cb47e-903d-4617-8aa4-8ae1a7ee56ea'
)
 OR  BCS.EntityId in ( (Select id from LoosePart where TopHandlingUnitId = '1b0fec8d-5236-4c83-8041-30ef956c0d18'))
OR  BCS.EntityId in ( (Select id from HandlingUnit where TopHandlingUnitId = '1b0fec8d-5236-4c83-8041-30ef956c0d18')
)
UNION

select 'Warehouse' 
,CAST(WE.QuantityBase as varchar)
,WE.Created
,U.[Login]
,HU.Code HU
,NULL PO
,LP.Code Loosepart 
,B.Code
,NULL
from WarehouseEntry WE
inner join LoosePart LP on WE.LoosepartId = LP.Id
left join HandlingUnit HU on WE.HandlingUnitId = HU.Id
inner join [User] U on WE.CreatedById = U.Id
left join [Bin] B on WE.BinId = B.Id
where (LoosepartId in (Select id from LoosePart where TopHandlingUnitId = '1b0fec8d-5236-4c83-8041-30ef956c0d18'))
OR  HandlingUnitId in ( (Select id from HandlingUnit where TopHandlingUnitId = '1b0fec8d-5236-4c83-8041-30ef956c0d18'))

) DATA ORDER by Created


