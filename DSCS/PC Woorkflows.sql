/****** Script for SelectTopNRows command from SSMS  ******/

use DFCZ_OSLET
SELECT
t_olds.Language language, 
t_news.Language language1,  
bu.name bu, 
p.name permission,
s_old.name olds,
t_olds.text olds_name,
t_news.text news_name,
s_new.name news,
w.entity,
case w.entity
when 2 then 'Handling Unit 2'
when 7 then 'Dimension'
when 11 then 'Handlint Unit'
when 15 then 'Lose Part'
when 31 then 'Shipment Header'
when 35 then 'Packing Order Header'
when 48 then 'Service Line'
else 'X'end as 'entity name',
w.action,
case w.Action
when 0 then 'none'
when 1 then 'Inbound'
when 2 then 'Outbound'
when 5 then 'Packing'
when 6 then 'Unpacking'
when 7 then 'Loading'
when 8 then 'Packing In'
when 9 then 'Unpacking From'
when 10 then 'Unloading'
when 11 then 'Loading To'
when 13 then 'Loaded All'
when 14 then 'Unloaded All'
when 16 then 'Printing'
when 17 then 'Change Status'
when 21 then 'Assigned'
when 22 then 'Packed All'
when 24 then 'Assign Value'
else 'X' end as 'action name',
s_old.position old_pos,
s_new.position new_pos
--,w.*
  FROM [Workflow] w
  inner join dbo.Permission p on w.PermissionId = p.id
  inner join dbo.businessunit bu on w.clientBusinessUnitId = bu.id
  inner join dbo.status s_old on w.oldstatusid = s_old.id
  inner join dbo.status s_new on w.newstatusid = s_new.id
  left outer join dbo.Translation t_olds on s_old.id = t_olds.entityid
  left outer join dbo.Translation t_news on s_new.id = t_news.entityid
  where (s_old.[Disabled] = 0 and s_new.[Disabled] = 0) and
  w.clientbusinessUnitId = 'ec936ade-e7de-47a8-8015-14ef302bff59' and t_olds.Language = 'DE' and t_news.Language = 'DE'

  order by w.entity



