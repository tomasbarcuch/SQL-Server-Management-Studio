DECLARE @DATEFROM as DATE = '2020-01-01'
DECLARE @DATETO as DATE = '2025-12-31'

select

WFE.Client,
WFE.BusinessUnit,
'Active Users' = (select count(Id) from [User] U where [Disabled] = 0 and IsAdmin = 0) ,
WFE.Users,
BCS.BCSUsers,
WFE.StatusCount,
BCS.BCSCount,
WFE.YearMonth

 from (
select
Count(WFE.id) StatusCount
,BU.Name BusinessUnit
,CBU.Name Client
,Count(distinct U.[Login]) Users,
CAST(YEAR(WFE.Created) as varchar(4))+'-'+RIGHT('0' + RTRIM(MONTH(WFE.Created)), 2) as YearMonth
 from WorkflowEntry WFE 
inner join BusinessUnit CBU on WFE.ClientBusinessUnitId = CBU.Id
inner join BusinessUnit BU on WFE.BusinessUnitId = BU.Id
inner join [User] U on WFE.CreatedById = U.Id and U.isAdmin = 0



where WFE.Created between @DATEFROM and @DATETO

group by
BU.Name
,CBU.Name
,CAST(YEAR(WFE.Created) as varchar(4))+'-'+RIGHT('0' + RTRIM(MONTH(WFE.Created)), 2)


) WFE 

left join (

select
Count(BCS.id) BCSCount

,BU.Name BusinessUnit
,CBU.Name Client
,Count(distinct U.[Login]) BCSUSers,
CAST(YEAR(BCS.Created) as varchar(4))+'-'+RIGHT('0' + RTRIM(MONTH(BCS.Created)), 2) as YearMonth
 from BCSLog BCS 
inner join BusinessUnit CBU on BCS.ClientBusinessUnitId = CBU.Id
inner join BusinessUnit BU on BCS.PackerBusinessUnitId = BU.Id
inner join [User] U on BCS.CreatedById = U.Id and U.isAdmin = 0
where BCS.Created between @DATEFROM and @DATETO and BCS.Result not in (2)

group by 
BU.Name
,CBU.Name
,CAST(YEAR(BCS.Created) as varchar(4))+'-'+RIGHT('0' + RTRIM(MONTH(BCS.Created)), 2)

) BCS on WFE.BusinessUnit = BCS.BusinessUnit and WFE.Client = BCS.Client and WFE.YearMonth = BCS.YearMonth



Order by Client, BusinessUnit, YearMonth, Users desc

