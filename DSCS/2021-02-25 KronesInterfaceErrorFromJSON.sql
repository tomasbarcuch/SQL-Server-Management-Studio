
SELECT top(1)
isnull(isnull(LPi.Code,HUi.Code),SHi.Code),
isnull(isnull(LP.Code,HU.Code),SH.Code),
DATA.ERROR_MESSAGE
FROM
( SELECT ERROR_MESSAGE, cast(JSON as nvarchar(255)) as JSON
-- select RECEIVED, VVID, ERROR_MESSAGE, JSON 
from DCNLPWSQL02.[KRO_VV].[dbo].VV_PCENTER_INTERFACE
where ERROR_COUNT = 1 and STATUS in (2)) DATA

INNER join CustomValue CV on JSON_VALUE([JSON], '$.Outer') = CV.Content
left join HandlingUnit HU on CV.EntityId = HU.Id
left join LoosePart LP on CV.EntityId = LP.Id
left join ShipmentHeader SH on CV.EntityId = SH.Id

INNER join CustomValue CVi on JSON_VALUE([JSON], '$.Inner') = CVi.Content
left join HandlingUnit HUi on CVi.EntityId = HUi.Id
left join LoosePart LPi on CVi.EntityId = LPi.Id
left join ShipmentHeader SHi on CVi.EntityId = SHi.Id