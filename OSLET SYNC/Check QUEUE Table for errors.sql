SELECT 
SUBSTRING(XMLDocument,CHARINDEX('"Code" : "',XMLDocument,1)+10,15)
  FROM [DFCZ_OSLETSYNC].[dbo].[Queue] 
where ErrorMessage = 'Import Error: BaseUnitOfMeasure - Column: BaseUnitOfMeasure Value: PC - It is not allowed to change base unit of measure; It is not allowed to change base unit of measure'


Select * FROM [DFCZ_OSLETSYNC].[dbo].[Queue] where ErrorMessage is not null




--AND ProxyId = 'pcsduisync' ORDER BY Updated 
--AND ProxyId = 'pcazsync' ORDER BY Updated 
--UPDATE [Queue] SET [Status] = 3 WHERE ProxyId = 'pcsduisync' AND [Status] = 2 
--UPDATE [Queue] SET [Status] = 2 WHERE ProxyId = 'pcsduisync' AND [Status] = 3 AND [ErrorMessage] = 'Import Error: BaseUnitOfMeasure - Column: BaseUnitOfMeasure Value: PC - It is not allowed to change base unit of measure; It is not allowed to change base unit of measure' 
--DELETE FROM [Queue] WHERE ProxyId = 'pcsduisync' AND [Status] = 3 AND Updated >= '2023-01-17 06:19:20.303' 
--DELETE FROM [Queue] WHERE ProxyId = 'pcsduisync' AND [ErrorMessage] = 'Import Error: - One or more selected items are assigned to packing order' 
--DELETE FROM [Queue] WHERE ProxyId = 'sms-hh' AND [Status] = 3

