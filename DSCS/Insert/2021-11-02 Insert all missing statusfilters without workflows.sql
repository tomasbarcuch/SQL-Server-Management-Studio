DECLARE @ActionToFind as TINYINT = 11
DECLARE @ActionToAdd as TINYINT = 11
DECLARE @Entity as TINYINT = 31

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
    ,BusinessUnitID UNIQUEIDENTIFIER
)

insert into #TEMP

select 
--S.name,
NEWID() Id,
@ActionToAdd as Action,
WF.NewStatusId as StatusId,
@Entity AS Entity,
WF.DimensionId,
CreatedById = (select id from [User] where login = 'tomas.barcuch'),
UpdateById = (select id from [User] where login = 'tomas.barcuch'),
Getdate() as Created,
Getdate() as Updated,
BU.Id BusinessUnitID

 from workflow WF
inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.id
--inner join status S on NewStatusId = S.id and S.name in ('HuItemInserted','HuTeilverpackt','HuPart inserted','HuTeilverpackt','ITEM_INSERTED','CRATE_INSIDE','ITEM_INSIDE','HuItemInsertedTWN')
inner join status S on NewStatusId = S.id and S.name in ('SpLoading')
LEFT JOIN StatusFilter SF on WF.NewStatusId = SF.StatusId and SF.[Action] = @ActionToAdd
where WF.action = @ActionToFind and SF.id is null

insert into StatusFilter select 
    ID
    ,Action
    ,StatusId
    ,Entity
    ,DimensionId
    ,CreateById
    ,UpdateById
    ,Created 
    ,Updated  from #TEMP

insert into BusinessUnitPermission

select 
 NEWID() [Id],
	#TEMP.[BusinessUnitId],
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


select * from #TEMP

Drop Table #Temp

COMMIT