select * from (
Select
'HU' as 'Ebene',
'Art' as 'Art',
Project.ProjectNr as 'Projekt Nr',
Project.Kennwort as 'Projekt Kennwort',
Project.[Deufol order] as 'Auftrag Deufol',
HU.[Description] as 'Inhalt Deutsch',
CV_PL.Content as 'P-Linie',
HU.Macros as 'Kisten-art',
CV_AnzMarkierung.Content  as 'Anz',
CV_AnzSeiten.Content  as 'Anzahl Seiten',
HUWFS.Name as 'Status',
TR.Text as 'Status (DE)',  
HU.ColliNumber as 'Kolli-Nr',
HU.Code as 'Kiste Nr',
CV_ABBR.Content as 'Abrechnung Eingang ZV',
SlStart.Created as 'SlStart',
cast(WFE.Created as date) as 'SlFertig',
packed.Packed,
HU.Length,
HU.Width,
HU.Height,
HU.Netto,
HU.Brutto,
HU.Surface,
CV_Markierung.Content as 'Markierung',
CV_ADS.Content as 'Art der Spezialsymbole'

from WorkflowEntry WFE 

INNER JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.ServiceLineId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Name = 'Siemens Berlin'

INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id and WFS.Name = 'SlDone'

INNER JOIN ServiceLine SL ON WFE.EntityId = SL.Id
INNER JOIN ServiceType ST ON SL.ServiceTypeId = ST.Id and ST.Code in ('Sondermarkierung')

LEFT JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart'))

LEFT JOIN CustomField CF_Markierung ON BU.Id = CF_Markierung.ClientBusinessUnitId and CF_Markierung.Name in ('Markierung')
LEFT JOIN CustomValue CV_Markierung ON CF_Markierung.Id = CV_Markierung.CustomFieldId and CV_Markierung.EntityId = SL.Id

LEFT JOIN CustomField CF_AnzMarkierung ON BU.Id = CF_AnzMarkierung.ClientBusinessUnitId and CF_AnzMarkierung.Name in ('Anzahl markierung')
LEFT JOIN CustomValue CV_AnzMarkierung ON CF_AnzMarkierung.Id = CV_AnzMarkierung.CustomFieldId and CV_AnzMarkierung.EntityId = SL.Id

LEFT JOIN CustomField CF_AnzSeiten ON BU.Id = CF_AnzSeiten.ClientBusinessUnitId and CF_AnzSeiten.Name in ('PagesCount')
LEFT JOIN CustomValue CV_AnzSeiten ON CF_AnzSeiten.Id = CV_AnzSeiten.CustomFieldId and CV_AnzSeiten.EntityId = SL.Id

LEFT JOIN CustomField CF_ADS ON BU.Id = CF_ADS.ClientBusinessUnitId and CF_ADS.Name in ('Art der Spezialsymbole')
LEFT JOIN CustomValue CV_ADS ON CF_ADS.Id = CV_ADS.CustomFieldId and CV_ADS.EntityId = SL.Id

INNER JOIN HandlingUnit HU ON SL.EntityId = HU.Id


LEFT JOIN (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('Kennwort','Deufol order'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Deufol order])) as Project on HU.id = Project.EntityId

LEFT JOIN CustomField CF_ABBR ON BU.Id = CF_ABBR.ClientBusinessUnitId and CF_ABBR.Name in ('Abrechnung Eingang ZV')
LEFT JOIN CustomValue CV_ABBR ON CF_ABBR.Id = CV_ABBR.CustomFieldId and CV_ABBR.EntityId = HU.Id

LEFT JOIN CustomField CF_PL ON BU.Id = CF_PL.ClientBusinessUnitId and CF_PL.Name in ('Produktlinie') and CF_PL.Entity = 11
LEFT JOIN CustomValue CV_PL ON CF_PL.Id = CV_PL.CustomFieldId and CV_PL.EntityId = HU.Id

LEFT JOIN CustomField CF_M ON BU.Id = CF_M.ClientBusinessUnitId and CF_M.Name in ('Macros')
LEFT JOIN CustomValue CV_M ON CF_M.Id = CV_M.CustomFieldId and CV_M.EntityId = HU.Id


LEFT JOIN CustomField CF_MV ON BU.Id = CF_MV.ClientBusinessUnitId and CF_MV.Name in ('Projekt Markierungsvorschrift')
LEFT JOIN CustomValue CV_MV ON CF_MV.Id = CV_MV.CustomFieldId and CV_MV.EntityId = HU.Id

LEFT JOIN [Status] HUWFS ON HU.StatusId = HUWFS.Id

LEFT JOIN Translation TR ON HUWFS.Id = TR.EntityId and TR.[Language] = 'de'

left join 
(select entityid, min(created) as Packed from WorkflowEntry WFE inner join (
select S.id STATUSID
from BusinessUnitPermission BUP
inner join [Status] S on BUP.StatusId = S.id and S.name = 'HuPacked'
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin' )) STAT on WFE.StatusId = STAT.STATUSID group by entityid) PACKED on sl.EntityId =packed.EntityId



UNION


Select
'LP' as 'Ebene',
'Art' as 'Art',
Project.ProjectNr as 'Projekt Nr',
Project.Kennwort as 'Projekt Kennwort',
Project.[Deufol order] as 'Auftrag Deufol',
lp.[Description] as 'Inhalt Deutsch',
CV_PL.Content as 'P-Linie',
'Kollo' as 'Kisten-art',
CV_AnzMarkierung.Content  as 'Anz',
CV_AnzSeiten.Content  as 'Anzahl Seiten',
LPWFS.Name as 'Status', 
TR.Text as 'Status (DE)',
CV_CL.Content as 'Kolli-Nr',
lp.Code as 'Kiste Nr',
CV_ABBR.Content as 'Abrechnung Eingang ZV',
SlStart.Created as 'SlStart',
cast(WFE.Created  as date) as 'SlFertig',
packed.Packed,
lp.Length,
lp.Width,
lp.Height,
lp.Netto as Netto,
lp.Weight as 'Brutto',
lp.Surface,
CV_Markierung.Content as 'Markierung',
CV_ADS.Content as 'Art der Spezialsymbole'

from WorkflowEntry WFE 

INNER JOIN BusinessUnitPermission BUP ON WFE.EntityId = BUP.ServiceLineId
INNER JOIN BusinessUnit BU ON BUP.BusinessUnitId = BU.Id and BU.Name = 'Siemens Berlin'

INNER JOIN [Status] WFS ON WFE.StatusId = WFS.Id and WFS.Name = 'SlDone'

INNER JOIN ServiceLine SL ON WFE.EntityId = SL.Id
INNER JOIN ServiceType ST ON SL.ServiceTypeId = ST.Id and ST.Code = ('Sondermarkierung LP')

LEFT JOIN WorkflowEntry SlStart ON SL.Id = SlStart.EntityId and SlStart.StatusId in (select [Status].Id from [Status] where [Status].Name in ('SlStart'))

LEFT JOIN CustomField CF_Markierung ON BU.Id = CF_Markierung.ClientBusinessUnitId and CF_Markierung.Name in ('Markierung')
LEFT JOIN CustomValue CV_Markierung ON CF_Markierung.Id = CV_Markierung.CustomFieldId and CV_Markierung.EntityId = SL.Id

LEFT JOIN CustomField CF_AnzMarkierung ON BU.Id = CF_AnzMarkierung.ClientBusinessUnitId and CF_AnzMarkierung.Name in ('Anzahl markierung')
LEFT JOIN CustomValue CV_AnzMarkierung ON CF_AnzMarkierung.Id = CV_AnzMarkierung.CustomFieldId and CV_AnzMarkierung.EntityId = SL.Id

LEFT JOIN CustomField CF_AnzSeiten ON BU.Id = CF_AnzSeiten.ClientBusinessUnitId and CF_AnzSeiten.Name in ('PagesCount')
LEFT JOIN CustomValue CV_AnzSeiten ON CF_AnzSeiten.Id = CV_AnzSeiten.CustomFieldId and CV_AnzSeiten.EntityId = SL.Id

LEFT JOIN CustomField CF_ADS ON BU.Id = CF_ADS.ClientBusinessUnitId and CF_ADS.Name in ('Art der Spezialsymbole')
LEFT JOIN CustomValue CV_ADS ON CF_ADS.Id = CV_ADS.CustomFieldId and CV_ADS.EntityId = SL.Id

INNER JOIN LoosePart LP ON SL.EntityId = LP.Id

LEFT JOIN (
select
DV.Content ProjectNr,
DV.[Description] Project, 
D.[Description] Dimemsion,
EDVR.EntityId,
DF.Name, 
DFV.Content
from DimensionField DF
inner join DimensionFieldValue DFV on Df.id = DFV.DimensionFieldId
inner join EntityDimensionValueRelation EDVR on DFV.DimensionValueId = EDVR.DimensionValueId
inner join DimensionValue DV on EDVR.DimensionValueId = DV.Id
inner join Dimension D on DF.DimensionId = D.id and D.name = 'Project'
where 
DF.name in ('Kennwort','Deufol order'))SRC
pivot (max(SRC.Content) for SRC.Name   in ([Kennwort],[Deufol order])) as Project on LP.id = Project.EntityId


LEFT JOIN CustomField CF_ABBR ON BU.Id = CF_ABBR.ClientBusinessUnitId and CF_ABBR.Name in ('Abrechnung Eingang ZV')
LEFT JOIN CustomValue CV_ABBR ON CF_ABBR.Id = CV_ABBR.CustomFieldId and CV_ABBR.EntityId = LP.id

LEFT JOIN CustomField CF_PL ON BU.Id = CF_PL.ClientBusinessUnitId and CF_PL.Name in ('Produktlinie') and CF_PL.Entity = 15
LEFT JOIN CustomValue CV_PL ON CF_PL.Id = CV_PL.CustomFieldId and CV_PL.EntityId = LP.id

LEFT JOIN CustomField CF_M ON BU.Id = CF_M.ClientBusinessUnitId and CF_M.Name in ('Macros')
LEFT JOIN CustomValue CV_M ON CF_M.Id = CV_M.CustomFieldId and CV_M.EntityId = LP.id

LEFT JOIN CustomField CF_CL ON BU.Id = CF_CL.ClientBusinessUnitId and CF_CL.Name in ('Colli')
LEFT JOIN CustomValue CV_CL ON CF_CL.Id = CV_CL.CustomFieldId and CV_CL.EntityId = LP.id

LEFT JOIN [Status] LPWFS ON LP.StatusId = LPWFS.Id
LEFT JOIN Translation TR ON LPWFS.Id = TR.EntityId and TR.[Language] = 'DE'

left join 
(select entityid, min(created) as Packed from WorkflowEntry WFE inner join (
select S.id STATUSID
from BusinessUnitPermission BUP
inner join [Status] S on BUP.StatusId = S.id and S.name = 'LpPacked'
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'Siemens Berlin' )) STAT on WFE.StatusId = STAT.STATUSID group by entityid) PACKED on sl.EntityId =packed.EntityId


)
data
--where  data.SlFertig >=   $P{Von}  and data.SlFertig <=  $P{Bis}
where  data.SlFertig >=   '2023-05-08'  and data.SlFertig <=  '2023-05-09'
order by data.SlFertig ASC