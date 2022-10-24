DECLARE @FROM as date = '2022-02-01'
DECLARE @TO as date = '2022-02-28'

select
DISTINCT 

final.Datum,
final.Uhrzeit, 
final.Kundenauftrag as Projekt,
final.[Projekt Beschreibung], 
final.BusinessUnit,
final.[Pos (Baugrp)], 
final.[PackstückIdent (Beipack)],
final.Weight,
final.[Description] as [Bem.], 
final.[Kisten Nr.],
case final.[Rückmeldepunkt Bezeichnung] when 'Rücklieferung abgeschlossen' then '610' else final.[Rückmeldepunkt Code] end as 'Rückmeldepunkt Code',
case when final.[Rückmeldepunkt Code] = '610' then 'Rücklieferung abgeschlossen' else final.[Rückmeldepunkt Bezeichnung] end as 'Rückmeldepunkt Bezeichnung',
'WE' 'Bewegung',
Final.Sorting,
Final.Class,
MONTH(final.Datum) as 'Month'

 from (select MAIN.* from (
select
DATA.[Description],
DATA.Weight,
DATA.BusinessUnit,
data.created,
cast(isnull(case row.code
when '100' then cast(data.Created as datetime)
when '110' then cast(InbBin.inbende as datetime)
when '400' then cast(InbBin.inbende as datetime)
end,
DATA.Created) as date) as 'Datum',
substring(CONVERT(VARCHAR, (isnull(case row.code
when '100' then cast(data.Created as datetime)
when '110' then cast(InbBin.inbende as datetime)
when '400' then cast(InbBin.inbende as datetime)
end,DATA.Created)), 108),0,6)  as 'Uhrzeit',
Coded.code as 'Kundenauftrag',
Coded.DDesc as 'Projekt Beschreibung',
CFPosition.Position as 'Pos (Baugrp)',
Data.lp as 'PackstückIdent (Beipack)',
DAta.hu as 'Kisten Nr.',
isnull(row.code, 
Case when RetDel.Rücklieferdatum is null then 
(case DATA.[Status explanation]
when 'Sondermarkierung Start' then '500'
when 'Lackierung Start' then '200'
when 'Nachträgliche Markierung Start' then '520'
when 'Nachträgliche Markierung LP Start' then '520'
when 'Sondermarkierung LP Start' then '500'
when 'Sondermarkierung abgeschlossen' then '510'
when 'Nachträgliche Markierung abgeschlossen' then '530'
when 'Nachträgliche Markierung LP abgeschlossen' then '530'
when 'Sondermarkierung LP Ende' then '510'
when 'Nachträgliche Lackierung Start' then '220'
when 'Nachträgliche Lackierung abgeschlossen' then '230'
when 'Sondermarkierung LP abgeschlossen' then '510'
when 'Lackschaden Start' then '240'
when 'Lackschaden abgeschlossen' then '250'
else ExplanationCode end)else 
case RetDel.[Status explanation] 
when 'Rücklieferung Start' then '600'
when 'Rücklieferung Abgeschlossen' then '610'
end end) as 'Rückmeldepunkt Code',
Case when RetDel.Rücklieferdatum is null then (case row.code 
when '100' then Data.[Status explanation]
when '110' then 'WE gebucht'
when '400' then 'Lagerung Start'
else Data.[Status explanation] end) else
case when row.code = '100' then retdel.[Status explanation] else
case when row.code = '110' then 'WE gebucht' else  
data.[Status explanation] end end
end as 'Rückmeldepunkt Bezeichnung',
DATA.Sorting,
DATA.Class

from (


select
LP.[Description],
LP.Weight,
BU.Name as BusinessUnit,
wfe.Created as createdwfe,
wfe.StatusId,
case when (
left(right((convert(datetime, WFE.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
WFE.Created + right((convert(datetime, WFE.Created) at TIME zone 'Central European Standard Time'),5)
else 
WFE.Created - right((convert(datetime, WFE.Created) at TIME zone 'Central European Standard Time'),5)
end as Created,
case T.Text
when 'LpWESiemens' then '600'
when 'LpLackiertFreiSiemens' then '600'
when 'LpSollLackiertSiemens' then '600'
else '' end as 'ExplanationCode',
case T.Text
when 'LpLackiertFreiSiemens' then 'Rücklieferung Start'
when 'LpSollLackiertSiemens' then 'Rücklieferung Start'
else T.text end as 'Status explanation',
T.Text,
isnull(Isnull(isnull((isnull(LP.id,SLofLP.id)),SLSL.id),LPinHU.id),virt.LoosePartId) as LPid,
isnull(Isnull(isnull((isnull(LP.Code,SLofLP.Code)),SLSL.code),LPinHU.Code),VIRTLP.Code) as LP,
isnull(Isnull(isnull(isnull(HULP.Code,HU.code),HUofSLofLP.Code),slhu.code),virt.hucode) as HU,
CASE when CF.Abrechnungskategorie ='Stückgut (Hand) kleiner 5 kg/Stk' then '5.2.1' else
CASE when CF.Abrechnungskategorie ='Palettengut (Stapler),kleiner 1 Tonne/Stk' then '5.2.2' else
CASE when CF.Abrechnungskategorie ='Stapler gross bei Kiste bzw. bei nicht Palettengut bzw. wenn Ware grosser 1 Tonne, Abrechnung mindestens 1 Tonne, >1 to =KG genau' then '5.2.3' else
CASE when CF.Abrechnungskategorie ='Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description not like '%8VM1%' then '5.2.4' else
CASE when CF.Abrechnungskategorie = 'Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description like '%8VM1%' then '5.2.5' end end end end end
as Sorting,
CASE when CF.Abrechnungskategorie ='Stückgut (Hand) kleiner 5 kg/Stk' then 'Stückgut' else
CASE when CF.Abrechnungskategorie ='Palettengut (Stapler),kleiner 1 Tonne/Stk' then 'Palette' else
CASE when CF.Abrechnungskategorie ='Stapler gross bei Kiste bzw. bei nicht Palettengut bzw. wenn Ware grosser 1 Tonne, Abrechnung mindestens 1 Tonne, >1 to =KG genau' then 'Kiste' else
CASE when CF.Abrechnungskategorie ='Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description not like '%8VM1%' then 'Kran' else
CASE when CF.Abrechnungskategorie = 'Krangut (Kran), kleiner 20 Tonnen, Abrechnung mindestens 1 Tonne,> 1 to = KG genau' and LP.Description like '%8VM1%' then 'Kran 8VM1' end end end end end
as Class,



 case wfe.entity
	  when '15' then 'LP'
	  when '11' then 'HU'
	  when '48' then upper(SLT.Code)
	  else '' end as EntityShortcut
from WorkflowEntry WFE with (NOLOCK)
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
inner join status S on WFE.StatusId = S.id and WFE.Entity = 15 and s.disabled = 'false'
  	left outer join (SELECT StatusId,BusinessUnitId  FROM [BusinessUnitPermission] with (NOLOCK) WHERE StatusId is not null) BUPs on S.id = BUPs.StatusId
  inner join [User] U on WFE.UpdatedById = U.Id
  left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE'
  
  INNER join LoosePart LP on WFE.EntityId = LP.Id and WFE.Entity = 15
  left join HandlingUnit HULP on LP.TopHandlingUnitId = HULP.id
  left join HandlingUnit HU on wfe.EntityId = HU.id and WFE.Entity =  11
  left join (select loosepartid, HandlingUnitId from WarehouseEntry with (NOLOCK) where loosepartid is not null and HandlingUnitId is not null	group by loosepartid,HandlingUnitID) LPHU on HU.id = LPHU.HandlingUnitId
  left join LoosePart LPinHU on LPHU.LoosepartId = LPinHU.id
  left join ServiceLine SL on WFE.EntityId = SL.Id and WFE.Entity =  48
  left join LoosePart SLofLP on SL.EntityId = SLofLP.Id
  left join HandlingUnit HUofSLofLP on SLofLP.TopHandlingUnitId = HUofSLofLP.Id
  left join HandlingUnit slHU on SL.EntityId = slHU.Id
  left join LoosePart SLSL on SLHU.id = SLSL.TopHandlingUnitId
  left join ServiceType SLT on SL.ServiceTypeId = SLT.Id
  
  left join (   select HU.code hucode, StatusChanged,PR.ParentHandlingUnitId, PR.LoosePartId from PackingRule PR with (NOLOCK)
    inner join HandlingUnit HU on PR.ParentHandlingUnitId = HU.Id
   inner join 
(select 
HU.id HUId,
HU.statusid stid,
cast(max(WE.Created) as Date) as Datum,
max(WE.Created) as StatusChanged
from HandlingUnit HU with (NOLOCK)
inner join dbo.workflowentry WE on HU.id = we.entityid and hu.StatusId = (select id from status with (NOLOCK) where name = 'HuPackedByPackingRule')
group by HU.id,HU.statusid) sdate on PR.ParentHandlingUnitId = sdate.HUId and HU.StatusId = Sdate.stid) virt on HU.id = virt.ParentHandlingUnitId
left join LoosePart VIRTLP on virt.LoosePartId = VIRTLP.Id

left join (
SELECT
CustomField.Name as CF_Name, 
CV.Content as CV_Content,
CV.EntityId as EntityID
FROM CustomField 
INNER JOIN CustomValue CV ON (CustomField.Id = CV.CustomFieldId)
where name in (select name from CustomField where ClientBusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin') group by name) and CV.Entity = 15
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([Position],[Abrechnungskategorie])
        ) as CF on LP.Id = CF.EntityID


where BUPs.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'
and wfe.Entity in (15)
and cast(WFE.Updated as date)  BETWEEN @FROM and @TO


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
'Entpacken Ende',
'Entpacken Start',
'LpEntpackt'
    )   
    ) DATA
left join (select row,code from (values ('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','100'), ('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','110'),('a253d98b-6a1b-49ad-a59c-6b3f0d5d3ccd','400')) x(row,code)) row on DATA.StatusId = row.[row]





left join (
Select
EDVR.entityid,
DV.Content as 'Code',
DV.Description 'DDesc'
from DimensionValue DV with (NOLOCK)
inner join EntityDimensionValueRelation EDVR on DV.Id = EDVR.DimensionValueId
inner join Dimension D on DV.DimensionId  = D.Id
) CodeD on data.LPid = CodeD.EntityId

left join  (select 
CV.EntityId,
CV.Content 'Position'
from customvalue CV with (NOLOCK)
inner join CustomField CF on CV.CustomFieldId = cf.Id where CF.name = 'Position') CFPosition on Data.LPid = CfPosition.EntityId

left join 
(select
(case when (
left(right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
WE.Created + right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
else 
WE.Created - right((convert(datetime, WE.Created) at TIME zone 'Central European Standard Time'),5)
end) as inbende,
case when we.Quantity < 0 then 'end' else
case when we.quantity > 0 then 'start' end end as typ,
isnull(WE.LoosepartId,WE.HandlingUnitId) as EntityId
from WarehouseEntry WE with (NOLOCK)
inner join bin B on WE.BinId = B.Id
where b.Code = 'Wareneingang' and we.quantity < 0 )
 InbBin on Data.LPId = InbBin.EntityId

INNER JOIN (select * from (
select 
WorkflowEntry.EntityId,
max(Berlin.Created) 'Rücklieferung Start', 
min(WorkflowEntry.created) 'Rücklieferung Abgeschlossen'
from WorkflowEntry  with (NOLOCK)
inner join (
select
ST.Id sidsiemens, 
sidberlin = (
    select status.id from Status with (NOLOCK)
    inner join BusinessUnitPermission BUP on Status.id = BUP.StatusId
    where name = left(ST.name,len(ST.name)-7) and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2'),
WF.EntityId, WF.Created from workflowentry WF  with (NOLOCK)
inner join [Status] ST on StatusId = ST.Id
where wf.StatusId in (select S.id from Status S with (NOLOCK)
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId
where s.name in
('LpInboundSiemens',
'LpToBePaintedSIEMENS',
'LpPaintedSiemens',
'LpPackedManuallySiemens',
'LpPackedManuallySiemensPrinted'
) and bup.BusinessUnitId = 'f1a46d31-c25a-4459-95d8-8db804cb7bf2') 
) Berlin on WorkflowEntry.EntityId = Berlin.EntityId and WorkflowEntry.StatusId = sidberlin and Berlin.Created < WorkflowEntry.Created

group by workflowentry.EntityID, WorkflowEntry.id) p unpivot (Rücklieferdatum for [Status explanation] in ([Rücklieferung Start],[Rücklieferung Abgeschlossen])) unpvt) RetDel on data.LPid = RetDel.entityId and RetDel.Rücklieferdatum = DATA.CreatedWFE) MAIN
where 

 cast(main.Datum as date)  BETWEEN @FROM and @TO


) Final WHERE
--final.[PackstückIdent (Beipack)] is not null
--and len(final.[Rückmeldepunkt Code]) > 0
--and left(final.Kundenauftrag,3) <> '999'
 --final.[Rückmeldepunkt Code]+final.[Rückmeldepunkt Bezeichnung] not like '400Warenankunft'
 Final.[Rückmeldepunkt Code] not in ('400','110','600')
--and final.[Rückmeldepunkt Code] = '610'