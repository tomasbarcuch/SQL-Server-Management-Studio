SELECT
bu.Name as 'Clien BU name',
lp.code as 'lpName',
HU.Code as HUCode,
HUtop.code as TopHuCode,
isnull(t.Text,s.name) as 'LP Status',
isnull(lhu.name,l.name) as 'Location',
isnull(zhu.name,Z.name) as 'Zone',
isnull(bhu.[Description],B.[Description]) as 'Bin',
--L.Name as 'LP Location',
--lhu.Name as 'HU Location',
lwhc.name as 'WHC Location',
--z.name as 'LP Zone',
--zhu.name as 'HU Zone',
Zwhc.name as 'WHC Zone',
--b.[Code] as 'LP Bin',
--bhu.Code as 'HU Bin',
Bwhc.Code as 'WHC Bin',
whc.QuantityBase
      
  FROM [LoosePart] LP

  left outer join [Location] L on lp.ActualLocationId = L.Id
  left outer join Zone Z on LP.ActualZoneId = Z.Id
  left outer join Bin B on LP.ActualBinId = B.Id
  left outer join status s on lp.StatusId = S.Id
  left outer join HandlingUnit HU on lp. ActualHandlingUnitId = hu.Id
  left outer join HandlingUnit HUtop on lp.TopHandlingUnitId = HUtop.Id
  left outer join Location Lhu on HU.ActualLocationId = lhu.Id
  left outer join Zone Zhu on HU.ActualZoneId= Zhu.id
  left outer join Bin Bhu on HU.ActualBinId = Bhu.Id
  left outer join WarehouseContent WHC on LP.Id = WHC.LoosePartId
  left outer join Location Lwhc on WHC.LocationId = lwhc.Id
  left outer join Zone Zwhc on WHC.ZoneId= Zwhc.id
  left outer join Bin Bwhc on WHC.BinId = Bwhc.Id
  left outer join BusinessUnit BU on lp.ClientBusinessUnitId = bu.id

  left OUTER join dbo.[Translation] T on S.ID = T.entityId and language = 'DE'