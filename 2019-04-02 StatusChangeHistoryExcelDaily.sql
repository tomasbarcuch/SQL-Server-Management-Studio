declare @fromdate as DATETIME
declare @todate as DATETIME

set @fromdate = getdate()-300
set @todate = getdate()

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

select 
final.Datum,
final.Uhrzeit,
final.Kundenauftrag,
final.[Pos (Baugrp)],
final.[PackstückIdent (Beipack)],
final.[Kisten Nr.],
case final.[Rückmeldepunkt Bezeichnung] when 'Rücklieferung abgeschlossen' then '610' else final.[Rückmeldepunkt Code] end as 'Rückmeldepunkt Code',
case when final.[Rückmeldepunkt Code] = 610 then 'Rücklieferung abgeschlossen' else final.[Rückmeldepunkt Bezeichnung] end as 'Rückmeldepunkt Bezeichnung',
final.Sperrcode,
final.[Sperrgrund-Bezeichnung],
final.[Sperrgrund Beschreibung],
final.[Sperrt Lack],
final.[Sperrt Verpack],
final.[Sperrt WA]


 from (
select
--retdel.Rücklieferdatum,
--isnull(case row.code when 100 then cast(data.Created as datetime) when 110 then cast(InbBin.inbende as datetime) when 400 then cast(InbBin.inbende as datetime) end,DATA.Created) as 'Created',
--retdel.Rücklieferdatumstart as created,
data.created,
--data.createdwfe,
cast(isnull(case row.code
when 100 then cast(data.Created as datetime)
when 110 then cast(InbBin.inbende as datetime)
when 400 then cast(InbBin.inbende as datetime)
end,
DATA.Created) as date) as 'Datum',
substring(CONVERT(VARCHAR, (isnull(case row.code
when 100 then cast(data.Created as datetime)
when 110 then cast(InbBin.inbende as datetime)
when 400 then cast(InbBin.inbende as datetime)
end,DATA.Created)), 108),0,6)  as 'Uhrzeit',
Coded.code as 'Kundenauftrag',
CFPosition.Position as 'Pos (Baugrp)',
Data.lp as 'PackstückIdent (Beipack)',
DAta.hu as 'Kisten Nr.',
isnull(row.code, 
Case when RetDel.Rücklieferdatum is null then 
(case [Status explanation]
when 'Sondermarkierung Start' then '500'
when 'Lackierung Start' then '200'
when 'Nachträgliche Markierung Start' then '520'
when 'Nachträgliche Markierung LP Start' then '520'
when 'Sondermarkierung LP Start' then '500'
when 'Sondermarkierung abgeschlossen' then '510'
when 'Nachträgliche Markierung Ende' then '530'---
when 'Nachträgliche Markierung LP abgeschlossen' then '530'
when 'Sondermarkierung LP Ende' then '510'
when 'Nachträgliche Lackierung Start' then '220'---
when 'Nachträgliche Lackierung Ende' then '230'---
when 'Sondermarkierung LP abgeschlossen' then '510'
when 'Lackschaden Start' then '240'---
when 'Lackschaden abgeschlossen' then '250'---
else ExplanationCode end)else '610' end) as 'Rückmeldepunkt Code',
/*case row.code 
when '100' then Data.[Status explanation]
when '110' then 'Lagerung Start'
when '400' then 'Lagerung Start'
else (Case when RetDel.Rücklieferdatum is null then (Data.[Status explanation]) else 'Rücklieferung abgeschlossen' end) end as 'Rückmeldepunkt Bezeichnung'*/

Case when RetDel.Rücklieferdatum is null then (case row.code 
when '100' then Data.[Status explanation]
when '110' then 'WE gebucht' --
when '400' then 'Lagerung Start' --
else Data.[Status explanation] end) else --'Rücklieferung abgeschlossen'
case when row.code = '100' then 'Rücklieferung abgeschlossen' else
case when row.code = '110' then 'WE gebucht' else  
'Lagerung Start' end end
end as 'Rückmeldepunkt Bezeichnung',
NULL as 'Sperrcode',
NULL as 'Sperrgrund-Bezeichnung',
NULL as 'Sperrgrund Beschreibung',
NULL as 'Sperrt Lack',
NULL as 'Sperrt Verpack',
NULL as 'Sperrt WA'

from (
select
wfe.Created as createdwfe,
wfe.StatusId,
case when (
left(right((convert(datetime, WFE.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
WFE.Created + right((convert(datetime, WFE.Created) at TIME zone 'Central European Standard Time'),5)
else 
WFE.Created - right((convert(datetime, WFE.Created) at TIME zone 'Central European Standard Time'),5)
end as Created,
--WFE.Created,
case T.Text
when 'LpNeu' then '100'
when 'LpWe' then '110'
when 'Entpacken Start' then '540'
when 'Entpacken Ende' then '550'
when 'LpVerladen' then '700'
when 'LpAusgeliefert' then '410'
when 'LpLackiertFrei' then '210'
when 'HuVerpackt' then '310'
when 'LpVerpackt' then '300'
when 'SlStart' then SLT.Code +' Start'
when 'SlFertig' then SLT.Code +' Ende'
when 'LpWESiemens' then '600'
when 'LpLackiertFreiSiemens' then '600'
when 'LpSollLackiertSiemens' then '600'
else '' end as 'ExplanationCode',
case T.Text

when 'LpWe' then 'Warenankunft' --
when 'Entpacken Start' then 'Entpacken Start' --
when 'Entpacken Ende' then 'Entpacken abgeschlossen' --
when 'LpVerladen' then 'Warenausgang gebucht'
when 'LpAusgeliefert' then 'Lagerung abgeschlossen'
when 'HuVerladen' then 'Lagerung abgeschlossen'
when 'HuTeilverpackt' then 'Verpackung Start'
when 'LpLackiertFrei' then 'Lackierung abgeschlossen'--
when 'HuVerpackt' then 'Verpackung abgeschlossen'
when 'LpVerpackt' then 'Verpackung Start'
when 'HuWA' then 'Warenausgang gebucht'
when 'LpWA' then 'Warenausgang gebucht'
when 'SlStart' then SLT.Code +' Start'
when 'SlFertig' then SLT.Code +' abgeschlossen'
when 'LpWESiemens' then 'Rücklieferung Start'
when 'LpLackiertFreiSiemens' then 'Rücklieferung Start'
when 'LpSollLackiertSiemens' then 'Rücklieferung Start'
else '' end as 'Status explanation',
T.Text,
Isnull(isnull((isnull(LP.id,SLofLP.id)),SLSL.id),LPinHU.id) as LPid,
Isnull(isnull((isnull(LP.Code,SLofLP.Code)),SLSL.code),LPinHU.Code) as LP,
Isnull(isnull(isnull(HULP.Code,HU.code),HUofSLofLP.Code),slhu.code) as HU,
 case wfe.entity
	  when '15' then 'LP'
	  when '11' then 'HU'
	  when '10' then 'DIMENSION Value'
	  when '48' then upper(SLT.Code)
	  when '9' then 'DIMENSION'
	  when '31' then 'SHIPMENT'
	  when '35' then 'PACKORDER'
	  else '' end as EntityShortcut
from WorkflowEntry WFE
inner join status S on WFE.StatusId = S.id
  	left outer join (SELECT StatusId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE StatusId is not null) BUPs on S.id = BUPs.StatusId
  inner join [User] U on WFE.UpdatedById = U.Id
  left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE' and s.disabled = 'false'
  
  left join LoosePart LP on WFE.EntityId = LP.Id and WFE.Entity =  15
      left join HandlingUnit HULP on LP.TopHandlingUnitId = HULP.id
  left join HandlingUnit HU on wfe.EntityId = HU.id and WFE.Entity =  11
     left join LoosePart LPinHU on HU.id = LPinHU.TopHandlingUnitId
    
  left join ServiceLine SL on WFE.EntityId = SL.Id and WFE.Entity =  48
  left join LoosePart SLofLP on SL.EntityId = SLofLP.Id
  left join HandlingUnit HUofSLofLP on SLofLP.TopHandlingUnitId = HUofSLofLP.Id
  left join HandlingUnit slHU on SL.EntityId = slHU.Id
  left join LoosePart SLSL on SLHU.id = SLSL.TopHandlingUnitId
  left join ServiceType SLT on SL.ServiceTypeId = SLT.Id
  
where BUPs.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'
and wfe.Entity in (11,15,48)
and WFE.Updated between @fromdate and @todate
and t.text not in(
'SlNeu',
'Annulliert',
'HuVerladen',
'HuMarkierung',
'HuWA',
'HuAnnulliert',
'HuNeu',
'HuTeilverpackt',
'HuWE',
'SlFertig',
'SlGedruckt',
'SlAkzeptiert',
'SlAngebot',
'LpSollLackiertSiemensG',
'LpZuAnnullieren',
'LpWeSiemensG',
'LpNeu',
'LpWA',
'LpLackiertFreiSiemensG',
'LpGedruckt',
'LpAnnulliert',
'LpSollLackiert'
    )) DATA
left join (select row,code from (values ('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','100'), ('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','110'),('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','400')) x(row,code)) row on DATA.StatusId = row.[row]

left join (
Select
EDVR.entityid,
DV.Content as 'Code'
from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id
) CodeD on data.LPid = CodeD.EntityId

left join  (select 
CV.EntityId,
CV.Content 'Position'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Position') CFPosition on Data.LPid = CfPosition.EntityId

left join (select 
isnull(WE.LoosepartId,WE.HandlingUnitId) as EntityId,
min(case when (
left(right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
WE.Created + right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
else 
WE.Created - right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
end) as 'inbstart',
max(case when (
left(right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
WE.Created + right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
else 
WE.Created - right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
end) as 'inbende'
from WarehouseEntry WE
inner join bin B on WE.BinId = B.Id
where b.Code = 'Wareneingang' 
group by isnull(WE.LoosepartId,WE.HandlingUnitId)) InbBin on Data.LPId = InbBin.EntityId

left join (select 
LP.code LPcode,
min(distinct berlin.created) 'Rücklieferdatumstart',
Max(distinct berlin.created) 'Rücklieferdatum',  
berlin.EntityId from( select Statusid,created,Id, EntityId from workflowentry WF 
where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where name in
('LpInbound',
'LpToBePainted',
'LpPainted') 
and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2')) Berlin 
inner join (

select WF.EntityId from workflowentry WF where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where name in
('LpInboundSiemens',
'LpToBePaintedSIEMENS',
'LpPaintedSiemens'
)and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2')) Siemens on Berlin.EntityId = Siemens.EntityId
inner join status S on berlin.StatusId = S.id
inner join LoosePart LP on berlin.EntityId = LP.id
inner join (
select WF.EntityId from workflowentry WF where wf.StatusId in (select S.id from Status S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where name in
('LpInbound',
'LpToBePainted',
'LpPainted'
)
and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2')
group by EntityId
having count(id) > 1) CNT on berlin.EntityId = CNT.EntityId 
group by berlin.EntityId,LP.code) RetDel on data.LPid = RetDel.entityId and RetDel.Rücklieferdatum = DATA.CreatedWFE

union

select
cast(dates.datum as date),
cast(dates.Datum as date) as Datum,
'12:00' as Uhrzeit,
CodeD.Code as Kundenauftrag,
CFPosition.Position as 'Pos (Baugrp)',
LP.code as 'PackstückIdent (Beipack)',
HU.Code as 'Kisten Nr.',
case dates.Name 
when 'DatumStart' then '150'--
when 'DatumEnd' then '160'
end as 'Rückmeldepunkt Code',
'Sperrfläche '+' '+ dates.Name 'Rückmeldepunkt Bezeichnung' ,
LEFT(LockHeader.LockReason,2) as 'Sperrcode',
substring(LockHeader.LockReason,4,30) 'Sperrgrund-Bezeichnung',
LockHeader.Text as 'Sperrgrund Beschreibung',
LockHeader.LockPaint as 'Sperrt Lack',
LockHeader.LockPacking as 'Sperrt Verpack',
LockHeader.LockOutbound as 'Sperrt WA'

from (
select LockHeader.* from (
SELECT 
C.text,
--Customfield.clientbusinessunitid,
CustomField.Name as CF_Name, 
C.entityID as LPid,
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
inner join Comment C on CV.EntityId = C.Id
where name in ('LockReason','LockOutbound','LockPacking','LockPaint')
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([LockReason],[LockOutbound],[LockPacking],[LockPaint])
        ) as LockHeader) as LockHeader --,'LockOutbound','LockPacking','LockPaint'

inner join (
select 
EntityID,
CF.Name,
cast(CV.Content as datetime) as Datum,
case when (
left(right((convert(datetime, CV.updated) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
CV.Updated + right((convert(datetime,CV.Updated) at TIME zone 'Central European Standard Time'),5)
else 
CV.updated - right((convert(datetime, CV.updated) at TIME zone 'Central European Standard Time'),5)
end as Created


from customvalue CV 
--inner join Comment C on CV.EntityId = C.Id
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CV.CustomFieldId in 
(select id from CustomField where name in ('DatumStart','DatumEnd'))) dates on lockheader.EntityID = dates.EntityId

inner join LoosePart LP on lockHeader.LPid = LP.id

left join (
Select
EDVR.entityid,
DV.Content as 'Code'
from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id
) CodeD on LP.id = CodeD.EntityId

left join  (select 
CV.EntityId,
CV.Content 'Position'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Position') CFPosition on LP.id = CfPosition.EntityId

left join HandlingUnit HU on LP.TopHandlingUnitId = HU.Id
where dates.created between @fromdate and @todate

UNION

select
cast(dates.datum as date),
cast(dates.Datum as date) as Datum,
'12:00' as Uhrzeit,
CodeD.Code as Kundenauftrag,
CFPosition.Position as 'Pos (Baugrp)',
LP.code as 'PackstückIdent (Beipack)',
HU.Code as 'Kisten Nr.',
case dates.Name 
when 'DatumStart' then '150'
when 'DatumEnd' then '160'
end as 'Rückmeldepunkt Code',
'Sperrfläche '+' '+ dates.Name 'Rückmeldepunkt Bezeichnung' ,
LEFT(LockHeader.LockReason,2) as 'Sperrcode',
substring(LockHeader.LockReason,4,30) 'Sperrgrund-Bezeichnung',
LockHeader.Text as 'Sperrgrund Beschreibung',
LockHeader.LockPaint as 'Sperrt Lack',
LockHeader.LockPacking as 'Sperrt Verpack',
LockHeader.LockOutbound as 'Sperrt WA'

from (
select LockHeader.* from (
SELECT 
C.text,
--Customfield.clientbusinessunitid,
CustomField.Name as CF_Name, 
C.entityID as HUid,
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
inner join Comment C on CV.EntityId = C.Id
where name in ('LockReason','LockOutbound','LockPacking','LockPaint')
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([LockReason],[LockOutbound],[LockPacking],[LockPaint])
        ) as LockHeader) as LockHeader --,'LockOutbound','LockPacking','LockPaint'

inner join (
select 
EntityID,
CF.Name,
cast(CV.Content as datetime) as Datum,
case when (
left(right((convert(datetime, CV.updated) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
CV.Updated + right((convert(datetime,CV.Updated) at TIME zone 'Central European Standard Time'),5)
else 
CV.updated - right((convert(datetime, CV.updated) at TIME zone 'Central European Standard Time'),5)
end as Created


from customvalue CV 
--inner join Comment C on CV.EntityId = C.Id
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CV.CustomFieldId in 
(select id from CustomField where name in ('DatumStart','DatumEnd'))) dates on lockheader.EntityID = dates.EntityId

inner join HandlingUnit HU on lockHeader.HUid = HU.id

left join (
Select
EDVR.entityid,
DV.Content as 'Code'
from DimensionValue DV
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id
) CodeD on HU.id = CodeD.EntityId

left join  (select 
CV.EntityId,
CV.Content 'Position'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Position') CFPosition on HU.id = CfPosition.EntityId

left join LoosePart LP on HU.id = LP.TopHandlingUnitId
where dates.created between @fromdate and @todate


) Final where final.[PackstückIdent (Beipack)] is not null

--and final.Created BETWEEN @fromdate and @todate

--and [Rückmeldepunkt Code]+[Rückmeldepunkt Bezeichnung] not in ('110Rücklieferung abgeschlossen','400Rücklieferung abgeschlossen')
and [PackstückIdent (Beipack)] = '0000035673/000201'
--and [Rückmeldepunkt Bezeichnung] = 'Rücklieferung abgeschlossen'

