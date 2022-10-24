/*
select
BUC.Name Client,
year(BCSL.created) 'Year',
month(BCSL.created) 'Month',
U.login 'User login',
BCSA.[Description] 'Action',
case Result
when 2 then 'Error'
else 'OK'
end as Result,
count(BCSL.id) 'Count'
 from BCSLog BCSL
inner join BCSAction BCSA on BCSL.ActionId = BCSA.Id
inner join BusinessUnit BUC on BCSL.ClientBusinessUnitId = BUC.id
inner join [User] U on BCSL.CreatedById = U.Id
left join Translation T on BCSA.id = t.EntityId and [Language] = 'de'
where BCSL.ClientBusinessUnitId = (select id from BusinessUnit where name = 'Krones AG') 
Group by
BUC.Name, 
year(BCSL.created),
month(BCSL.created),
U.login,
BCSA.[Description],
case Result
when 2 then 'Error'
else 'OK'
end

order by u.login


select 
*
 from BCSLog BCSL
inner join BCSAction BCSA on BCSL.ActionId = BCSA.Id
inner join BusinessUnit BUC on BCSL.ClientBusinessUnitId = BUC.id
inner join [User] U on BCSL.CreatedById = U.Id
left join Translation T on BCSA.id = t.EntityId and [Language] = 'de'

left join LoosePart LP on BCSL.EntityID = LP.id and BCSL.Entity = 15


where BCSL.ClientBusinessUnitId = (select id from BusinessUnit where name = 'Krones AG') 

select * from Log4Net

select * from BCSLog where result = 2 order by created desc

*/
declare @interval as int

set @interval = 100000 --in minuts

select
CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    BCSlog.Created), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as created,

U.LOGIN,

'Aktion: '+isnull(T.text,A.[Description])+'; Project: '+isnull(Project.ProjectNr+'-'+ord.OrderNr+'-'+commission.CommissionNr,'')+'; ColliNr.:'+Isnull(Hu.ColliNumber,'')+'; Code: '+isnull(isnull(lp.Code,HU.code),BCSlog.Barcode)+'; Message: '+isnull(BCSLog.ErrorMessage,'Fehler unbestimmt') as 'Message'
from BCSLog 
left join HandlingUnit HU on BCSLog.EntityId = HU.id and BCSLog.Entity = 11
left join LoosePart LP on BCSLog.EntityId = LP.id and BCSLog.Entity = 15
left join (
select
DV.Content CommissionNr,
DV.[Description] Commission, 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Commission'
where 
DF.name in ('Plant','Comments','OrderPosition','Network'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Plant],[Comments],[OrderPosition],[Network])) as Commission on BCSLog.EntityId = Commission.EntityId

left join (
select
DV.Content 'OrderNr',
DV.[Description] 'Order', 
D.[Description] Dimension,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Order'
where 
DF.name in ('Comments','DateOfPlannedDeliveryToCustomer'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Comments],[DateOfPlannedDeliveryToCustomer])) as Ord on BCSLog.EntityId = Ord.EntityId

left join (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('Comments'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Comments])) as Project on BCSlog.EntityId = Project.EntityId




inner join [User] U on BCSLog.CreatedById = U.Id
inner join BCSAction A on BCSLog.ActionId = A.Id
left join Translation T on A.Id = T.EntityId and T.[Language] = 'de'
where 
--result = 2 and 
U.login not in ('test.test','test.heap') 
and BCSLog.ClientBusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL') 
and BCSLog.PackerBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')

and 
CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    BCSlog.Created), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
 between getdate()-(1.0/(24.0*60.0)*cast(@interval as decimal)) and getdate() --variable interval in minuts

/*
union

select 
Log4Net.LogTime,
REL.login,
Log4Net.[Message]
from Log4Net
inner join (
select
U.ID, 
U.LOGIN
from [UserRole] UR
inner join [User] U on UR.UserId = U.id
where 
UR.ClientBusinessUnitId = (select id from BusinessUnit where name = 'Krones AG VV') 
and UR.BusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg')
and U.login not in ('test.test','test.heap') ) REL on Log4Net.UserName = REL.[Login]
where Log4Net.LogLevel not in ('INFO')
*/

order by bcslog.created desc

select * from BCSLog
Where BCSLog.ClientBusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL') 
and BCSLog.PackerBusinessUnitId = (select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')
order by created DESC