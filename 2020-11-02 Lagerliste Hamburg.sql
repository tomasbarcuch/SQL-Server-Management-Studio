--select * from businessunit where name in ('KRONES GLOBAL', 'Deufol Hamburg Rosshafen')

--Conditions for this report - LP is not packed in HU, HU is not packed in HU and HU is not empty and item must be on stock.
--first is taken CF ('HuInbound Date' and 'LpInbound Date') if those fields are empty/NULL than day of Inbound is taken then Lagerzeit in days is counted from that.

Select 
DB_NAME() AS 'Current Database',
DataBasic.Client,
DataBasic.[Projekt-Nr.],
DataBasic.Projektbezeichnung,
DataBasic.StatusD,
max(DataBasic.[WE-Date]) as 'MaxWE',
max(DataBasic.[Lagerzeit Tage])as 'MaxLagerzeit Tage',
sum(DataBasic.[Qm-Wert])as 'SumQm-Wert',
DataBasic.[LOCATION],
DataBasic.Bin

from

(select
ENT.Entität as 'Entität',
Dim01.Content as 'Projekt-Nr.',
DIM01.[Description] as 'Projektbezeichnung',
T.Text as 'StatusD',
Client.Name as 'Client',
ent.code as 'LpHuCode', 
case when isnull((isnull(CF01.content,CF02.content)),(isnull(inbdate01.lpInbound,inbdate.HuInbound)))='' then isnull(inbdate01.lpInbound,inbdate.HuInbound) else isnull((isnull(CF01.content,CF02.content)),(isnull(inbdate01.lpInbound,inbdate.HuInbound))) end  as 'WE-Date',
datediff(day,isnull(inbdate01.lpInbound,inbdate.HuInbound), getdate()--$P{ToDate}
 ) as 'Lagerzeit Tage',
isnull(ENT.BaseArea,PHU.BaseArea) as BaseArea,
ENT.BaseArea as 'Qm-Wert',
L.Code+'/'+Z.Name+'/'+Bin.Code as 'LOCATION',
Bin.Code as 'Bin'


from
(SELECT 'HU' as 'Entität',[Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],[TypeId],[ParentHandlingUnitId],[ColliNumber] ,[PackingRuleType],[PackingRuleDimensionId],[LoadCapacity],[Netto],[Brutto],[Empty],[PackingOrderHeaderId],[NettoCalc],[BruttoCalc],[CapacityCheckDisabled]  FROM HandlingUnit where ParentHandlingUnitId is null
UNION
SELECT 'LP'  as 'Entität',[Id],[Code],[Length],[Width],[Height],[Weight],[LotNo],[SerialNo],[Description],[CreatedById],[UpdatedById],[Created],[Updated],[StatusId],[ActualLocationId],[ActualZoneId],[ActualBinId],[ShipmentHeaderId],[Volume],[NumberSeriesId],[TopHandlingUnitId],[Surface],[BaseArea],null,null,null,null,null,null,null,null,null,null,null,null,null  FROM LoosePart where TopHandlingUnitId is null)
ENT

inner join (select BusinessUnitID, isnull(BUP.LoosePartId,BUP.HandlingUnitId) EntityID from BusinessUnitPermission BUP
where isnull(BUP.LoosePartId,BUP.HandlingUnitId) is not null
and BusinessUnitId in(select BusinessUnitId from BusinessUnitRelation where RelatedBusinessUnitId = '5a73300c-1b1d-4ebe-9a7b-f335947ea422'--$P{PackerBusinessUnitID}
 )) BU on ent.id = BU.EntityId
inner join BusinessUnit Client on BU.BusinessUnitId = Client.id

LEFT join CustomValue CF01 on CF01.EntityId = ENT.Id and CF01.CustomFieldId in (select id from CustomField where name in ('HuInbound Date'))
LEFT join CustomValue CF02 on CF02.EntityId = ENT.Id and CF02.CustomFieldId in (select id from CustomField where name in ('LpInbound Date'))

left join WarehouseEntry WE01 on ENT.Id=WE01.id
left outer join HandlingUnit PHU on WE01.ParentHandlingUnitId = PHU.id




left join (select EDVR.EntityId,DV.StatusId,DV.[Description],DV.content from Dimension D
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId and name = 'Project'
inner join DimensionValue DV on D.id = DV.DimensionId
inner join EntityDimensionValueRelation EDVR on DV.id = edvr.DimensionValueId
where BUP.BusinessUnitId = '2afb0812-aa09-4494-b2d3-777460852831' --$P{ClientBusinessUnitID}
) DIM01 on ent.id = DIM01.EntityId

left join (select hu.id huId,hu.statusid stid,cast(max(WE.Created) as date) as StatusChanged from HandlingUnit HU left join dbo.workflowentry WE on hu.id = we.entityid group by hu.id,hu.statusid) sdate on Ent.id = sdate.huId and Ent.StatusId = Sdate.stid 
left join (select hu.id huId,hu.statusid stid,cast(min(WE.Created)as date) as HuInbound     from HandlingUnit HU left join dbo.workflowentry WE on hu.id = we.entityid inner join status S on WE.StatusId = S.Id and S.name = 'HuInbound'group by hu.id,hu.statusid) inbdate on Ent.id = inbdate.huId

left outer join (select lp.id lpId,lp.statusid stid,cast(max(WE.Created)as date) as StatusChanged from LoosePart LP left join dbo.workflowentry WE on lp.id = we.entityid group by lp.id,lp.statusid) sdate01 on Ent.id = sdate01.lpId and ent.StatusId = Sdate.stid 
left outer join (select lp.id lpId,lp.statusid stid,cast(min(WE.Created)as date) as LpInbound     from LoosePart LP left join dbo.workflowentry WE on lp.id = we.entityid inner join status S on WE.StatusId = S.Id and S.name = 'LpReceived'group by lp.id,lp.statusid) inbdate01 on ENT.id = inbdate01.lpId 

inner join Bin as Bin on ent.ActualBinId=Bin.Id
inner join Zone as Z on ent.ActualZoneId=Z.Id
inner join [Location] as L on ent.ActualLocationId=L.Id and L.name = 'Deufol Rosshafen'--$X{IN, L.Name,ForLocation}


left join dbo.Status S on DIM01.StatusId = S.Id
left join dbo.Translation T on S.id = T.EntityId and t.[Language] = 'de'--$P{Language} 
Left join dbo.[Status] sHuLP on sHuLP.Id = ent.StatusId
where Ent.[ActualLocationId] is not null and isnull(Ent.Empty,1) <> 0 and case when isnull((isnull(CF01.content,CF02.content)),(isnull(inbdate01.lpInbound,inbdate.HuInbound)))='' then isnull(inbdate01.lpInbound,inbdate.HuInbound) else isnull((isnull(CF01.content,CF02.content)),(isnull(inbdate01.lpInbound,inbdate.HuInbound))) end <  getdate()--$P{ToDate} 
) as DataBasic

Group BY
DataBasic.Client,
DataBasic.[Projekt-Nr.],
DataBasic.Projektbezeichnung,
DataBasic.StatusD,
DataBasic.Client,
DataBasic.[LOCATION],
DataBasic.Bin
order by [Projekt-Nr.]