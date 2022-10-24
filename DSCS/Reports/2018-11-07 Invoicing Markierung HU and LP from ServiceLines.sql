Select
'Art' as 'Art',
DimVal.Content as 'Projekt Nr',
DFV_K.Content as 'Projekt Kennwort',
hu.[Description] as 'Inhalt Deutsch',
CV_PL.Content as 'P-Linie',
CV_M.Content as 'Kisten-art',
'1' as 'Anz',
HUWFS.Name as 'Status', 
TR.Text as 'Status (DE)',
hu.ColliNumber as 'Kolli-Nr',
hu.Code as 'Kiste Nr',
CV_ABBR.Content as 'Abrechnung Eingang ZV',
SlStart.Created as 'SlStart',
WFE.Created as 'SlFertig',
hu.Length,
hu.Width,
hu.Height,
hu.Netto,
hu.Brutto,
hu.Surface,
CV_Markierung.Content as 'Markierung'

from WorkflowEntry WFE 

LEFT JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.ServiceLineId
LEFT JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id

LEFT JOIN [Status] WFS ON WFE.StatusId = WFS.Id

LEFT JOIN ServiceLine SL ON WFE.EntityId = SL.Id
LEFT JOIN ServiceType ST ON SL.ServiceTypeId = ST.Id

LEFT JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart'))

LEFT JOIN CustomField CF_Markierung ON BU.Id = CF_Markierung.ClientBusinessUnitId and CF_Markierung.Name in ('Markierung')
LEFT JOIN CustomValue CV_Markierung ON CF_Markierung.Id = CV_Markierung.CustomFieldId and CV_Markierung.EntityId = SL.Id

LEFT JOIN HandlingUnit HU ON SL.EntityId = HU.Id


LEFT JOIN BusinessUnitPermission BUP_Dim ON BU.Id = BUP_Dim.BusinessUnitId and BUP_Dim.DimensionId is not null
LEFT JOIN Dimension Proj ON BUP_Dim.DimensionId = Proj.Id and Proj.Name = 'Project'

LEFT JOIN EntityDimensionValueRelation EDVR ON hu.id = EDVR.EntityId
LEFT JOIN DimensionValue DimVal ON EDVR.DimensionValueId = DimVal.Id

LEFT JOIN DimensionField AS DF_K ON DF_K.DimensionId = BUP_Dim.DimensionId AND DF_K.Name IN ('Kennwort')
LEFT JOIN DimensionFieldValue AS DFV_K	ON DFV_K.DimensionFieldId = DF_K.Id AND DimVal.Id = DFV_K.DimensionValueId

LEFT JOIN CustomField CF_ABBR ON BU.Id = CF_ABBR.ClientBusinessUnitId and CF_ABBR.Name in ('Abrechnung Eingang ZV')
LEFT JOIN CustomValue CV_ABBR ON CF_ABBR.Id = CV_ABBR.CustomFieldId and CV_ABBR.EntityId = hu.id

LEFT JOIN CustomField CF_PL ON BU.Id = CF_PL.ClientBusinessUnitId and CF_PL.Name in ('Produktlinie')
LEFT JOIN CustomValue CV_PL ON CF_PL.Id = CV_PL.CustomFieldId and CV_PL.EntityId = hu.id

LEFT JOIN CustomField CF_M ON BU.Id = CF_M.ClientBusinessUnitId and CF_M.Name in ('Macros')
LEFT JOIN CustomValue CV_M ON CF_M.Id = CV_M.CustomFieldId and CV_M.EntityId = hu.id

LEFT JOIN [Status] HUWFS ON hu.StatusId = HUWFS.Id

LEFT JOIN Translation TR ON HUWFS.Id = TR.EntityId and TR.[Language] = 'DE'

where 
BU.Name = 'Siemens Berlin'
and cast(WFE.Created as date) >=  '2018-10-01'  and cast(WFE.Created as date) <  '2018-10-31' 
--and cast(WFE.Created as date) >=  $P{Von}  and cast(WFE.Created as date) <  $P{Bis} 
and WFS.Name = 'SlDone'
and ST.Code = ('Nachträgliche Markierung')
and CV_PL.Content is not NULL

UNION


Select
'Art' as 'Art',
DimVal.Content as 'Projekt Nr',
DFV_K.Content as 'Projekt Kennwort',
lp.[Description] as 'Inhalt Deutsch',
CV_PL.Content as 'P-Linie',
CV_M.Content as 'Kisten-art',
'1' as 'Anz',
LPWFS.Name as 'Status', 
TR.Text as 'Status (DE)',
CV_CL.Content as 'Kolli-Nr',
lp.Code as 'Kiste Nr',
CV_ABBR.Content as 'Abrechnung Eingang ZV',
SlStart.Created as 'SlStart',
WFE.Created as 'SlFertig',
lp.Length,
lp.Width,
lp.Height,
lp.Weight as Netto,
cast(case when (charindex(',',CV_BR.Content)) > 0 then
left(CV_BR.Content,(charindex(',',CV_BR.Content))-1)+'.'+right(CV_BR.Content,len(CV_BR.Content)-(charindex(',',CV_BR.Content)))
 else CV_BR.Content end as float) as 'Brutto',
lp.Surface,
CV_Markierung.Content as 'Markierung'

from WorkflowEntry WFE 

LEFT JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.ServiceLineId
LEFT JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id

LEFT JOIN [Status] WFS ON WFE.StatusId = WFS.Id

LEFT JOIN ServiceLine SL ON WFE.EntityId = SL.Id
LEFT JOIN ServiceType ST ON SL.ServiceTypeId = ST.Id

LEFT JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart'))

LEFT JOIN CustomField CF_Markierung ON BU.Id = CF_Markierung.ClientBusinessUnitId and CF_Markierung.Name in ('Markierung')
LEFT JOIN CustomValue CV_Markierung ON CF_Markierung.Id = CV_Markierung.CustomFieldId and CV_Markierung.EntityId = SL.Id

LEFT JOIN LoosePart LP ON SL.EntityId = LP.Id

LEFT JOIN BusinessUnitPermission BUP_Dim ON BU.Id = BUP_Dim.BusinessUnitId and BUP_Dim.DimensionId is not null
LEFT JOIN Dimension Proj ON BUP_Dim.DimensionId = Proj.Id and Proj.Name = 'Project'

LEFT JOIN EntityDimensionValueRelation EDVR ON LP.id = EDVR.EntityId
LEFT JOIN DimensionValue DimVal ON EDVR.DimensionValueId = DimVal.Id

LEFT JOIN DimensionField AS DF_K ON DF_K.DimensionId = BUP_Dim.DimensionId AND DF_K.Name IN ('Kennwort')
LEFT JOIN DimensionFieldValue AS DFV_K	ON DFV_K.DimensionFieldId = DF_K.Id AND DimVal.Id = DFV_K.DimensionValueId

LEFT JOIN CustomField CF_ABBR ON BU.Id = CF_ABBR.ClientBusinessUnitId and CF_ABBR.Name in ('Abrechnung Eingang ZV')
LEFT JOIN CustomValue CV_ABBR ON CF_ABBR.Id = CV_ABBR.CustomFieldId and CV_ABBR.EntityId = LP.id

LEFT JOIN CustomField CF_PL ON BU.Id = CF_PL.ClientBusinessUnitId and CF_PL.Name in ('Produktlinie')
LEFT JOIN CustomValue CV_PL ON CF_PL.Id = CV_PL.CustomFieldId and CV_PL.EntityId = LP.id

LEFT JOIN CustomField CF_M ON BU.Id = CF_M.ClientBusinessUnitId and CF_M.Name in ('Macros')
LEFT JOIN CustomValue CV_M ON CF_M.Id = CV_M.CustomFieldId and CV_M.EntityId = LP.id

LEFT JOIN CustomField CF_BR ON BU.Id = CF_BR.ClientBusinessUnitId and CF_BR.Name in ('Brutto kg')
LEFT JOIN CustomValue CV_BR ON CF_BR.Id = CV_BR.CustomFieldId and CV_BR.EntityId = LP.id

LEFT JOIN CustomField CF_CL ON BU.Id = CF_CL.ClientBusinessUnitId and CF_CL.Name in ('Colli')
LEFT JOIN CustomValue CV_CL ON CF_CL.Id = CV_CL.CustomFieldId and CV_CL.EntityId = LP.id

LEFT JOIN [Status] LPWFS ON LP.StatusId = LPWFS.Id
LEFT JOIN Translation TR ON LPWFS.Id = TR.EntityId and TR.[Language] = 'DE'

where 
BU.Name = 'Siemens Berlin'
and cast(WFE.Created as date) >=  '2018-10-01'  and cast(WFE.Created as date) <  '2018-10-31' 
--and cast(WFE.Created as date) >=  $P{Von}  and cast(WFE.Created as date) <  $P{Bis} 
and WFS.Name = 'SlDone'
and ST.Code = ('Nachträgliche Markierung LP')
and CV_PL.Content is not NULL

