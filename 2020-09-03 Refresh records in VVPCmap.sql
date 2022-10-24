declare @client as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')
declare @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
declare @vs1 as UNIQUEIDENTIFIER = (select D.id from Dimension D inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and D.Name = 'Project' and BUP.BusinessUnitId = @client)
declare @vs2 as UNIQUEIDENTIFIER = (select D.id from Dimension D inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and D.Name = 'Order' and BUP.BusinessUnitId = @client)
declare @vs3 as UNIQUEIDENTIFIER = (select D.id from Dimension D inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and D.Name = 'Commission' and BUP.BusinessUnitId = @client)

--select top(1) @vs1,@vs2,@vs3,@packer,@client from DimensionField
begin TRANSACTION
--delete from DFCZ_OSLETSYNC.dbo.VVPCMap --musí se stopnout služba ESB
COMMIT


BEGIN TRANSACTION
--SELECT * FROM BusinessUnit WHERE Name LIKE '%Deufol Hamburg%' OR Name LIKE '%Krones%'
--SELECT dim.* FROM Dimension dim WHERE EXISTS(SELECT Id FROM BusinessUnitPermission WHERE DimensionId =  dim.Id AND BusinessUnitId = @client)
--DELETE FROM DFCZ_OSLETSYNC.dbo.VVPCMap
INSERT INTO DFCZ_OSLETSYNC.dbo.VVPCMap
SELECT NEWID() AS Id,
'KRO_VV' AS Instance,
@client AS ClientId,
@packer AS PackerId,
CASE dv.DimensionId 
WHEN @vs1 THEN 'VS1'
WHEN @vs2 THEN 'VS2'
WHEN @vs3 THEN 'VS3'
END AS ObjectType,
dv.Content AS VVId,
dv.Id AS PCId
FROM DimensionValue dv 
WHERE dv.DimensionId IN (@vs1,@vs2,@vs3)
and dv.content not in (select vvid FROM DFCZ_OSLETSYNC.dbo.VVPCMap)

COMMIT

BEGIN TRANSACTION
INSERT INTO DFCZ_OSLETSYNC.dbo.VVPCMap
SELECT NEWID() AS Id,
'KRO_VV' AS Instance,
@client AS ClientId,
@packer AS PackerId,
'LP' AS ObjectType,
cv.Content AS VVId,
lp.Id AS PCId
FROM LoosePart lp 
INNER JOIN CustomField cf ON cf.Name = 'VVId' AND cf.ClientBusinessUnitId = @client AND cf.Entity = 15
INNER JOIN CustomValue cv ON cv.EntityId = lp.Id AND cv.Entity = 15 AND cv.CustomFieldId = cf.Id AND cv.Content <> ''
WHERE EXISTS(SELECT Id FROM BusinessUnitPermission WHERE LoosePartId =  lp.Id AND BusinessUnitId = @client)
and cv.content not in (select vvid FROM DFCZ_OSLETSYNC.dbo.VVPCMap)
COMMIT

BEGIN TRANSACTION
INSERT INTO DFCZ_OSLETSYNC.dbo.VVPCMap
SELECT NEWID() AS Id,
'KRO_VV' AS Instance,
@client AS ClientId,
@packer AS PackerId,
'HU' AS ObjectType,
cv.Content AS VVId,
hu.Id AS PCId
FROM HandlingUnit hu 
INNER JOIN CustomField cf ON cf.Name = 'VVId' AND cf.ClientBusinessUnitId = @client AND cf.Entity = 11
INNER JOIN CustomValue cv ON cv.EntityId = hu.Id AND cv.Entity = 11 AND cv.CustomFieldId = cf.Id AND cv.Content <> ''
WHERE EXISTS(SELECT Id FROM BusinessUnitPermission WHERE HandlingUnitId =  hu.Id AND BusinessUnitId = @client)
and cv.content not in (select vvid FROM DFCZ_OSLETSYNC.dbo.VVPCMap)
COMMIT

BEGIN TRANSACTION
INSERT INTO DFCZ_OSLETSYNC.dbo.VVPCMap
SELECT NEWID() AS Id,
'KRO_VV' AS Instance,
@client AS ClientId,
@packer AS PackerId,
'SHP' AS ObjectType,
cv.Content AS VVId,
sh.Id AS PCId
FROM ShipmentHeader sh 
INNER JOIN CustomField cf ON cf.Name = 'VVId' AND cf.ClientBusinessUnitId = @client AND cf.Entity = 31
INNER JOIN CustomValue cv ON cv.EntityId = sh.Id AND cv.Entity = 31 AND cv.CustomFieldId = cf.Id AND cv.Content <> ''
WHERE EXISTS(SELECT Id FROM BusinessUnitPermission WHERE ShipmentHeaderId =  sh.Id AND BusinessUnitId = @client)
and cv.content not in (select vvid FROM DFCZ_OSLETSYNC.dbo.VVPCMap)
COMMIT