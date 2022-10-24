select DATA.*, L.Description 'WH Location', isnull(PDCAValue.PDCAValue,'') 'PDCAValue'   from (
--HU
SELECT distinct 
HU.id as EntityId,
    'HU' as Entity
    ,hu.[Code] as EntityCode
    ,wfe.WorkflowAction
    ,ba.[Description]
    ,wfeu.[Login] as WFEUser
    ,wfe.[Created] as WFECreated
    ,datepart(wk, wfe.Created) as WFEWeek
    ,bu.Name as WFEPacker
    ,(SELECT TOP (1) WHE.Locationid
        FROM [DFCZ_OSLET].[dbo].[WarehouseEntry] as whe
  
        where whe.[HandlingUnitId] = wfe.EntityId
            and whe.[Created] < wfe.Created
            and whe.LoosepartId is NULL
            and whe.Quantity > 0
        order by whe.Created desc) as 'LocationId'
    ,'' as 'WH Zone'
    ,'' as 'WH BIN'
    ,bl.Barcode
    ,bubl.Name as BCSPacker
    ,ubl.Login as BLUser
    ,bl.Created as BLCreated
  FROM HandlingUnit as HU
  inner join BusinessUnitPermission as bup on bup.HandlingUnitId = hu.id and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')
    inner join EntityDimensionValueRelation EDVR on HU.Id = EDVR.EntityID
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id and DV.Content = '0007029952'
  inner join WorkflowEntry as wfe on wfe.Entity = 11 and wfe.EntityId = hu.Id
  inner join [User] as wfeu on wfeu.id = wfe.CreatedById
  inner join BusinessUnit as bu on bu.id = wfe.BusinessUnitId
  left join BCSAction as ba on wfe.WorkflowAction = ba.BCSaction
  inner join BCSActionPermission as bap on bap.ActionId = ba.Id and bap.ClientBusinessUnitId = bup.BusinessUnitId
  left join BCSLog as bl 
    on bl.ActionId = ba.id 
    and bl.ClientBusinessUnitId = bup.BusinessUnitId 
    and wfe.Entity = bl.Entity 
    and wfe.EntityId = bl.EntityId
    and wfe.CreatedById = bl.CreatedById
    and CONVERT(varchar, wfe.Created, 23) = CONVERT(varchar, bl.Created, 23)
    and bl.Result = 1
  left join BusinessUnit as bubl on bubl.id = bl.PackerBusinessUnitId
  left join [User] as ubl on ubl.id = bl.CreatedById
  where 
    hu.StatusId <> 'e63fe671-112f-4e76-987c-1581f5ea7c84'
    and hu.StatusId <> '47e84acb-5f26-4d72-9128-00d4f843a74b'

UNION

--LP
SELECT distinct 
lp.id as EntityId,
    'LP' as Entity
    ,lp.[Code] as EntityCode
    ,wfe.WorkflowAction
    ,ba.[Description]
    ,wfeu.[Login] as WFEUser
    ,wfe.[Created] as WFECreated
    ,datepart(wk, wfe.Created) as WFEWeek
    ,bu.Name as WFEPacker
    ,(SELECT TOP (1) WHE.LocationId
        FROM [DFCZ_OSLET].[dbo].[WarehouseEntry] as whe
      
        where whe.[LoosepartId] = wfe.EntityId
            and whe.[Created] < wfe.Created
            and whe.Quantity > 0
        order by whe.Created desc) as 'LocationId'
    ,'' as 'WH Zone'
    ,'' as 'WH BIN'
    ,bl.Barcode
    ,bubl.Name as BCSPacker
    ,ubl.Login as BLUser
    ,bl.Created as BLCreated
  FROM Loosepart as lp
  inner join BusinessUnitPermission as bup on bup.LoosePartId = lp.id and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')
    inner join EntityDimensionValueRelation EDVR on lp.Id = EDVR.EntityID
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id and DV.Content = '0007029952'
  inner join WorkflowEntry as wfe on wfe.Entity = 15 and wfe.EntityId = lp.Id
  inner join [User] as wfeu on wfeu.id = wfe.CreatedById
  inner join BusinessUnit as bu on bu.id = wfe.BusinessUnitId
  left join BCSAction as ba on wfe.WorkflowAction = ba.BCSaction
  inner join BCSActionPermission as bap on bap.ActionId = ba.Id and bap.ClientBusinessUnitId = bup.BusinessUnitId
  left join BCSLog as bl 
    on bl.ActionId = ba.id 
    and bl.ClientBusinessUnitId = bup.BusinessUnitId 
    and wfe.Entity = bl.Entity 
    and wfe.EntityId = bl.EntityId
    and wfe.CreatedById = bl.CreatedById
    and CONVERT(varchar, wfe.Created, 23) = CONVERT(varchar, bl.Created, 23)
    and bl.Result = 1
  left join BusinessUnit as bubl on bubl.id = bl.PackerBusinessUnitId
  left join [User] as ubl on ubl.id = bl.CreatedById
  where 
    lp.StatusId <> 'e63fe671-112f-4e76-987c-1581f5ea7c84'
    and lp.StatusId <> '47e84acb-5f26-4d72-9128-00d4f843a74b'

UNION

--WHE LP
SELECT DISTINCT
    lp.id as EntityId,
    'LP' as Entity
    ,lp.[Code] as EntityCode
    ,1 as WorkflowAction
    ,'Inbound' as [Description]
    ,wheu.[Login] as WFEUser
    ,whe.[Created] as WFECreated
    ,datepart(wk, whe.Created) as WFEWeek
    ,'' as WFEPacker
    ,whe.locationid
    ,z.[Description] as 'WH Zone'
    ,b.[Description] as 'WH BIN'
    ,bl.Barcode
    ,bubl.Name as BCSPacker
    ,ubl.Login as BLUser
    ,bl.Created as BLCreated
  FROM Loosepart as lp
  inner join BusinessUnitPermission as bup on bup.LoosePartId = lp.id and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')
  inner join WarehouseEntry as whe on whe.LoosepartId = lp.Id
    inner join EntityDimensionValueRelation EDVR on lp.Id = EDVR.EntityID
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id and DV.Content = '0007029952'
  left join [Zone] as z on z.id = whe.ZoneId
  left join [Bin] as b on b.id = whe.BinId
  inner join [User] as wheu on wheu.id = whe.CreatedById
  left join BCSAction as ba on ba.BCSaction = 1
  inner join BCSActionPermission as bap on bap.ActionId = ba.Id and bap.ClientBusinessUnitId = bup.BusinessUnitId
  left join BCSLog as bl 
    on bl.ActionId = ba.id 
    and bl.ClientBusinessUnitId = bup.BusinessUnitId 
    and bl.Entity = 15
    and whe.LoosepartID = bl.EntityId
    and whe.CreatedById = bl.CreatedById
    and CONVERT(varchar, whe.Created, 23) = CONVERT(varchar, bl.Created, 23)
    and bl.Result = 1
  left join BusinessUnit as bubl on bubl.id = bl.PackerBusinessUnitId
  left join [User] as ubl on ubl.id = bl.CreatedById
  where 
    lp.StatusId <> 'e63fe671-112f-4e76-987c-1581f5ea7c84'
    and lp.StatusId <> '47e84acb-5f26-4d72-9128-00d4f843a74b'
    and whe.Quantity > 0
    and whe.HandlingUnitId is NULL

UNION

--WHE HU
SELECT DISTINCT
hu.id as EntityId,
    'HU' as Entity
    ,hu.[Code] as EntityCode
    ,ba.BCSaction as WorkflowAction
    ,ba.Description as [Description]
    ,wheu.[Login] as WFEUser
    ,whe.[Created] as WFECreated
    ,datepart(wk, whe.Created) as WFEWeek
    ,'' as WFEPacker
   ,WHE.locationId
    ,z.[Description] as 'WH Zone'
    ,b.[Description] as 'WH BIN'
    ,bl.Barcode
    ,bubl.Name as BCSPacker
    ,ubl.Login as BLUser
    ,bl.Created as BLCreated
  FROM HandlingUnit as hu
  inner join BusinessUnitPermission as bup on bup.HandlingUnitId = hu.id and bup.BusinessUnitId = (select id from BusinessUnit where name = 'Krones AG')
  inner join WarehouseEntry as whe on whe.HandlingUnitId = hu.Id
  inner join EntityDimensionValueRelation EDVR on HU.Id = EDVR.EntityID
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id and DV.Content = '0007029952'
  left join [Zone] as z on z.id = whe.ZoneId
  left join [Bin] as b on b.id = whe.BinId
  inner join [User] as wheu on wheu.id = whe.CreatedById
  inner join BCSActionPermission as bap on bap.ClientBusinessUnitId = bup.BusinessUnitId
  inner join BCSAction as ba on bap.ActionId = ba.Id
  left join BCSLog as bl 
    on bl.ActionId = ba.id 
    and bl.ClientBusinessUnitId = bup.BusinessUnitId 
    and bl.Entity = 11
    and whe.HandlingUnitId = bl.EntityId
    and whe.CreatedById = bl.CreatedById
    and CONVERT(varchar, whe.Created, 23) = CONVERT(varchar, bl.Created, 23)
    and bl.Result = 1
  left join BusinessUnit as bubl on bubl.id = bl.PackerBusinessUnitId
  left join [User] as ubl on ubl.id = bl.CreatedById
  where 
    hu.StatusId <> 'e63fe671-112f-4e76-987c-1581f5ea7c84'
    and hu.StatusId <> '47e84acb-5f26-4d72-9128-00d4f843a74b'
    and ((whe.Quantity > 0 and ba.BCSaction = 1) or (whe.Quantity < 0 and ba.BCSaction = 3))
    and whe.LoosepartId is null
) DATA


left join (
select entityid, content as PDCAValue from customvalue CV where customfieldid = (
select id from customfield where name = 'PDCAValue')) PDCAValue on DATA.LocationID = PDCAValue.EntityID
left join Location L on DATA.LocationID = L.id






