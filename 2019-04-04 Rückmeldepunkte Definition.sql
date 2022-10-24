select
T.text,
S.name, 
case when stat.Entity in (11,15,48) and t.text not in('Annulliert','LpAnnulliert','SlNeu','HuAnnulliert','HuNeu','HuWE','HuTeilverpackt','LpSollLackiert','LpGedruckt','SlAngebot','SlAkzeptiert','SlGedruckt') then 1 else 0 end as export,
case stat.entity
	  when '15' then 'LOOSE PART'
	  when '11' then 'HANDLING UNIT'
	  when '10' then 'DIMENSION Value'
	  when '48' then 'SERVICELINE'
	  when '9' then 'DIMENSION'
	  when '31' then 'SHIPMENT'
	  when '35' then 'PACKORDER'
	  else '' end as EntityShortcut,
      case T.Text
when 'LpNeu' then 'WE (Warenankunft)'
when 'LpWe' then 'WE gebucht / Lagerung Start'
when 'Entpacken Start' then 'Entpacking Start'
when 'Entpacken Ende' then 'Entpacking abgeschlossen'
when 'LpVerladen' then 'Lagerung abgeschlossen'
when 'LpAusgeliefert' then 'Warenausgang gebucht'
when 'HuVerladen' then 'Lagerung abgeschlossen'
when 'HuTeilverpackt' then 'Verpackung Start'
when 'LpLackiertFrei' then 'Lackierung Ende'
when 'HuVerpackt' then 'Verpackung abgeschlossen'
when 'LpVerpackt' then 'Verpackung Start'
when 'HuWA' then 'Warenausgang gebucht'
when 'LpWA' then 'Warenausgang gebucht'
when 'SlStart' then 'SL Start'
when 'SlFertig' then 'SL Ende'
when 'LpWESiemens' then 'Rücklieferung Start'
when 'LpLackiertFreiSiemens' then 'Rücklieferung Start'
when 'LpSollLackiertSiemens' then 'Rücklieferung Start'
else '' end as 'Status explanation',
case T.Text
when 'LpNeu' then '100'
when 'LpWe' then '110'
when 'Entpacken Start' then '0'
when 'Entpacken Ende' then '0'
when 'LpVerladen' then '410'
when 'LpAusgeliefert' then '600'
when 'HuVerladen' then '410'
when 'HuTeilverpackt' then '300'
when 'LpLackiertFrei' then '210'
when 'HuVerpackt' then '310'
when 'LpVerpackt' then '300'
when 'HuWA' then '600'
when 'SlStart' then ' SL Start'
when 'SlFertig' then 'SL Ende'
when 'LpWESiemens' then '560'
when 'LpLackiertFreiSiemens' then '560'
when 'LpSollLackiertSiemens' then '560'
else '' end as 'ExplanationCode'

 from

(select WFE.StatusId, WFE.Entity from WorkflowEntry WFE
inner join status S on WFE.StatusId = S.id
  left outer join (SELECT StatusId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE StatusId is not null) BUPs on S.id = BUPs.StatusId

  where BUPs.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'
  group by WFE.StatusId, WFE.Entity) Stat
inner join Status S on Stat.StatusId = s.Id and s.[Disabled] = 0
    left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE'
where stat.Entity in (11,15)

union

select 
T.text,
S.Name,
case when Serl.Entity in (11,15,48) and t.text not in('Annulliert','LpAnnulliert','SlNeu','HuAnnulliert','HuNeu','HuWE','HuTeilverpackt','LpSollLackiert','LpGedruckt','SlAngebot','SlAkzeptiert','SlGedruckt') then 1 else 0 end as export,
    ST.Code as EntityShortcut,
      case T.Text
when 'SlStart' then 'SL Start'
when 'SlFertig' then 'SL Ende'
else '' end as 'Status explanation',
case T.Text
when 'SlStart' then '0'
when 'SlFertig' then '0'
else '' end as 'ExplanationCode'

 from (
select SL.ServiceTypeId, SL.StatusId,Sl.Entity from ServiceLine SL
inner join BusinessUnitPermission BUPsl on SL.id = BUPsl.ServiceLineId
where BUPsl.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'
group by SL.ServiceTypeId,SL.StatusId, SL.Entity) Serl

inner join Status S on Serl.StatusId = s.Id and s.[Disabled] = 0
    left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE'
inner join ServiceType ST on serl.ServiceTypeId = ST.Id

