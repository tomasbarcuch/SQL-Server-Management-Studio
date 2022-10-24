    --select * from DCNLPWSQL02.KRO_VV.dbo.DAT_KISTEN

declare @TSTClientID as UNIQUEIDENTIFIER
declare @PRDClientID as UNIQUEIDENTIFIER
declare @TSTPackerID as UNIQUEIDENTIFIER
declare @PRDPackerID as UNIQUEIDENTIFIER

set @TSTClientID = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Krones AG VV')
set @PRDClientID = (Select id from BusinessUnit where name = 'Krones AG')
set @TSTPackerID = (Select BU.id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU where name = 'Deufol Hamburg')
set @PRDPackerID = (Select id from BusinessUnit where name = 'Deufol Hamburg Rosshafen')


print'BINS'

select B.*,Z.name Zone,B.Code, B.LocationID, B.DESCRIPTION  from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Bin B

left join (select B.Code, Z.name from BIN B
left join Zone Z on B.zoneid = Z.ID
where B.LOCATIONid = (select id from LOCATION where code = 'Rosshafen')) PRD on B.Code = PRD.Code
left join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Zone Z on B.zoneid = Z.ID

where B.LOCATIONid = (select id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.LOCATION where code = 'Rosshafen')
and B.DISABLED = 0
and PRD.Code is null




print'ZONES'
select PRD.name,Z.* from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.ZONE Z

left join (select name from ZONE Z
where Z.LOCATIONid = (select id from LOCATION where code = 'Rosshafen')) PRD on Z.name = PRD.NAME

where Z.LOCATIONid = (select id from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.LOCATION where code = 'Rosshafen')
and DISABLED = 0
and PRD.Name is null




print'USERS'
select 
U.Login 'User',
U.*,
TSTU.[USER],
Role.name Role,
'Krones AG' as ClientBusinessUnit,
'Deufol Hamburg Rosshafen' BusinessUnit,
BUC.name as SourceClient,
BU.name as SourceBusinessUnit
 from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.UserRole UR
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.[User] U on UR.UserId = U.Id
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Role on UR.RoleId = Role.id
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BUC on UR.ClientBusinessUnitId = BUC.id
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnit BU on UR.BusinessUnitId = BU.id
left join (

select 
U.Login 'User', 
U.email,
Role.name Role,
'Krones AG' as ClientBusinessUnit,
'Deufol Hamburg Rosshafen' BusinessUnit,
BUC.name as SourceClient,
BU.name as SourceBusinessUnit
 from UserRole UR
inner join [User] U on UR.UserId = U.Id
inner join Role on UR.RoleId = Role.id
inner join BusinessUnit BUC on UR.ClientBusinessUnitId = BUC.id
inner join BusinessUnit BU on UR.BusinessUnitId = BU.id
where clientbusinessunitid = @PRDClientID
and BusinessUnitId =  @PRDPackerID
) TSTU on U.login = TSTU.[User]

where clientbusinessunitid = @TSTClientID
and BusinessUnitId =  @TSTPackerID
and TSTU.[USER] is null


print'DIMENSION FIELDS'


SELECT DF.Name, DFTST.name  FROM DimensionField DF


right join (

SELECT DFTST.Name  FROM DCNLTWSQL02.DFCZ_OSLET_TST.dbo.DimensionField DFTST
where DFTST.ClientBusinessUnitId = @TSTClientID) DFTST on DF.name = DFTST.NAME

where ClientBusinessUnitId = @PRDClientID and df.name is null


 
 
print'CUSTOM FIELDS FIELDS'

    select DT.name,CF.*,PRD.name, PRD.Entity
    from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Customfield CF
    inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.DataType DT on CF.datatypeid = DT.id
    left join (
    select name,Entity from DFCZ_OSLET.dbo.CustomField PRDCF 
 where PRDCF.ClientBusinessUnitId = @PRDClientID) PRD on CF.name = PRD.NAME and CF.entity = PRD.Entity
      where CF.ClientBusinessUnitId = @TSTClientID
      and prd.name is null


print'STATUS'
    select STST.*
    from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Status STST
    inner join  DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission TSTBUP on STST.id = TSTBUP.statusid and TSTBUP.BusinessUnitId = @TSTClientID
left join (
      select S.* from STATUS S
      inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BusinessUnitId = @PRDClientID) SPRD on STST.Name = SPRD.Name
      where 
      STST.DISABLED = 0
      and SPRD.NAme is null
    
print'WORKFLOWS'
select isnull(OS.name,'') OldStatus, NS.Name NewStatus, WF.Entity, WF.Action, P.Name Permission,
cast(isnull(OS.name,'') as varchar)+cast(NS.Name as varchar)+cast(WF.Entity as varchar)+cast(WF.Action as varchar)+cast(P.Name as varchar) as TSTID
,WFPRD.ID
from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Workflow WF
      inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission BUP on WF.id = BUP.WorkflowId and BusinessUnitId = @TSTClientID
      left join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.[Status] OS on WF.OldStatusId = OS.Id
      left join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.[Status] NS on WF.NewStatusId = NS.Id
      left join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.Permission P on WF.PermissionId = P.Id
    
left join (

      select isnull(OS.name,'') OldStatus, NS.Name NewStatus, WF.Entity, WF.Action, P.Name Permission, 
      cast(isnull(OS.name,'') as varchar)+cast(NS.Name as varchar)+cast(WF.Entity as varchar)+cast(WF.Action as varchar)+cast(P.Name as varchar) ID
      from Workflow WF
      inner join BusinessUnitPermission BUP on WF.id = BUP.WorkflowId and BusinessUnitId = @PRDClientID
      left join [Status] OS on WF.OldStatusId = OS.Id
      left join [Status] NS on WF.NewStatusId = NS.Id
      left join Permission P on WF.PermissionId = P.Id) WFPRD on WFPRD.ID = (cast(isnull(OS.name,'') as varchar)+cast(NS.Name as varchar)+cast(WF.Entity as varchar)+cast(WF.Action as varchar)+cast(P.Name as varchar))
    where  WFPRD.ID is null

print'STATUSFILTER'
 select STST.Name, SFTST.Action, SFTST.Entity, SFPRD.Name from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.StatusFilter SFTST
    inner join (
      select S.* from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.STATUS S
      inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission BUP on S.id = BUP.StatusId and BusinessUnitId = @TSTClientID) STST on SFTST.StatusId = STST.Id
left join (
    select SPRD.Name, SFPRD.Action, SFPRD.Entity from StatusFilter SFPRD
    inner join (
      select S.* from STATUS S
      inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BusinessUnitId = @PRDClientID) SPRD on SFPRD.StatusId = SPRD.Id) SFPRD on STST.name = SFPRD.name

      where SFPRD.Name is null

/*
-- IMPORTED RECORDS rozdílová migrace handling unit v TST ========================
select zaehler from DCNLPWSQL02.KRO_VV.dbo.DAT_KISTEN K
where 
			K.W_STANDORT in (1221, 1240, 1239) and K.W_Status = 12050

and K.zaehler not in (
select cv.content from DCNLTWSQL02.DFCZ_OSLET_TST.dbo.CustomValue CV 
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.CustomField CF on CV.CustomFieldId = CF.id 
and CF.ClientBusinessUnitId = @TSTClientID
and CF.name = 'VVID'
and CF.entity = 11)


-- IMPORTED RECORDS rozdílová migrace handling unit v PRD ========================
and K.zaehler not in (
select cv.content from CustomValue CV 
inner join CustomField CF on CV.CustomFieldId = CF.id 
and CF.ClientBusinessUnitId = @PRDClientID
and CF.name = 'VVID'
and CF.entity = 11)

*/

/*
;With Looseparts
AS
(
SELECT *,DATEDIFF(dd,0,BUP.created) AS dayoffset,
DATEDIFF(ss,MIN(BUP.created) OVER (PARTITION BY DATEDIFF(dd,0,BUP.created)),BUP.created)/60 AS MinOffset
FROM DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission BUP
where BUP.BusinessUnitid = @TSTClientID and BUP.LoosePartID is not NULL
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(created) AS StartDatetime,
 MAX(created) AS EndDatetime,
 COUNT(ID) AS TotalCount
FROM LooseParts
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc
--)  data

;With HandlingUnits
AS
(
SELECT *,DATEDIFF(dd,0,BUP.created) AS dayoffset,
DATEDIFF(ss,MIN(BUP.created) OVER (PARTITION BY DATEDIFF(dd,0,BUP.created)),BUP.created)/60 AS MinOffset
FROM DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission BUP
where BUP.BusinessUnitid = @TSTClientID and BUP.HandlingUnitID is not NULL
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(created) AS StartDatetime,
 MAX(created) AS EndDatetime,
 COUNT(ID) AS TotalCount
FROM HandlingUnits
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc
--)  data



;With WHE
AS
(
SELECT we.id, we.created,DATEDIFF(dd,0,WE.created) AS dayoffset,
DATEDIFF(ss,MIN(WE.created) OVER (PARTITION BY DATEDIFF(dd,0,WE.created)),WE.created)/60 AS MinOffset
FROM DCNLTWSQL02.DFCZ_OSLET_TST.dbo.WarehouseEntry WE
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission BUP on WE.LoosepartId = BUP.LoosePartId

where BUP.BusinessUnitid = @TSTClientID and (WE.LoosePartID is not NULL)
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(created) AS StartDatetime,
 MAX(created) AS EndDatetime,
 COUNT(ID) AS TotalCount
FROM WHE
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc
--)  data





;With WORKFLOWENTRY
AS
(

SELECT WF.id, WF.created,DATEDIFF(dd,0,WF.created) AS dayoffset,
DATEDIFF(ss,MIN(WF.created) OVER (PARTITION BY DATEDIFF(dd,0,WF.created)),WF.created)/60 AS MinOffset
FROM DCNLTWSQL02.DFCZ_OSLET_TST.dbo.WorkflowEntry WF
inner join DCNLTWSQL02.DFCZ_OSLET_TST.dbo.BusinessUnitPermission BUP on WF.StatusId = bup.StatusId
where BUP.BusinessUnitid = @TSTClientID
)
--select avg(totalcount) as RecordsInMinute  from (
SELECT top(5) MIN(created) AS StartDatetime,
 MAX(created) AS EndDatetime,
 COUNT(ID) AS TotalCount
FROM WORKFLOWENTRY
GROUP BY dayoffset,(MinOffset-1)/60

ORDER by StartDatetime desc
--)  data
*/