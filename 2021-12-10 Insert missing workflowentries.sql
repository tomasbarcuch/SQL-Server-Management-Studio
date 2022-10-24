begin TRANSACTION

--insert into WorkflowEntry

select NEWID() 
      ,15 [Entity]
      ,LP.Id [EntityId]
      ,LP.statusid
      ,LP.[CreatedById]
      ,LP.[CreatedById] [UpdatedById]
      ,LP.[Created]
      ,LP.[Created] [Updated]
      ,NULL [WorkflowAction]
      ,BUC.[BusinessUnitId]
      ,BUC.[BusinessUnitId] [ClientBusinessUnitId]
  


from LoosePart LP
left join WorkflowEntry WFE on Wfe.EntityId = LP.id
inner join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.Type <> 2
inner join BusinessUnitPermission BUC on LP.id = BUC.LoosePartId
inner join BusinessUnit CU on BUC.BusinessUnitId = CU.id and Cu.Type = 2
where WFE.EntityId is null

COMMIT


begin TRANSACTION

--insert into WorkflowEntry

select NEWID() 
      ,11 [Entity]
      ,HU.Id [EntityId]
      ,HU.statusid
      ,HU.[CreatedById]
      ,HU.[CreatedById] [UpdatedById]
      ,HU.[Created]
      ,HU.[Created] [Updated]
      ,NULL [WorkflowAction]
      ,BUC.[BusinessUnitId]
      ,BUC.[BusinessUnitId] [ClientBusinessUnitId]
  


from HandlingUnit HU
left join WorkflowEntry WFE on Wfe.EntityId = HU.id
--inner join BusinessUnitPermission BUP on HU.id = BUP.LoosePartId
--inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and bu.Type <> 2
inner join BusinessUnitPermission BUC on HU.id = BUC.LoosePartId
inner join BusinessUnit CU on BUC.BusinessUnitId = CU.id and Cu.Type = 2
where WFE.EntityId is null

COMMIT