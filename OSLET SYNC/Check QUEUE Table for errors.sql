SELECT  DISTINCT
Client.Name 
--SUBSTRING(XMLDocument,CHARINDEX('"LoosePart" : "',XMLDocument,1)+10,15)
--SUBSTRING(XMLDocument,CHARINDEX('"LoosePart" : "',XMLDocument,1),31)
,Q.ErrorMessage
,CASE Q.Status 
WHEN 0 then 'Import'
WHEN 1 then 'None'
WHEN 2 then 'Error'
WHEN 3 then 'Critical Error'
END StatusMessage
,CASE Q.ProxyId
when 'pcsduisync' then 'Siemens Duisburg'
else Q.ProxyId end as ClientBusinessUnit
,REPLACE(Cast(Q.XMLDocument as varchar(MAX)), CHAR(13),'')
,Q.ProxyId
,Q.Status
,MIN(Q.Updated)
  FROM DCNLPWSQL05.[DFCZ_OSLETSYNC].[dbo].[Queue] Q
LEFT JOIN (SELECT Id, ClientBusinessUnitId, BusinessUnitId
 FROM (VALUES 
('sms-hh','475b677d-b1b5-45c3-85c9-13bcac010463','5a73300c-1b1d-4ebe-9a7b-f335947ea422'),
('sms-bh','475b677d-b1b5-45c3-85c9-13bcac010463','e1a4a0d0-22e2-4da2-a76c-5faab107b490'),
('sms-pn','475b677d-b1b5-45c3-85c9-13bcac010463','e1ca5b53-40df-4a02-8115-117c32b7a380'),
('sms-wm','475b677d-b1b5-45c3-85c9-13bcac010463','0f58c359-693b-4ff6-a06c-e2cefd0917f2'),
('siempelkamp','a8ed6ae2-9016-4ff9-9951-0ff233a6328c','5a73300c-1b1d-4ebe-9a7b-f335947ea422'),
('kropcsync','2afb0812-aa09-4494-b2d3-777460852831','22acd076-0417-4ee5-a369-f4f0a767416d'),
('pcbccustgetsync','3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c','3b15a324-a7ae-4777-97a8-ba5e9ecf8d4c'),
('pcazsync','3f2d7a09-feb1-42c4-bb09-1e4f76fb9ec4','e7cce9f4-cca4-41b1-9065-f9fbb1b02f42'),
('pcsduisync','e25db7fd-f18d-43d2-bfab-d0db36e9cdfa','720af739-d9c3-4615-b3bc-39f85d7d8480'),
('pctkissync','4068eb72-2804-4ab0-982b-65892c946502','6e9c2155-d6e0-476b-ad5d-f54a9722c8e5'),
('pctkissync','e73284df-088a-4e1c-88f6-8afa670551a7','6e9c2155-d6e0-476b-ad5d-f54a9722c8e5')

 ) Proxy (Id, ClientBusinessUnitId, BusinessUnitId)) Proxy ON Q.ProxyId = Proxy.Id

 INNER JOIN BusinessUnit Client on Proxy.ClientBusinessUnitId = Client.Id


--where ErrorMessage = 'Import Error: BaseUnitOfMeasure - Column: BaseUnitOfMeasure Value: PC - It is not allowed to change base unit of measure; It is not allowed to change base unit of measure'
where ErrorMessage = 'Import Error:  - One or more selected items are assigned to packing order'
group by 
Client.Name 
,Q.ErrorMessage
,REPLACE(Cast(Q.XMLDocument as varchar(MAX)), CHAR(13),'')
,Q.ProxyId
,Q.Status

--Select * FROM DCNLPWSQL05.[DFCZ_OSLETSYNC].[dbo].[Queue] where ErrorMessage is not null ORDER by Updated desc


--AND ProxyId = 'pcsduisync' ORDER BY Updated 
--AND ProxyId = 'pcazsync' ORDER BY Updated 
--UPDATE [Queue] SET [Status] = 3 WHERE ProxyId = 'pcsduisync' AND [Status] = 2 
--UPDATE [Queue] SET [Status] = 2 WHERE ProxyId = 'pcsduisync' AND [Status] = 3 AND [ErrorMessage] = 'Import Error: BaseUnitOfMeasure - Column: BaseUnitOfMeasure Value: PC - It is not allowed to change base unit of measure; It is not allowed to change base unit of measure' 
--DELETE FROM [Queue] WHERE ProxyId = 'pcsduisync' AND [Status] = 3 AND Updated >= '2023-01-17 06:19:20.303' 
--DELETE FROM [Queue] WHERE ProxyId = 'pcsduisync' AND [ErrorMessage] = 'Import Error: - One or more selected items are assigned to packing order' 
--DELETE FROM [Queue] WHERE ProxyId = 'sms-hh' AND [Status] = 3



 SELECT ErrorStatus.Value, 
ErrorStatus.Name
 FROM (VALUES 
( 0 , 'Importing'),
( 1 , 'None'),
( 2 , 'Error'),
( 3 , 'Critical Error')
 ) 
ErrorStatus (Value,Name)


 SELECT 
ErrorMessages.Message
 FROM (VALUES 
('Import Error: - One or more selected items are assigned to packing order'),
('Import overwrite is not allowed')
 ) 
ErrorMessages (Message)



--select * from Queue where ProxyId = 'pctkissync'