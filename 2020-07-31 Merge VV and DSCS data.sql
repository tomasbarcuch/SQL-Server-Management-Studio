declare @ShowPackedLooseparts as bit = 0

select * from (
select
'Loose Part' as Entity,
'VV' as source
,vv_lp.barcode 'code'
,K.KOLLINUMMER as 'ColliNr'
,cast (isnull(vv_lp.ABMESS1_MM,0)/10 as varchar)+'-'+cast(isnull(vv_lp.ABMESS2_MM,0)/10 as varchar)+'-'+cast(isnull(vv_lp.ABMESS3_MM,0)/10 as Varchar)
 as 'LBH'
,S.TXX as 'Status'
, case O.TXX
when 'Ex Hub Hamburg' then 'Deufol Rosshafen'
when 'Hub Hamburg' then 'Deufol Rosshafen'
when 'Deu Neutraubling' then 'Deufol Neutraubling'
when 'Ex Deu Neutraubling' then 'Deufol Neutraubling'
when 'HH Travehafen' then 'Deufol Travehafen'
else isnull(O.TXX, '') end as  Location
,'' as 'TruckNumber'
,'' as 'Adress to'
,'' as 'Actual bin'
,vv_lp.LAGERORT1+vv_lp.LAGERORT2+vv_lp.LAGERORT3 as 'PackingLocation'
,vv_lp.MATERIAL_NR as 'Material Nr.'
,vv_lp.[LT_TXD] as 'Description'
,vv_lp.[LT_MENGE] as 'Quantity'
,cast(ME.KUERZEL as Nvarchar) as 'UOM'
,'' as Typ
,vv_lp.vs_hier1 Project
,vv_lp.vs_hier2 [Order]
,vv_lp.vs_hier3 Commission
,vv_lp.zaehler VVID

 from DCNLPWSQL02.KRO_VV.dbo.DAT_LOSTEILE vv_lp with (NOLOCK)
 left join DCNLPWSQL02.[KRO_VV].[dbo].SAP_MENGENEINHEITEN ME on vv_lp.W_LT_MENGENEINHEIT = ME.ZAEHLER-- and ME.SAP_SPRACHE = 'E'
 left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE O on vv_lp.W_Standort = O.WERT
 left join DCNLPWSQL02.KRO_VV.dbo.N_STATUS S on vv_lp.W_Status = S.Zaehler
left join DCNLPWSQL02.[KRO_VV].[dbo].DAT_KISTEN K on vv_lp.Z_KISTEN = K.ZAEHLER
--where vv_lp.W_Standort not in (0) and (vv_lp.Z_KISTEN = '' or vv_lp.Z_KISTEN is null) and (vv_lp.vs_hier1 = $P{Project} or vv_lp.vs_hier2 = $P{Order}  or vv_lp.vs_hier3 =  $P{Commission})
where  vv_lp.vs_hier1 =  'VT00081770' and vv_lp.W_Standort not in (0)

and (((case when   @ShowPackedLooseparts   = 0  and (vv_lp.Z_KISTEN = '' or vv_lp.Z_KISTEN is null) then 1 else 0 end)=1)
or 
((case when  @ShowPackedLooseparts = 1 then 1 else 0 end)=1))


and cast(vv_lp.zaehler as nvarchar) not in (select content from 
CustomValue CV 
inner join CustomField CF on CV.CustomFieldId = CF.id and cf.ClientBusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL')
where cf.name = 'VVID' and len(content)>0) 
and S.TXX not in ('annulliert')

UNION

select
'Loose Part' as Entity,
'DSCS' as source
,dscs_lp.Code
,acHU.ColliNumber as 'ColliNr'
,cast(dscs_lp.Length/10 as varchar)+'-'+cast(dscs_lp.Width/10 as varchar)+'-'+cast(dscs_lp.Height/10 as varchar) as 'LBH'
,isnull(T.text,S.name) as 'Status'
,isnull(L.code, '') as Location

,'' as 'SH.TruckNumber'
,'' as 'SH.Adress to'
,B.Code as 'Actual bin'
,'' as 'HU.PackingLocation'
,CUS.MaterialNo as 'CF_Material Nr.'
,dscs_lp.Description as 'Description'
,wc.QuantityBase as 'Quantity'
,cast(UOM.Code as nvarchar) as 'UOM'
,'' as Typ
,dims.Project
,dims.[Order]
,dims.Commission
,Cv.Content as VVID
from LoosePart dscs_lp with (NOLOCK)
left join [Location] L on dscs_lp.ActualLocationId = L.Id
left join [Bin] B on dscs_lp.ActualBinId = B.Id
left join WarehouseContent WC with (NOLOCK) on dscs_lp.id = WC.loosepartid
left join UnitOfMeasure UOM with (NOLOCK) on dscs_lp.BaseUnitOfMeasureId = UOM.id
left join HandlingUnit acHU on dscs_lp.ActualHandlingUnitId = acHU.id
inner join STATUS S on dscs_lp.StatusId = S.id
inner join Translation T on S.id = T.EntityId and T.language = 'de'
inner join BusinessUnitPermission BUP on dscs_lp.id = BUP.LoosePartId and BusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL')

left join (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('VVID','MaterialNo')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([VVID],[MaterialNo])) as CUS on dscs_lp.id = CUS.EntityId

inner join  (
Select EDVR.EntityId,D.name, DV.content from  EntityDimensionValueRelation EDVR 
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id
)SRC
pivot (max(SRC.Content) for SRC.Name   in ([Project],[Order],[Commission])) as Dims on dscs_lp.id = Dims.EntityId
left join CustomValue CV on dscs_lp.id = cv.EntityId
left join CustomField CF on CV.CustomFieldId = CF.id
where cf.name = 'VVID'  --and S.[Name] = ('IN_STOCK')

and (((case when  @ShowPackedLooseparts   = 0  and dscs_lp.TopHandlingUnitId is null then 1 else 0 end)=1)
or 
((case when  @ShowPackedLooseparts   = 1 then 1 else 0 end)=1))




 )DATA

where Data.[Status] not in ('annulliert','Storniert','Canceled','Canceled2')

and 
--(Data.Project =  $P{Project} or Data.[Order] = $P{Order} or Data.Commission = $P{Commission})
Data.Project =  'VT00081770'

UNION

select * from (
select
'Handling Unit' as Entity,
'VV' as source
,vv_hu.barcode code
,vv_hu.KOLLINUMMER as 'ColliNr'
,cast (vv_hu.ABMESS1_MM/10 as varchar)+'-'+cast(vv_hu.ABMESS2_MM/10 as varchar)+'-'+cast(vv_hu.ABMESS3_MM/10 as Varchar) as 'LBH'
,S.TXX as 'Status'
, case O.TXX
when 'Ex Hub Hamburg' then 'Deufol Rosshafen'
when 'Hub Hamburg' then 'Deufol Rosshafen'
when 'Deu Neutraubling' then 'Deufol Neutraubling'
when 'Ex Deu Neutraubling' then 'Deufol Neutraubling'
when 'HH Travehafen' then 'Deufol Travehafen'
else isnull(O.TXX, '') end as  Location

,C.LKW_KENNZEICHEN as 'TruckNumber'
 ,ZO.TXX as 'Adress to'
,vv_hu.LAGERORT1+vv_hu.LAGERORT2+vv_hu.LAGERORT3 as 'Actual bin'
,PO.TXX as 'PackingLocation'
,'' as 'CF_Material Nr.'
,vv_hu.INHALT_TXD as 'Description'
,1 as 'Quantity'
,'stk' 'UOM'
,A.TXX as Typ
,vv_hu.vs_hier1 Project
,vv_hu.vs_hier2 [Order]
,vv_hu.vs_hier3 Commission
,vv_hu.zaehler VVID

 from DCNLPWSQL02.KRO_VV.dbo.DAT_Kisten vv_hu with (NOLOCK)
 left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE O on vv_hu.W_Standort = O.WERT
 left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE PO on vv_hu.W_ORT_VP = PO.WERT
  left join DCNLPWSQL02.KRO_VV.dbo.N_STATUS S on vv_hu.W_Status = S.Zaehler
    left join DCNLPWSQL02.KRO_VV.dbo.DAT_CONTAINER C on vv_hu.Z_CONTAINER = C.ZAEHLER
  left join DCNLPWSQL02.KRO_VV.dbo.N_ORTE ZO on C.W_ORT_ZIEL = ZO.ZAEHLER
    left join DCNLPWSQL02.[KRO_VV].[dbo].N_ARTEN A on vv_hu.W_ART = A.WERT and A.sap_sprache = 'D'
  
where vv_hu.W_Standort not in (0) AND (vv_hu.Z_AUSSENKISTE = 0)
and cast(vv_hu.zaehler as nvarchar) not in (select content from 
CustomValue CV 
inner join CustomField CF on CV.CustomFieldId = CF.id and cf.ClientBusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL')
where cf.name = 'VVID' and len(content)>0)
and S.TXX in ('Ausgang')
--and (vv_hu.vs_hier1 = $P{Project} or vv_hu.vs_hier2 = $P{Order}  or vv_hu.vs_hier3 =  $P{Commission})
and vv_hu.vs_hier1 =  'VT00081770'


UNION

select
'Handling Unit' as Entity,
'DSCS' as source
,dscs_hu.Code
,dscs_hu.ColliNumber
,cast(dscs_hu.Length/10 as varchar)+'-'+cast(dscs_hu.Width/10 as varchar)+'-'+cast(dscs_hu.Height/10 as varchar) as 'Code/LBH'
,isnull(T.text,S.name) as 'Status'
,isnull(L.code, '') as Location

,SH.Code as 'SH.TruckNumber'
,SH.ToAddressName as 'SH.Adress to'
,B.Code as 'HU.Actual bin'
,case when len(CUS.W_ORT_VP) = 0 then 'Hub Hamburg' else CUS.W_ORT_VP end as 'PackingLocation'
,'' as 'CF_Material Nr.'
,dscs_hu.Description as 'Description'
,1 as 'Quantity'
,cast('stk' as nvarchar) as 'UOM'
,isnull(HUTT.text, HUT.Description) as Typ
,dims.Project
,dims.[Order]
,dims.Commission
,Cv.Content as VVID
from HandlingUnit dscs_hu with (NOLOCK)
left join [Location] L on dscs_hu.ActualLocationId = L.Id
left join [Bin] B on dscs_hu.ActualBinId = B.Id
inner join STATUS S on dscs_hu.StatusId = S.id
inner join Translation T on S.id = T.EntityId and T.language = 'de'
inner join BusinessUnitPermission BUP on dscs_hu.id = BUP.HandlingUnitId and BusinessUnitId = (Select id from BusinessUnit where name = 'KRONES GLOBAL')

left join ShipmentLine SL on dscs_hu.id = SL.HandlingUnitId
left join ShipmentHeader SH on SL.ShipmentHeaderId = SH.Id
left join [Location] SHL on SH.ToLocationId = SHL.Id
left join HandlingUnitType HUT on dscs_hu.TypeId = HUT.Id
left join Translation HUTT on HUT.Id = HUTT.EntityId and HUTT.[Language] = 'de' and HUTT.[Column]='Description'

left join (select 
CV.EntityId,
CV.Content,
CF.Name
from CustomValue CV
inner join CustomField CF on CV.CustomFieldId = CF.Id
where CF.name in ('VVID','W_ORT_VP')) SRC
PIVOT (max(SRC.Content) for SRC.name in ([VVID],[W_ORT_VP])) as CUS on dscs_hu.id = CUS.EntityId

inner join  (
Select EDVR.EntityId,D.name, DV.content from  EntityDimensionValueRelation EDVR 
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DV.DimensionId = D.id
)SRC
pivot (max(SRC.Content) for SRC.Name   in ([Project],[Order],[Commission])) as Dims on dscs_hu.id = Dims.EntityId
left join CustomValue CV on dscs_hu.id = cv.EntityId
left join CustomField CF on CV.CustomFieldId = CF.id
where cf.name = 'VVID' and dscs_hu.TopHandlingUnitId is null --and S.Name in ('BOX_CLOSED') */
) DATA

where Data.[Status] not in ('annulliert','Storniert','Canceled','Canceled2') 
and 
--(Data.Project =  $P{Project} or Data.[Order] = $P{Order} or Data.Commission = $P{Commission})
Data.Project =  'VT00081770'