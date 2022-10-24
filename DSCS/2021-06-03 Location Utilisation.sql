DECLARE @ClientBusinessUnitId as UNIQUEIDENTIFIER = (Select id from BusinessUnit where name =  'Mölnlycke Health Care')
DECLARE @BusinessUnitId as UNIQUEIDENTIFIER = (Select id from BusinessUnit where name =  'Deufol Hub Antwerp')

SELECT 
 NEWID() [Id],  
 [OnWarehouse].[LocationId],  
 [OnWarehouse].[Location] [LocationName],  
 SUM([OnWarehouse].[BaseArea]) [UsedArea],  
 [LocCapacity] AS [Capacity], 
SUM(OnWarehouse.EntityCount) Count,
LEAD(SUM(InboundQuantity)) over (order by DATE) - SUM(InboundQuantity) LInboundQuantity,
LEAD(SUM(OutboundQuantity)) over (order by DATE) -  SUM(OutboundQuantity) LOutboundQuantity,
SUM(InboundQuantity) InboundQuantity,
SUM(OutboundQuantity) OutboundQuantity,
 ROUND(CASE WHEN MAX([OnWarehouse].[LocCapacity]) > 0 THEN  SUM([OnWarehouse].[BaseArea])/MAX([OnWarehouse].[LocCapacity])*100 ELSE 100 END, 0) [Utilisation],   
 CAST(ROUND(CASE WHEN MAX([OnWarehouse].[LocCapacity]) > 0 THEN  SUM([OnWarehouse].[BaseArea])/MAX([OnWarehouse].[LocCapacity])*100 ELSE 100 END, 0) AS INT) [Utilisation], 
 [Calendar].[Date] [Date] FROM   
 (SELECT
  [DATA].[LocationId], 
 [L].[Name] AS [Location],  
 [LCap].[LocCapacity],  
 SUM([DATA].[BaseArea]) AS [BaseArea],  
 Count(distinct[DATA].[EntityID]) AS [EntityCount],
 SUM(DATA.Inbound_quantity) as InboundQuantity,
 SUM(DATA.Outbound_quantity) as OutboundQuantity,  
 [DATA].[InboundDate],  
 ISNULL([DATA].[OutboundDate],GETDATE()-1) AS [OutboundDate]  
 FROM (  
 SELECT  
 [WE].[LocationId], 
  ISNULL(ISNULL([WE].[LoosepartId],[WE].[HandlingUnitId]),[WE].[ParentHandlingUnitId]) AS [EntityID],  
 SUM(ISNULL(ISNULL([LP].[BaseArea],[HU].[BaseArea]),[PHU].[BaseArea])) AS [BaseArea],  
MIN(CASE WHEN [WE].[QuantityBase] > 0 AND [WE].[LocationId] IS NOT NULL THEN [RegisteringDate] ELSE NULL END) AS [InboundDate],  
 MAX(CASE WHEN [WE].[QuantityBase] < 0 AND [WE].[LocationId] IS NOT NULL THEN [RegisteringDate] ELSE NULL END) AS [OutboundDate], 
  sum(case WHEN WE.QuantityBase > 0 and we.LocationId is not null then 1 else 0 end) as Inbound_quantity, 
 sum(case WHEN WE.QuantityBase < 0 and we.LocationId is not null then 1 else 0 end) as Outbound_quantity
 FROM [WarehouseEntry] [WE]  
 LEFT OUTER JOIN [LoosePart] [LP] ON [WE].[LoosepartId] = [LP].[Id] AND [WE].[HandlingUnitId] IS NULL  
 LEFT OUTER JOIN [HandlingUnit] [HU] ON [WE].[HandlingUnitId] = [HU].[Id] AND [WE].[ParentHandlingUnitId] IS NULL  
 LEFT OUTER JOIN [HandlingUnit] [PHU] ON [WE].[ParentHandlingUnitId] = [PHU].[Id]  
 WHERE [WE].[LocationId] IS NOT NULL AND  
 (([LoosepartId] = [WE].[LoosePartId] AND [WE].[LoosePartId] IS NOT NULL) OR   
 ([HandlingUnitId] = [WE].[HandlingUnitId] AND [WE].[HandlingUnitId] IS NOT NULL) OR  
 ([HandlingUnitId] = [WE].[ParentHandlingUnitId] AND [WE].[ParentHandlingUnitId] IS NOT NULL))  
 GROUP BY   
 [WE].[LocationId],  
 ISNULL(ISNULL([WE].[LoosepartId],[WE].[HandlingUnitId]),[WE].[ParentHandlingUnitId]),  
 (ISNULL(ISNULL([LP].[Code],[HU].[Code]),[PHU].[Code]))  
 ) [DATA]  
 LEFT OUTER JOIN [Location] [L] ON [DATA].[LocationId] = [L].[Id]  
 LEFT OUTER JOIN (SELECT  
 [L].[id] [LocationId], 
 [Capacity] AS [LocCapacity] 
 FROM [Location] [L]  
 WHERE [L].[Disabled] = 0  
 ) [LCap] ON [DATA].[LocationId] = [LCap].[LocationId] 
 INNER JOIN [BusinessUnitPermission] [BUPC] ON [DATA].[LocationId] = [BUPC].[LocationId] AND [BUPC].[BusinessUnitId] = @ClientBusinessUnitId 
 GROUP BY 
 [DATA].[LocationId],  
 [L].[Name],  
 [LCap].[LocCapacity],  
 [DATA].[InboundDate],  
 ISNULL([DATA].[OutboundDate],GETDATE()-1)) [OnWarehouse],
 [Calendar] 
 WHERE [Calendar].[Date] BETWEEN [OnWarehouse].[InboundDate] AND [OnWarehouse].[OutboundDate]  
 GROUP BY  
 [LocCapacity], 
 [OnWarehouse].[LocationId],  
 [OnWarehouse].[Location],  
 [Calendar].[Date] 

Order by [Location],[Date] 
/*

 SELECT   
 NEWID() [Id],  
 [OnWarehouse].[LocationId],  
 [OnWarehouse].[Location] [LocationName],  
 SUM([OnWarehouse].[BaseArea]) [UsedArea],  
 [LocCapacity] AS [Capacity], 
                --((connectionType == ConnectionTypeEnum.mysql) ?
 ROUND(CASE WHEN MAX([OnWarehouse].[LocCapacity]) > 0 THEN  SUM([OnWarehouse].[BaseArea])/MAX([OnWarehouse].[LocCapacity])*100 ELSE 100 END, 0) [Utilisation], 
 CAST(ROUND(CASE WHEN MAX([OnWarehouse].[LocCapacity]) > 0 THEN  SUM([OnWarehouse].[BaseArea])/MAX([OnWarehouse].[LocCapacity])*100 ELSE 100 END, 0) AS INT) [Utilisation],  
 [Calendar].[Date] [Date] FROM   
 (SELECT  
 [DATA].[LocationId], 
 [L].[Name] AS [Location],  
 [LCap].[LocCapacity],  
 SUM([DATA].[BaseArea]) AS [BaseArea],  
 [DATA].[InboundDate],  
 ISNULL([DATA].[OutboundDate],GETDATE()-1) AS [OutboundDate]  
 FROM (  
 SELECT  
 [WE].[LocationId], 
  ISNULL(ISNULL([WE].[LoosepartId],[WE].[HandlingUnitId]),[WE].[ParentHandlingUnitId]) AS [EntityID],  
 SUM(ISNULL(ISNULL([LP].[BaseArea],[HU].[BaseArea]),[PHU].[BaseArea])) AS [BaseArea],  
 MIN(CASE WHEN [WE].[QuantityBase] > 0 AND [WE].[LocationId] IS NOT NULL THEN [RegisteringDate] ELSE NULL END) AS [InboundDate],  
 MAX(CASE WHEN [WE].[QuantityBase] < 0 AND [WE].[LocationId] IS NOT NULL THEN [RegisteringDate] ELSE NULL END) AS [OutboundDate]  
 FROM [WarehouseEntry] [WE]  
 LEFT OUTER JOIN [LoosePart] [LP] ON [WE].[LoosepartId] = [LP].[Id] AND [WE].[HandlingUnitId] IS NULL  
 LEFT OUTER JOIN [HandlingUnit] [HU] ON [WE].[HandlingUnitId] = [HU].[Id] AND [WE].[ParentHandlingUnitId] IS NULL  
 LEFT OUTER JOIN [HandlingUnit] [PHU] ON [WE].[ParentHandlingUnitId] = [PHU].[Id]  
 LEFT OUTER JOIN [BusinessUnitPermission] [BUPLP] on [LP].[Id] = [BUPLP].[LoosePartId]  
 LEFT OUTER JOIN [BusinessUnitPermission] [BUPHU] on [HU].[Id] = [BUPHU].[HandlingUnitId]  
 LEFT OUTER JOIN [BusinessUnitPermission] [BUPPHU] on [PHU].[Id] = [BUPPHU].[HandlingUnitId]  
 WHERE [WE].[LocationId] IS NOT NULL AND  
 (([WE].[LoosepartId] = [WE].[LoosePartId] AND [WE].[LoosePartId] IS NOT NULL) OR   
 ([WE].[HandlingUnitId] = [WE].[HandlingUnitId] AND [WE].[HandlingUnitId] IS NOT NULL) OR  
 ([WE].[HandlingUnitId] = [WE].[ParentHandlingUnitId] AND [WE].[ParentHandlingUnitId] IS NOT NULL)) AND  
 ISNULL(ISNULL([BUPLP].[BusinessUnitId],[BUPHU].[BusinessUnitId]),[BUPPHU].[BusinessUnitId]) = @BusinessUnitId  
 GROUP BY   
 [WE].[LocationId],  
 ISNULL(ISNULL([WE].[LoosepartId],[WE].[HandlingUnitId]),[WE].[ParentHandlingUnitId]),  
 (ISNULL(ISNULL([LP].[Code],[HU].[Code]),[PHU].[Code]))  
 ) [DATA]  
 LEFT OUTER JOIN [Location] [L] ON [DATA].[LocationId] = [L].[Id]  
 LEFT OUTER JOIN (SELECT  
 [L].[id] [LocationId], 
 [Capacity] AS [LocCapacity] 
 FROM [Location] [L]  
 WHERE [L].[Disabled] = 0  
 ) [LCap] ON [DATA].[LocationId] = [LCap].[LocationId] 
 INNER JOIN [BusinessUnitPermission] [BUPC] ON [DATA].[LocationId] = [BUPC].[LocationId] AND [BUPC].[BusinessUnitId] = @ClientBusinessUnitId 
 GROUP BY 
 [DATA].[LocationId],  
 [L].[Name],  
 [LCap].[LocCapacity],  
 [DATA].[InboundDate],  
 ISNULL([DATA].[OutboundDate],GETDATE()-1)) [OnWarehouse],  
 [Calendar] 
 WHERE [Calendar].[Date] BETWEEN [OnWarehouse].[InboundDate] AND [OnWarehouse].[OutboundDate]  
 GROUP BY  
 [LocCapacity], 
 [OnWarehouse].[LocationId],  
 [OnWarehouse].[Location],  
 [Calendar].[Date];
 */