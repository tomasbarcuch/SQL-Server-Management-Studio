
select 
lp.code,
lphu.code,
--lp.id lpid
lphu.id lptophuid
,topHU.id as hutophuid
,parHU.id as huparhuid
,lpHU.Code
,topHU.Code
,parhu.Code
,lp.ActualBinId binlp
,lphu.ActualbinId binlphu
,topHU.ActualbinId bintophu
,parHU.ActualBinId binparhu
from loosepart lp
inner join HandlingUnit lpHU on lp.TopHandlingUnitId = lpHU.Id
left join HandlingUnit parHU on lpHU.ParentHandlingUnitId = parHU.Id 
left join HandlingUnit topHU on lpHU.TopHandlingUnitId = TopHU.Id

where --lphu.Id = 'bbdda469-9a63-4603-9366-eb12cce2361d'
lp.ActualBinId is not NULL
and 
(
lp.ActualBinId <> lphu.ActualBinId 
--OR lphu.ActualBinId <> tophu.ActualBinId
--lp.ActualBinId <> tophu.ActualBinId
)
and lphu.Empty = 0

group by 
lp.code,
lphu.id
,topHU.id
,parHU.id

,lpHU.Code
,topHU.Code
,parhu.Code
,lp.ActualBinId
,lphu.ActualbinId
,topHU.ActualbinId
,parHU.ActualBinID



/*

select 


HU.Code
,topHU.Code
,parhu.Code

,hu.ActualbinId
,topHU.ActualbinId
,parHU.ActualBinId
from HandlingUnit HU

INNER join HandlingUnit topHU on HU.topHandlingUnitId = topHU.Id 
left join HandlingUnit parHU on HU.parentHandlingUnitId = parHU.Id

where 
hu.ActualBinId is not NULL 
and 
(hu.ActualBinId <> tophu.ActualBinId
OR
hu.ActualBinId <> parhu.ActualBinId
)
*/