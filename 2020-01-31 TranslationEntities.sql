declare @BUID as UNIQUEIDENTIFIER = (select id from businessunit where name = 'DEMO Project Client')

SELECT [EntityId] FROM (
SELECT [tr].[EntityId] FROM [Translation] AS [tr] 
INNER JOIN [BusinessUnitPermission] AS [pub] ON ([pub].[BusinessUnitId] = @BUID) 
WHERE 
(
    [pub].[DimensionId] = [tr].[EntityId] 
    OR [pub].[UnitOfMeasureId] = [tr].[EntityId] 
    OR [pub].[StatusId] = [tr].[EntityId] 
    OR [pub].[BCSActionId] = [tr].[EntityId] 
    OR [pub].[ServiceTypeId] = [tr].[EntityId] 
    OR [pub].[UnitOfMeasureId] = [tr].[EntityId] 
    OR [pub].[ServiceTypeId] = [tr].[EntityId] 
) 
UNION 
SELECT [tr].[EntityId] FROM [Translation] AS [tr] 
INNER JOIN (
    SELECT 	[df].[Id] AS [EntityId] FROM [DimensionField] AS [df] 
    INNER JOIN [Dimension] AS [d] ON [df].[DimensionId] = [d].[Id] 
    INNER JOIN [BusinessUnitPermission] AS [pub] ON [d].[Id] = [pub].[DimensionId] AND [pub].[BusinessUnitId] = @BUID AND [pub].[DimensionId] IS NOT NULL 
    UNION 
    SELECT [cf].[Id] AS [EntityId] FROM [CustomField] AS [cf] 
    WHERE [cf].[ClientBusinessUnitId] = @BUID 
    UNION 
    SELECT [Id] AS [EntityId] FROM [DataType] 
    UNION 
    SELECT [ur].[RoleId] AS [EntityId] FROM [UserRole] AS [ur] 
    INNER JOIN [Role] AS [r] ON [ur].[RoleId] = [r].[Id] 
    WHERE [ur].[ClientBusinessUnitId] = @BUID 
    UNION 
    SELECT [Id] AS [EntityId] FROM [DocumentTemplate] AS [dt] 
    WHERE [businessUnitId] IN (SELECT [RelatedBusinessUnitId] FROM [BusinessUnitRelation] WHERE [BusinessUnitId] = @BUID) 
) AS [entity] ON [tr].[EntityId] = [entity].[EntityId] 
) AS [e] GROUP BY [EntityId]