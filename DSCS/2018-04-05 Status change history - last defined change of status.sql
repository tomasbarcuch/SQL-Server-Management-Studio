/****** Script for SelectTopNRows command from SSMS  ******/
--use DFCZ_OSLET_TST
SELECT 

		case s.name
    when 'LpInbound' then 'Inbound'
    else 'Painting' end as name ,
		wfe.[EntityId]
      ,max(wfe.[Updated]) as Updated
  FROM dbo.WorkflowEntry WFE
  inner join dbo.status s on wfe.statusid = s.id
  where entity = 15 and wfe.statusid in (select S.id from [Status] S
inner join BusinessUnitPermission BUP on S.id = BUP.StatusId and BUP.BusinessUnitID = (Select id from BusinessUnit where name = 'Siemens Berlin')
where S.name in ('LpInbound','LpPainted','LpToBePainted','LpToBePaintedSiemensPrinted','LpPaintedSiemensPrinted'))
  group by 
	case s.name
    when 'LpInbound' then 'Inbound'
    else 'Painting' end,
      wfe.[EntityId]

having EntityId = 'd5c117b8-ea43-479f-94c0-e6cfb2db78ff'


--'LpPainted','LpToBePainted','LpToBePaintedSiemensPrinted','LpPaintedSiemensPrinted'



