declare @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Debrecen')
--declare @client as UNIQUEIDENTIFIER = (Select id from BusinessUnit where name = 'KRONES HUNGARY Kft.')
declare @client as UNIQUEIDENTIFIER = (Select id from BusinessUnit where name = 'KRONES GLOBAL')
declare @FromDate as DATE = '2023-04-01'
declare @ToDate as DATE = '2023-04-30'





SELECT D.[Login],[D].[Client], [D].[Packer], [D].[Entity], Count([D].[EntityCode]), YEAR(D.Created), MONTH(D.Created) FROM (
SELECT distinct
 [cbu].[Name] AS Client
 ,[pbu].[Name] AS Packer
 ,'HU' AS Entity
 ,U.Login
 ,[hu].[Id] AS EntityCode
 ,MIN([wfe].[Created]) AS Created
FROM [HandlingUnit] AS [HU]
 --INNER JOIN [BusinessUnitPermission] AS [bup] ON [bup].[HandlingUnitId] = [hu].[Id]
 INNER JOIN [WorkflowEntry] AS [wfe] ON [wfe].[Entity] = 11 AND [wfe].[EntityId] = [hu].[Id]
 INNER JOIN [User] U on WFE.CreatedById = U.Id
 INNER JOIN [BusinessUnit] AS [pbu] ON [pbu].[Id] = [wfe].[BusinessUnitId] and WFE.BusinessUnitId = @packer
 INNER JOIN [BusinessUnit] AS [cbu] ON [cbu].[Id] = [wfe].[ClientBusinessUnitId] AND WFE.ClientBusinessUnitId = @client
 WHERE [wfe].[WorkflowAction] = 1 and WFE.Created between @FromDate and @ToDate
 GROUP BY 
  [cbu].[Name]
 ,[pbu].[Name] 
  ,U.Login
 ,[hu].[Id]
) AS [D]
GROUP BY D.Login, [D].[Client], [D].[Packer], [D].[Entity], YEAR(D.Created), MONTH(D.Created)


UNION
SELECT D.[Login],[D].[Client], [D].[Packer], [D].[Entity], Count([D].[EntityCode]), YEAR(D.Created), MONTH(D.Created) FROM (
SELECT distinct
 [cbu].[Name] AS Client
 ,[pbu].[Name] AS Packer
 ,'LP' AS Entity
 ,U.Login
 ,[LP].[Id] AS EntityCode
 ,MIN([wfe].[Created]) AS Created
FROM [LoosePart] AS [LP]
 --INNER JOIN [BusinessUnitPermission] AS [bup] ON [bup].[HandlingUnitId] = [hu].[Id]
 INNER JOIN [WorkflowEntry] AS [wfe] ON [wfe].[Entity] = 15 AND [wfe].[EntityId] = [LP].[Id]
 INNER JOIN [User] U on WFE.CreatedById = U.Id
 INNER JOIN [BusinessUnit] AS [pbu] ON [pbu].[Id] = [wfe].[BusinessUnitId] and WFE.BusinessUnitId = @packer
 INNER JOIN [BusinessUnit] AS [cbu] ON [cbu].[Id] = [wfe].[ClientBusinessUnitId] AND WFE.ClientBusinessUnitId = @client
 WHERE [wfe].[WorkflowAction] = 1 and WFE.Created between @FromDate and @ToDate
 GROUP BY 
  [cbu].[Name]
 ,[pbu].[Name] 
  ,U.Login
 ,[LP].[Id]
) AS [D]
GROUP BY D.Login, [D].[Client], [D].[Packer], [D].[Entity], YEAR(D.Created), MONTH(D.Created)

/*
--original query for business central
SELECT [P].[Client], [P].[Packer], [P].[FirstInboundYear], [P].[FirstInboundMonth], COUNT(*) AS 'Count' FROM ( 
SELECT * FROM ( 
SELECT [D].[Client], [D].[Packer], [D].[Entity], [D].[EntityCode], YEAR(MIN([D].[Created])) AS FirstInboundYear, MONTH(MIN([D].[Created])) AS FirstInboundMonth FROM ( 
SELECT  
    [cbu].[Id] AS Client 
    ,[pbu].[Id] AS Packer 
    ,'HU' AS Entity 
    ,[hu].[Code] AS EntityCode 
    ,[wfe].[Created] AS Created 
FROM [HandlingUnit] AS [HU] 
  INNER JOIN [BusinessUnitPermission] AS [bup] ON [bup].[HandlingUnitId] = [hu].[Id]  
  INNER JOIN [WorkflowEntry] AS [wfe] ON [wfe].[Entity] = 11 AND [wfe].[EntityId] = [hu].[Id] 
  INNER JOIN [BusinessUnit] AS [pbu] ON [pbu].[Id] = [wfe].[BusinessUnitId] 
  INNER JOIN [BusinessUnit] AS [cbu] ON [cbu].[Id] = [bup].[BusinessUnitId] AND [cbu].[Type] = 2 
  WHERE [wfe].[WorkflowAction] = 1 
) AS [D] 
GROUP BY [D].[Client], [D].[Packer], [D].[Entity], [D].[EntityCode]  
UNION 
SELECT [D].[Client],  
    [D].[Packer],  
    [D].[Entity],  
    [D].[EntityCode],  
    YEAR(MIN([D].[Created])) AS FirstInboundYear, 
    MONTH(MIN([D].[Created])) AS FirstInboundMonth FROM ( 
SELECT  
    [cbu].[Id] AS Client 
    ,[pbu].[Id] AS Packer 
    ,'LP' AS Entity 
    ,[lp].[Code] AS EntityCode 
    ,[wfe].[Created] AS Created 
     
  FROM [Loosepart] AS [lp] 
  INNER JOIN [BusinessUnitPermission] AS [bup] ON [bup].[LoosePartId] = [lp].[Id] 
  INNER JOIN [WorkflowEntry] AS [wfe] ON [wfe].[Entity] = 15 AND wfe.EntityId = [lp].[Id] 
  INNER JOIN [BusinessUnit] AS [pbu] ON [pbu].[Id] = [wfe].[BusinessUnitId] 
  INNER JOIN [BusinessUnit] AS [cbu] ON [cbu].[Id] = [bup].[BusinessUnitId] AND [cbu].[Type] = 2 
  WHERE [wfe].[WorkflowAction] = 1 
) AS [D] 
GROUP BY [D].[Client], [D].[Packer], [D].[Entity], [D].[EntityCode]  
) AS [DATA] 
WHERE ([DATA].[FirstInboundYear] = YEAR(DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1)) AND [DATA].[FirstInboundMonth] = MONTH(DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))) OR  
    ([DATA].[FirstInboundYear] = YEAR(GETDATE()) AND [DATA].[FirstInboundMonth] = MONTH(GETDATE())) 
) AS  [P]  
GROUP BY [P].[Client], [P].[Packer], [P].[FirstInboundYear], [P].[FirstInboundMonth] 
ORDER BY [P].[FirstInboundYear], [P].[FirstInboundMonth], [P].[Client], [P].[Packer]
*/