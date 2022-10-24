declare @fromdate as DATETIME
declare @todate as DATETIME

set @fromdate = getdate()-360
set @todate = getdate()-1

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

select
dates.Datum,
'12:00' as Uhrzeit,
CodeD.Code as Kundenauftrag,
CFPosition.Position as 'Pos (Baugrp)',
LP.code as 'PackstückIdent (Beipack)',
HU.Code as 'Kisten Nr.',
case dates.Name 
when 'DatumStart' then '160'
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
left(right((convert(datetime, CV.Created) at TIME zone 'Central European Standard Time'),6),1) = '+' )
then
CV.Created + right((convert(datetime,CV.Created) at TIME zone 'Central European Standard Time'),5)
else 
CV.Created - right((convert(datetime, CV.Created) at TIME zone 'Central European Standard Time'),5)
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


--'LockReason'

/*
select P.* from (
SELECT 
Customfield.clientbusinessunitid,
CustomField.Name as CF_Name, 
CustomValue.EntityId as CV_EntityID,
CustomValue.Content as CV_Content
FROM CustomField 
INNER JOIN CustomValue ON (CustomField.Id = CustomValue.CustomFieldId)
where name in ('LockReason','DatumStart','DatumEnd')
) SRC
PIVOT (max(src.CV_Content) for src.CF_Name  in ([LockReason],[DatumStart],[DatumEnd],[LockOutbound],[LockPacking],[LockPaint])
        ) as P

        */
/*
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
        ) as LockHeader
        */