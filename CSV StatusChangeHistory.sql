SELECT

cast (WFE.Updated as smalldatetime) as StatusDate, 
 case wfe.entity
	  when '15' then 'LP'
	  when '11' then 'HU'
	  when '10' then 'DIMENSION Value'
	  when '48' then SLT.Code
	  when '9' then 'DIMENSION'
	  when '31' then 'SHIPMENT'
	  when '35' then 'PACKORDER'
	  else '' end as EntityShortcut,
     Cast(  case wfe.entity
	  when '15' then LP.Code
	  when '11' then HU.Code
	  when '48' then SL.[Description]
	  when '9' then D.Name
	  when '31' then SH.Code
	  when '35' then PO.Code
	    when '10' then DV.[Content]
	  else '' end as varchar)  as EntityCode,
T.Text as Status,
isnull(CV_sg.Content,'') as 'Lock reason',
U.lastname+' '+U.FirstName as ByUSer
  FROM WorkflowEntry WFE
  inner join status S on WFE.StatusId = S.id
  inner join [User] U on WFE.UpdatedById = U.Id
  left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE' and s.disabled = 'false'
  left join LoosePart LP on WFE.EntityId = LP.Id and WFE.Entity =  15
  left join HandlingUnit HU on WFE.EntityId = HU.Id and WFE.Entity =  11
  left join ServiceLine SL on WFE.EntityId = SL.Id and WFE.Entity =  48
	left join ServiceType SLT on SL.ServiceTypeId = SLT.Id
  left join Dimension D on WFE.EntityId = D.Id and WFE.Entity = 9
  left join ShipmentHeader SH on WFE.EntityId = SH.Id and WFE.Entity = 31
left join PackingOrderHeader PO on WFE.EntityId = PO.Id and WFE.Entity = 35
left join DimensionValue DV on WFE.EntityId = PO.Id and WFE.Entity = 10
inner JOIN customfield CF_SG on s.ClientBusinessUnitId = CF_SG.clientbusinessunitid and CF_SG.name = 'Sperrlager Gründe'
inner JOIN customvalue CV_SG on CV_SG.customfieldid = CF_SG.Id and CV_SG.EntityId = WFE.EntityId



where S.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2' and wfe.Entity <> 10
--and LP.Code in ('0000034343/000401','0000034176/001001')

order by wfe.entity,WFE.Updated