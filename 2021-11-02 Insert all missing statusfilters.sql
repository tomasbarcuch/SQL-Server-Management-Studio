declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'BASIS CLIENT')
begin TRANSACTION
create TABLE #TEMP 
(
    ID UNIQUEIDENTIFIER
    ,Action TINYINT
    ,StatusId UNIQUEIDENTIFIER
    ,Entity TINYINT
    ,DimensionId UNIQUEIDENTIFIER
    ,CreateById UNIQUEIDENTIFIER
    ,UpdateById UNIQUEIDENTIFIER
    ,Created DATETIME
    ,Updated DATETIME

)

insert into #TEMP
select 
NEWID(),
WF.[Action],
WF.OldStatusId as StatusId,
WF.Entity,
WF.DimensionId,
CreatedById = (select id from [User] where login = 'tomas.barcuch'),
UpdateById = (select id from [User] where login = 'tomas.barcuch'),
Getdate() as Created,
Getdate() as Updated
from Workflow WF 
left join StatusFilter SF on WF.OldStatusId = SF.StatusId and WF.[Action] = SF.[Action]
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id and BU.[Disabled] = 0 and BU.id = @ClientBusinessUnitId 
inner join dbo.status s_old on wf.oldstatusid = s_old.id
where WF.[Action] <> isnull(SF.[Action],0) and WF.[Action] not in (16)
order by BU.Name, s_old.Name

insert into StatusFilter select * from #TEMP

insert into BusinessUnitPermission

select 
 NEWID() [Id],
	@ClientBusinessUnitId as [BusinessUnitId], --BUP.BusinessUnitId,
	1 [PermissionType],
	NULL [HandlingUnitId],
	NULL [LoosePartId],
	NULL [ShipmentHeaderId],
	NULL [ShipmentLineId],
	NULL [InventoryHeaderId],
	NULL [InventoryLineId],
	NULL [CommentId],
	NULL [ServiceTypeId],
	NULL [ServiceLineId],
	NULL [LocationId],
	NULL [PackingOrderHeaderId],
	NULL [PackingOrderLineId],
	NULL [AddressId],
	NULL [DimensionId],
	NULL [HandlingUnitTypeId],
	NULL [UnitOfMeasureId],
	NULL [WorkflowId],
	NULL [StatusId],
	#TEMP.ID [StatusFilterId],
	NULL [BCSActionId],
	NULL [NumberSeriesId],
	[CreatedById] = (select id from [User] where login = 'tomas.barcuch'),
	[UpdatedById] = (select id from [User] where login = 'tomas.barcuch'),
	GETUTCDATE() [Created],
	GETUTCDATE() [Updated],
	NULL [DimensionValueId],
	NULL [TenderHeaderId],
	NULL [TenderLineId],
    NULL [DocumentTemplateId] 


 from #TEMP
 inner join BusinessUnitPermission BUP on #TEMP.StatusId = BUP.StatusId

SELECT * from #TEMP

Drop Table #Temp

COMMIT

/*
-- Status filtry bez workflow
select BU.NAME, SF.ID, WF.OldStatusId 
from StatusFilter SF 
left join Workflow WF on WF.OldStatusId = SF.StatusId and WF.[Action] = SF.[Action]
inner join BusinessUnitPermission BUP on SF.id = BUP.StatusFilterId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id and BU.[Disabled] = 0-- and BU.NAME = 'BASIS CLIENT'


where OldStatusId is NULL

order by BU.Name
*/