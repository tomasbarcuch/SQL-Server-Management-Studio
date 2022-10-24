select 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
dfvl.content as 'Land' ,
DFVm.Content as 'Machinentyp',
dv.content as 'Projekt',
dv.description as 'Bezeichnung',
DFVk.Content as 'Kontierung',
dfvpl.Content as 'Projektleiter',
dfvle.Content as 'Liefertermin Extern',
dfvli.Content as 'Produktlinie',
t.Text as Status,
DATA.Wareneingang,
data.[Datum WE (fix)],
data.Lagerort,
cast(sum(data.[Qm Wert]) as decimal (10,2)) as 'Qm Wert',
datediff(day, data.Wareneingang,getdate()) as 'Lagerzeit Tage'

from 

(SELECT
lp.ClientBusinessUnitId,
EDVR.DimensionValueId,
DV.ID DimensionID,
min(inbdate.lpInbound) as 'Wareneingang',
'LP' as 'Entität',
Sum((cast(LP.Length as decimal)/1000)* (cast(LP.Width as decimal)/1000)) as 'Qm Wert',
 min(CV_WE.Content) as 'Datum WE (fix)',
L.Code+'/'+Z.Name+'/'+B.Code as 'Lagerort'

from loosepart LP

INNER join customfield CF_WE on lp.ClientBusinessUnitId = CF_WE.clientbusinessunitid and CF_WE.name = 'Datum WE (fix)'
INNER join customvalue CV_WE on CV_WE.customfieldid = CF_WE.Id and CV_WE.EntityId = LP.Id
INNER join customfield CF_POSlp on lp.ClientBusinessUnitId = CF_POSlp.clientbusinessunitid and CF_POSlp.name = 'Position'
INNER join customvalue CV_POSlp on CV_POSlp.customfieldid = CF_POSlp.Id and CV_POSlp.EntityId = LP.Id
INNER join customfield CF_FNlp on lp.ClientBusinessUnitId = CF_FNlp.clientbusinessunitid and CF_FNlp.name = 'Feld Nr.'
INNER join customvalue CV_FNlp on CV_FNlp.customfieldid = CF_FNlp.Id and CV_FNlp.EntityId = LP.Id
inner join Status S on LP.StatusId = s.Id

left outer join (select lp.id lpId,lp.statusid stid,max(WE.Created) as StatusChanged from LoosePart LP left join dbo.workflowentry WE on lp.id = we.entityid group by lp.id,lp.statusid) sdate on lp.id = sdate.lpId and lp.StatusId = Sdate.stid 
left outer join (select lp.id lpId,lp.statusid stid,min(WE.Created) as lpInbound     from LoosePart LP left join dbo.workflowentry WE on lp.id = we.entityid inner join status S on WE.StatusId = S.Id and S.name = 'lpInbound'group by lp.id,lp.statusid) inbdate on lp.id = inbdate.lpId and lp.StatusId = inbdate.stid  

left outer join Bin B on lp.ActualBinId = B.Id
left outer join Zone Z on lp.ActualZoneId = Z.Id
left outer join [Location] L on lp.ActualLocationId = L.id

left outer join dbo.EntityDimensionValueRelation EDVR on LP.id = EDVR.EntityId and EDVR.Entity = 15
left outer join dbo.DimensionValue DV on EDVR.DimensionValueId = DV.Id

where lp.ActualHandlingUnitId is null and lp.ClientBusinessUnitId = 'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'  and s.name not in ('lpNew')

group by
lp.ClientBusinessUnitId, 
EDVR.DimensionValueId,
DV.ID,
L.Code+'/'+Z.Name+'/'+B.Code

union

SELECT
hu.ClientBusinessUnitId,
EDVR.DimensionValueId,
DV.ID DimensionID,
min(inbdate.huInbound) as 'Wareneingang',
'HU' as 'Entität',
Sum((cast(HU.Length as decimal)/1000)* (cast(HU.Width as decimal)/1000)) as 'Qm Wert',
 min(CV_WE.Content) as 'Datum WE (fix)',
L.Code+'/'+Z.Name+'/'+B.Code as 'Lagerort'

from HandlingUnit HU


INNER join customfield CF_WE on HU.ClientBusinessUnitId = CF_WE.clientbusinessunitid and CF_WE.name = 'Datum Fertigung'
INNER join customvalue CV_WE on CV_WE.customfieldid = CF_WE.Id and CV_WE.EntityId = HU.Id
INNER join customfield CF_POShu on HU.ClientBusinessUnitId = CF_POShu.clientbusinessunitid and CF_POShu.name = 'Position'
INNER join customvalue CV_POShu on CV_POShu.customfieldid = CF_POShu.Id and CV_POShu.EntityId = HU.Id
INNER join customfield CF_FNhu on HU.ClientBusinessUnitId = CF_FNhu.clientbusinessunitid and CF_FNhu.name = 'Feld Nr.'
INNER join customvalue CV_FNhu on CV_FNhu.customfieldid = CF_FNhu.Id and CV_FNhu.EntityId = HU.Id
inner join Status S on HU.StatusId = s.Id

left outer join (select hu.id huId,hu.statusid stid,max(WE.Created) as StatusChanged from HandlingUnit HU left join dbo.workflowentry WE on hu.id = we.entityid group by hu.id,hu.statusid) sdate on hu.id = sdate.huId and hu.StatusId = Sdate.stid 
left outer join (select hu.id huId,hu.statusid stid,min(WE.Created) as huInbound     from HandlingUnit HU left join dbo.workflowentry WE on hu.id = we.entityid inner join status S on WE.StatusId = S.Id and S.name = 'huInbound'group by hu.id,hu.statusid) inbdate on hu.id = inbdate.huId and hu.StatusId = inbdate.stid  
left outer join Bin B on HU.ActualBinId = B.Id
left outer join Zone Z on hu.ActualZoneId = Z.Id
left outer join [Location] L on hu.ActualLocationId = L.id

left outer join dbo.EntityDimensionValueRelation EDVR on HU.id = EDVR.EntityId and EDVR.Entity = 11
left outer join dbo.DimensionValue DV on EDVR.DimensionValueId = DV.Id

where HU.Empty = 0 and HU.ClientBusinessUnitId =  'ad5a5f6b-8ec4-463b-836a-0a8cb60a39d2'   and s.name not in ('huNew')

group by 
hu.ClientBusinessUnitId,
EDVR.DimensionValueId,
DV.ID,
L.Code+'/'+Z.Name+'/'+B.Code
) DATA

left outer join BusinessUnit BU on  Data.ClientBusinessUnitId = BU.id
left join DimensionValue DV on Data.DimensionValueId = DV.Id
left join dbo.DimensionField DF on DV.DimensionId = DF.DimensionId and DF.name in ('Kennwort')
left join dbo.DimensionFieldValue DFV on DF.Id = DFV.DimensionFieldId and DFV.DimensionValueId = DV.Id 

left join DimensionValue DVl on Data.DimensionValueId = DVl.Id
left join dbo.DimensionField DFl on DVl.DimensionId = DFl.DimensionId and DFl.name in ('Land')
left join dbo.DimensionFieldValue DFVl on DFl.Id = DFVl.DimensionFieldId and DFVl.DimensionValueId = DVl.Id 

left join DimensionValue DVpl on Data.DimensionValueId = DVpl.Id
left join dbo.DimensionField DFpl on DVpl.DimensionId = DFpl.DimensionId and DFpl.name in ('Projektleiter')
left join dbo.DimensionFieldValue DFVpl on DFpl.Id = DFVpl.DimensionFieldId and DFVpl.DimensionValueId = DVpl.Id 

left join DimensionValue DVk on Data.DimensionValueId = DVk.Id
left join dbo.DimensionField DFk on DVk.DimensionId = DFk.DimensionId and DFk.name in ('Kontierung')
left join dbo.DimensionFieldValue DFVk on DFk.Id = DFVk.DimensionFieldId and DFVk.DimensionValueId = DVk.Id 

left join DimensionValue DVle on Data.DimensionValueId = DVle.Id
left join dbo.DimensionField DFle on DVle.DimensionId = DFle.DimensionId and DFle.name in ('Liefertermin Extern')
left join dbo.DimensionFieldValue DFVle on DFle.Id = DFVle.DimensionFieldId and DFVle.DimensionValueId = DVle.Id 

left join DimensionValue DVm on Data.DimensionValueId = DVm.Id
left join dbo.DimensionField DFm on DVm.DimensionId = DFm.DimensionId and DFm.name in ('Maschinen Typ')
left join dbo.DimensionFieldValue DFVm on DFm.Id = DFVm.DimensionFieldId and DFVm.DimensionValueId = DVm.Id 

left join DimensionValue DVli on Data.DimensionValueId = DVli.Id
left join dbo.DimensionField DFli on DVli.DimensionId = DFli.DimensionId and DFli.name in ('Produktlinie')
left join dbo.DimensionFieldValue DFVli on DFli.Id = DFVli.DimensionFieldId and DFVli.DimensionValueId = DVli.Id 

left join dbo.Dimension D on DV.DimensionId = D.Id and D.disabled = 0
left join dbo.Status S on DV.StatusId = S.Id
left join dbo.Translation T on S.id = T.EntityId and t.[Language] = 'DE' 
group BY
bu.name,
dfvl.content,
DFVm.Content,
dv.content,
dv.description,
DFVk.Content,
dfvpl.Content,
dfvle.Content,
dfvli.Content,
t.Text,
DATA.Wareneingang,
data.[Datum WE (fix)],
data.Lagerort

having sum(data.[Qm Wert]) > 0