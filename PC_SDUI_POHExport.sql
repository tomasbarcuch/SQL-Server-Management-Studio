DECLARE @POHEntity AS TINYINT = 35;
DECLARE @HUEntity AS TINYINT = 11;
DECLARE @DateFrom AS DATETIME = '1970-01-01T00:00:00';
DECLARE @POHStatusName1 AS NVARCHAR(20) = 'CREATED';
DECLARE @POHStatusName2 AS NVARCHAR(20) = 'CANCELED';
DECLARE @POHStatusName3 AS NVARCHAR(20) = 'BXNLProduced';
DECLARE @SDUIAbfrage1CFName AS NVARCHAR(250) = 'Abfrage1';
DECLARE @SDUIAbfrage2CFName AS NVARCHAR(250) = 'Abfrage2';
DECLARE @SDUIReprotectionSTName AS NVARCHAR(250) = 'REPROTECTION';
DECLARE @ClientBusinessUnitId AS UNIQUEIDENTIFIER = '76803f5b-a0fc-4570-b672-e27119eced7e';
DECLARE @PackerBusinessUnitId AS UNIQUEIDENTIFIER = '5365ba4d-bd29-4e86-a86d-1be48d1e5f1e';

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
SELECT 'HU' AS [Type], CONCAT('BC',[poh].[Code]) AS [Code], [st].[Name] AS [Status], [we].[Created] AS [Created], ISNULL([loc].[Code], '') AS [Location], '' AS [Kolli],
ISNULL([hu].[Code], '') AS [HUCode], ISNULL([hut].[Code], ISNULL([poht].[Code], '')) AS [HUType], ISNULL([cvaf1].[Content], '') AS [Abfrage1], ISNULL([cvaf2].[Content], '') AS [Abfrage2],
'0 x 0 x 0' AS [Measurements], 'cm' AS [MeasurementsUOM], 0 AS [BaseArea], 'qm' AS [BaseAreaUOM], 0 AS [Volume], 'm3' AS [VolumeUOM], 0 AS [Area], 'qm' AS [AreaUOM],
0 AS [Gross], 0 AS [Tare], 0 AS [Net], 'kg' AS [WeightUOM], ISNULL([hu].[Protection], [poh].[Protection]) AS [Protection], 0 AS [Reprotection], ISNULL([hu].[DangerousGoods], 0) AS [DangerousGoods]

,CASE WHEN ISNULL(CAST(sl.EntityId as NVARCHAR(36)),'FALSE') = 'FALSE' THEN 0 ELSE 1 END AS REPROTECTION

FROM [Status] [st] 
INNER JOIN [WorkflowEntry] [we] ON [we].[StatusId] = [st].[Id] AND [we].[Entity] = @POHEntity AND [st].[Name] IN (@POHStatusName1, @POHStatusName2, @POHStatusName3)
INNER JOIN [PackingOrderHeader] [poh] ON [poh].[Id] = [we].[EntityId] AND [we].[Entity] = @POHEntity
LEFT OUTER JOIN [HandlingUnit] [hu] ON [hu].[Id] = [poh].[HandlingUnitId]
LEFT OUTER JOIN [Location] [loc] ON [poh].[LocationId] = [loc].[Id]
LEFT OUTER JOIN [HandlingUnitType] [poht] ON [poh].[HandlingUnitTypeId] = [poht].[Id]
LEFT OUTER JOIN [HandlingUnitType] [hut] ON [hu].[TypeId] = [hut].[Id]
LEFT OUTER JOIN [CustomValue] [cvaf1] ON [cvaf1].[EntityId] = [poh].[Id] AND [cvaf1].[Entity] = @POHEntity  
AND [cvaf1].[CustomFieldId] IN (SELECT [Id] FROM [CustomField] WHERE [Name] = @SDUIAbfrage1CFName AND [Entity] = @POHEntity AND [ClientBusinessUnitId] = @ClientBusinessUnitId)
LEFT OUTER JOIN [CustomValue] [cvaf2] ON [cvaf2].[EntityId] = [poh].[Id] AND [cvaf2].[Entity] = @POHEntity  
AND [cvaf2].[CustomFieldId] IN (SELECT [Id] FROM [CustomField] WHERE [Name] = @SDUIAbfrage2CFName AND [Entity] = @POHEntity AND [ClientBusinessUnitId] = @ClientBusinessUnitId)

LEFT OUTER JOIN (select distinct EntityId, Entity from ServiceLine where ServiceTypeId in (select id from ServiceType where code = @SDUIReprotectionSTName) ) [sl] ON [sl].[EntityId] = [hu].[Id] AND [sl].[Entity] = @HUEntity


WHERE [we].[Created] > @DateFrom 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] WHERE [StatusId] = [st].[Id] AND [BusinessUnitId] = @ClientBusinessUnitId)
AND EXISTS(SELECT * FROM [BusinessUnitPermission] WHERE [PackingOrderHeaderId] = [poh].[Id] AND [BusinessUnitId] = @ClientBusinessUnitId) 
AND EXISTS(SELECT * FROM [BusinessUnitPermission] WHERE [PackingOrderHeaderId] = [poh].[Id] AND [BusinessUnitId] = @PackerBusinessUnitId) 
ORDER BY [we].[Created]