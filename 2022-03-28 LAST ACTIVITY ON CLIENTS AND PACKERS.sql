DECLARE @packer as UNIQUEIDENTIFIER = (select id from BusinessUnit where name = 'Deufol Frankenthal')

SELECT 
DATA.Packer, 
SUM(DATA.Entities) as Entities,MAX(DATA.LastUpdate) [Last activity]
,DATA.Client
FROM(

select  COUNT(LP.id) Entities, MAX(LP.Updated) LastUpdate,BU.Name Packer,CL.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join BusinessUnit BU with (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Disabled] = 0 and BU.[Type] <> 2 and BU.id = @packer
inner join LoosePart LP with (NOLOCK) on BUP.LoosePartId = LP.Id
inner join BusinessUnitPermission BUC with (NOLOCK)  on LP.id = BUC.LoosePartId
INNER JOIN BusinessUnit CL with (NOLOCK) on BUC.BusinessUnitId = CL.Id and CL.[Disabled] = 0 and CL.[Type] = 2

inner join (
select 
BU.Id, CV.Content as 'REASON'
from BusinessUnit BU with (NOLOCK)
left join CustomValue CV with (NOLOCK) on BU.id = CV.EntityId
left join CustomField CF with (NOLOCK) on CV.CustomFieldId = CF.Id
where CF.Name = 'REASON' AND CV.Content = 'PRODUCTION'
) Client on CL.Id = Client.id


group by BU.Name, CL.Name

union

select  COUNT(HU.id) Entities, MAX(HU.Updated) LastUpdate,BU.Name,CL.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join BusinessUnit BU with (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Disabled] = 0 and BU.[Type] <> 2 and BU.id = @packer
inner join HandlingUnit HU with (NOLOCK) on BUP.HandlingUnitId = HU.Id
inner join BusinessUnitPermission BUC with (NOLOCK) on HU.id = BUC.HandlingUnitId
INNER JOIN BusinessUnit CL with (NOLOCK) on BUC.BusinessUnitId = CL.Id and CL.[Disabled] = 0 and CL.[Type] = 2
inner join (
select 
BU.Id, CV.Content as 'REASON'
from BusinessUnit BU with (NOLOCK)
left join CustomValue CV with (NOLOCK) on BU.id = CV.EntityId
left join CustomField CF with (NOLOCK) on CV.CustomFieldId = CF.Id
where CF.Name = 'REASON' AND CV.Content = 'PRODUCTION'
) Client on CL.Id = Client.id

group by BU.Name, CL.Name


union

select  COUNT(SH.id) Entities, MAX(SH.Updated) LastUpdate,BU.Name,CL.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join BusinessUnit BU with (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Disabled] = 0 and BU.[Type] <> 2 and BU.id = @packer
inner join ShipmentHeader SH with (NOLOCK) on BUP.ShipmentHeaderId = SH.Id
inner join BusinessUnitPermission BUC with (NOLOCK) on SH.id = BUC.ShipmentHeaderId
INNER JOIN BusinessUnit CL with (NOLOCK) on BUC.BusinessUnitId = CL.Id and CL.[Disabled] = 0 and CL.[Type] = 2
inner join (
select 
BU.Id, CV.Content as 'REASON'
from BusinessUnit BU with (NOLOCK)
left join CustomValue CV with (NOLOCK) on BU.id = CV.EntityId
left join CustomField CF with (NOLOCK) on CV.CustomFieldId = CF.Id
where CF.Name = 'REASON' AND CV.Content = 'PRODUCTION'
) Client on CL.Id = Client.id

group by BU.Name, CL.Name

union

select  COUNT(PO.id) Entities, MAX(PO.Updated) LastUpdate,BU.Name,CL.Name as Client
from BusinessUnitPermission BUP with (NOLOCK)
inner join BusinessUnit BU with (NOLOCK) on BUP.BusinessUnitId = BU.Id and BU.[Disabled] = 0 and BU.[Type] <> 2 and BU.id = @packer
inner join PackingOrderHeader PO with (NOLOCK) on BUP.PackingOrderHeaderId = PO.Id
inner join BusinessUnitPermission BUC with (NOLOCK) on PO.id = BUC.PackingOrderHeaderId
INNER JOIN BusinessUnit CL with (NOLOCK) on BUC.BusinessUnitId = CL.Id and CL.[Disabled] = 0 and CL.[Type] = 2
inner join (
select 
BU.Id, CV.Content as 'REASON'
from BusinessUnit BU with (NOLOCK)
left join CustomValue CV with (NOLOCK) on BU.id = CV.EntityId
left join CustomField CF with (NOLOCK) on CV.CustomFieldId = CF.Id
where CF.Name = 'REASON' AND CV.Content = 'PRODUCTION'
) Client on CL.Id = Client.id

group by BU.Name, CL.Name


) DATA 

group by 
DATA.Packer,
 DATA.Client
order by 
 DATA.Packer, 
 DATA.Client


