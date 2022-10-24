select
bu. id ClientBusinessUnitId,
  BU.name as BusinessUnitName,
  LP.code, 
  CV_POS.content as [Position],
  LP.Description,
  SLP.Name as 'LP Status',
cast(case when CV_D_WE.content = '' then LP.created else CV_D_WE.content end as date)as [Datum WE (Fix)],
lp.created as [Datum Zeit WE (Fix)],
  CV_KENN.content as [Kennwort],
  CV_SPE.content as [Sperrgründe],
  LP.length as Länge,
  LP.Width as Breite,
  LP.Height as Höhe,
  LP.Weight as Bruto,
  LP.Weight as Netto,
  Z.Name as 'Actual Zone',
  B.Code as 'Lagerplatz',
  HU.PackingRuleType as 'Verpackung Typ',
  isnull(SHU.Name,'ohne HU') as 'HU Status',
  WC.QuantityBase as Lagermenge,
  Case WC.BlockMovement
  when 0 then ''
  when 1 then 'Ladesperre' end as 'Ladesperre'


  from loosepart LP
  
  left outer join dbo.Status SLP on LP.statusid = SLP.id
  left outer join dbo.Zone Z on LP.ActualZoneId = Z.Id
  left outer join dbo.bin B on LP.actualbinid = B.id
  left outer join dbo.HandlingUnit HU on LP.ActualHandlingUnitId = HU.Id
  left outer join dbo.Status SHU on HU.statusid = SHU.id
  left outer join dbo.WarehouseContent WC on LP.id = WC.LoosePartId
  left outer join BusinessUnitPermission BUP on LP.id = BUP.LoosePartId and BUP.LoosePartId is not null
  left outer join dbo.businessunit BU on BUP.BusinessUnitId = BU.id and type = 2


  inner join customfield CF_D_WE on bu.Id = CF_D_WE.clientbusinessunitid and cf_d_we.name = 'Datum WE (Fix)'
  inner join customvalue CV_D_WE on CV_D_WE.customfieldid = CF_D_WE.Id and CV_D_WE.EntityId = LP.Id
  
  inner join customfield CF_KENN on bu.Id = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kennwort'
  inner join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = LP.Id

  inner join customfield CF_POS on bu.Id = CF_POS.clientbusinessunitid and CF_POS.name = 'Position'
  inner join customvalue CV_POS on CV_POS.customfieldid = CF_POS.Id and CV_POS.EntityId = LP.Id

  inner join customfield CF_SPE on bu.Id = CF_SPE.clientbusinessunitid and CF_SPE.name = 'Sperrlager Gründe'
  inner join customvalue CV_SPE on CV_SPE.customfieldid = CF_SPE.Id and CV_SPE.EntityId = LP.Id
  
  where 
bu.Id =  $P{ClientID} and
lp.created >= $P{FromDate} and
lp.created < $P{ToDate} and
  slp.name <> 'lpNew'