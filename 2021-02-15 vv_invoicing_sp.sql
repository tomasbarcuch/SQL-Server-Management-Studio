CREATE PROCEDURE GetInvoicingData (@DatabaseNames VARCHAR(500))
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @databases TABLE (database_id int, [name] VARCHAR(250))
    DECLARE @CalTable TABLE ([DatabaseId] Varchar(50), [Table] VARCHAR(250), [Year] int, [Month] int)
    DECLARE @DataTable TABLE ([DatabaseId] Varchar(50), [Table] VARCHAR(250), [Year] int, [Month] int, [Count] int)
    DECLARE @DBSQL NVARCHAR(1000) = N'SELECT [database_id],[name] FROM [sys].[databases] WHERE [name] IN (' + @DatabaseNames + ')'
    DECLARE @ObjectId int
    INSERT @databases EXEC(@DBSQL)
    
    DECLARE db CURSOR FOR SELECT * FROM @databases
    OPEN db
	DECLARE @DatabaseId AS varchar(50)
	DECLARE @DatabaseName AS nvarchar(250)
	FETCH NEXT FROM db INTO @DatabaseId, @DatabaseName

	WHILE @@Fetch_Status=0 BEGIN
	   INSERT INTO @CalTable VALUES(@DatabaseId, 'Losteile', YEAR(GETDATE()), MONTH(GETDATE()))
       INSERT INTO @CalTable VALUES(@DatabaseId, 'Losteile', YEAR(CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))), MONTH(CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))))
       SET @DBSQL = 'SELECT ''' + @DatabaseId + ''' AS [DatabaseId], ''Losteile'' AS [Table], YEAR([DAT_LASTMOD]) AS [Year], MONTH(DAT_LASTMOD) AS [Month], COUNT(*) AS [Count] FROM [' + @DatabaseName + '].[dbo].[LOG_LOSTEILE] WHERE [W_STATUS] = 11020 AND [DAT_LASTMOD] >= CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1)) AND [DAT_LASTMOD] <= CONVERT(DATE, GETDATE()) GROUP BY YEAR([DAT_LASTMOD]), MONTH([DAT_LASTMOD])'
       INSERT @DataTable EXEC (@DBSQL)
	   INSERT INTO @CalTable VALUES(@DatabaseId, 'Kisten', YEAR(GETDATE()), MONTH(GETDATE()))
       INSERT INTO @CalTable VALUES(@DatabaseId, 'Kisten', YEAR(CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))), MONTH(CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))))
       IF (@DatabaseName = 'DCA_Flender_Data')
       BEGIN
          SET @DBSQL = 'SELECT ''' + @DatabaseId + ''' AS [DatabaseId], ''Kisten'' AS [Table], YEAR([DAT_LASTMOD]) AS [Year], MONTH(DAT_LASTMOD) AS [Month], COUNT(*) AS [Count] FROM [' + @DatabaseName + '].[dbo].[DAT_KISTEN] WHERE [W_STATUS] = 12110 AND [DAT_LASTMOD] >= CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1)) AND [DAT_LASTMOD] <= CONVERT(DATE, GETDATE()) GROUP BY YEAR([DAT_LASTMOD]), MONTH([DAT_LASTMOD])'
       END
       ELSE
       BEGIN
          SET @DBSQL = 'SELECT ''' + @DatabaseId + ''' AS [DatabaseId], ''Kisten'' AS [Table], YEAR([DAT_LASTMOD]) AS [Year], MONTH(DAT_LASTMOD) AS [Month], COUNT(DISTINCT(Z_KISTEN)) AS [Count] FROM [' + @DatabaseName + '].[dbo].[LOG_KISTEN] WHERE [W_STATUS] = 12040 AND [DAT_LASTMOD] >= CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1)) AND [DAT_LASTMOD] <= CONVERT(DATE, GETDATE()) GROUP BY YEAR([DAT_LASTMOD]), MONTH([DAT_LASTMOD])'
       END
	   INSERT INTO @CalTable VALUES(@DatabaseId, 'WEKollis', YEAR(GETDATE()), MONTH(GETDATE()))
       INSERT INTO @CalTable VALUES(@DatabaseId, 'WEKollis', YEAR(CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))), MONTH(CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1))))
       INSERT @DataTable EXEC (@DBSQL)
       SET @ObjectId = 0
       SET @DBSQL = N'SELECT TOP 1 @ObjectId = [object_id] FROM [' + @DatabaseName + N'].[sys].[tables] WHERE [name] = ''LOG_PAPPKARTONS'''
       EXEC sp_executesql @DBSQL, N'@ObjectId int out', @ObjectId out
       IF (@ObjectId > 0)
       BEGIN
          SET @DBSQL = 'SELECT ''' + @DatabaseId + ''' AS [DatabaseId], ''WEKollis'' AS [Table], YEAR([DAT_LASTMOD]) AS [Year], MONTH(DAT_LASTMOD) AS [Month], COUNT(*) AS [Count] FROM [' + @DatabaseName + '].[dbo].[LOG_PAPPKARTONS] WHERE [W_STATUS] = 23028 AND [DAT_LASTMOD] >= CONVERT(DATE, DATEADD(MONTH, -1, GETDATE() - DAY(GETDATE()) + 1)) AND [DAT_LASTMOD] <= CONVERT(DATE, GETDATE()) GROUP BY YEAR([DAT_LASTMOD]), MONTH([DAT_LASTMOD])'
          INSERT @DataTable EXEC (@DBSQL)
       END
       FETCH NEXT FROM db INTO @DatabaseId, @DatabaseName
	END

	CLOSE db
	DEALLOCATE db
    
    SELECT ct.*, ISNULL(dt.[Count], 0) AS [Count] FROM @CalTable ct LEFT OUTER JOIN @DataTable dt ON ct.DatabaseId = dt.DatabaseId AND ct.[Table] = dt.[Table] AND ct.[Year] = dt.[Year] AND ct.[Month] = dt.[Month];
END
GO

EXEC GetInvoicingData @DatabaseNames = '''ABB_VV'',''BAR_VV'',''DCA_Flender_Data'',''DO_UHDE_VV'',''GHH_KWU_VV'',''GHH_MAN_VV'',''KHS_VV'',''KRO_VV'',''LVS_VV'',''ONE_VV'',''SDU_VV'',''SIEMENSCLT_VV'',''SMS_VV'',''UCA_VV'',''XXX_VV'',''XXX_VV_DEUFOL_DORTMUND'''
GO

DROP PROCEDURE GetInvoicingData
GO