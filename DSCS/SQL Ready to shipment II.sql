/*use [DFCZ_OSLET_TST]

  select 
  * from (*/
  SELECT
  lp.ClientBusinessUnitId,
lp.id,
code as LPCode,
s.name as Status,
max(wfe.Updated)as StatusChange
--U.LastName as ChangedBy
   FROM dbo.LoosePart LP   
left outer join dbo.WorkflowEntry WFE on LP.id = WFE.EntityId
left outer join dbo.Status S on WFE.StatusID = S.id
left outer join dbo.[User] U on WFE.updatedbyid = U.id


  where wfe.entity = 15 
  /*and s.id in (
  --'78A22DB1-23E7-407F-B1AB-462922D63095', --LpToBePainted
  --'2452006C-DD9D-4354-8AD7-9E83D1FD21F8' --LpPainted
  --'70390CA4-93BF-4BD1-ABC5-0E0C01F619D3'  --LpToBePaintedSIEMENS
    )*/
	and lp.ClientbusinessUnitId = 'AD5A5F6B-8EC4-463B-836A-0A8CB60A39D2'
	group by
	lp.ClientBusinessUnitId,
	lp.id,
	code,
	s.name,
	U.LastName

		/*) STCH 

	

 
  
  
 inner join customfield CF_D_WE on STCH.ClientBusinessUnitId = CF_D_WE.clientbusinessunitid and cf_d_we.name = 'Datum WE (Fix)'
  inner join customvalue CV_D_WE on CV_D_WE.customfieldid = CF_D_WE.Id and CV_D_WE.EntityId = Stch.Id
  
  inner join customfield CF_KENN on stch.ClientBusinessUnitId = CF_KENN.clientbusinessunitid and CF_KENN.name = 'Kennwort'
  inner join customvalue CV_KENN on CV_KENN.customfieldid = CF_KENN.Id and CV_KENN.EntityId = stch.Id

  inner join customfield CF_POS on stch.ClientBusinessUnitId = CF_POS.clientbusinessunitid and CF_POS.name = 'Position'
  inner join customvalue CV_POS on CV_POS.customfieldid = CF_POS.Id and CV_POS.EntityId = stch.Id

  inner join customfield CF_SPE on stch.ClientBusinessUnitId = CF_SPE.clientbusinessunitid and CF_SPE.name = 'Sperrlager Gründe'
  inner join customvalue CV_SPE on CV_SPE.customfieldid = CF_SPE.Id and CV_SPE.EntityId = stch.Id

  order by lpCode, StatusChange*/