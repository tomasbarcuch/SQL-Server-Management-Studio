BEGIN TRANSACTION
DECLARE @LocationIdMain AS UniqueIdentifier;
DECLARE @LocationCodeMain AS VARCHAR(100);
DECLARE @Location_Id AS UniqueIdentifier;
DECLARE @Location_Code AS VARCHAR(100);
--
DECLARE Locations_Cursor CURSOR FOR  
SELECT [Id],[Code]
FROM [Location]
WHERE [Id] IN('a02dc3a9-aac0-4d0d-9ef2-3d5184af20d9') --'44DCCCCA-E8B9-4550-8C7D-85F3FB398D46'
OPEN Locations_Cursor;  
FETCH NEXT FROM Locations_Cursor INTO @LocationIdMain, @LocationCodeMain;
WHILE @@FETCH_STATUS = 0  
    BEGIN  
		PRINT '=== MAIN LOOP: ' + @LocationCodeMain + ' - ' + CAST(@LocationIdMain AS VARCHAR(64)) + ' ===';

		DECLARE Location_Cursor CURSOR FOR  
		SELECT [Id],[Code]
		FROM [Location]
		WHERE [Code] = @LocationCodeMain AND (Id <> @LocationIdMain)
		OPEN Location_Cursor;  
		FETCH NEXT FROM Location_Cursor INTO @Location_Id, @Location_Code;
		WHILE @@FETCH_STATUS = 0  
			BEGIN  
				PRINT @Location_Code + ' - ' + CAST(@Location_Id AS VARCHAR(64)) + ' ---'; 

				--Zone Insert
				DECLARE @MainZoneID as UNIQUEIDENTIFIER
				DECLARE @MainZoneName as VARCHAR(100)
				declare zone_cursor CURSOR FOR
				select ID, Name
				FROM Zone
				where LocationId = @Location_Id and (LocationId <> @LocationIdMain)
				OPEN zone_cursor;
				FETCH NEXT from zone_cursor INTO @MainZoneId,@MainZoneName;
				WHILE @@FETCH_STATUS = 0 
BEGIN
				PRINT 'Zone Insert:'
				INSERT INTO [Zone] 
				([Id], [LocationId],[Name],[Description],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[NumberSeriesId],[Capacity])
			/*
				SELECT NEWID(),@LocationIdMain,[Name],[Description],[Disabled],[CreatedById],[UpdatedById],GETDATE(),GETDATE(),[NumberSeriesId],[Capacity]
				FROM [Zone] AS [z]
				WHERE 0 = (SELECT COUNT([Id]) FROM [Zone] AS [zMain] WHERE ([zMain].[Name] = [z].[Name] AND [zMain].[LocationId] = @LocationIdMain) )
				AND [z].[LocationId] = @Location_Id 
*/
				SELECT NEWID(),@LocationIdMain,@MainZoneName,@MainZoneName,0,(select id from [user] where login = 'tomas.barcuch'),(select id from [user] where login = 'tomas.barcuch'),GETDATE(),GETDATE(),NULL,max(Z.[Capacity])
				
				from location L
				left join zone Z on L.id = Z.LocationId and L.Code = @LocationCodeMain and Z.LocationId <> @Location_Id
				where z.name is not null
				group by Z.[Name]

			END;  
		CLOSE zone_Cursor;  
		DEALLOCATE Zone_Cursor;  

				--Bin Insert
				PRINT 'Bin Insert:'
				INSERT INTO [Bin] 
				([Id],[Code],[LocationId],[ZoneId],[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[MaximumVolume],[NumberSeriesId])     
				SELECT NEWID(),[Code],@LocationIdMain,[ZoneId],[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],[Disabled],[CreatedById],[UpdatedById],GETDATE(),GETDATE(),[MaximumVolume],[NumberSeriesId]     
				FROM [Bin] AS [b]
				WHERE 0 = (SELECT COUNT([Id]) FROM [Bin] AS [bMain] WHERE ([bMain].[Code] = [b].[Code] AND [bMain].[LocationId] = @LocationIdMain) )
				AND [b].[LocationId] = @Location_Id 
		
				--[HandlingUnit]
				PRINT 'HandlingUnit:::'
				--Location
				PRINT 'Location:'
				UPDATE [HandlingUnit] SET [ActualLocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [HandlingUnit] 
				WHERE [ActualLocationId] = @Location_Id
				--Zone
				PRINT 'Zone:'
				UPDATE [HandlingUnit] SET [ActualZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] LEFT JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) LEFT JOIN [HandlingUnit] AS [e] ON ([e].[ActualZoneId] = [z].[Id])--   AND [z].[LocationId] = [e].[ActualLocationId] )
				WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]
				--Bin
				PRINT 'Bin:'
				UPDATE [HandlingUnit] SET [ActualBinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	LEFT JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) LEFT JOIN [HandlingUnit] AS [e] ON ([e].[ActualBinId] = [b].[Id])-- and [b].[LocationId] = [e].[ActualLocationId] )
				WHERE [bMain].[LocationId] = @LocationIdMain AND [b].[LocationId] = @Location_Id AND [bMain].[Id] <> [b].[Id]

				--[LoosePart]
				PRINT 'LoosePart:::'
				--Location
				PRINT 'Location:'
				UPDATE [LoosePart] SET [ActualLocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [LoosePart] 
				WHERE [ActualLocationId] = @Location_Id
				--Zone
				PRINT 'Zone:'
				UPDATE [LoosePart] SET [ActualZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] INNER JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [LoosePart] AS [e] ON ([e].[ActualZoneId] = [z].[Id] ) 
				WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]
				--Bin
				PRINT 'Bin:'
				UPDATE [LoosePart] SET [ActualBinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	INNER JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) INNER JOIN [LoosePart] AS [e] ON ([e].[ActualBinId] = [b].[Id] ) 
				WHERE [bMain].[LocationId] = @LocationIdMain AND [b].[LocationId] = @Location_Id AND [bMain].[Id] <> [b].[Id]

				--[WarehouseEntry]
				PRINT 'WarehouseEntry:::'
				--Location
				PRINT 'Location:'
				UPDATE [WarehouseEntry] SET [LocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [WarehouseEntry] 
				WHERE [LocationId] = @Location_Id
				--Zone
				PRINT 'Zone:'
				UPDATE [WarehouseEntry] SET [ZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] INNER JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [WarehouseEntry] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
				WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]
				--Bin
				PRINT 'Bin:'
				UPDATE [WarehouseEntry] SET [BinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	INNER JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) INNER JOIN [WarehouseEntry] AS [e] ON ([e].[BinId] = [b].[Id] ) 
				WHERE [bMain].[LocationId] = @LocationIdMain AND [b].[LocationId] = @Location_Id AND [bMain].[Id] <> [b].[Id]

				--[WarehouseContent]
				PRINT 'WarehouseContent:::'
				--Location
				PRINT 'Location:'
				UPDATE [WarehouseContent] SET [LocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [WarehouseContent] 
				WHERE [LocationId] = @Location_Id
				--Zone
				PRINT 'Zone:'
				UPDATE [WarehouseContent] SET [ZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] INNER JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [WarehouseContent] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
				WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]
				--Bin
				PRINT 'Bin:'
				UPDATE [WarehouseContent] SET [BinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	INNER JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) INNER JOIN [WarehouseContent] AS [e] ON ([e].[BinId] = [b].[Id] ) 
				WHERE [bMain].[LocationId] = @LocationIdMain AND [b].[LocationId] = @Location_Id AND [bMain].[Id] <> [b].[Id]

				--[ShipmentHeader]
				PRINT 'ShipmentHeader:::'
				--From Location
				PRINT 'From Location:'
				UPDATE [ShipmentHeader] SET [FromLocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [ShipmentHeader] 
				WHERE [FromLocationId] = @Location_Id
				--To Location
				PRINT 'To Location:'
				UPDATE [ShipmentHeader] SET [ToLocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [ShipmentHeader] 
				WHERE [ToLocationId] = @Location_Id

				--[PackingOrderHeader]
				PRINT 'PackingOrderHeader:::'
				--Location
				PRINT 'Location:'
				UPDATE [PackingOrderHeader] SET [LocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [PackingOrderHeader]
				WHERE [LocationId] = @Location_Id

				--[InventoryHeader]
				PRINT 'InventoryHeader:::'
				--Location
				PRINT 'Location:'
				UPDATE [InventoryHeader] SET [LocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [InventoryHeader]
				WHERE [LocationId] = @Location_Id

				--[InventoryLine]
				PRINT 'InventoryLine:::'
				--Zone
				PRINT 'Zone:'
				UPDATE [InventoryLine] SET [ZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] INNER JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [InventoryLine] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
				WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]
				--Bin
				PRINT 'Bin:'
				UPDATE [InventoryLine] SET [BinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	INNER JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) INNER JOIN [InventoryLine] AS [e] ON ([e].[BinId] = [b].[Id] ) 
				WHERE [bMain].[LocationId] = @LocationIdMain AND [b].[LocationId] = @Location_Id AND [bMain].[Id] <> [b].[Id]

				--[User]
				PRINT 'User:::'
				--Location
				PRINT 'Location:'
				UPDATE [User] SET [LastLocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [User]
				WHERE [LastLocationId] = @Location_Id

				--[BusinessUnitPermission]
				PRINT 'BusinessUnitPermission:::'
				--Location
				PRINT 'Location:'
				UPDATE [BusinessUnitPermission] SET [LocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [BusinessUnitPermission] AS [e]
				WHERE [LocationId] = @Location_Id
				AND 0 = (SELECT COUNT([Id]) FROM [BusinessUnitPermission] AS [bupMain] WHERE ([bupMain].[LocationId] = @LocationIdMain) AND ([bupMain].[BusinessUnitId] = [e].[BusinessUnitId]))
				--Zone
				PRINT 'Zone:'
				UPDATE [BusinessUnitPermission] SET [ZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] INNER JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [BusinessUnitPermission] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
				WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]
				AND 0 = (SELECT COUNT([Id]) FROM [BusinessUnitPermission] AS [bupMain] WHERE ([bupMain].[ZoneId] = [zMain].[Id]) AND ([bupMain].[BusinessUnitId] = [e].[BusinessUnitId]))
				--Bin
				PRINT 'Bin:'
				UPDATE [BusinessUnitPermission] SET [BinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	INNER JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) INNER JOIN [BusinessUnitPermission] AS [e] ON ([e].[BinId] = [b].[Id] ) 
				WHERE [bMain].[LocationId] = @LocationIdMain AND [b].[LocationId] = @Location_Id AND [bMain].[Id] <> [b].[Id]
				AND 0 = (SELECT COUNT([Id]) FROM [BusinessUnitPermission] AS [bupMain] WHERE ([bupMain].[BinId] = [bMain].[Id]) AND ([bupMain].[BusinessUnitId] = [e].[BusinessUnitId]))
		
				-- DELETE -- 
				PRINT '--- DELETE::'
				--BusinessUnitPermission remove for Location
				PRINT 'BusinessUnitPermission remove for Location:'
				DELETE [BusinessUnitPermission]
				FROM [Location] AS [l]
				INNER JOIN [BusinessUnitPermission] AS [bup] ON ([bup].[LocationId] = [l].[Id] ) 
				WHERE [l].[Id] = @Location_Id
				--BusinessUnitPermission remove for Zone
				PRINT 'BusinessUnitPermission remove for Zone:'
				DELETE [BusinessUnitPermission]
				FROM [Zone] AS [z] 
				INNER JOIN [BusinessUnitPermission] AS [bup] ON ([bup].[ZoneId] = [z].[Id] ) 
				WHERE [z].[LocationId] = @Location_Id
				--BusinessUnitPermission remove for Bin
				PRINT 'BusinessUnitPermission remove for Bin:'
				DELETE [BusinessUnitPermission]
				FROM [Bin] AS [b] 
				INNER JOIN [BusinessUnitPermission] AS [bup] ON ([bup].[BinId] = [b].[Id] ) 
				WHERE [b].[LocationId] = @Location_Id
				---
				--Bin remove
				PRINT 'Bin remove:'
				--SELECT * -- 
				DELETE [Bin]
				FROM [Bin] AS [b] 
				WHERE [b].[LocationId] = @Location_Id
				--Zone remove
				PRINT 'Zone remove:'
				--SELECT * -- 
				DELETE [Zone]
				FROM [Zone] AS [z] 
				WHERE [z].[LocationId] = @Location_Id
				--Location remove
				PRINT 'Location remove:'
				--SELECT * -- 
				DELETE [Location]
				FROM [Location] AS [l]
				WHERE [Id] = @Location_Id

				FETCH NEXT FROM Location_Cursor INTO @Location_Id, @Location_Code;  
			END;  
		CLOSE Location_Cursor;  
		DEALLOCATE Location_Cursor;  

		FETCH NEXT FROM Locations_Cursor INTO @LocationIdMain, @LocationCodeMain;
	END;  
CLOSE Locations_Cursor;  
DEALLOCATE Locations_Cursor;

ROLLBACK