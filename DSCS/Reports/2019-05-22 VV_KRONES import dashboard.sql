select vvid,(cast(count(*) as varchar) +' '+ (state)) as message from
(select vvid,OBJECT_TYPE+'-'+VVID+' - '+ERROR_MESSAGE as state FROM DCNLPWSQL02.[KRO_VV].[dbo].VV_PCENTER_INTERFACE WHERE [STATUS] = 0 and ERROR_COUNT > 0) data
group by state,vvid
union
select '' as 'vvid',(cast(count(*) as varchar)+' '+'records are waiting for import') as state from
(select * FROM DCNLPWSQL02.[KRO_VV].[dbo].VV_PCENTER_INTERFACE WHERE [STATUS] = 0 and ERROR_COUNT = 0) data


/*
SELECT GETDATE()              --your query to run
raiserror('',0,1) with nowait --to flush the buffer
waitfor delay '00:00:03'      --pause for 3 seconds
GO 5                          --loop 5 times
*/

select HU,vvid,msg,count(*) as records from
(select HU.Code as hu,PCI.VVID as vvid, PCI.ERROR_MESSAGE as msg FROM DCNLPWSQL02.[KRO_VV].[dbo].VV_PCENTER_INTERFACE  PCI
inner join customvalue CV on PCI.vvid = CV.content
inner join CustomField CF on CV.customfieldid = CF.id and CF.Name = 'VVID'
inner join handlingunit HU on CV.entityid = HU.id
WHERE [STATUS] = 0 and ERROR_COUNT > 0) data
group by HU,vvid,msg
union
select '',cast(count(*) as varchar) as vvids,'waiting for import' as msg,count(*) from
(select * FROM DCNLPWSQL02.[KRO_VV].[dbo].VV_PCENTER_INTERFACE WHERE [STATUS] = 0 and ERROR_COUNT = 0) data



--select * from DCNLPWSQL02.[KRO_VV].[dbo].VV_PCENTER_INTERFACE where received >  '2021-05-11' and status = 3