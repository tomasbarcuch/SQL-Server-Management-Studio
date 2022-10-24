

select
  LP.code, 
  CV_POS.content as [Position],
  LP.Description,
  SLP.Name as 'LP Status',
 -- case when CV_D_WE.content ='' then LP.created else CV_D_WE.content end  as [Datum WE (Fix)], --podmínka je pro testování reportu nastavena do ostré pouze hodnota WE 
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
  stch.updated as 'Status change',
  s.name as 'Status'

  from loosepart LP
  
  left outer join dbo.Status SLP on LP.statusid = SLP.id
  left outer join dbo.Zone Z on LP.ActualZoneId = Z.Id
  left outer join dbo.bin B on LP.actualbinid = B.id
  left outer join dbo.HandlingUnit HU on LP.ActualHandlingUnitId = HU.Id
  left outer join dbo.Status SHU on HU.statusid = SHU.id
  --left outer join dbo.WorkflowEntry WFE on LP.id = WFE.EntityId
  left outer join dbo.Status S on LP.StatusID = S.id
  left outer join (SELECT [EntityId]
      ,[StatusId]
      ,max([Updated]) as Updated
  FROM [DFCZ_OSLET_TST].[dbo].[WorkflowEntry]
  where entity = 15 and statusid = '2452006C-DD9D-4354-8AD7-9E83D1FD21F8'
  group by 

       [Entity]
      ,[EntityId]
      ,[StatusId]) STCH
on LP.id = stch.EntityID

  inner join customfield CF_D_WE on lp.ClientBusinessUnitId = CF_D_WE.clientbusinessunitid and cf_d_we.name = 'Datum WE (Fix)'
  inner join customvalue CV_D_WE on CV_D_WE.customfieldid = CF_D_WE.Id and CV_D_WE.EntityId = LP.Id
  
  inner join customfield CF_KENN on lp.ClientBusinessUnitId = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kennwort'
  inner join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = LP.Id

  inner join customfield CF_POS on lp.ClientBusinessUnitId = CF_POS.clientbusinessunitid and CF_POS.name = 'Position'
  inner join customvalue CV_POS on CV_POS.customfieldid = CF_POS.Id and CV_POS.EntityId = LP.Id

  inner join customfield CF_SPE on lp.ClientBusinessUnitId = CF_SPE.clientbusinessunitid and CF_SPE.name = 'Sperrlager Gründe'
  inner join customvalue CV_SPE on CV_SPE.customfieldid = CF_SPE.Id and CV_SPE.EntityId = LP.Id
  
  where 
  lp.ClientbusinessUnitId = 'AD5A5F6B-8EC4-463B-836A-0A8CB60A39D2' and
 -- (case when CV_D_WE.content ='' then LP.created else CV_D_WE.content end) between $P{WE Datum from} and $P{WE Datum to} and
  slp.name <> 'lpNew'
  and
 lp.statusid = '2452006C-DD9D-4354-8AD7-9E83D1FD21F8'




  