BEGIN TRANSACTION

----- MultiClientScript -----
-- VAR:
DECLARE @LocationIdMain AS UniqueIdentifier;
DECLARE @LocationCodeMain AS VARCHAR(100);
DECLARE @Location_Id AS UniqueIdentifier;
DECLARE @Location_Code AS VARCHAR(100);
--
DECLARE Locations_Cursor CURSOR FOR  
SELECT [Id],[Code]
FROM [Location]
--where id = '534037B9-E706-470E-8A67-CE08CAEBE340' --PPS
--where id = '6D67792C-A72D-4BD8-8CD8-DCB54BFFF728' -- HH
--where id = 'F8D3A4CA-5D9D-4642-BAEC-ECB9DCAD5E8D'
--where id = '9D10F414-3CEB-472F-84DC-EF9835CFA9F7'
--where id = 'D2B8D30D-8AFC-490F-9D9B-F90B3233A3A2'
--where id = '437D9FDB-8AF4-419E-BB27-FFCD2B22EA1A'
where id = 'a1bad147-33aa-4618-b885-ed1ba33bfc14'

--WHERE [Id] IN('3f6b06e0-91b5-4fb1-95f1-ff4beb6db155') --skupina 2.
--WHERE [Id] IN('dec61ca4-d4a5-44e0-925c-fba93e2f3f23') --skupina 1.
--WHERE [Id] IN('3720de7d-cd99-4d6e-a4ba-f97e92afe8b5') --skupina 1.
--WHERE [Id] IN('031dc79a-0052-49c5-96f7-e9d76260ce0b') --skupina 1.
--WHERE [Id] IN('6fee7b90-79d2-488d-9069-fa1eff68b626') --skupina 1.
--WHERE [Id] IN('313b8a53-8958-43b0-ac85-feee4edc2a02') --skupina 2.
--WHERE [Id] IN('3f6b06e0-91b5-4fb1-95f1-ff4beb6db155') --skupina 2.
--WHERE [Id] IN('dec61ca4-d4a5-44e0-925c-fba93e2f3f23','375692d7-6eab-4059-ba07-e1572e97062a','3720de7d-cd99-4d6e-a4ba-f97e92afe8b5','031dc79a-0052-49c5-96f7-e9d76260ce0b','3f6b06e0-91b5-4fb1-95f1-ff4beb6db155','6fee7b90-79d2-488d-9069-fa1eff68b626','6fa3847f-e839-4da4-abef-cc158523fb60','313b8a53-8958-43b0-ac85-feee4edc2a02') --skupina 1.
--WHERE [Id] IN(select max(id) from location group by code HAVING count(id) > 1)



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
				PRINT 'Zone Insert:'
				INSERT INTO [Zone] 
				([Id], [LocationId],[Name],[Description],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[Capacity])
				SELECT NEWID(),@LocationIdMain,[Name],[Description],[Disabled],[CreatedById],[UpdatedById],GETDATE(),GETDATE(),[Capacity]
				FROM [Zone] AS [z]
				WHERE 0 = (SELECT COUNT([Id]) FROM [Zone] AS [zMain] WHERE ([zMain].[Name] = [z].[Name] AND [zMain].[LocationId] = @LocationIdMain) )
				AND [z].[LocationId] = @Location_Id 
				--Bin Insert
				PRINT 'Bin Insert:'
				INSERT INTO [Bin] 
				([Id],[Code],[LocationId],zoneid,[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[MaximumVolume])     
				SELECT NEWID(),[Code],@LocationIdMain,null,B.[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],b.[Disabled],b.[CreatedById],b.[UpdatedById],GETDATE(),GETDATE(),[MaximumVolume]     
				FROM [Bin] AS [b]
                left join zone on b.ZoneId = zone.id
                left join (select name,id from Zone where [LocationId] = @LocationIdMain) zname on zname.name = Zone.name
where not exists (select id, code from bin where bin.id = b.id and bin.code = b.code)
and 0 = (SELECT COUNT([Id]) FROM [Bin] AS [bMain] WHERE ([bMain].[Code] = [b].[Code] AND [bMain].[LocationId] = @LocationIdMain) )
--						 where ([b].[LocationId] = @Location_Id and zone.LocationId <> @LocationIdMain and b.Code not in (select code from bin where LocationId = @LocationIdMain)) --funkční pro skupinu 1.
						 --and ([b].[LocationId] = @Location_Id and zone.LocationId <> @LocationIdMain ) and b.Code not in (select code from bin where LocationId = @LocationIdMain)) --funkční pro skupinu 2.
		--or  ([b].[LocationId] = @Location_Id and b.Code not in (select code from bin where LocationId = @LocationIdMain))
				--[HandlingUnit]

/*	INSERT INTO [Bin] 
				([Id],[Code],[LocationId],zoneid,[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],[Disabled],[CreatedById],[UpdatedById],[Created],[Updated],[MaximumVolume])     
				SELECT NEWID(),Bin.Code,@LocationIdMain,null,Bin.[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],bin.[Disabled],bin.[CreatedById],bin.[UpdatedById],GETDATE(),GETDATE(),[MaximumVolume]   
from WarehouseEntry
inner join Bin on WarehouseEntry.BinId = bin.Id
left join (select code,id from Bin where locationid = @LocationIdMain) bmain on bin.code = bmain.Code
 where BinId in (
select id from bin where LocationId = @Location_Id) 
group by bin.Code,
Bin.[Description],[Length],[Width],[Height],[Empty],[MaximumWeight],[BlockMovement],bin.[Disabled],bin.[CreatedById],bin.[UpdatedById],[MaximumVolume]   
*/

				PRINT 'HandlingUnit:::'
				--Location
				PRINT 'Location:'
				UPDATE [HandlingUnit] SET [ActualLocationId] =  @LocationIdMain, [Updated] = GETDATE()
				FROM [HandlingUnit] 
				WHERE [ActualLocationId] = @Location_Id
				--Zone
							PRINT 'Zone:'
				UPDATE [HandlingUnit] SET [ActualZoneId] = [zMain].[Id], [Updated] = GETDATE()
				FROM [Zone] AS [zMain] 
				INNER JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) 
				INNER JOIN [HandlingUnit] AS [e] ON ([e].[ActualZoneId] = [z].[Id] )  --AND [z].[LocationId] = [e].[ActualLocationId] 
						WHERE [zMain].[LocationId] = @LocationIdMain AND [z].[LocationId] = @Location_Id AND [zMain].[Id] <> [z].[Id]

				--Bin
				PRINT 'Bin:'
				UPDATE [HandlingUnit] SET [ActualBinId] = [bMain].[Id], [Updated] = GETDATE()
				FROM [Bin] AS [bMain]	INNER JOIN [Bin] AS [b] ON ([b].[Code] = [bMain].[Code]) INNER JOIN [HandlingUnit] AS [e] ON ([e].[ActualBinId] = [b].[Id] ) -- ?? AND [z].[LocationId] = [e].[ActualLocationId] )
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
				FROM [Zone] AS [zMain] LEFT JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [LoosePart] AS [e] ON ([e].[ActualZoneId] = [z].[Id] ) 
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
				FROM [Zone] AS [zMain] LEFT JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [WarehouseEntry] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
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
				FROM [Zone] AS [zMain] LEFT JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [WarehouseContent] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
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
				FROM [Zone] AS [zMain] LEFT JOIN [Zone] AS [z] ON ([z].[Name] = [zMain].[Name]) INNER JOIN [InventoryLine] AS [e] ON ([e].[ZoneId] = [z].[Id] ) 
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
						
				-- DELETE -- 
				PRINT '--- DELETE::'
				--BusinessUnitPermission remove for Location
				PRINT 'BusinessUnitPermission remove for Location:'
				DELETE [BusinessUnitPermission]
				FROM [Location] AS [l]
				INNER JOIN [BusinessUnitPermission] AS [bup] ON ([bup].[LocationId] = [l].[Id] ) 
				WHERE [l].[Id] = @Location_Id
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

COMMIT