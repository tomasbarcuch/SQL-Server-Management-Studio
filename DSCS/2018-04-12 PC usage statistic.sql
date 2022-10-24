select 
data.*,
cast(data.created as date) as day,
LEFT(CONVERT(varchar, data.created,112),6) as YearMonth,
year(data.created) as Year,
month(data.created) as Month

 from (

--15 LoosePart 
  (SELECT 
      'LP' as EntityShortcut
      ,e.Code as EntityCode
	  ,c.Name as ClientName
	  ,p.Name as PackerName
	  ,s.Name as WorkFlow
	  ,w.Created
	  ,u.FirstName + ' ' + u.LastName as UserName
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry] as w
  inner join [DFCZ_OSLET_TST].[dbo].[Status] as s on w.StatusId = s.Id 
  inner join [DFCZ_OSLET_TST].[dbo].[User] as u on w.CreatedById = u.ID
  inner join [DFCZ_OSLET_TST].[dbo].[LoosePart] as e on w.EntityID = e.Id
  inner join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as c on c.ID = e.ClientBusinessUnitId
  left outer join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as p on p.ID = e.PackerBusinessUnitId
  where w.Entity = '15'
  and w.Created >= '2017-11-01'
  ) 

UNION 

--11 HandlingUnit
  (SELECT 
      'HU' as EntityShortcut
      ,e.Code as EntityCode
	  ,c.Name as ClientName
	  ,p.Name as PackerName
	  ,s.Name as WorkFlow
	  ,w.Created
	  ,u.FirstName + ' ' + u.LastName as UserName
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry] as w
  inner join [DFCZ_OSLET_TST].[dbo].[Status] as s on w.StatusId = s.Id 
  inner join [DFCZ_OSLET_TST].[dbo].[User] as u on w.CreatedById = u.ID
  inner join [DFCZ_OSLET_TST].[dbo].[HandlingUnit] as e on w.EntityID = e.Id
  inner join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as c on c.ID = e.ClientBusinessUnitId
  left outer join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as p on p.ID = e.PackerBusinessUnitId
  where w.Entity = '11'
  and w.Created >= '2017-11-01')

UNION 

--48 ServiceLine
  (SELECT 
      'Service' as EntityShortcut
      ,e.Description as EntityCode
	  ,c.Name as ClientName
	  ,p.Name as PackerName
	  ,s.Name as WorkFlow
	  ,w.Created
	  ,u.FirstName + ' ' + u.LastName as UserName
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry] as w
  inner join [DFCZ_OSLET_TST].[dbo].[Status] as s on w.StatusId = s.Id 
  inner join [DFCZ_OSLET_TST].[dbo].[User] as u on w.CreatedById = u.ID
  inner join [DFCZ_OSLET_TST].[dbo].[ServiceLine] as e on w.EntityID = e.Id
  inner join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as c on c.ID = e.ClientBusinessUnitId
  left outer join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as p on p.ID = e.PackerBusinessUnitId
  where w.Entity = '48'
  and w.Created >= '2017-11-01')

  UNION

--9 DimensionValue
  (SELECT 
      'DimValue' as EntityShortCut
      ,e.Content as EntityCode
	  ,c.Name as ClientName
	  ,'' as PackerName
	  ,s.Name as WorkFlow
	  ,w.Created
	  ,u.FirstName + ' ' + u.LastName as UserName
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry] as w
  inner join [DFCZ_OSLET_TST].[dbo].[Status] as s on w.StatusId = s.Id 
  inner join [DFCZ_OSLET_TST].[dbo].[User] as u on w.CreatedById = u.ID
  inner join [DFCZ_OSLET_TST].[dbo].[DimensionValue] as e on w.EntityID = e.Id
  inner join [DFCZ_OSLET_TST].[dbo].[Dimension] as d on e.DimensionId = d.Id
  inner join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as c on c.ID = d.ClientBusinessUnitID
  --left outer join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as p on p.ID = d.PackerBusinessUnitId
  where w.Entity = '9'
  and w.Created >= '2017-11-01')

  UNION

--31 Transport
(SELECT 
      'Shipment' as EntityShortCut
      ,e.Code as EntityCode
	  ,c.Name as ClientName
	  ,p.Name as PackerName
	  ,s.Name as WorkFlow
	  ,w.Created
	  ,u.FirstName + ' ' + u.LastName as UserName
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry] as w
  inner join [DFCZ_OSLET_TST].[dbo].[Status] as s on w.StatusId = s.Id 
  inner join [DFCZ_OSLET_TST].[dbo].[User] as u on w.CreatedById = u.ID
  inner join [DFCZ_OSLET_TST].[dbo].[ShipmentHeader] as e on w.EntityID = e.Id
  inner join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as c on c.ID = e.ClientBusinessUnitId
  left outer join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as p on p.ID = e.PackerBusinessUnitId
  where w.Entity = '31'
  and w.Created >= '2017-11-01')

  UNION

--35 PackingOrder
(SELECT 
      'PackOrder' as EntityShortCut
      ,e.Code as EntityCode
	  ,c.Name as ClientName
	  ,p.Name as PackerName
	  ,s.Name as WorkFlow
	  ,w.Created
	  ,u.FirstName + ' ' + u.LastName as UserName
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry] as w
  inner join [DFCZ_OSLET_TST].[dbo].[Status] as s on w.StatusId = s.Id 
  inner join [DFCZ_OSLET_TST].[dbo].[User] as u on w.CreatedById = u.ID
  inner join [DFCZ_OSLET_TST].[dbo].[PackingOrderHeader] as e on w.EntityID = e.Id
  inner join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as c on c.ID = e.ClientBusinessUnitId
  left outer join [DFCZ_OSLET_TST].[dbo].[BusinessUnit] as p on p.ID = e.PackerBusinessUnitId
  where w.Entity = '35'
  and w.Created >= '2017-11-01')) data
  