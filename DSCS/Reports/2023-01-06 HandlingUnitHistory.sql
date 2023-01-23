DECLARE @CLIENT as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Siemens Duisburg')
DECLARE @ENTITYIDS as UNIQUEIDENTIFIER = 'bca79837-ae98-4016-8899-a1a237771f78'

select * from (
  select
case HU.empty when 0 then '' else 'empty' end as empty,
HU.Code as HuCode,
HU.Collinumber,
HU.DESCRIPTION, 
isnull(T.Text,S.name) as current_status,
HU.updated last_change,
U.login last_change_by,
isnull(L.Code,'') actual_location,
isnull(Z.name,'') actual_zone,
isnull(B.Code,'') actual_bin,
isnull(TOPHU.Code,'loose') actual_hu,
cast(da.created as date) as day,
BU.name as actual_BU,
da.HandlingUnitId,
da.[location],
da.[Zone],
da.Bin,
--da.[Status],
da.hu,
da.lp,
da.created,
da.login,
'Status' [ColumnName],
NULL [OldValue],
da.[Status]  [NewValue]

 from (
select max(isnull(BU,'')) as BU,HandlingUnitId,max(Location) location, Max(Zone) Zone,max( Bin) Bin, max(isnull(Status,'')) Status, max(isnull(hu,'')) hu, max(isnull(lp,'')) lp, cast(created as datetime) created, max(login) Login from (
select null as BU, HandlingUnitId,isnull(L.code,'') Location,isnull(Z.Name,'') Zone, isnull(B.code,'') bin, null as status, HU.code hu, LP.code as LP, cast(WE.created as datetime) created, U.login from WarehouseEntry WE  with (NoLock)
left join LOCATION L on WE.locationID = L.id
left join Zone Z on WE.ZoneID = Z.id
left join HandlingUnit HU on WE.Parenthandlingunitid = HU.id
left join LoosePart LP on WE.LoosepartId = LP.id
left join Bin B on WE.BinID = B.id
inner join [USER] U on WE.createdById = U.id
--where  $X{IN,handlingunitid,HandlingUnitIDs}
WHERE HU.Id in (@ENTITYIDS)
and WE.quantity > 0

union

select BU.name,WFE.entityid as handlingunitid,'','','',isnull(T.Text,S.name) as name, null, null,convert(VARCHAR,WFE.created,120) created,U.login from WorkflowEntry WFE with (nolock)
inner join status S on WFE.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'de'--$P{Language}
inner join [USER] U on WFE.createdById = U.id
left join BusinessUnit Bu on WFE.BusinessUnitID = BU.id

--where $X{IN,WFE.EntityId,HandlingUnitIDs} 
WHERE WFE.EntityId in (@ENTITYIDS)
) data
group by data.created,data.HandlingUnitId,data.LP
) da
inner join HandlingUnit HU on da.HandlingUnitid = HU.id
inner join status S on HU.statusid = S.id
left join Translation T on S.id = T.entityId and T.language = 'de'--$P{Language}
inner join [USER] U on HU.updatedById = U.id
left join LOCATION L on HU.ActuallocationID = L.id
left join Zone Z on HU.ActualZoneID = Z.id
left join Bin B on HU.ActualBinID = B.id
left join HandlingUnit TOPHU on HU.Tophandlingunitid = TOPHU.id
inner join businessunitpermission BUP on HU.id = BUP.HandlingUnitid and BUP.BusinessUnitId = @CLIENT --$P{ClientBusinessUnitId} 
inner join BusinessUnit BU on BUP.BusinessUnitID = BU.id and BU.type = 2

UNION

SELECT 
case HU.empty when 0 then '' else 'empty' end as empty,

      ISNULL(ISNULL(LP.Code,HU.Code),PO.Code) as Code
         ,HU.ColliNumber
         ,ISNULL(ISNULL(LP.Description,HU.Description),PO.Description) as Description
         ,NULL
         ,NULL
         ,NULL
         ,NULL
     --    ,NULL
      --   ,NULL
       --  ,NULL
         ,NULL
         ,NULL ActualBin
,NULL
    ,CAST(LE.[Updated] as DATE)
      --,Packer.Name PackerBusinessUnit
      ,Client.Name ClientBusinessUnit
      ,LE.EntityId
      ,NULL
      ,NULL
      ,NULL
      --,NULL
      ,NULL hu 
      ,NULL lp
       ,LE.[Updated]
       ,U.Login as UpdatedBy
         ,[ColumnName]
      ,[OldValue]
      ,[NewValue]
  FROM LogEntity LE
  INNER JOIN BusinessUnit Client on LE.ClientBusinessUnitId = Client.Id and Client.id = @CLIENT
  INNER JOIN BusinessUnit Packer on LE.PackerBusinessUnitId = Packer.Id
  INNER JOIN [User] U on LE.UpdatedById = U.Id

  LEFT JOIN LoosePart LP on LE.EntityId = LP.Id AND LE.Entity = 15
  LEFT JOIN HandlingUnit HU on LE.EntityId = HU.Id AND LE.Entity = 11
  LEFT JOIN PackingOrderHeader PO on LE.EntityId = PO.Id AND LE.Entity = 35
  where LE.ColumnName NOT IN ('Updated','UpdatedById')
  And LE.EntityId in (@ENTITYIDS)
) DATA
  Order by DATA.created desc
