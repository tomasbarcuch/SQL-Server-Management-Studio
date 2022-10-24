DECLARE @FromDate as DATE = '2022-06-01'

PRINT 'TOTAL COUNT OF USED REPORTS:'
select 
'Active' = (Select COUNT(ID) from DocumentTemplate where [Disabled] = 0 ),
Count (distinct(substring([Message],20,8))) Used,
'Started' = (select 
Count (Log4Net.Id) DocumentsStarted
from Log4Net
inner join [User] U on UserName = U.[Login] and U.IsAdmin = 0
where message like 'Document Template%'
and CAST(LogTime as date) >= @FromDate )
from Log4Net
inner join [User] U on UserName = U.[Login] and U.IsAdmin = 0
where message like 'Document Template%' 
and CAST(LogTime as date) >= @FromDate



/*
select DT.Name, DT.[FileName], DT.[Description], DATA.ClientBusinessUnit, DATA.BusinessUnit, DATA.LogTime from (
select 
substring([Message],20,8) DocumentName,
substring([Message],42,PATINDEX ( '%"%' , substring([Message],42,250) )-1) BusinessUnit,
replace(substring([Message],PATINDEX('%for%',[Message])+5,250),'"','') ClientBusinessUnit,
[UserName],
CONVERT(datetime, 
SWITCHOFFSET(CONVERT(datetimeoffset,LogTime),DATENAME(TzOffset, SYSDATETIMEOFFSET()))) LogTime


from Log4Net

where message like 'Document Template%'
) DATA
left join BusinessUnit BU on DATA.BusinessUnit = BU.Name
left join BusinessUnit CLIENT on DATA.BusinessUnit = CLIENT.name
left join DocumentTemplate DT on DATA.DocumentName = DT.Name
*/
--MOST USED REPORTS
select DT.Name, Count(DT.Name) Count,  DT.[Description], DT.[FileName], MAX(DATA.LogTime) LastUsed from (
select 
substring([Message],20,8) DocumentName,
substring([Message],42,PATINDEX ( '%"%' , substring([Message],42,250) )-1) BusinessUnit,
replace(substring([Message],PATINDEX('%for%',[Message])+5,250),'"','') ClientBusinessUnit
,cast(LogTime as date) LogTime
from Log4Net
inner join [User] U on UserName = U.[Login] and U.IsAdmin = 0
where message like 'Document Template%' and UserName not in ('tomas.barcuch')
and CAST(LogTime as date) >= @FromDate
) DATA
--left join BusinessUnit BU on DATA.BusinessUnit = BU.Name
--left join BusinessUnit CLIENT on DATA.BusinessUnit = CLIENT.name
left join DocumentTemplate DT on DATA.DocumentName = DT.Name

group by DT.Name, DT.[Description],DT.[FileName]
order by Count(DT.Name) desc

--REPORTS USED BY PACKERS
select DATA.BusinessUnit, Count(DT.Name) Count, Count(Distinct(DT.Name)) CountDistinct from (
select 
substring([Message],20,8) DocumentName,
substring([Message],42,PATINDEX ( '%"%' , substring([Message],42,250) )-1) BusinessUnit,
replace(substring([Message],PATINDEX('%for%',[Message])+5,250),'"','') ClientBusinessUnit
from Log4Net
inner join [User] U on UserName = U.[Login] and U.IsAdmin = 0
where message like 'Document Template%'
and CAST(LogTime as date) >= @FromDate
) DATA
--left join BusinessUnit BU on DATA.BusinessUnit = BU.Name
--left join BusinessUnit CLIENT on DATA.BusinessUnit = CLIENT.name
inner join DocumentTemplate DT on DATA.DocumentName = DT.Name --and DT.NAme = 'REP-0055'

group by DATA.BusinessUnit
order by Count(DT.Name) desc

--REPORTS USED BY CLIENTS
select DATA.ClientBusinessUnit, Count(DT.Name) Count, Count(Distinct(DT.Name)) CountDistinct  from (
select 
substring([Message],20,8) DocumentName,
substring([Message],42,PATINDEX ( '%"%' , substring([Message],42,250) )-1) BusinessUnit,
replace(substring([Message],PATINDEX('%for%',[Message])+5,250),'"','') ClientBusinessUnit
from Log4Net
inner join [User] U on UserName = U.[Login] and U.IsAdmin = 0
where message like 'Document Template%'
and CAST(LogTime as date) >= @FromDate
) DATA
--left join BusinessUnit BU on DATA.BusinessUnit = BU.Name
--left join BusinessUnit CLIENT on DATA.BusinessUnit = CLIENT.name
left join DocumentTemplate DT on DATA.DocumentName = DT.Name

group by DATA.ClientBusinessUnit
order by Count(DT.Name) desc


--NOT USED REPORTS

select CAST(DT.Created as date) created, CAST(DT.Updated as date) updated,DT.Name, DT.[Description], DT.[FileName] from DocumentTemplate DT

left join (
select 
(substring([Message],20,8)) Name
from Log4Net
inner join [User] U on UserName = U.[Login] and U.IsAdmin = 0
where message like 'Document Template%'
and CAST(LogTime as date) >= @FromDate
group by (substring([Message],20,8))
) Used on DT.name = Used.Name

where DT.[Disabled] = 0 and USED.NAme is null order by FileName

/*
update DocumentTemplate set [Disabled] = 1 where name in (
'REP-0013',
'REP-0003',
'REP-0005',
'REP-0006', --/Reports/PackCenter/PRD/KRONES_GLOBAL/MarkingHandlingUnits_Debrecen_A3
'REP-0022', --/Reports/PackCenter/PRD/Berlin/Kistenaufstellung
'REP-0024',
'REP-0093',
'REP-0094',
'REP-0095',
'REP-0096',
'REP-0097',
'REP-0098',
'REP-0099',
'REP-0106', --/Reports/PackCenter/PRD/Hamburg/HandlingUnitContentOverview
'REP-0130',
'REP-0156',
'REP-0164', --/Reports/PackCenter/PRD/Sankt_Pölten/HU_Labels
'REP-0167', --/Reports/PackCenter/PRD/Sankt_Pölten/LP_Labels
'REP-0110', --/Reports/PackCenter/PRD/KRONES_GLOBAL/HuLabel_Hamburg_Krones_sl
'REP-0118' --/Reports/PackCenter/PRD/KRONES_GLOBAL/LpLabel_Hamburg_Krones_sl
) and disabled = 0
*/