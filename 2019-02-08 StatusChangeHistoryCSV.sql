select
Data.[Current Database],
Data.ClientBusinessName,
Data.Status,
case Data.Status
when 'LpNeu' then 'WE (Warenankunft)'
when 'LpWe' then 'WE gebucht / Lagerung Start'
when 'Entpacken Start' then 'Entpacking Start'
when 'Entpacken Ende' then 'Entpacking abgeschlossen'
when 'LpWA' then 'Lagerung abgeschlossen'
when 'SlStart' then Data.EntityShortcut +' Start'
when 'SlFertig' then Data.EntityShortcut +' Ende'
when 'LpWESiemens' then 'Rücklieferung Start'
when 'LpLackiertFreiSiemens' then 'Rücklieferung Start'
when 'LpSollLackiertSiemens' then 'Rücklieferung Start'
else ''--Data.Status
end as 'Status explanation',
Data.StatusDate,
Data.EntityShortcut,
Data.EntityCode,
Data.ByUSer,
isnull(SG.SperrlagerGründe,'') as 'Sperrlager Gründe',
LockBin.splstart as 'Sperrlager Start',
LockBin.splende as 'Sperrlager Ende',  
case isnull(SBE.SBExport,'False')
when 'TRUE' then 1
else 0 end as SBExport
from (SELECT
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
wfe.entityid,
bu.id as buid,
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
	  when '48' then isnull(slLP.Code,slhu.code)
	  when '9' then D.Name
	  when '31' then SH.Code
	  when '35' then PO.Code
	    when '10' then DV.[Content]
	  else '' end as varchar)  as EntityCode,
T.Text as Status,

U.lastname+' '+U.FirstName as ByUSer
  FROM WorkflowEntry WFE
  inner join status S on WFE.StatusId = S.id
  	left outer join (SELECT StatusId,BusinessUnitId  FROM [BusinessUnitPermission] WHERE StatusId is not null) BUPs on S.id = BUPs.StatusId
  inner join [User] U on WFE.UpdatedById = U.Id
  left join dbo.[Translation] T on S.ID = T.entityId and T.LANGUAGE = 'DE' and s.disabled = 'false'
  left join LoosePart LP on WFE.EntityId = LP.Id and WFE.Entity =  15
  left join HandlingUnit HU on WFE.EntityId = HU.Id and WFE.Entity =  11
  left join ServiceLine SL on WFE.EntityId = SL.Id and WFE.Entity =  48
  left join LoosePart slLP on SL.EntityId = slLP.Id
  left join HandlingUnit slHU on SL.EntityId = slHU.Id
  left join ServiceType SLT on SL.ServiceTypeId = SLT.Id
  left join Dimension D on WFE.EntityId = D.Id and WFE.Entity = 9
  left join ShipmentHeader SH on WFE.EntityId = SH.Id and WFE.Entity = 31
left join PackingOrderHeader PO on WFE.EntityId = PO.Id and WFE.Entity = 35
left join DimensionValue DV on WFE.EntityId = PO.Id and WFE.Entity = 10
left outer join BusinessUnit BU on  BUPs.BusinessUnitId = BU.id
where BUPs.BusinessUnitId =  'f1a46d31-c25a-4459-95d8-8db804cb7bf2'--$P{ClientBusinessUnitID} 
and wfe.Entity <> 10
--and WFE.Updated >= $P{FromDate} and WFE.Updated <= $P{ToDate}
and WFE.Updated between '2019-02-01' and '2019-02-28'

) data

left join (select 
CF.ClientBusinessUnitId,
CV.EntityId,
CV.Content 'SperrlagerGründe'
from customvalue CV
inner join CustomField CF on CV.CustomFieldId = cf.Id
where CF.name = 'Sperrlager Gründe'and CF.Entity in (11,15)) SG on Data.EntityId = sg.EntityId and data.buid = sg.ClientBusinessUnitId

left join (select 
Isnull(Isnull(isnull(LP.id,hu.id),SH.id),sl.id) as EntityId,
CV.content as SBExport
from CustomField CF 
inner join CustomValue CV on CF.id = CV.CustomFieldId
left join LoosePart LP on CV.EntityId = LP.id and CV.Entity = 15
left join Handlingunit HU on CV.EntityId = HU.id and CV.Entity = 11
left join ShipmentHeader SH on CV.EntityId = SH.id and CV.Entity = 31
left join Serviceline SL on CV.EntityId = SL.id and CV.Entity = 48
where name = 'SBExport') SBE on Data.entityId = SBE.EntityId

left join (select 
isnull(WE.LoosepartId,WE.HandlingUnitId) as EntityId,
min(WE.Created) as 'splstart',
max(WE.Created) as 'splende'
from WarehouseEntry WE
inner join bin B on WE.BinId = B.Id
where right(b.Code,2) = 'SP'
group by isnull(WE.LoosepartId,WE.HandlingUnitId)) LockBin on Data.EntityId = LockBin.EntityId



