SELECT 
BU.*,
LP.*

  FROM [DFCZ_ENTRYTOOL_DEV].[dbo].[BusinessUnitPermission] BP

  inner join BusinessUnit BU on BP.BusinessUnitId = BU.id
  left join LoosePart LP on BP.LoosePartId = LP.id
  left join HandlingUnit HU on BP.HandlingUnitId = HU.ID
  where LoosePartid = '1cb4525c-1445-40e2-a90d-1b15210d2e81'


  select 
  bu.*,
  LP.*
  
  from LoosePart LP
left join BusinessUnitPermission BP on LP.id = BP.LoosePartId
left outer join BusinessUnitPermission BPhu on LP.ActualHandlingUnitId = BPhu.HandlingUnitId
left outer join BusinessUnitPermission BPthu on LP.TopHandlingUnitId = BPthu.HandlingUnitId
left outer join BusinessUnit BU on BP.BusinessUnitId = BU.ID
  where LP.Id = '1cb4525c-1445-40e2-a90d-1b15210d2e81'