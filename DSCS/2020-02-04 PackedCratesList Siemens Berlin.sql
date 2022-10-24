SELECT
DB_NAME() AS [Current Database],
[BU].[Name] AS [ClientBusinessName],

--CASE WHEN ISNULL([CFPO].[Schwimmende Verpackung],'false') = 'true' AND REPLACE([Macros],';','') = 'VG' THEN 'Verschlag' ELSE 

CASE WHEN REPLACE([Macros],';','') = 'VG' AND [HU].[Netto] >= 2000 THEN 'Verschlag > 2t' ELSE
CASE WHEN REPLACE([Macros],';','') = 'VG' AND [HU].[Netto] < 2000 THEN 'Verschlag < 2t' ELSE

CASE WHEN ISNULL([CFPO].[Schwimmende Verpackung],'false') = 'true' THEN  'Schwim. Verpack.' ELSE
CASE WHEN REPLACE([Macros],';','') IN ('Kiste','BO','OSB Kiste','OSB-Kiste','KISTE') AND [HU].[Netto] >= 2000 THEN 'Kiste > 2t' ELSE
CASE WHEN REPLACE([Macros],';','') IN ('Kiste','BO','OSB Kiste','OSB-Kiste','KISTE') AND [HU].[Netto] < 2000 THEN 'Kiste < 2t' ELSE
CASE WHEN REPLACE([Macros],';','') IN ('Boden','BD','BRETTWARE') THEN 'Boden' 
ELSE 'Unbekannt'
END END  END END END END AS 'Sorting',
REPLACE([Macros],';','') AS 'Crate',
[HU].[Code],
[HU].[Description],
[HU].[Length],
[HU].[Width],
[HU].[Height],
[HU].[ColliNumber],
[HU].[Weight],
[HU].[Netto],
[HU].[Brutto],
[HU].[BaseArea],
[HU].[Surface],
[BU].[Name],
ISNULL([TR].[Text],[CWS].[Name]) AS 'Status',
[Project].[ProjectNr] AS [Projekt],
[Project].[Kennwort],
[Project].[Produktlinie],
[Project].[Verpackungsart],
[CF].[Macros],
[CF].[Abrechnungshinweis],
[CF].[Anzahl (Kisten) Packstücke],
ISNULL([CFPO].[Schwimmende Verpackung],'false') AS [Schwimmende Verpackung],
[WFE].[Created] AS [Datum]
FROM [WorkflowEntry] [WFE]
INNER JOIN [Status] [WFS] ON [WFE].[StatusId] = [WFS].[Id]
INNER JOIN [HandlingUnit] HU ON [WFE].[EntityId] = [HU].[Id]
INNER JOIN [BusinessUnitPermission] [BUP] ON [HU].[Id] = [BUP].[HandlingUnitId]
INNER JOIN [BusinessUnit] [BU] ON [BUP].[BusinessUnitId] = [BU].[Id] AND [BU].[name] = 'Siemens Berlin'
INNER JOIN [Status] AS [CWS] ON [HU].[StatusId] = [CWS].[Id]

LEFT JOIN (SELECT
[CustomField].[Name] AS [CF_Name], 
[CV].[Content] AS [CV_Content],
[CV].[EntityId] AS [EntityID]
FROM [CustomField] 
INNER JOIN [CustomValue] [CV] ON ([CustomField].[Id] = [CV].[CustomFieldId])
WHERE [name] IN (SELECT [Name] FROM [CustomField] WHERE [ClientBusinessUnitId] = (SELECT [Id] FROM [BusinessUnit] WHERE [Name] = 'Siemens Berlin') group by [Name])) [SRC]
PIVOT (max([SRC].[CV_Content]) FOR [SRC].[CF_Name]  IN ([Abrechnungshinweis],[Schwimmende Verpackung],[Macros],[Anzahl (Kisten) Packstücke]) ) AS [CF] ON [HU].[Id] = [CF].[EntityID]



INNER JOIN (
SELECT
[DV].[Content] [ProjectNr],
[DV].[Description] [Project], 
[D].[Description] [Dimension],
[EDVR].[EntityId],
[DF].[Name], 
[DFV].[Content]
FROM [DimensionField] [DF]
INNER JOIN [DimensionFieldValue] [DFV] ON [Df].[Id] = [DFV].[DimensionFieldId]
INNER JOIN [EntityDimensionValueRelation] [EDVR] ON [DFV].[DimensionValueId] = [EDVR].[DimensionValueId]
INNER JOIN [DimensionValue] [DV] ON [EDVR].[DimensionValueId] = [DV].[Id]
INNER JOIN [Dimension] [D] ON [DF].[DimensionId] = [D].[Id] AND [D].[name] = 'Project'
WHERE 
[DF].[name] IN ('Verpackungsart','Produktlinie','Kennwort'))[SRC]
pivot (max([SRC].[Content]) FOR [SRC].[Name]   IN ([Verpackungsart],[Produktlinie],[Kennwort])) AS [Project] ON [HU].[Id] = [Project].[EntityId]

LEFT JOIN (SELECT 
[CV].[EntityId],
[CV].[Content],
[CF].[Name]
FROM [CustomValue] [CV]
INNER JOIN [CustomField] [CF] ON [CV].[CustomFieldId] = [CF].[Id]
WHERE [CF].[name] IN ('Schwimmende Verpackung')) [SRC]
PIVOT (max([SRC].[Content]) FOR [SRC].[name] IN ([Schwimmende Verpackung])) AS [CFPO] ON [HU].[PackingOrderHeaderId] = [CFPO].[EntityId]
LEFT JOIN [Translation] [TR] ON [CWS].[Id] = [TR].[EntityId] AND [TR].[Language] =  'de' 
LEFT JOIN [WorkflowEntry] AS [WFE_Parent] ON [WFE].[EntityId] = [WFE_Parent].[EntityId] AND [WFE_Parent].[Created] < [WFE].[Created] 
AND [WFE_Parent].[StatusId] IN (SELECT [Status].[Id] FROM [Status] WHERE [Status].[Name] IN ('HuPacked','HuPackedafterPackingRule'))

WHERE 
[WFS].[Name] IN ('HuPacked','HuPackedafterPackingRule')
AND [WFE_Parent].[Id] IS  NULL
AND cast([wfe].[created] AS date) >=  '2020-02-01'
AND cast([wfe].[created] AS date) <=  '2020-02-28'
AND [macros] NOT IN ('Kollo','Rohrcolli')
