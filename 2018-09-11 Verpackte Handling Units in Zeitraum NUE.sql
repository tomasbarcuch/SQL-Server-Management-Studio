declare @JustInserted as BIT
declare @FromDate as DATE
declare @ToDate as DATE
declare @BusinessUnitID as UNIQUEIDENTIFIER
set @JustInserted = 0
set @FromDate = '2018-10-01'
set @ToDate = '2018-11-07'
set @BusinessUnitID = '33d1cc70-25d9-45d1-b08c-39e86b5701f7'

SELECT 
DB_NAME() AS 'Current Database',
BU.name as ClientBusinessName,
sdate.StatusChanged,
S.name,
T.Text,
HU.Code HUCode,
HU.[Description],
HUT.Code HUTypecode,
HU.ColliNumber,
Dim.Content as CustomerProject,
'Auftrag' as Auftrag,
HU.Length,
HU.Width,
HU.Height,
HU.Brutto,
HU.Netto,
HU.Weight,
b.code Bin,
Z.Name Zone,
L.Name Location,
cast(CV_WA.Content as datetime) as 'Verpackt am',
CV_VP.Content as 'Verpacker'
from HandlingUnit HU
inner join status S on HU.StatusId = S.Id
inner join BusinessUnitPermission BUP on HU.id = BUP.HandlingUnitId
inner join BusinessUnit BU on BUP.BusinessUnitId = BU.Id
inner join customfield CF_WA on BUP.BusinessUnitId = CF_WA.clientbusinessunitid and cf_WA.name = 'Verpackt am'
inner join customvalue CV_WA on CV_WA.customfieldid = CF_WA.Id and CV_WA.EntityId = HU.Id
inner join customfield CF_VP on BUP.BusinessUnitId = CF_VP.clientbusinessunitid and cf_VP.name = 'Verpacker'
inner join customvalue CV_VP on CV_VP.customfieldid = CF_VP.Id and CV_VP.EntityId = HU.Id
INNER join HandlingUnitType HUT on HU.TypeId = HUT.Id

left join 
(select 
edvr.entityid,
DV.Content
from
DimensionValue DV 
inner join Dimension D on DV.DimensionId = D.Id and D.name = 'Customer project' 
inner join EntityDimensionValueRelation EDVR on DV.id = EDVR.DimensionValueId and Entity = 11
inner join BusinessUnitPermission BUP on D.id = BUP.DimensionId) DIM on HU.Id = DIM.EntityId
left join [Location] L on HU.ActualLocationId = L.Id
left join Zone Z on HU.ActualZoneId = Z.Id
left join Bin B on HU.ActualBinId = B.Id

left outer join 
(select 
HU.id huId,
hu.statusid stid,
max(WE.Created) as StatusChanged
from HandlingUnit HU 
left join dbo.workflowentry WE on hu.id = we.entityid 
group by hu.id,hu.statusid) sdate on hu.id = sdate.huId

left join Translation T on s.id = T.EntityId and T.[Language] = 'de'

where

(((case when @JustInserted = 1 and s.name = 'huItemInserted' and cast(StatusChanged as date) >= @FromDate and cast(StatusChanged as date) <= @ToDate then 1 else 0 end) = 1 )
or
((case when @JustInserted = 0 and cast(CV_WA.Content as date) >= @FromDate and cast(CV_WA.Content as date) <= @ToDate then 1 else 0 end) = 1 ))

and BUP.BusinessUnitId in ( SELECT
BU.id ClientID
  FROM [DFCZ_OSLET].[dbo].[BusinessUnitRelation] BUR
  inner join BusinessUnit BU on BUR.BusinessUnitId = BU.Id
 inner join BusinessUnit BURel on BUR.RelatedBusinessUnitId = @BusinessUnitID)
  
  --where RelatedBusinessUnitId = '33d1cc70-25d9-45d1-b08c-39e86b5701f7')-- @BusinessUnitID)
 -- and HU.Code = 'KAP-HU0000192'