SELECT [P].[Client], [P].[Packer], [P].[FirstInboundYear], [P].[FirstInboundMonth], P.EntityCode, P.FirstInboundDate
--, COUNT(*) AS 'Count' 
FROM (
SELECT * FROM (
SELECT 
[D].[Client], 
[D].[Packer], 
[D].[Entity], 
[D].[EntityCode], 
YEAR(MIN([D].[Created])) AS FirstInboundYear, 
MONTH(MIN([D].[Created])) AS FirstInboundMonth
,MIN([D].[Created]) as FirstInboundDate 
FROM (
SELECT
    [cbu].[Name] AS Client
    ,[pbu].[Name] AS Packer
    ,'HU' AS Entity
    ,[hu].[Code] AS EntityCode
    ,[wfe].[Created] AS Created
FROM [HandlingUnit] AS [HU]
  INNER JOIN [BusinessUnitPermission] AS [bup] ON [bup].[HandlingUnitId] = [hu].[Id]
  INNER JOIN [WorkflowEntry] AS [wfe] ON [wfe].[Entity] = 11 AND [wfe].[EntityId] = [hu].[Id]
  INNER JOIN [BusinessUnit] AS [pbu] ON [pbu].[Id] = [wfe].[BusinessUnitId]
  INNER JOIN [BusinessUnit] AS [cbu] ON [cbu].[Id] = [bup].[BusinessUnitId] AND [cbu].[Type] = 2 and cbu.name = 'KRONES GLOBAL'--'KHU Debrecen'
  WHERE [wfe].[WorkflowAction] = 1
) AS [D]
GROUP BY [D].[Client], [D].[Packer], [D].[Entity], [D].[EntityCode]
UNION
SELECT [D].[Client],
    [D].[Packer],
    [D].[Entity],
    [D].[EntityCode],
    YEAR(MIN([D].[Created])) AS FirstInboundYear,
    MONTH(MIN([D].[Created])) AS FirstInboundMonth
    ,MIN([D].[Created]) as FirstInboundDate  FROM (
SELECT
    [cbu].[Name] AS Client
    ,[pbu].[Name] AS Packer
    ,'LP' AS Entity
    ,[lp].[Code] AS EntityCode
    ,[wfe].[Created] AS Created

  FROM [Loosepart] AS [lp]
  INNER JOIN [BusinessUnitPermission] AS [bup] ON [bup].[LoosePartId] = [lp].[Id]
  INNER JOIN [WorkflowEntry] AS [wfe] ON [wfe].[Entity] = 15 AND wfe.EntityId = [lp].[Id]
  INNER JOIN [BusinessUnit] AS [pbu] ON [pbu].[Id] = [wfe].[BusinessUnitId]
  INNER JOIN [BusinessUnit] AS [cbu] ON [cbu].[Id] = [bup].[BusinessUnitId] AND [cbu].[Type] = 2 and cbu.name = 'KHU Debrecen'
  WHERE [wfe].[WorkflowAction] = 1
) AS [D]
GROUP BY [D].[Client], [D].[Packer], [D].[Entity], [D].[EntityCode]
) AS [DATA]
WHERE ([DATA].[FirstInboundYear] = YEAR(DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1)) AND [DATA].[FirstInboundMonth] = MONTH(DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))) OR
    ([DATA].[FirstInboundYear] = YEAR(GETDATE()) AND [DATA].[FirstInboundMonth] = MONTH(GETDATE()-1))
) AS  [P]
--GROUP BY [P].[Client], [P].[Packer], [P].[FirstInboundYear], [P].[FirstInboundMonth]
ORDER BY P.EntityCode

