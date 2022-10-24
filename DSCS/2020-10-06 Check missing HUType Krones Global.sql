
select 
count(DATA.code) as Count,
Data.VVtyp

 from (
select HU.code, HUType.Text HUtype, CV.Content VVtyp, CV.CustomFieldId,
BUP.HandlingUnitId from BusinessUnitPermission BUP 
inner join HandlingUnit HU on BUP.HandlingUnitId = HU.Id
left join HandlingUnitType HUT on HU.TypeId = HUT.id
left join Translation HUType on HUT.Id = HUType.EntityId and HUType.[Language] = 'de' and HUType.[Column] = 'Code'
left join CustomValue CV on HU.id = CV.EntityId and CV.CustomFieldId = 'ffb54812-3ef7-4f69-a18d-cebb26de61ca'
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
and HU.TypeId is null and len (CV.Content)>0) DATA
group by 
Data.VVtyp

begin transaction
update hu set TypeId = (
    case CV.Content
when 'unverpackt' then '7ec371a2-bdef-4f98-a6cc-14911e602eed' --'NON'
when 'Bund' then '7ec371a2-bdef-4f98-a6cc-14911e602eed'--'NON'
when 'Kanister' then '7ec371a2-bdef-4f98-a6cc-14911e602eed'--'NON'
when 'auf Bohlen' then '74cfc834-0cb0-467c-ad44-468b39be114e' --'ON_PLANKS'
when 'Behälter' then '7ec371a2-bdef-4f98-a6cc-14911e602eed' --'NON'
when 'Gitterbox' then '9bdf16f1-44ad-4f9d-a1d9-9f415b6a8414' --'Gitterbox'
when 'Irgendwas' then '7ec371a2-bdef-4f98-a6cc-14911e602eed' --'NON'
when 'Karton' then '6d52ee74-41c9-4cbe-96d5-8daf7cb47a67' --'Carton'
when 'Kiste' then 'fb139b51-7299-4ba4-88d4-cabd738fe5ac' --'CRATE'
when 'Korb' then '9bdf16f1-44ad-4f9d-a1d9-9f415b6a8414'--'Gitterbox'
when 'OSB-Kiste' then '6b828212-64f2-4801-b9d5-96df3ba45fb2' --'KI-OSB'
when 'Paket' then '7ec371a2-bdef-4f98-a6cc-14911e602eed'--'NON'
when 'Palette' then '532ff539-a36f-48d2-bd44-be0682d3b329' --'PALLET'
when 'Podest' then '5c4d2a06-6103-4126-87e4-14122a182ac5' --'PODEST'
when 'Traverse' then '9010f707-d560-4458-9cee-14d29c8c4e81' --'TRAVERSE'

else NULL end
)
--select HU.code, HUType.Text HUtype, CV.Content VVtyp, CV.CustomFieldId,
from BusinessUnitPermission BUP 
inner join HandlingUnit HU on BUP.HandlingUnitId = HU.Id
left join HandlingUnitType HUT on HU.TypeId = HUT.id
left join Translation HUType on HUT.Id = HUType.EntityId and HUType.[Language] = 'de' and HUType.[Column] = 'Code'
left join CustomValue CV on HU.id = CV.EntityId and CV.CustomFieldId = 'ffb54812-3ef7-4f69-a18d-cebb26de61ca'
where BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL')
and HU.TypeId is null and len (CV.Content)>0


commit

/*
select BUP.HandlingUnitTypeId, HUT.Code from 
BusinessUnitPermission BUP
inner join HandlingUnitType HUT on BUP.HandlingUnitTypeId = HUT.id and BUP.BusinessUnitId = (select id from BusinessUnit where name = 'KRONES GLOBAL') and HUT.Container = 'false'
*/


