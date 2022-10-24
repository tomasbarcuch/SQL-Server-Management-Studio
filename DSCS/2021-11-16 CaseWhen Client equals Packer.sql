
declare @ClientBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')
declare @PackerBusinessUnitId as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'KRONES GLOBAL')


select * from BCSLog



where (
(CASE WHEN @ClientBusinessUnitId = @PackerBusinessUnitId and BCSLog.ClientBusinessUnitId = @ClientBusinessUnitId then 1 else 0 end ) = 1
OR 
(CASE WHEN @ClientBusinessUnitId <> @PackerBusinessUnitId and BCSLog.ClientBusinessUnitId = @ClientBusinessUnitId and BCSLog. PackerBusinessUnitId = @PackerBusinessUnitId then 1 else 0 end ) = 1
)