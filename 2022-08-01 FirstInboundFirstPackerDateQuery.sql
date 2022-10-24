Select PACKER.Name as Packer, CLIENT.Name as Client, WFEMIN.BusinessUnitId, DATA.ClientBusinessUnitId, COUNT(DATA.EntityId) Quantity, YEAR(DATA.Created) FirstInboundYear, MONTH(DATA.Created) FirstInboundMonth from (
select distinct WFE.EntityId, WFE.ClientBusinessUnitId,Min(WFE.Created) over (PARTITION BY WFE.EntityId) Created from WorkflowEntry WFE where WFE.WorkflowAction = 1) DATA
inner join WorkflowEntry WFEMIN on DATA.EntityId = WFEMIN.EntityId and DATA.Created = WFEMIN.Created
inner join BusinessUnit PACKER on WFEMIN.BusinessUnitId = PACKER.Id
inner join BusinessUnit CLIENT on DATA.ClientBusinessUnitId = Client.Id
 
WHERE 
--DATA.EntityId = '3dacd728-c08a-4c53-9e76-c6ecf7bd4577'
DATA.Created between '2022-07-01' and '2022-07-31'

group by 
PACKER.Name, CLIENT.Name,WFEMIN.BusinessUnitId, DATA.ClientBusinessUnitId, YEAR(DATA.Created), MONTH(DATA.Created)

order by PACKER.Name, CLIENT.Name

--having Client.Name = 'KHU Debrecen'