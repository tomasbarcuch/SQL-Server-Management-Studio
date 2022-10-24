declare @client as VARCHAR (100)
declare @status as VARCHAR (100)
declare @statushu as VARCHAR (100)
declare @fromdate as DATETIME
declare @todate as DATETIME

set @client = 'Siemens Berlin'
set @status = 'lpPainted'
set @fromdate = '2010-10-01'
set @todate = '2018-10-30'
set @statushu = 'HuInbound'


select
s.name Status,
cast(WFE.Created as date) created,
U.LOGIN,
LP.code LPcode,
slp.Name as LPstatus,
HU.Code HUcode,
st.Code as ServiceLine,
shu.Name as ServiceLineStatus

from WorkflowEntry WFE
inner join LoosePart LP on WFE.EntityId = LP.id and entity = 15
left join HandlingUnit HU on lp.TopHandlingUnitId = HU.Id
inner join BusinessUnitPermission BUP on wfe.EntityId = BUP.LoosePartId
inner join Status S on WFE.StatusId = S.Id
left join [Status] Slp on LP.StatusId = SLp.Id
inner join [User] U on WFE.CreatedById = U.Id
left join ServiceLine SL on WFE.EntityId = SL.EntityId
left join ServiceType ST on SL.ServiceTypeId = ST.Id
left join [Status] Shu on hu.StatusId = Shu.Id

where BUP.BusinessUnitId = (select id from BusinessUnit where name = @client)
and wfe.StatusId = (select status.id from status inner join BusinessUnitPermission BUP on status.id = BUP.StatusId 
where Name = @status and BUP.BusinessUnitId = (select id from BusinessUnit where name = @client))
and WFE.Created between @fromdate and @todate
and st.Code is null and U.LOGIN <> 'vvmigration'
order by wfe.Created
