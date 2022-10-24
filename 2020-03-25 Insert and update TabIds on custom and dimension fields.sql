
BEGIN TRANSACTION
IF NOT EXISTS (SELECT [name]
      FROM sys.tables
      WHERE [name] = 'Bookmarks')
    CREATE TABLE dbo.Bookmarks (
    [FieldName] [nvarchar] (250) NOT NULL,
    [FieldID] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[ClientBusinessUnitId] [uniqueidentifier] NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Entity] [tinyint] NOT NULL,
	[DimensionId] [uniqueidentifier] NULL,
	[Position] [int] NOT NULL,
	[PermissionId] [uniqueidentifier] NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[UpdatedById] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL
    )
GO


insert into dbo.Bookmarks (    
    [FieldName],
    [FieldID],
	[Id],
	[ClientBusinessUnitId],
	[Name],
	[Entity],
	[DimensionId],
	[Position],
	[PermissionId],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated])

SELECT 
CF.Name,
CF.ID CFID,
      newid() [Id]
      ,BU.id as [ClientBusinessUnitId]
      ,'Extra' as [Name]
      ,CF.Entity [Entity]
      ,NULL as [DimensionId]
      ,CF.[Position] [Position]
      ,(select id from Permission where name = 'Tabs_read') [PermissionId]
      ,(select id from [User] U where U.login = 'tomas.barcuch')[CreatedById]
      ,(select id from [User] U where U.login = 'tomas.barcuch')[UpdatedById]
      ,getdate() as [Created]
      ,getdate() as [Updated]
       
      from customfield CF 
inner join BusinessUnit BU on CF.ClientBusinessUnitId = BU.Id
where tab <> 0

union

SELECT 
DF.Name,
DF.ID CFID,
      newid() [Id]
      ,BU.id as [ClientBusinessUnitId]
      ,'Extra' as [Name]
      ,8 [Entity]
      ,DF.DimensionId as [DimensionId]
      ,DF.[Position] [Position]
      ,(select id from Permission where name = 'Tabs_read') [PermissionId]
      ,(select id from [User] U where U.login = 'tomas.barcuch')[CreatedById]
      ,(select id from [User] U where U.login = 'tomas.barcuch')[UpdatedById]
      ,getdate() as [Created]
      ,getdate() as [Updated]
       
      from dimensionfield DF  
inner join BusinessUnit BU on DF.ClientBusinessUnitId = BU.Id
where tab <> 0

ROLLBACK


--TABLE [dbo].[Tab] has to be created, 


begin TRANSACTION

INSERT INTO dbo.Tab(
	[Id],
	[ClientBusinessUnitId],
	[Name],
	[Entity],
	[DimensionId],
	[Position],
	[PermissionId],
	[CreatedById],
	[UpdatedById],
	[Created],
	[Updated]
)

select 
newid() Id, 
	B.[ClientBusinessUnitId],
	B.[Name],
	B.[Entity],
	B.[DimensionId],
	20  [Position],
	B.[PermissionId]
      ,(select id from [User] U where U.login = 'tomas.barcuch')[CreatedById]
      ,(select id from [User] U where U.login = 'tomas.barcuch')[UpdatedById]
      ,getdate() as [Created]
      ,getdate() as [Updated]

 from Bookmarks B
group by 
	B.[ClientBusinessUnitId],
	B.[Name],
	B.[Entity],
	B.[DimensionId],
	B.[PermissionId]

ROLLBACK

--Column TabId [uniqueidentifier] in tables [dbo].[CustomField] and [dbo].[DimensionField] has to be added 

BEGIN TRANSACTION

update CF set CF.TabId = T.Id
 from
dbo.CustomField CF
inner join TAB T on CF.ClientBusinessUnitId = T.ClientBusinessUnitId and CF.Entity = T.Entity
inner join Bookmarks B on CF.Id = B.FieldID

ROLLBACK

BEGIN TRANSACTION

update DF set DF.TabId = T.Id
 from
dbo.DimensionField DF
inner join TAB T on DF.ClientBusinessUnitId = T.ClientBusinessUnitId and DF.DimensionId = T.DimensionId
inner join Bookmarks B on DF.Id = B.FieldID

ROLLBACK















/*

begin TRANSACTION
update DimensionField set TabID = B.Id
from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.DimensionField DF
inner join Bookmarks B on DF.id = B.FieldID

ROLLBACK
*/

